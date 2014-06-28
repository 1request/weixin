db.messages = new Meteor.Collection 'messages'

Meteor.methods
  insertMsg: (data) ->
    if !data.message
      throw new Meteor.Error(422, '不能发送空消息')
    msgId = db.messages.insert(data)