(function() {
  var WFProcessDefn, WorkflowDB, _, app, bluebird, config, debug, errors, initResources, mongoose, msgfloNodejs, path, runtime, startParticipant, startWeb, uuid;

  debug = require('debug')('koreflow:coordinator');

  path = require('path');

  bluebird = require('bluebird');

  uuid = require('uuid');

  msgfloNodejs = require('msgflo-nodejs');

  runtime = require('noflo-runtime-msgflo');

  mongoose = require('mongoose');

  _ = require('lodash');

  config = require('./config/env');

  errors = require('./errors');

  app = require('./config/express');

  WFProcessDefn = require('./models/WFProcessDefn');

  WorkflowDB = require('./utils/WorkflowDB');

  // routes = {}

  // KFlowWebhookParticipant = require '../participants/KFlowHttp'
  // KFlowLoggerParticipant = require '../participants/KFlowLogger'

  // routes.execWFProcess = (req, res, next) ->
  //   debug "POST /workflow/process/exec", req.body?.message?.length

  //   # TODO: verify request payload with a JSON schema
  //   throw new errors.HttpError "Missing message", 422 if not req.body.message
  //   process = req.body.process

  //   if data.workflowDefinitionId 
  //         output.done "workflowDefinitionId is missing"
  //         return

  //   req.participants.kflowwebhook.send 'process', process

  // routes.getWFInstances = (req, res, next) ->
  //   debug "GET /workflow/instances"

  // routes.getWFDefinitions = (req, res, next) ->
  //   debug "GET /workflow/definitions"

  // routes.createWFDefinition = (req, res, next) ->
  //   debug "POST /workflow/definitions", req.body?.definition?.length

  //   # TODO: verify request payload with a JSON schema
  //   throw new errors.HttpError "Missing definition", 422 if not req.body.definition

  //   definition = req.body.definition

  //   r = new WFProcessDefn.model(req.body.definition)

  //   r.save((err, resource) -> 
  //     if err
  //       res.send err.errors
  //     else 
  //       res.send resource
  //   );

  // setupApp = (app) ->
    // WorkflowDB.connect(config.msgflo.db_url)

  //   app.participants =
  //     logger: KFlowLoggerParticipant config.msgflo.broker, 'logger'
  //     kflowwebhook: KFlowWebhookParticipant config.msgflo.broker, 'webhook'

  //   app.use bodyParser.json
  //     limit: '1mb'

  //   app.use (req, res, next) ->
  //     req.participants = app.participants
  //     return next()

  // API routes
  // app.post '/workflow/process/exec', routes.execWFProcess
  // app.post '/workflow/definitions', routes.createWFDefinition
  // app.get '/workflow/instances', routes.getWFInstances 
  // app.get '/workflow/definitions', routes.getWFDefinitions

  // # 404 handler
  // app.use (req, res, next) ->
  //   next new errors.HttpError "#{req.path} not found", 404
  //   return

  // # Error handler
  // app.use (err, req, res, next) ->
  //   debug 'error handler', err

  //   unless err.type is 'HttpError'
  //     # Convert regular errors to HTTP errors
  //     err = new errors.HttpError err.message, 500
  //   res.status err.code
  //   res.json
  //     message: err.message
  //     errors: err.errors if err.errors?
  //   return

  // return app
  startParticipant = function(p) {
    return bluebird.promisify(p.start, {
      context: p
    })();
  };

  startWeb = function(app, port) {
    // Expose extra Bluebird methods
    return bluebird.resolve().then(function() {
      // wrapped for Exception safety
      return new Promise(function(resolve, reject) {
        return app.server = app.listen(port, function(err) {
          if (err) {
            return reject(err);
          }
          return resolve(app);
        });
      });
    });
  };

  initResources = function(app) {
    return app.participants.kflowwebhook.send('init', config.msgflo.db_url);
  };

  exports.startServer = function(port) {
    return bluebird.resolve().then(function() {
      debug('db connection url is', config.msgflo.db_url);
      WorkflowDB.connect(config.msgflo.db_url)
      
      return app;
    }).then(function() {
      return bluebird.all([
        startWeb(app,
        port),
        startParticipant(app.participants.logger),
        startParticipant(app.participants.kflowwebhook)
      ]).then(function(array) {
        initResources(app);
        return Promise.resolve(app);
      });
    });
  };

}).call(this);


//# sourceMappingURL=app.js.map
//# sourceURL=coffeescript