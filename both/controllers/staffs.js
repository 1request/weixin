Staffs.chat = AppController.extend({
  customersOption: function(){
    if (Session.get('customersLimit')){
      return {limit: Session.get('customersLimit')};
    }
    else {
      Session.set('customersLimit', Meteor.settings.public.customers_inc);
      return {limit: Session.get('customersLimit')};
    }
  },  
  messagesOption: function(){
    var messagesLimit = Session.get('customerSelected') + 'msgsLimit';
    if (Session.get(messagesLimit)){
      return {
        sort: {created_at: -1},
        limit: Session.get(messagesLimit)
      };
    }
    else {
      Session.set(messagesLimit, Meteor.settings.public.messages_inc)
       return {
        sort: {created_at: -1},
        limit: Session.get(messagesLimit)
      };
    }
  },
  waitOn: function() {
    currentUserId = Meteor.userId();
    return [
      Meteor.subscribe('staffs'), 
      Meteor.subscribe('accounts', Meteor.userId()),
      Meteor.subscribe('customers', Session.get('accountSelected'), this.customersOption()),
      Meteor.subscribe('messages', Session.get('customerSelected'), this.messagesOption())
    ];
  }
});

// page for a list of Staffs - /staffs
Staffs.index = AppController.extend({
  template: 'staffs',

  onBeforeAction: function() {

  },

  onAfterAction: function() {
    Router.go('staffChat');
  }
});

 
// page for creating a single Staff - /staffs/new/:id
Staffs.new = AppController.extend({
  template: 'newStaff',

  onBeforeAction: function() {

  },

  onAfterAction: function() {

  }
});

  
// page for showing a single Staff - /staffs/:id
Staffs.show = AppController.extend({
  template: 'showStaff',

  onBeforeAction: function() {

  },

  onAfterAction: function() {

  }
});

 
// show edit page for single Staff : /staffs/edit/:id
Staffs.edit = AppController.extend({
  template: 'editStaff',

  onBeforeAction: function() {

  },

  onAfterAction: function() {

  }
});

 
// create a Staff
Staffs.create = function(data, callback) {
  console.log('Fired Create Staff', data);
  Meteor.call('Staffs.create', data, callback);
};

 
// update a Staff
Staffs.update = function(data, callback) {
  console.log('Fired Update Staff', data);
  Meteor.call('Staffs.update', data, callback);
};


// destroy a Staff
Staffs.destroy = function(data, callback) {
  console.log('Fired Destroy Staff', data);
  Meteor.call('Staffs.destroy', data, callback);
};

