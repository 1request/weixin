//  Iron Router - for useage see https://github.com/EventedMind/iron-router

Router.configure({
  layoutTemplate: 'layout'
});

Router.map(function () {

  // delete me and replace with your homepage
  this.route('weixin', {path: '/'})

  // staffs routes
  this.route('staffs',    { path: '/staffs',          controller: Staffs.index });
  this.route('newStaff',  { path: '/staffs/new',      controller: Staffs.new });
  this.route('showStaff', { path: '/staffs/:id',      controller: Staffs.show });
  this.route('editStaff', { path: '/staffs/edit/:id', controller: Staffs.edit });

});//<end-routes>

