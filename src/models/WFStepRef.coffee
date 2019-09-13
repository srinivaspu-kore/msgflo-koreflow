joi = require('joi')
mongoose = require('mongoose');


WFStepRefSchema = new mongoose.Schema({
    stepId : {
        type : "String",
        required : true
    },
    refId : {
        type : "String",
        required : false
    },
    assignee : {
        type : "String",
        required : true
    }
});

exports.validator = joi.object().keys({
      stepId: joi.string().required(),
      refId: joi.string(),
      assignee: joi.string().required()
})

exports.schema = WFStepRefSchema;
exports.model = mongoose.model 'WFStepRef', WFStepRefSchema;
