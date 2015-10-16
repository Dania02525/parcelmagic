define(['plugins/http', 'plugins/router', 'durandal/app', './Address', './Parcel', './Rate', './CustomsInfo', 'knockout'], function(http, router, app, Address, Parcel, Rate, CustomsInfo, ko) {

  var Shipment = function(){
    var self = this;
    //lets change these to from_address and so on to match data from easypost
    self.from_address = new Address({country: 'US'});
    self.to_address = new Address({country: 'US'});
    self.parcel = new Parcel({});
    self.customs_info = new CustomsInfo({});
    self.easypost_id = ko.observable();
    self.rates = ko.observableArray([]);
    self.loading = ko.observable(false);
    self.proceed = function () {
      if( self.from_address.isValid() && self.to_address.isValid() && self.parcel.isValid()){
        if(self.from_address.country() != self.to_address.country()){
          router.navigate('#customs');
          return;
        }
        else {
          self.getQuotes();
        }
      }
      else{
        self.from_address.isValid();
        self.to_address.isValid();
        self.parcel.isValid();
      }
    };
    self.getQuotes = function () {
      var from = self.from_address.id_valid() ? {id: self.from_address.easypost_id()} : self.from_address;
      var to = self.to_address.id_valid() ? {id: self.to_address.easypost_id()} : self.to_address;
      var parcel = self.parcel.id_valid() ? {id: self.parcel.easypost_id()} : self.parcel;
      var data = {};
      var headers = {};
      var count = 0;
      var sortedrates = [];

      //validation
      if( !self.from_address.isValid() || !self.to_address.isValid() || !self.parcel.isValid() ){
        self.from_address.isValid();
        self.to_address.isValid();
        self.parcel.isValid();
        router.navigate('#quote');
      }
      if( !self.customs_info.isValid() && (self.to_address.country() !== self.from_address.country() )){
        self.customs_info.isValid();
        router.navigate('#customs');
      }
      if( self.to_address.country() !== self.from_address.country() ){
        data = {shipment:{from_address: from, to_address: to, parcel: parcel, customs_info: self.customs_info}};
      }
      else{
        data = {shipment:{from_address: from, to_address: to, parcel: parcel}};
      }

      //work
      self.loading(true);
      headers = {contentType: "application/json", authorization: "Bearer " + session.token()};
      http.post('/api/shipments/quote', data, headers).then(function(response) {
          router.navigate('#rates');
          self.from_address.easypost_id(response.data.shipment.from_address.id);
          self.to_address.easypost_id(response.data.shipment.to_address.id);
          self.parcel.easypost_id(response.data.shipment.parcel.id);
          self.easypost_id(response.data.shipment.id);
          self.loading(false);
          count = response.data.rates.length;
          sortedrates = response.data.rates.sort(function(a,b){return parseFloat(a.rate)-parseFloat(b.rate);});
          console.log(sortedrates);
          for(i=0;i<count;i++){
            var rate = new Rate(sortedrates[i]);
            self.rates.push(rate);
          }
      }).fail( function() {
          self.loading(false);
          toastr["error"]("An error occurred, please check fields for accuracy");
      });
    };
    self.clear = function() {
      self.from_address.clear();
      self.to_address.clear();
      self.parcel.clear();
      self.customs_info({});
      self.rates([]);
      self.easypost_id('');
    };
    self.edit = function() {
      self.rates([]);
    };
  };

  return Shipment;
});