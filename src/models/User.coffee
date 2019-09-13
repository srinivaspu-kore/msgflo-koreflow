mongoose = require 'mongoose';

bcrypt = require 'bcrypt';

UserSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    trim: true
  },
  password: {
    type: String,
    required: true,
    trim: true
  }
});

UserSchema.pre('save', (next) -> 
  user = this;

  if (!user.isModified('password'))
    return next();

  bcrypt.genSalt(10, (err, salt) -> 
    if (err) 
        return next(err);

    bcrypt.hash(user.password, salt, (hashErr, hash) -> 
      if (hashErr) 
        return next(hashErr);

      user.password = hash;
      next();
    );
  );
);

UserSchema.methods.comparePassword = (toCompare, done) -> 
  bcrypt.compare(toCompare, this.password, (err, isMatch) -> 
    if (err) done(err);
    else done(err, isMatch);
  );

exports.schema = UserSchema
exports.model = mongoose.model('User', UserSchema);