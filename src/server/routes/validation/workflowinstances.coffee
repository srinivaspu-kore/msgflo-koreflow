joi = require 'joi';
WFProcessInstance = require('../../../models/WFProcessInstance');

module.exports = {
  createWorkflowInstance: {
    body: WFProcessInstance.validator
  },

  getWorkflowInstance: {
    params: {
      instanceId: joi.string().regex(/^[0-9a-fA-F]{24}$/).required()
    }
  },

  updateWorkflowInstance: {
    body: WFProcessInstance.validator
  }
};