express = require 'express';
validate = require 'express-validation';
workflowDefinitionsCtrl = require '../controllers/workflowdefinitions';
validations = require './validation/workflowdefinitions';

router = express.Router();

router.route('/')
  .get(workflowDefinitionsCtrl.list)
  .post(validate(validations.createWorkflowDefinition),
        workflowDefinitionsCtrl.create);

router.route('/:definitionId')
  .get(workflowDefinitionsCtrl.get)
  .delete(workflowDefinitionsCtrl.remove);

router.param('definitionId', validate(validations.getWorkflowDefinition));
router.param('definitionId', workflowDefinitionsCtrl.load);

module.exports = router;