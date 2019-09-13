uuid = require 'uuid'
msgfloNodejs = require 'msgflo-nodejs'
debug = require('debug')('koreflow:KFlowLogger')

KFlowLogger = (client, role) ->
  id = process.env.DYNO or uuid.v4()
  id = "#{role}-#{id}"

  definition =
    id: id
    component: 'koreflow/KFlowLogger'
    icon: 'code'
    label: 'Creates processing jobs from koreflow HTTP requests'
    inports: [
      { id: 'in' }
    ]
    outports: [
      { id: 'out' }
    ]

  func = (inport, indata, send) ->
    # forward
    debug 'logged payload: ', indata
    return send 'out', null, indata

  return new msgfloNodejs.participant.Participant client, definition, func, role

module.exports = KFlowLogger
