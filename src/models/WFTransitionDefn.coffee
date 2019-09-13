joi = require('joi')
mongoose = require('mongoose');

WFConditionalIf = require('./WFConditionalIf');

WFTransitionDefnSchema = new mongoose.Schema({
    if : {
        type : WFConditionalIf.schema,
        required : false
    },
    then : {
        type : "String",
        required : false
    },
    else : {
        type : "String",
        required : false
    },
    default : {
        type : "String",
        required : true
    }
});

exports.validator = joi.object().keys({
    if: WFConditionalIf.validator,
    then: joi.string(),
    else: joi.string(),
    default: joi.string()
})

exports.schema = WFTransitionDefnSchema;
exports.model = mongoose.model 'WFTransitionDefn', WFTransitionDefnSchema;
