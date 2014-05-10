############################
# Function: layoutDone()
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
  messageCount: ->
    @count
  newMessage: ->
    @count > 0

  lastUpdateTime: ->
    Date.now()

  messages: ->
    db.messages.find()

Template.chat.events
  'submit .form': (e) ->
    e.preventDefault()

    message = $('.write-message')
    data =
      message: message.val()
      user_id: Meteor.userId()
      message_type: 'staff'
    db.messages.insert(data)

    message.val('')

    Meteor.defer ->
      layoutDone()
      toBottom()

Template.chat.rendered = ->
  layoutDone()

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
  toBottom()

