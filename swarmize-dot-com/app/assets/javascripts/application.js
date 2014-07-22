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
//= require_tree .

$.verify.addRules({
  isAPostcode: function(field) {
    var fullPostcodeRegex = /^([A-Z][A-Z0-9]?[A-Z0-9]?[A-Z0-9]? {1,2}[0-9][A-Z0-9]{2})$/;
    var halfPostcodeRegex = /^(([A-Z][0-9])|([A-Z][A-Z0-9][A-Z])|([A-Z][A-Z][0-9][A-Z0-9]?))$/;
    if(field.val().trim().match(fullPostcodeRegex) || field.val().trim().match(halfPostcodeRegex)) {
      return true
    } else {
      return "Sorry, that doesn't look like a real UK postcode.";
    }
  }
});

$(document).ready(function() {
  $('.dropdown-toggle').dropdown();
});

