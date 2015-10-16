define(['plugins/http', 'plugins/router', 'durandal/app'], function (http, router, app) {
    //Note: This module exports an object.
    //That means that every module that "requires" it will get the same object instance.
    //If you wish to be able to create multiple instances, instead export a function.
    //See the "welcome" module for an example of function export.

  function vm(){
    validation.init({
      decorateInputElement: true,
      errorElementClass: 'invalid',
      decorateElementOnModified: true,
      messagesOnModified: true,
      grouping: {
        deep: false
      }
    });
    var self = this;
    self.displayName = 'Shipping Quote';
    self.session = session;
    self.canActivate = function () {
      if( session.token() === null){
        router.navigate('#');
        return false;
      }
      else{
        return true;
      }
    };
    self.activate = function (context) {
      var headers = {};
      if(typeof context === 'undefined'){
        context = {};
      }
      if(context.from){
        headers = {contentType: "application/json", authorization: "Bearer " + session.token()};
        http.get('/api/addresses/' + context.from, {}, headers).then(function(response) {
          session.shipment.from_address.select(response.data);
        });
      }
      if(context.to){
        headers = {contentType: "application/json", authorization: "Bearer " + session.token()};
        http.get('/api/addresses/' + context.to, {}, headers).then(function(response) {
          session.shipment.to_address.select(response.data);
        });
      }
      if(context.parcel){
        headers = {contentType: "application/json", authorization: "Bearer " + session.token()};
        http.get('/api/parcels/' + context.parcel, {}, headers).then(function(response) {
          session.shipment.parcel.select(response.data);
        });
      }
      $(document).ready(function() {
        $('select').material_select();
      });
    };
    self.attached = function(view) {
      $(document).ready(function() {
        $('select').material_select();
      });
    };
  }

  return new vm();

});