Meteor.publish 'customers', (accountSelected) ->
  account = db.accounts.findOne({gh_id: accountSelected})
  db.customers.find({account_id: account._id}) if account