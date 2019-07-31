express = require 'express'
bluebird = require 'bluebird'
bodyParser = require 'body-parser'
uuid = require 'uuid'
msgfloNodejs = require 'msgflo-nodejs'
runtime = require 'noflo-runtime-msgflo'
routes = {}

debug = require('debug')('koreflow:web')
path = require 'path'

config = require '../config'
errors = require './errors'

KFlowWebhookParticipant = require '../participants/KFlowHttp'
KFlowLoggerParticipant = require '../participants/KFlowLogger'

routes.postMessage = (req, res, next) ->
  debug "POST /messages", req.body?.message?.length

  # TODO: verify request payload with a JSON schema
  throw new errors.HttpError "Missing .images array", 422 if not req.body.message

  message = req.body.message

  req.participants.kflowwebhook.send 'process', message

setupApp = (app) ->
  app.participants =
    logger: KFlowLoggerParticipant config.msgflo.broker, 'logger'
    kflowwebhook: KFlowWebhookParticipant config.msgflo.broker, 'webhook'

  app.use bodyParser.json
    limit: '1mb'

  app.use (req, res, next) ->
    req.participants = app.participants
    return next()

  # API routes
  app.post '/messages', routes.postMessage

  # 404 handler
  app.use (req, res, next) ->
    next new errors.HttpError "#{req.path} not found", 404
    return

  # Error handler
  app.use (err, req, res, next) ->
    debug 'error handler', err

    unless err.type is 'HttpError'
      # Convert regular errors to HTTP errors
      err = new errors.HttpError err.message, 500
    res.status err.code
    res.json
      message: err.message
      errors: err.errors if err.errors?
    return

  return app

startParticipant = (p) ->
  return bluebird.promisify(p.start, context: p)()

startWeb = (app, port) ->
  # Expose extra Bluebird methods
  bluebird.resolve().then () ->
    # wrapped for Exception safety
    return new Promise (resolve, reject) ->
      app.server = app.listen port, (err) ->
        return reject err if err
        return resolve app

exports.startServer = (port) ->
  app = express()
  bluebird.resolve().then () ->
    return setupApp app
  .then () ->
    return bluebird.all([
      startWeb app, port
      startParticipant app.participants.logger
      startParticipant app.participants.kflowwebhook
    ]).then (array) ->
      return Promise.resolve app

