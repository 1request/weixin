Meteor.publish 'messages', ->
  db.messages.find()