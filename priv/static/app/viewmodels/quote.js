define(['plugins/http', 'plugins/router', 'durandal/app', '../prototypes/Address', '../prototypes/Parcel', '../prototypes/Rate'], function (http, router, app, Address, Parcel, Rate) {
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
    self.FromNew = ko.observable(false);
    self.ToNew = ko.observable(false);
    self.ParcelNew = ko.observable(false);
    self.editing = ko.observable(true);
    self.loading = ko.observable(false);
    self.loadingMessage = ko.observable();
    self.quoted = ko.observable(false);
    self.quotes = ko.observableArray();
    self.countries = info.countries;
    self.editFields = function(){
      self.quoted(false);
      self.quotes([]);
      self.loadingMessage();
      self.editing(true)
    }
    self.isValid = function() {
      if(ko.validation.group(self)().length){
        ko.validation.group(self).showAllMessages(true);
        return false;
      }
      else {
        return true;
      }
    }
    self.buy = function(rate){
      console.log(rate);
      self.quoted(false);
      self.loading(true);
      self.loadingMessage('Buying rate...');
      var data = {shipment: self.shipment, rate: rate};
      var headers = {contentType: "application/json", authorization: "Bearer " + session.token()}
      http.post('/api/shipments/buy', data, headers).then(function(response) {
          self.loadingMessage(); 
          self.loading(false);        
          labelpopup = window.open(response.data.label_url, "Postage Label", "width=558,height=837"); 
          labelpopup.print();    
      }).fail( function() {
          self.loadingMessage();
          self.loading(false);
          toastr["error"]("An error occurred");
      });
    }
    self.getQuotes = function () {
      if( self.isValid()){
        self.quotes([]);
        self.editing(false);
        self.loading(true);
        self.loadingMessage('Fetching quotes...');
        var data = {shipment:{from_address: self.From, to_address: self.To, parcel: self.Parcel}};
        var headers = {contentType: "application/json", authorization: "Bearer " + session.token()}
        http.post('/api/shipments/quote', data, headers).then(function(response) {
            self.loadingMessage();
            self.loading(false);
            self.quoted(true);
            self.shipment = response.data.shipment;
            self.shipment.from_address.reference = self.From.reference();
            self.shipment.to_address.reference = self.To.reference();
            self.shipment.parcel.reference = self.Parcel.reference();
            var count = response.data.rates.length;
            for(i=0;i<count;i++){
              var rate = new Rate(response.data.rates[i]);
              self.quotes.push(rate);
            } 
            console.log(self.quotes());      
        }).fail( function() {
            self.loadingMessage();
            self.loading(false);
            self.editing(true);
            toastr["error"]("An error occurred, please check fields for accuracy");
        });
      }  
      else {
        toastr["error"]("Please check required parameters " + ko.validation.group(self, { deep: true })());
      } 
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
    self.activate = function (context) {
      if(typeof context == 'undefined'){
        context = {};
      }
      self.From = new Address({country: 'US'});
      self.To = new Address({country: 'US'});
      self.Parcel = new Parcel({});
      if(context.from){
        var headers = {contentType: "application/json", authorization: "Bearer " + session.token()}
        http.get('/api/addresses/' + context.from, {}, headers).then(function(response) {
          self.From.select(response.data);
        });
      }
      if(context.to){
        var headers = {contentType: "application/json", authorization: "Bearer " + session.token()}
        http.get('/api/addresses/' + context.to, {}, headers).then(function(response) {
          self.To.select(response.data);
        });
      }
      if(context.parcel){
        var headers = {contentType: "application/json", authorization: "Bearer " + session.token()}
        http.get('/api/parcels/' + context.parcel, {}, headers).then(function(response) {
          self.Parcel.select(response.data);
        });
      }
      console.log(self.From);
      self.quoted(false);
      self.editing(true);
    }

    self.attached = function(view) {
      $(document).ready(function() {
        $('select').material_select();
      });
    }
  }

  return new vm();

});