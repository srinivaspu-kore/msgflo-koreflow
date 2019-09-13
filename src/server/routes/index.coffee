debug = require('debug')('koreflow:router');
express = require 'express';
workflowdefinitionRoutes = require './workflowdefinitions';
workflowinstanceRoutes = require './workflowinstances';
authRoutes = require './auth';

router = express.Router();

router.use((req, res, next) ->
    debug('Received request:', req.url, 'at Time: ', new Date())
    next()
)

router.get('/health', (req, res) =>
  res.json
    status: "ok"
);

router.use('/workflow/processes', workflowinstanceRoutes);
router.use('/workflow/definitions', workflowdefinitionRoutes);
router.use('/auth', authRoutes);

module.exports = router;