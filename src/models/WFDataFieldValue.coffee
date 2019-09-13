joi = require('joi')
mongoose = require('mongoose');


WFDataFieldValueSchema = new mongoose.Schema({
    fieldName : {
        type : "String",
        required : true
    },
    fieldValue : {
        type : "String",
        required : true
    }
});

exports.validator = joi.object().keys({
    fieldName: joi.string().required(),
    fieldValue: joi.string().required()
})

exports.schema = WFDataFieldValueSchema;
exports.model = mongoose.model 'WFDataFieldValue', WFDataFieldValueSchema;