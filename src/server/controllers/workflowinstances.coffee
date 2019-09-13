WFProcessInstance = require '../../models/WFProcessInstance';

load = (req, res, next, id) ->
  WFProcessInstance.model.findById(id)
    .exec()
    .then((processInstance) -> 
      if (!processInstance) 
        return res.status(404).json({
          status: 400,
          message: "processInstance not found"
        });
      
      req.dbprocessInstance = processInstance;
      return next();
    , (e) -> next(e));

get = (req, res) ->
  return res.json(req.dbprocessInstance)

create = (req, res, next) ->
  throw new errors.HttpError "Missing message", 422 if not req.body

  process = req.body
  req.participants.kflowwebhook.send 'process', process

  return res.status(404).json({
    status: 200,
    message: "processing_ok"
  });
  # WFProcessInstance.model.create({
  #   refId : req.body.refId,
  #   workflowId : req.body.workflowId,
  #   data : req.body.data,
  #   pendingSteps : req.body.pendingSteps
  #   })
  #   .then((savedprocessInstance) ->
  #     return res.json(savedprocessInstance);
  #   , (e) -> next(e));

update = (req, res, next) ->
  processInstance = req.dbprocessInstance;
  Object.assign(processInstance, req.body);

  processInstance.save()
  .then(() -> 
    res.sendStatus(204);
  , (e) -> next(e));

list = (req, res, next) ->
  limit = req.query.limit || 50
  skip = req.query || 0
  WFProcessInstance.model.find()
    .skip(skip)
    .limit(limit)
    .exec()
    .then((processInstances) -> 
        res.json(processInstances)
    , (e) -> next(e));

remove = (req, res, next) ->
  processInstance = req.dbprocessInstance;
  processInstance.remove()
    .then(() -> 
        res.sendStatus(204)
    , (e) -> next(e));

module.exports = {load, get, create, update, list, remove}