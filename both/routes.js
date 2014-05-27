//  Iron Router - for useage see https://github.com/EventedMind/iron-router

Router.configure({
  layoutTemplate: 'layout'
});

Router.map(function () {

  // delete me and replace with your homepage
  this.route('weixin', {path: '/'})

  // staffs routes
  this.route('staffChat', { path: '/staffs/chat',     controller: Staffs.chat }, function(){
    this.setHeader('access-control-allow-origin', '*');
    this.response.setHeader('access-control-allow-origin', '*');
  });

  this.route('staffs',    { path: '/staffs',          controller: Staffs.index });
  this.route('newStaff',  { path: '/staffs/new',      controller: Staffs.new });
  this.route('showStaff', { path: '/staffs/:id',      controller: Staffs.show });
  this.route('editStaff', { path: '/staffs/edit/:id', controller: Staffs.edit });

  // products routes
  this.route('products',    { path: '/products',          controller: Products.index });

  // developers routes
  this.route('developers',    { path: '/developers',          controller: Developers.index });

  // helps routes
  this.route('helps',    { path: '/helps',          controller: Helps.index });

});//<end-routes>

Router.onBeforeAction(function() {
  document.title = 'XinPlus';
});