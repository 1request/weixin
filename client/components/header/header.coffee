############################
# Local Functions
############################
@validateAccountInfo = ->
  if (!document.getElementById('weixin_id').value)
    throw new Meteor.Error(422, 'Please fill in WeChat ID')
  if (!Session.get('accountSelected')?)
    account = db.accounts.findOne({weixin_id: document.getElementById('weixin_id').value})
    throw new Meteor.Error(422, 'WeChat ID is already in use') if account?
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
    db.accounts.find()

Template.accountList.events
  'click li': (e) ->
    Session.set('accountSelected', @weixin_id)

Template.accountModal.helpers
  account: ->
    db.accounts.findOne({weixin_id: Session.get('accountSelected')})

Template.accountModal.events
  'submit .form': (e) ->
    e.preventDefault()

    try 
      validateAccountInfo()

      HTTP.post('http://localhost:3000/accounts',
        params:
          weixin_id: document.getElementById('weixin_id').value
          name: document.getElementById('account_name').value
          app_id: document.getElementById('app_id').value
          app_secret: document.getElementById('app_secret').value
        headers:
          'Content-Type': 'application/x-www-form-urlencoded'
        (error, result) -> console.log result
      )

      Session.set('accountSelected', document.getElementById('weixin_id').value)

      $('.form')[0].reset()
      $('#accountModal').modal('toggle')
    catch error
      alert(error.reason)
