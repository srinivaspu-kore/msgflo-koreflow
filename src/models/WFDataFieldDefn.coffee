joi = require('joi')
mongoose = require('mongoose');


WFDataFieldDefnSchema = new mongoose.Schema({
    fieldName : {
        type : "String",
        required : true
    },
    fieldDescription : {
        type : "String",
        required : true
    },
    fieldType : {
        type : "String",
        required : true
    },
    fieldOption : {
        type : "String",
        required : false
    },
    default : {
        type : mongoose.Schema.Types.Mixed,
        required : false
    },
});

exports.validator = joi.object().keys({
    fieldName: joi.string().required(),
    fieldDescription: joi.string().required(),
    fieldType: joi.string().required(),
    fieldOption: joi.string(),
    default: joi.any()
})

exports.schema = WFDataFieldDefnSchema;
exports.model = mongoose.model 'WFDataFieldDefn', WFDataFieldDefnSchema;