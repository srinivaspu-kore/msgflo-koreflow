noflo = require 'noflo'
mongoose = require 'mongoose'
_ = require 'lodash'
WFProcessDefn = require '../src/models/WFProcessDefn'
WFProcessInstance = require '../src/models/WFProcessInstance'
debug = require('debug')('koreflow:WFStateTransition')

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

  c.process (input, output) ->
    # return unless input.hasData 'in'
    payload = input.getData 'in' 
    assignee = 'test@kore.com'
    
    debug "received", payload

    processDefn = WFProcessDefn.model.findById(payload.workflowId)

    processDefn.then((defn) ->
      debug 'payload.workflowProcessId ->', payload.workflowProcessId
      WFProcessInstance.model.findById(payload.workflowProcessId)
      .then((process) ->        
        debug 'process:', process
        thisStep = _.find(defn.steps, {id: payload.stepId});
        transition = thisStep.transition
        transitionStep = transition.default

        if transition.if
          ifCtx = transition.if
          expr = ifCtx.context + ifCtx.op + ifCtx.value
        
          result = eval(expr)
          debug "evaluated expression: '"+expr+"' to: "+result
          
          if result is true
            transitionStep = transition.then
        
          debug "transitionStep: '"+transitionStep+"'"
        else 
          debug "using default transitionStep: '"+transitionStep+"'"

        # Update PendingSteps
        if _.findIndex(process.pendingSteps, {stepId: transitionStep}) is -1
          debug 'Adding nextStep to pendingSteps: ', transitionStep
          process.pendingSteps.push({stepId: transitionStep, assignee})
          process.save()
        
        return process
      )
      .then((process) ->
        debug 'process', process
        output.sendDone
          out: payload
      )      
    )   
    .catch((error)->
      output.done error if error
    )

