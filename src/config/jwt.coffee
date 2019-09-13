config = require './env';
jwt = require 'express-jwt';

authenticate = jwt({
  secret: config.jwtSecret
});

module.exports = authenticate;