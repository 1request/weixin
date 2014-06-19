############################
# Testing Functions
############################
@test = (content, from) ->
  customer = db.customers.findOne({name: from})
  customerId = if customer isnt null then customer._id else Session.get('customerSelected')
  count = if customer isnt null then customer.count + 1 else 1
  data = 
    message: content
    customer_id: customerId
    message_type: 'customer'
  console.log data
  db.messages.insert(data)
  if Session.get('customerSelected') isnt customerId
    db.customers.update({_id: customerId}, {$set: {count: count}})
  Meteor.setTimeout toBottom, 100

@addCustomer = (from) ->
  customer = db.customers.insert({
    name: from, 
    headimgurl: '/assets/avatar.jpg'
    count: 0
  })
