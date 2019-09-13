mongoose = require 'mongoose'
debug = require('debug')('koreflow:db')

exports.connect = (dbUrl) ->
    mongoose.connect(dbUrl, { useNewUrlParser: true })
    mongoose.connection.on 'error', () -> 
        throw new Error("unable to connect to database: ", dbUrl);
    mongoose.connection.on 'connected', () -> 
        console.log("Connected to database: ", dbUrl)
