############################
# Local Functions
############################
@toBottom = ->
  $('.conversation .talk').animate({scrollTop: $('.conversation .talk #chat-messages-inner').height()});
  
layoutDone = ->
  $('.me').map (index, elem) ->
    padding = 20
    height = $(elem).find('.message-content').height() + padding
    offset = height - 17
    $(elem).find('.message-arrow').css({'height': height + 'px', 'background-position-y': offset + 'px'})

############################
# Template: accountInfo
############################
Template.accountInfo.helpers
  accountSelected: ->
    Session.get('accountSelected')
  account: ->
    db.accounts.findOne({gh_id: Session.get('accountSelected')})
  account_url: ->
    account = db.accounts.findOne({gh_id: Session.get('accountSelected')})
    if account
      'http://api.xin.io/weixin/' + account.weixin_secret_key

############################
# Template: chat
############################
Template.chat.helpers
  customers: ->
    db.customers.find()

  lastUpdateTime: ->
    Session.get('lastUpdateTime')

  messages: ->
    db.messages.find({}, {sort: {weixin_msg_id: 1}})

  showDefault: ->
    'default' if Session.get('customerSelected') == ''

  isDisabled: ->
    'disabled' if Session.get('customerSelected') == ''

Template.chat.events
  'submit .form': (e) ->
    e.preventDefault()
    account = db.accounts.findOne({gh_id: Session.get('accountSelected')})

    message = $('.write-message')
    data =
      message: message.val()
      account_id: account._id
      customer_id: Session.get('customerSelected')
      user_id: Meteor.userId()
      message_type: 'staff'
    db.messages.insert(data)

    customer = db.customers.findOne({_id: Session.get('customerSelected')})
    HTTP.post('http://api.xin.io/kf',
      params:
        gh_id: Session.get('accountSelected')
        weixin_id: customer.fromUser
        q: message.val()
      headers:
        'Content-Type': 'application/x-www-form-urlencoded'
      (error, result) -> console.log result
    )

    message.val('')

    Session.set('lastUpdateTime', Date())

    Meteor.defer ->
      layoutDone()
      toBottom()

Template.chat.rendered = ->
  Session.set('customerSelected', '')
  layoutDone()

############################
# Template: userItem
############################
Template.userItem.helpers
  messageCount: ->
    @count
  newMessage: ->
    @count > 0
  customerSelected: ->
    'user-selected' if Session.get('customerSelected') == @_id

Template.userItem.events
  'click li': (e) ->
    db.customers.update({_id: @_id}, {$set: {count: 0}})
    Session.set('customerSelected', @_id)
    Meteor.setTimeout toBottom, 100

############################
# Template: messageItem
############################
Template.messageItem.helpers
  youOrMe: ->
    if @message_type is 'staff'
      'me'
    else
      'you'
  contentTypeIs: (type) ->
    @content_type is type
  railsUrl: ->
    'http://api.xin.io'

Template.messageItem.rendered = ->
  layoutDone()

Template.messageItem.events
  'click img[data-toggle=\"modal\"]': (e) ->
    e.preventDefault()
    target = e.target.src

    $("#messageModal .modal-body").load target, ->
      $('#modalMedia').remove()
      $(this).append('<img class="model-media" id="modalMedia" />')
      $('#modalMedia').attr('src', target)

  'click button': (e) ->
    target = e.target.value
    window.open target, "_blank"

Deps.autorun ->
  console.log 'user: ', Meteor.user(), ' logging: ', Meteor.loggingIn()
