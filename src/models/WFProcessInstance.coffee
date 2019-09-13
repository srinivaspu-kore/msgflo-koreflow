joi = require('joi')
mongoose = require('mongoose');

WFDataItem = require('./WFDataItem');
WFStepRef = require('./WFStepRef');
WFContext = require('./WFContext');

WFProcessInstanceSchema = new mongoose.Schema({
    workflowId : {
        type : "String",
        required : true
    },
    data : {
        type : [WFDataItem.schema],
        required : true,
        default: undefined
    },
    context: {
        type : WFContext.schema,
        required : true,
        default: undefined
    },
    pendingSteps : {
        type : [WFStepRef.schema],
        required : false,
        default: undefined
    }
});

exports.validator = joi.object().keys({
      workflowId: joi.string().required(),
      data: joi.array().items(WFDataItem.validator).required(),
      context: WFContext.validator,
      stepId: joi.string().required()
})

exports.schema = WFProcessInstanceSchema;
exports.model = mongoose.model 'WFProcessInstance', WFProcessInstanceSchema;
