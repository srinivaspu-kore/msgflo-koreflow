noflo = require 'noflo'
mongoose = require 'mongoose'
WFProcessDefn = require '../src/models/WFProcessDefn'
WFProcessInstance = require '../src/models/WFProcessInstance'
debug = require('debug')('koreflow:WFInstance')
_ = require('lodash')

exports.getComponent = ->
  c = new noflo.Component
  c.description = ' The SplitStr component receives a string in the in port,
    splits it by string specified in the delimiter port, and send each part as
    a separate packet to the out port'

  c.inPorts.add 'in',
    datatype: 'all'
    description: 'String to split'
  c.outPorts.add 'error',
    datatype: 'all'
    description: 'Split off elements from the input
     string (one element per IP)'
  c.outPorts.add 'out',
    datatype: 'all'
    description: 'Split off elements from the input
     string (one element per IP)'
  c.outPorts.add 'pending',
    datatype: 'all'
    description: 'Split off elements from the input
     string (one element per IP)'

  c.process (input, output) ->
    # return unless input.hasData 'in'
    payload = input.getData 'in' 
    debug "received", payload

    processDefn = WFProcessDefn.model.findById(payload.workflowId)
    
    processDefn.then((defn) ->
      defaultStep = defn.steps[0].id
      stepId = payload.stepId || defaultStep
      assignee = 'test@kore.com'

      debug 'stepId --> ', stepId 

      WFProcessInstance.model.findById(payload.workflowProcessId)
      .then((process) ->
        if !process 
          debug 'creating new process'
          return WFProcessInstance.model.create({
            workflowId: payload.workflowId,
            data: payload.data,  
            context: payload.context, 
            pendingSteps: [{stepId: defaultStep, assignee}]
           })
          .then((savedProcess) ->
            return savedProcess
          ) 

        return process
      )
      .then((process) ->
        if process.pendingSteps
          ind = _.findIndex(process.pendingSteps, {stepId})

          if ind is -1
            throw new Error("The workflow has already executed step #{stepId} or step #{stepId} is not declared in the definition")
          else 
            process.pendingSteps.splice(ind, 1)

        debug 'process.pendingSteps', process.pendingSteps
        
        return process.save()
        .then(() -> 
          return process
        );
      )
      .then((process) ->
        debug 'process', process

        if !_.isEmpty(process.pendingSteps) and _.findIndex(process.pendingSteps, {stepId}) isnt -1
          return output.sendDone
            pending: {
              message: "'Async Step #{stepId} is in pending state'"
            }
        else 
          payload.workflowProcessId = process._id
          output.sendDone
            out: payload
      )
    )   
    .catch((error)->
      output.done error if error
    )
