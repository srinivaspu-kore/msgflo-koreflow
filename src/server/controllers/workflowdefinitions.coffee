debug = require('debug')('WorkFlowDefinitionsCtrl');
WFProcessDefn = require '../../models/WFProcessDefn';

load = (req, res, next, id) ->
  WFProcessDefn.model.findById(id)
    .exec()
    .then((processDefn) -> 
      if (!processDefn) 
        return res.status(404).json({
          status: 400,
          message: "definition not found"
        });
      
      req.dbprocessDefn = processDefn;
      return next()
      );

get = (req, res) ->
  return res.json(req.dbprocessDefn)

create = (req, res, next) ->
  throw new errors.HttpError "Missing definition", 422 if not req.body

  WFProcessDefn.model.create({
    refId : req.body.refId,
    trigger : req.body.trigger,
    data : req.body.data,
    steps : req.body.steps
    })
    .then((savedprocessInstance) ->
      return res.json(savedprocessInstance);
    , (e) -> next(e));

update = (req, res, next) ->
  processDefn = req.dbprocessDefn;
  Object.assign(processDefn, req.body);

  processDefn.save()
  .then(() -> 
    res.sendStatus(204);
  );

list = (req, res, next) ->
  debug 'in lists'
  limit = req.query.limit || 50
  skip = req.query.skip || 0
  WFProcessDefn.model.find()
    .skip(skip)
    .limit(limit)
    .exec()
    .then((processDefns) -> 
        debug 'in processDefns list', processDefns
        res.json(processDefns)
    );

remove = (req, res, next) ->
  processDefn = req.dbprocessDefn;
  processDefn.remove()
    .then(() -> 
        res.sendStatus(204)
    );

module.exports = {load, get, create, update, list, remove}