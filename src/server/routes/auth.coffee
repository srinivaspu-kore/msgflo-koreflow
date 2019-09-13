express = require 'express';
authCtrl = require '../controllers/auth';

router = express.Router();

router.route('/token')
  .post(authCtrl.authenticate,
    authCtrl.generateToken,
    authCtrl.respondJWT);

module.exports = router;