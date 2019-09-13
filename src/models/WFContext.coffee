joi = require('joi')
mongoose = require('mongoose');


WFContextSchema = new mongoose.Schema({

});

exports.validator = joi.object().keys({});
exports.schema = WFContextSchema;
exports.model = mongoose.model 'WFContext', WFContextSchema;
