joi = require('joi')
mongoose = require('mongoose');

WFStepOptionsDefn = require('./WFStepOptionsDefn');
WFTransitionDefn = require('./WFTransitionDefn');

WFStepDefnSchema = new mongoose.Schema({
    id : {
        type : "String",
        required : true
    },
    type : {
        type: "String",
        enum : ["task", "webhook", "alert", "script", "condition", "service", "end"],
        required: true
    },    
    refId : {
        type : "String",
        required : true
    },
    transition : {
        type : WFTransitionDefn.schema,
        required : true
    },
    stepOptions : {
        type : WFStepOptionsDefn.schema,
        required : true
    },
    metadata : {
        type : {},
        required : false
    }
});

exports.validator = joi.object().keys({
    id: joi.string().required(),
    type: joi.string().valid("task", "webhook", "alert", "script", "condition", "service", "end"),
    refId: joi.string().required()
    transition: WFTransitionDefn.validator,
    stepOptions: WFStepOptionsDefn.validator,
    metadata: joi.any()
})

exports.schema = WFStepDefnSchema;
exports.model = mongoose.model 'WFStepDefn', WFStepDefnSchema;
