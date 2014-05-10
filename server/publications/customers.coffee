Meteor.publish 'customers', ->
  db.customers.find()