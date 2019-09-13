joi = require('joi')
mongoose = require('mongoose');

WFDataFieldDefn = require('./WFDataFieldDefn');

WFDataItemDefnSchema = new mongoose.Schema({
    groupName : {
        type : "String",
        required : true
    },
    fields : {
        type : [WFDataFieldDefn.schema],
        required : true,
        default: undefined
    }
});

exports.validator = joi.object().keys({
    groupName: joi.string().required(),
    fields: joi.array().items(WFDataFieldDefn.validator).required()
})

exports.schema = WFDataItemDefnSchema;
exports.model = mongoose.model 'WFDataItemDefn', WFDataItemDefnSchema;
