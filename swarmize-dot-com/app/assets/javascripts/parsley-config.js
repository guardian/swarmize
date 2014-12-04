window.ParsleyConfig = {
  validators: {
    postcode: {
      fn: function (value, requirement) {
        var fullPostcodeRegex = /^([A-Z][A-Z0-9]?[A-Z0-9]?[A-Z0-9]? {1,2}[0-9][A-Z0-9]{2})$/;
        var halfPostcodeRegex = /^(([A-Z][0-9])|([A-Z][A-Z0-9][A-Z])|([A-Z][A-Z][0-9][A-Z0-9]?))$/;
        if(value.trim().toUpperCase().match(fullPostcodeRegex) || value.trim().toUpperCase().match(halfPostcodeRegex)) {
          return true;
        } else {
          return false
        }
      },
      priority: 32
    },
    conditionalother: {
      fn: function (value, requirement) {
        var vals = $('input[name="'+requirement+'"]:checked, select[name="'+requirement+'"] option:selected').map(function() {
          return this.value;
        });

        $.inArray('other', vals)
        if(($.inArray('other', vals) > -1) && value == '') {
          return false;
        } else {
          return true;
        }
      },
      priority: 32
    }
  },
  i18n: {
    en: {
      postcode: 'Please enter a valid UK postcode, eg "SW1A 1AA" or "SW1A"',
      conditionalother: 'Please supply an answer for \'other\''
    }
  }
};
