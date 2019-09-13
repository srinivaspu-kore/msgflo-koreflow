joi = require('joi');
mongoose = require('mongoose');

WFTriggerOptionsDefn = require('./WFTriggerOptionsDefn');

WFTriggerDefnSchema = new mongoose.Schema({
    refId : {
        type : "String",
        required : true
    },
    type : {
        type: "String",
        enum : ["webhook", "task", "schedule"],
        required: true
    },    
    triggerOptions : {
        type : WFTriggerOptionsDefn.schema,
        required : true
    },
});

exports.validator = joi.object().keys({
    refId: joi.string().required(),
    type: joi.string().valid("webhook", "task", "schedule").required(),
    triggerOptions: WFTriggerOptionsDefn.validator
})

exports.schema = WFTriggerDefnSchema;
exports.model = mongoose.model 'WFTriggerDefn', WFTriggerDefnSchema;
