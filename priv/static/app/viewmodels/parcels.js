define(['plugins/http', 'plugins/router', 'durandal/app', 'knockout', 'session'], function (http, router, app, ko, session) {
    //Note: This module exports an object.
    //That means that every module that "requires" it will get the same object instance.
    //If you wish to be able to create multiple instances, instead export a function.
    //See the "welcome" module for an example of function export.

  function vm(){
    var self = this;
    self.displayName = 'Saved Parcels';
    self.loading = ko.observable(true);
    self.table = ko.observable(false);
    self.errormessage = ko.observable(false);
    self.parcels = ko.observable([]);
    self.canActivate = function () {
      if( session.token() === null){
        router.navigate('#');
        return false;
      }
      else{
        return true;
      }
    };
    self.attached = function(view) {
      var headers = {};
      self.loading(true);
      self.table(false);
      self.errormessage(false);
      self.parcels([]);
      headers = {contentType: "application/json", authorization: "Bearer " + session.token()};
      http.get('/api/parcels', {}, headers).then(function(response) {
          self.parcels(response.data);
          self.loading(false);
          self.table(true);
      }).fail( function(response) {
          console.log(response.status); //401, 404, 500 etc 401 should cause redirect to login
          console.log(JSON.parse(response.responseText)); //error message/decription object
          switch(response.status){
            case 401:
              session.token(null);
              router.navigate('#');
              break;
            case 400:
              //display specific error message in toast 
              break;
            case 422:
              //display specific error message in toast 
              break;
            default:
              //display some error about the server
              break;
          }
          self.loading(false);
          self.errormessage(true);
      });
    };

  }

  return new vm();

});