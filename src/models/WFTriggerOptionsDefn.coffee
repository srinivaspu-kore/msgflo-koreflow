joi = require('joi')
mongoose = require('mongoose');


WFTriggerOptionsDefnSchema = new mongoose.Schema({

});

exports.validator = joi.object().keys({});
exports.schema = WFTriggerOptionsDefnSchema;
exports.model = mongoose.model 'WFTriggerOptionsDefn', WFTriggerOptionsDefnSchema;
