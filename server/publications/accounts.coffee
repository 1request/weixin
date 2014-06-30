Meteor.publish 'accounts', (userId)->
  db.accounts.find(user_id: userId)
