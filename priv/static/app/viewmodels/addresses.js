define(['plugins/http', 'durandal/app', 'knockout', 'session'], function (http, app, ko, session) {
    //Note: This module exports an object.
    //That means that every module that "requires" it will get the same object instance.
    //If you wish to be able to create multiple instances, instead export a function.
    //See the "welcome" module for an example of function export.

  function vm(){
    var self = this;
    self.displayName = 'Saved Addresses';
    self.loading = ko.observable(true);
    self.table = ko.observable(false);
    self.errormessage = ko.observable(false);
    self.activate = function () {

    }
    self.attached = function(view) {
      var headers = {contentType: "application/json", token: session.token}
      http.get('/api/addresses', {}, headers).then(function(response) {
          self.addresses(response);
          self.loading(false);
          self.table(true);
      }).fail( function() {
          self.loading(false);
          self.errormessage(true);
      });

    }
  }

  return new vm();

});