define(['plugins/http', 'plugins/router', 'durandal/app', 'knockout', 'knockout.validation', 'session', 'materialize', 'toastr', 'info'], function (http, router, app, ko, validation, session, materialize, toastr, info) {
    //Note: This module exports an object.
    //That means that every module that "requires" it will get the same object instance.
    //If you wish to be able to create multiple instances, instead export a function.
    //See the "welcome" module for an example of function export.

  function Address(data){
    var self = this;
    self.reference = ko.observable(data.reference);
    self.name = ko.observable(data.name);
    self.company = ko.observable(data.company);
    self.name.extend({
      required: {
        onlyIf: function() {return !self.company()},
        message: "Name or Company required"
      }
    }); 
    self.company.extend({
      required: {
        onlyIf: function() {return !self.name()},
        message: "Name or Company required"
      }
    });
    self.street1 = ko.observable(data.street1).extend({ required: true});
    self.street2 = ko.observable(data.street2);
    self.city = ko.observable(data.city).extend({ required: true});
    self.state = ko.observable(data.state);
    self.zip = ko.observable(data.zip);
    self.country = ko.observable(data.country).extend({ required: true});
    self.phone = ko.observable(data.phone);
    self.email = ko.observable(data.email);
    self.easypost_id = ko.observable(data.easypost_id);
    self.searchterm = ko.observable().extend({ rateLimit: { method: "notifyWhenChangesStop", timeout: 400 } });
    self.suggestions = ko.observableArray([]);
    self.asText = ko.computed( function(){
      var nameparams = [
        self.name(), 
        self.company(), 
      ];

      var addrparams = [       
        self.street1(), 
        self.street2(), 
        self.city(), 
        self.state(),
        self.zip(), 
        self.country(), 
        self.phone(), 
        self.email()
      ];
      var text = '';

      for(i=0;i<nameparams.length;i++){
        if(nameparams[i]){
          text += nameparams[i] + '<br>';
        }
      }

      for(i=0;i<addrparams.length;i++){
        if(addrparams[i]){
          var prev = i-1;
          if( addrparams[prev] && (addrparams[prev] + addrparams[i]).length < 35){
            text += addrparams[i] + ' ';
          }
          else{
            text += addrparams[i] + '<br>';
          }            
        }
      }
      return text;
    });
    self.select = function(selection) {
      self.suggestions([]); 
      if( !selection.disabled ){   
        self.name(selection.name);
        self.company(selection.company);
        self.street1(selection.street1);
        self.street2(selection.street2);
        self.city(selection.city);
        self.state(selection.state);
        self.zip(selection.zip);
        self.country(selection.country);
        self.phone(selection.phone);
        self.email(selection.email);
        self.easypost_id(selection.easypost_id);
      }
    }
    ko.computed(function(){
      var query = self.searchterm();
      if(self.searchterm()){
        var headers = {contentType: "application/json", authorization: "Bearer " + session.token()};
        http.get('api/addresses', "query=" + query + "&limit=6", headers).then(function(response) {
          if( response.data.length > 0 ){
            self.suggestions(response.data);
            setTimeout(function() {
                self.suggestions([]);
              }, 4000);
          }
          else {
            self.suggestions([{reference: "Nothing found", disabled: true}]);
            setTimeout(function() {
                self.suggestions([]);
              }, 4000);
          }
        })
      }
    })
  }

  function Parcel(data){
    var self = this;
    self.reference = ko.observable(data.reference);
    self.length = ko.observable(data.length).extend({ required: true, number: true});
    self.width = ko.observable(data.width).extend({ required: true, number: true});
    self.height = ko.observable(data.height).extend({ required: true, number: true});
    self.weight = ko.observable(data.weight).extend({ required: true, number: true});
    self.easypost_id = ko.observable(data.easypost_id);
    self.searchterm = ko.observable().extend({ rateLimit: { method: "notifyWhenChangesStop", timeout: 400 } });
    self.suggestions = ko.observableArray([]);
    self.asText = ko.computed( function(){
      return self.reference() + '<br>' + self.length() + 'in x ' + self.width() + 'in x ' + self.height() + 'in <br>' + 'weight: ' + self.weight();
    });
    self.select = function(selection) {
      self.suggestions([]);
      if( !selection.disabled ){
        self.reference(selection.reference);     
        self.length(selection.length);
        self.width(selection.width);
        self.height(selection.height);
        self.weight(selection.weight);
        self.easypost_id(selection.easypost_id);
      }    
    }
    ko.computed(function(){
      var query = self.searchterm();
      if(self.searchterm()){
        var headers = {contentType: "application/json", authorization: "Bearer " + session.token()};
        http.get('api/parcels', "query=" + query + "&limit=6", headers).then(function(response) {
          if( response.data.length > 0 ){
            self.suggestions(response.data);
            setTimeout(function() {
                self.suggestions([]);
              }, 4000);
          }
          else {
            self.suggestions([{reference: "Nothing found", disabled: true}]);
            setTimeout(function() {
                self.suggestions([]);
              }, 4000);
          }
        })
      }
    })
  }

  function Rate(data){
    var self= this;
    self.id = ko.observable(data.id);
    self.shipment_id = ko.observable(data.shipment_id);
    self.rate = ko.observable(data.rate);
    self.service = ko.observable(data.service);
    self.est_delivery_days = ko.observable(data.est_delivery_days);
    self.carrier = ko.observable(data.carrier);
    self.carrierLogo = ko.computed(function() {
      return info.images[self.carrier()];
    });
  }

  function vm(){
    toastr.options = {
      "closeButton": false,
      "debug": false,
      "newestOnTop": false,
      "progressBar": false,
      "positionClass": "toast-top-full-width",
      "preventDuplicates": false,
      "onclick": null,
      "showDuration": "300",
      "hideDuration": "1000",
      "timeOut": "5000",
      "extendedTimeOut": "1000",
      "showEasing": "swing",
      "hideEasing": "linear",
      "showMethod": "fadeIn",
      "hideMethod": "fadeOut"
    };
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
    self.activate = function () {
      self.From = new Address({country: 'United States'});
      self.To = new Address({country: 'United States'});
      self.Parcel = new Parcel({});
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