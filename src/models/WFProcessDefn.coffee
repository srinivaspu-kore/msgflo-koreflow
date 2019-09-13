joi = require('joi')
mongoose = require('mongoose');

WFTriggerDefn = require('./WFTriggerDefn');
WFDataItemDefn = require('./WFDataItemDefn');
WFStepDefn = require('./WFStepDefn');

WFProcessDefnSchema = new mongoose.Schema({
    refId : {
        type : "String",
        required : true
    },
    trigger : {
        type : WFTriggerDefn.schema,
        required : true
    },
    data : {
        type : [WFDataItemDefn.schema],
        required : true,
        default: undefined
    },
    steps : {
        type : [WFStepDefn.schema],
        required : true,
        default: undefined
    }
});

exports.validator = joi.object().keys({
      refId: joi.string().required(),
      trigger: WFTriggerDefn.validator,
      data: joi.array().items(WFDataItemDefn.validator).required(),
      steps: joi.array().items(WFStepDefn.validator).required()
})

exports.schema = WFProcessDefnSchema;
exports.model = mongoose.model('WFProcessDefn', WFProcessDefnSchema);