Meteor.publish 'messages', (customerId) ->
  db.messages.find({customer_id: customerId})