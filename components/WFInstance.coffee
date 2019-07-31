noflo = require 'noflo'
debug = require('debug')('koreflow:WFInstance')

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
    data = input.getData 'in' 
    debug "received", data

    output.send
        out: data

    output.done()
