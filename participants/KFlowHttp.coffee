uuid = require 'uuid'
msgfloNodejs = require 'msgflo-nodejs'
debug = require('debug')('koreflow:httpnode')

KFlowHttp = (client, role) ->
  id = process.env.DYNO or uuid.v4()
  id = "#{role}-#{id}"

  definition =
    id: id
    component: 'koreflow/HttpApi'
    icon: 'code'
    label: 'Creates processing jobs from koreflow HTTP requests'
    inports: [
      { id: 'process', hidden: true } # for proxying data from .send() to outports through func()
      { id: 'init', hidden: true } 
    ]
    outports: [
      { id: 'process' }
      { id: 'init' } 
    ]

  func = (inport, indata, send) ->
    # forward
    debug "calling component", "'#{inport}'" 
    debug "payload data: \n", indata
    send inport, null, indata
    
  return new msgfloNodejs.participant.Participant client, definition, func, role

module.exports = KFlowHttp
