Meteor.publish 'customers', (options)->
  db.customers.find {}, options