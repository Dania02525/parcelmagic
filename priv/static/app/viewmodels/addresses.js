define(['plugins/http', 'plugins/router', 'durandal/app', 'knockout', 'session'], function (http, router, app, ko, session) {
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
    self.addresses = ko.observable([]);
    self.canActivate = function () {
      if( session.token() == null){
        router.navigate('#');
        return false;
      }
      else{
        return true;
      }
    }
    self.attached = function(view) {
      self.loading(true);
      self.table(false);
      self.errormessage(false);
      self.addresses([]);
      var headers = {contentType: "application/json", authorization: "Bearer " + session.token()}
      http.get('/api/addresses', {}, headers).then(function(response) {
          self.addresses(response.data);
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