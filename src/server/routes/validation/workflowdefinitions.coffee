joi = require 'joi';
WFProcessDefn = require('../../../models/WFProcessDefn');

module.exports = {
  createWorkflowDefinition: {
    body: WFProcessDefn.validator
  },

  getWorkflowDefinition: {
    params: {
      definitionId: joi.string().regex(/^[0-9a-fA-F]{24}$/).required()
    }
  },

  updateWorkflowDefinition: {
    body: WFProcessDefn.validator
  }
};