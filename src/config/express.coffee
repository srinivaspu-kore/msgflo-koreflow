debug = require('debug')('express-config');
express = require 'express';
expressValidation = require 'express-validation';
bodyParser = require 'body-parser';
routes = require '../server/routes';
errors = require '../errors'
WorkflowDB = require '../utils/WorkflowDB'
config = require './env'

KFlowWebhookParticipant = require '../../participants/KFlowHttp'
KFlowLoggerParticipant = require '../../participants/KFlowLogger'

app = express();

app.participants =
  logger: KFlowLoggerParticipant config.msgflo.broker, 'logger'
  kflowwebhook: KFlowWebhookParticipant config.msgflo.broker, 'webhook'

app.use bodyParser.json
  limit: '1mb'

app.use (req, res, next) ->
  req.participants = app.participants
  return next()

# Do not move this from here
app.use '/api', routes

# 404 handler
app.use (req, res, next) ->
  next new errors.HttpError "#{req.path} not found", 404
  return

# Error handler
app.use (err, req, res, next) ->
  if err instanceof expressValidation.ValidationError
    res.status(err.status).json(err);
  else
    unless err.type is 'HttpError'
      # Convert regular errors to HTTP errors
      err = new errors.HttpError err.message, 500

    res.status(err.code)
      .json
        message: err.message,
        errors: err.errors if err.errors?

module.exports = app;