jwt = require 'jsonwebtoken';
config = require '../../config/env';
User = require '../../models/User';

authenticate = (req, res, next) -> 
  User.model.findOne({
      username: req.body.username
    })
    .exec()
    .then((user) -> 
      if (!user) 
        return next();
      user.comparePassword(req.body.password, (e, isMatch) -> 
        if (e) 
          return next(e);
        if (isMatch)
          req.user = user;
          next();
        else
          return next();
      );
    , (e) -> next(e))


generateToken = (req, res, next) ->
  if (!req.user)
    return next();

  jwtPayload = {
    id: req.user._id
  };
  jwtData = {
    expiresIn: config.jwtDuration,
  };
  secret = config.jwtSecret;
  req.token = jwt.sign(jwtPayload, secret, jwtData);

  next();

respondJWT = (req, res) ->
  if (!req.user)
    res.status(401).json({
      error: 'Unauthorized'
    });
  else
    res.status(200).json({
      jwt: req.token
    });

module.exports = { authenticate, generateToken, respondJWT };