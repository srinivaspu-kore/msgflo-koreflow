uuid = require 'uuid'
msgfloNodejs = require 'msgflo-nodejs'
debug = require('debug')('koreflow:KFlowHttp')

KFlowHttp = (client, role) ->
  id = process.env.DYNO or uuid.v4()
  id = "#{role}-#{id}"

  definition =
    id: id
    component: 'koreflow/KFlowHttp'
    icon: 'code'
    label: 'Creates processing jobs from koreflow HTTP requests'
    inports: [
      { id: 'process', hidden: true } # for proxying data from .send() to outports through func()
    ]
    outports: [
      { id: 'process' }
    ]

  func = (inport, indata, send) ->
    # forward
    debug 'sending', inport, indata.job, indata.payload.id
    return send inport, null, indata

  return new msgfloNodejs.participant.Participant client, definition, func, role

module.exports = KFlowHttp
