Meteor.publish 'messages', (customerId, options) ->
  db.messages.find({customer_id: customerId}, options)