# customer = db.customers.find()
# customer.forEach (eachCustomer) ->
#   msg = db.messages.find(customer_id: eachCustomer._id)
#   msg.forEach (message) ->
#     if !message.created_at
#       message.created_at = new Date()
