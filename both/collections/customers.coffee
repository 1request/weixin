db.customers = new Meteor.Collection 'customers'

db.customers.allow
  insert: (userId, doc) ->
    true