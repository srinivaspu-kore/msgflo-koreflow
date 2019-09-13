joi = require('joi')
mongoose = require('mongoose');

WFDataFieldValue = require('./WFDataFieldValue');

WFDataItemSchema = new mongoose.Schema({
    groupName : {
        type : "String",
        required : true
    },
    fields : {
        type : [WFDataFieldValue.schema],
        required : true,
        default: undefined
    }
});

exports.validator = joi.object().keys({
    groupName: joi.string().required(),
    fields: joi.array().items(WFDataFieldValue.validator).required()
})

exports.schema = WFDataItemSchema;
exports.model = mongoose.model 'WFDataItem', WFDataItemSchema;
