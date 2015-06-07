Router.configure
  layoutTemplate: 'DefaultLayout'

Router.route '/', ->
  this.render 'Home'

Router.route '/messages',
  name: 'messages'
  template: 'Messages'
  subscribe: ->
    this.subscribe 'lessons'
  data: -> Lessons.find({}, {sort:[['code', 'asc']]})

Router.route '/lesson/:_id/edit',
  name: 'lesson.edit'
  template: 'LessonEdit'
  data: -> Lessons.findOne(this.params._id)
  subscriptions: -> this.subscribe('lessonSingle', this.params._id)

Router.route '/lesson/:_id',
  name: 'lesson.view'
  template: 'Lesson'
  data: -> Lessons.findOne(this.params._id)
  subscriptions: -> this.subscribe('lessonSingle', this.params._id)

Router.route '/lesson/:_id/send',
  name: 'lesson.send'

Router.route 'download/:messageId/:fileName', ->
  msg = Lessons.findOne(this.params.messageId)
  for file in msg.attachments
    if file.fileName is this.params.fileName
      this.response.writeHead 200,
        'Content-Type': file.contentType
        # 'Content-Disposition': 'attachment; filename=' + file.fileName
      this.response.end new Buffer(file.content.data), 'binary'
      return
  this.response.writeHead 404
  this.response.end 'not found'
, where: 'server'

if (Meteor.isClient)

  Session.setDefault("counter", 0)
  
  Template.MessageRow.events
    "click .toggle-text": (event, template)->
      $(template.find(".collapse")).toggleClass("in")

  Template.LessonEdit.rendered = ->
    $('.form-control[name=html]').summernote
      maxHeight: 400
      height: 300

  Tracker.autorun ->
    Meteor.subscribe("lessons")

if (Meteor.isServer)

  Meteor.publish 'lessonSingle', (_id)->
    Lessons.find _id, { fields: { 'attachments.content': 0 } }

  Meteor.publish 'lessons', -> Lessons.find {},
    fields:
      'attachments.content':0
      text: 0
      html: 0


