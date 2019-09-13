(function() {
  var KFlowLogger, debug, msgfloNodejs, uuid;

  uuid = require('uuid');

  msgfloNodejs = require('msgflo-nodejs');

  debug = require('debug')('koreflow:KFlowLog');

  KFlowLogger = function(client, role) {
    var definition, func, id;
    id = process.env.DYNO || uuid.v4();
    id = `${role}-${id}`;
    definition = {
      id: id,
      component: 'koreflow/KFlowLogger',
      icon: 'code',
      label: 'Creates processing jobs from koreflow HTTP requests',
      inports: [
        {
          id: 'in'
        }
      ],
      outports: [
        {
          id: 'out'
        }
      ]
    };
    func = function(inport, indata, send) {
      // forward
      debug('logged payload: ', indata);
      return send('out', null, indata);
    };
    return new msgfloNodejs.participant.Participant(client, definition, func, role);
  };

  module.exports = KFlowLogger;

}).call(this);


//# sourceMappingURL=KFlowLogger.js.map
//# sourceURL=coffeescript