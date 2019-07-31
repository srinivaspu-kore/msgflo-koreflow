class HttpError extends Error
  type: 'HttpError'
  constructor: (message, code = 500) ->
    super message
    @code = code
    @message = message

exports.HttpError = HttpError
