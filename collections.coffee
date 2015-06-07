@Messages = new Mongo.Collection('messages')
@Lessons = new Mongo.Collection('lessons')

@Lessons.attachSchema new SimpleSchema
  title:
    type: String
    label: "Title"
    max: 200
  code:
    type: String
    label: "Code"
    max: 25
    optional: true
  text:
    type: String
    label: "Text"
    autoform:
      rows: 15
  html:
    type: String
    label: "HTML"
    optional: true
    autoform:
      rows:15
  attachments:
    type: [Object]
    label: "Pdf Files"
    optional: true
  "attachments.$.fileName":
    type: String
    label: "File Name"
  "attachments.$.contentType":
    type: String
    label: "Content Type"
  "attachments.$.content":
    type: Object
    label: "File Contents"
    blackbox: true
    autoform:
      omit:true

