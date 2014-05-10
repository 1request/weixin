db.messages = new Meteor.Collection 'messages'

db.messages.allow
  insert: (userId, doc) ->
    true