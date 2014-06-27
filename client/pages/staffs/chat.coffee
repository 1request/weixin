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
# Template: chat
############################
Template.chat.helpers
  customers: ->
    db.customers.find()

  lastUpdateTime: ->
    Session.get('lastUpdateTime')
    
  messages: ->
    db.messages.find(customer_id: Session.get('customerSelected'), {sort: created_at: 1})

  showDefault: ->
    'default' if Session.get('customerSelected') == ''

  isDisabled: ->
    'disabled' if Session.get('customerSelected') == ''

  greeting: ->
    t = new Date()
    h = t.getHours()
    if h >=0 && h <= 2
      greeting = '午夜好' 
    else if h >=3 && h <= 5
      greeting = '凌晨好' 
    else if h >= 6 && h <= 11
      greeting = '早上好' 
    else if h >=12 && h <=13
      greeting = '中午好' 
    else if h >=14 && h <=16
      greeting = '下午好' 
    else if h >= 17 && h <= 21
      greeting = '傍晚好' 
    else
      greeting = '晚上好'
    greeting

Template.chat.events
  'submit .form': (e) ->
    e.preventDefault()

    message = $('.write-message')
    data =
      message: message.val()
      customer_id: Session.get('customerSelected')
      user_id: Meteor.userId()
      message_type: 'staff'
      created_at: new Date()
    db.messages.insert(
      data,
      (error) ->
        if error
          return alert(error.reason)
    )

    customer = db.customers.findOne({_id: Session.get('customerSelected')})
    HTTP.post('http://api.xin.io/kf',
      params:
        weixin_id: customer.fromUser
        q: message.val()
      headers:
        'Content-Type': 'application/x-www-form-urlencoded'
      (error, result) -> console.log result
    )

    message.val('')

    Session.set('lastUpdateTime', Date())

    messagesLimit = Session.get('customerSelected') + 'msgsLimit'
    limit = Session.get(messagesLimit) + 1
    Session.set(messagesLimit, limit)

    Meteor.defer ->
      layoutDone()
      toBottom()

  # Load More customers
  'click .more-customers': (e) ->
    e.preventDefault

    increment = 2
    if Session.get('customersLimit')
      limit = Session.get('customersLimit') + increment
      Session.set('customersLimit', limit)
      Meteor.subscribe('customers', limit: Session.get('customersLimit'))
    else
      Session.setDefault('customersLimit', increment)

  # Load More messages
  'click .more-messages': (e) ->
    e.preventDefault

    increment = 2
    messagesLimit = Session.get('customerSelected') + 'msgsLimit'
    if Session.get(messagesLimit)
      limit = Session.get(messagesLimit) + increment
      Session.set(messagesLimit, limit)
      Meteor.subscribe('messages', Session.get('customerSelected'), limit: Session.get(messagesLimit))
    else
      Session.setDefault(messagesLimit, increment)

Template.chat.rendered = ->
  Session.set('customerSelected', '')
  Session.set('customersLimit', 5)
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
