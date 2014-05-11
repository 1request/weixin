############################
# Local Functions
############################
toBottom = ->
  $('.conversation .talk').animate({scrollTop: $('.conversation .talk #chat-messages-inner').height()});
  
layoutDone = ->
  $('.me').map (index, elem) ->
    padding = 20
    height = $(elem).find('.message-content').height() + padding
    offset = height - 17
    $(elem).find('.message-arrow').css({'height': height + 'px', 'background-position-y': offset + 'px'})

############################
# Template: chat
############################
Template.chat.helpers
  customers: ->
    db.customers.find()

  lastUpdateTime: ->
    Session.get('lastUpdateTime')

  messages: ->
    db.messages.find()

  showDefault: ->
    'default' if Session.get('customerSelected') == ''

  isDisabled: ->
    'disabled' if Session.get('customerSelected') == ''

Template.chat.events
  'submit .form': (e) ->
    e.preventDefault()

    message = $('.write-message')
    data =
      message: message.val()
      customer_id: Session.get('customerSelected')
      user_id: Meteor.userId()
      message_type: 'staff'
    db.messages.insert(data)

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
Template.messageItem.rendered = ->
  layoutDone()

