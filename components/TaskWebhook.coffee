noflo = require 'noflo'
WFProcessDefn = require '../src/models/WFProcessDefn'
config = require '../src/config/env'
debug = require('debug')('koreflow:ProcessInit')
mongoose = require('mongoose')

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
    # try 
    mongoose.connect(config.msgflo.db_url, { useNewUrlParser: true }, (error) ->
      return output.done error if error
    )

    data = input.getData 'in' 
    debug "received", data
    
    WFProcessDefn.model.findById(data.workflowId)
    .exec((error, processDefn) -> 
      try
        throw error if error;
        throw new Error("processDefn is not found") if !processDefn;
        
        debug "sent", data
        output.sendDone
          out: data
      catch error
        output.done error if error
    )

    # .then((processDefn) -> 
    #   debug 'processDefn', processDefn
    #   if (!processDefn) 
    #     throw new Error("workflowId not found");

    #   # output.send 
    #   #   out: data

    #   # debug '333'
    #   # output.done()
      
    #   return processDefn;
    # )
    # .catch((err) ->
    #   output.done 
    #     error: err
    #   return
    # );
      # .then((processDefn) -> 
      #   if (!processDefn) 
      #     return res.status(404).json({
      #       status: 400,
      #       message: "definition not found"
      #     });
        
      #   return processDefn;
      # );

      # debug outputData;

    #   debug '222'
    # output.send 
    #   out: data

    # debug '333'
    # output.done()

    #   debug '4444'
    # catch error
    #   output.sendDone(error)
    #   return;
    
