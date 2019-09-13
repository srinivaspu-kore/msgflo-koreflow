joi = require('joi')
mongoose = require('mongoose');


WFConditionalIfSchema = new mongoose.Schema({
    context : {
        type : "String",
        required : true
    },
    op : {
        type : "String",
        required : true
    },
    value : {
        type : "String",
        required : true
    }
});

exports.validator = joi.object().keys({
    context: joi.string().required(),
    op: joi.string().required(),
    value: joi.string().required()
})

exports.schema = WFConditionalIfSchema;
exports.model = mongoose.model 'WFConditionalIf', WFConditionalIfSchema;