chartdata = '';

Template.developers.helpers({
  html: function() {
    return new Handlebars.SafeString('<h2>hello</h2>');
  },

  data: function() {
    year_start = 2008;

    output = new Array();

    db.customers.find({}).forEach(function(count) {
      output.push({ year: year_start++, value: count.count });
    });
    console.log('interesting: ' + output);

    if (chartdata != '') {
      chartdata.setData(output);
    }

    return output;
  }
});

Template.developers.events({
  
});

Template.developers.rendered = function() {

  console.log('rendered');
  
  chartdata = new Morris.Line({
    // ID of the element in which to draw the chart.
    element: 'myfirstchart',
    // Chart data records -- each entry in this array corresponds to a point on
    // the chart.
    data: this.data,
    // The name of the data record attribute that contains x-values.
    xkey: 'year',
    // A list of names of data record attributes that contain y-values.
    ykeys: ['value'],
    // Labels for the ykeys -- will be displayed when you hover over the
    // chart.
    labels: ['Value']
  });

};
