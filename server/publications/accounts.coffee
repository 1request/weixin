Meteor.publish 'accounts', ->
  db.accounts.find()
