Meteor.publish 'customers', (accountSelected, options)->
  account = db.accounts.findOne({gh_id: accountSelected})
  db.customers.find {account_id: account._id}, options if account