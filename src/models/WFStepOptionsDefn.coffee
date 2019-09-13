joi = require('joi')
mongoose = require('mongoose');


WFStepOptionsDefnSchema = new mongoose.Schema({

});

exports.validator = joi.object().keys({})

exports.schema = WFStepOptionsDefnSchema;
exports.model = mongoose.model 'WFStepOptionsDefn', WFStepOptionsDefnSchema;

