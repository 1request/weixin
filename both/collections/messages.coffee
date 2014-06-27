db.messages = new Meteor.Collection 'messages'

db.messages.allow
  insert: (userId, doc) ->
    if doc.message != ""
      true
    else
      throw new Meteor.Error(422, '不能发送空消息')