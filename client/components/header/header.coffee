############################
# Local Functions
############################
@validateAccountInfo = ->
  if (!document.getElementById('gh_id').value)
    throw new Meteor.Error(422, 'Please fill in GH ID')
  if (!Session.get('accountSelected')?)
    account = db.accounts.findOne({gh_id: document.getElementById('gh_id').value})
    throw new Meteor.Error(422, 'GH ID is already in use') if account?
  if (!document.getElementById('weixin_id').value)
    throw new Meteor.Error(422, 'Please fill in WeChat ID')
  if (!document.getElementById('account_name').value)
    throw new Meteor.Error(422, 'Please fill in Account name')
  if (!document.getElementById('app_id').value)
    throw new Meteor.Error(422, 'Please fill in App ID')
  if (!document.getElementById('app_secret').value)
    throw new Meteor.Error(422, 'Please fill in App Secret')

############################
# Template: accountList
############################
Template.accountList.helpers
  accounts: ->
    db.accounts.find(user_id: Meteor.userId(), gh_id: {$not: Session.get 'accountSelected'})
  account: ->
    if Session.get 'accountSelected'
      db.accounts.findOne({user_id: Meteor.userId(), gh_id: Session.get 'accountSelected'})

Template.accountList.events
  'click li': (e) ->
    if e.target.id == 'addAccount'
      Session.set('accountSelected', undefined)
      Session.set('customerSelected', "")
    else if e.target.href.match '#'
      Session.set('accountSelected', @gh_id)
      Session.set('customerSelected', "")

Template.accountList.rendered = ->
  @accountListDep = Deps.autorun ->
    account = db.accounts.findOne(user_id: Meteor.userId())
    if account
      Session.setDefault('accountSelected', account.gh_id)

Template.accountList.destroyed = ->
  if @accountListDep
    @accountListDep.stop()

############################
# Template: accountModal
############################
Template.accountModal.helpers
  account: ->
    db.accounts.findOne({gh_id: Session.get('accountSelected')})
  accountSelected: ->
    Session.get('accountSelected')?

Template.accountModal.events
  'submit .form': (e) ->
    e.preventDefault()

    try 
      validateAccountInfo()

      HTTP.post(Meteor.settings.public.rails_server + '/accounts',
        params:
          gh_id: document.getElementById('gh_id').value
          weixin_id: document.getElementById('weixin_id').value
          name: document.getElementById('account_name').value
          app_id: document.getElementById('app_id').value
          app_secret: document.getElementById('app_secret').value
          user_id: Meteor.userId()
        headers:
          'Content-Type': 'application/x-www-form-urlencoded'
        (error, result) -> console.log result
      )

      Session.set('accountSelected', document.getElementById('gh_id').value)
      Session.set('customerSelected', "")

      $('.form')[0].reset()
      $('#accountModal').modal('toggle')
    catch error
      alert(error.reason)
