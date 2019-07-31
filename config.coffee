envvar = (key, defaultValue) ->
  val = process.env[key]
  return if val? then val else defaultValue

module.exports =
  msgflo:
    broker: process.env.CLOUDAMQP_URL or process.env.MSGFLO_BROKER or 'amqp://localhost'
