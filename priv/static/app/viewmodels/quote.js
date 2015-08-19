define(['plugins/http', 'plugins/router', 'durandal/app', 'knockout', 'session', 'materialize', 'images'], function (http, router, app, ko, session, materialize, images) {
    //Note: This module exports an object.
    //That means that every module that "requires" it will get the same object instance.
    //If you wish to be able to create multiple instances, instead export a function.
    //See the "welcome" module for an example of function export.

  function Address(data){
    var self = this;
    self.name = ko.observable(data.name);
    self.company = ko.observable(data.company);
    self.street1 = ko.observable(data.street1);
    self.street2 = ko.observable(data.street2);
    self.city = ko.observable(data.city);
    self.state = ko.observable(data.state);
    self.zip = ko.observable(data.zip);
    self.country = ko.observable(data.country);
    self.phone = ko.observable(data.phone);
    self.email = ko.observable(data.email);
    self.easypost_id = ko.observable(data.easypost_id);
  }

  function Parcel(data){
    var self = this;
    self.name = ko.observable(data.name);
    self.length = ko.observable(data.length);
    self.width = ko.observable(data.width);
    self.height = ko.observable(data.height);
    self.weight = ko.observable(data.weight);
    self.easypost_id = ko.observable(data.easypost_id);
  }

  function Rate(data){
    var self= this;
    self.rate = ko.observable(data.rate);
    self.service = ko.observable(data.service);
    self.est_delivery_days = ko.observable(data.est_delivery_days);
    self.carrier = ko.observable(data.carrier);
    self.carrierLogo = ko.computed(function() {
      return images[self.carrier()];
    });
    self.buy = function(){
      console.log(this);
    }
  }

  function vm(){
    var self = this;
    self.displayName = 'Shipping Quote';
    self.FromNew = ko.observable(false);
    self.ToNew = ko.observable(false);
    self.ParcelNew = ko.observable(false);
    self.editing = ko.observable(true);
    self.loading = ko.observable(false);
    self.quoted = ko.observable(false);
    self.quotes = ko.observableArray();
    self.getQuotes = function () {
      self.quotes([]);
      self.editing(false);
      self.loading(true);
      var data = {shipment:{from_address: self.From, to_address: self.To, parcel: self.Parcel}};
      var headers = {contentType: "application/json", authorization: "Bearer " + session.token()}
      http.post('/api/shipments', data, headers).then(function(response) {
          self.loading(false);
          self.quoted(true);
          var count = response.data.length;
          for(i=0;i<count;i++){
            var rate = new Rate(response.data[i]);
            self.quotes.push(rate);
          } 
          console.log(self.quotes());      
      }).fail( function() {
          self.loading(false);
          self.editing(true);
          //some error here?
      });
    }
    self.canActivate = function () {
      if( session.token() == null){
        router.navigate('#');
        return false;
      }
      else{
        return true;
      }
    }
    self.activate = function () {
      self.From = new Address({});
      self.To = new Address({});
      self.Parcel = new Parcel({});
    }
    self.attached = function(view) {

    }

  }

  return new vm();

});