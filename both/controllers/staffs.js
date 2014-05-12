Staffs.chat = AppController.extend({
  waitOn: function() {
    currentUserId = Meteor.userId();

    return [
      Meteor.subscribe('staffs'), 
      Meteor.subscribe('customers'),
      Meteor.subscribe('messages', Session.get('customerSelected'))
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

