express = require 'express';
validate = require 'express-validation';
workflowInstancesCtrl = require '../controllers/workflowinstances';
validations = require './validation/workflowinstances';

router = express.Router();

router.route('/')
  .get(workflowInstancesCtrl.list);
  
router.route('/exec')
  .post(validate(validations.createWorkflowInstance),
        workflowInstancesCtrl.create);

router.route('/:instanceId')
  .get(workflowInstancesCtrl.get)
  .delete(workflowInstancesCtrl.remove);

router.param('instanceId', validate(validations.getWorkflowInstance));
router.param('instanceId', workflowInstancesCtrl.load);

module.exports = router;