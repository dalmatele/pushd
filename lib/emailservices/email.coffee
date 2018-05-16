settings = require '../../settings'
nodemailer = require "nodemailer"
emailValidator = require "email-validator"
logger = require 'winston'

class PushServiceEmail
  validateToken: (token) ->
        isEmail = emailValidator.validate(token)
        if(isEmail)
          return token
  #empty constructor
  constructor: ->
  
  #push email to subscriber
  push: (subscriber, subOptions, payload) ->
    
    subscriber.get (info) =>
      receiver = info.token
      config = 
        host: settings.email.host
        port: settings.email.port
        secure: true
        logger: true
        debug: true
        auth:
          user: settings.email.username
          pass: settings.email.password
      transporter = nodemailer.createTransport(config)
      mailOptions = 
        from: settings.email.username
        to: receiver
        subject: payload.title.default
        text: payload.msg.default
        #html: payload.html
      logger.verbose(mailOptions)
      transporter.sendMail(mailOptions, (error, result) ->
        if(error)
          logger.verbose(error);
          return
        logger.verbose("Message sent: %s", result.messageId) 
        return
      )
  
exports.PushServiceEmail = PushServiceEmail
  
