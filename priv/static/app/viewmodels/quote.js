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
        deep: true
      }
    });
    var self = this;
    self.displayName = 'Shipping Quote';
    self.session = session;
    self.canActivate = function () {
      if( session.token() == null){
        router.navigate('#');
        return false;
      }
      else{
        return true;
      }
    }
    self.activate = function (context) {
      if(typeof context == 'undefined'){
        context = {};
      }
      if(context.from){
        var headers = {contentType: "application/json", authorization: "Bearer " + session.token()}
        http.get('/api/addresses/' + context.from, {}, headers).then(function(response) {
          session.shipment.From.select(response.data);
        });
      }
      if(context.to){
        var headers = {contentType: "application/json", authorization: "Bearer " + session.token()}
        http.get('/api/addresses/' + context.to, {}, headers).then(function(response) {
          session.shipment.To.select(response.data);
        });
      }
      if(context.parcel){
        var headers = {contentType: "application/json", authorization: "Bearer " + session.token()}
        http.get('/api/parcels/' + context.parcel, {}, headers).then(function(response) {
          session.shipment.Parcel.select(response.data);
        });
      }
    }
    self.attached = function(view) {
      $(document).ready(function() {
        $('select').material_select();
      });
    }
  }

  return new vm();

});