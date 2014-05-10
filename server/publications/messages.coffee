Meteor.publish 'messages', (userId) ->
  db.messages.find({user_id: userId})