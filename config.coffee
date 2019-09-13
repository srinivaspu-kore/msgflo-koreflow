envvar = (key, defaultValue) ->
  val = process.env[key]
  return if val? then val else defaultValue

module.exports =
  msgflo:
    broker: process.env.CLOUDAMQP_URL or process.env.MSGFLO_BROKER or 'amqp://localhost'
    db_url: process.env.DB_CONNECTION_URL or 'mongodb://localhost:27017/koredbm001'
