module.exports =
  env: 'development',
  db: 'mongodb://localhost/node-es6-api-dev',
  port: 3000,
  jwtSecret: 'my-api-secret',
  jwtDuration: '2 hours',
  msgflo:
    broker: process.env.CLOUDAMQP_URL or process.env.MSGFLO_BROKER or 'amqp://localhost'
    db_url: process.env.DB_CONNECTION_URL or 'mongodb://localhost:27017/koredbm001'