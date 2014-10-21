// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require underscore-min
//= require backbone-min
//= require parsley-config
//= require parsley.min
//= require d3.min
//= require c3.min
//= require rickshaw.min
//= require moment.min
//= stub swarmize-embed
//= require_tree .

$(document).ready(function() {
  $('.disabled a').click(function(e) { e.preventDefault(); return false });

});

function parseTimestamp(string) {
  return moment(string);
}

function formatTimestamp(timestamp) {
  return moment(timestamp).format('D MMMM YYYY HH:mm:ss');
}
