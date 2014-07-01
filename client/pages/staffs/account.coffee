############################
# Template: accountInfo
############################
Template.accountInfoDetail.helpers
  accountSelected: ->
    Session.get('accountSelected')
  account: ->
    db.accounts.findOne({gh_id: Session.get('accountSelected')})
  account_url: ->
    account = db.accounts.findOne({gh_id: Session.get('accountSelected')})
    if account
      Meteor.settings.public.rails_server + '/weixin/' + account.weixin_secret_key

