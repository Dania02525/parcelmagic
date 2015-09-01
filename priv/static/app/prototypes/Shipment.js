define(['plugins/http', 'plugins/router', 'durandal/app', './Address', './Parcel', './Rate', 'knockout'], function(http, router, app, Address, Parcel, Rate, ko) {

  var Shipment = function(){
    var self = this;
    self.From = new Address({country: 'US'});
    self.To = new Address({country: 'US'});
    self.Parcel = new Parcel({});
    self.Rates = ko.observableArray([]);
    self.loading = ko.observable(false);
    self.loadingMessage = ko.observable();
    self.getQuotes = function () {
      if( self.isValid()){
        self.loading(true);
        self.loadingMessage('Fetching quotes...');
        var data = {shipment:{from_address: self.From, to_address: self.To, parcel: self.Parcel}};
        var headers = {contentType: "application/json", authorization: "Bearer " + session.token()}
        http.post('/api/shipments/quote', data, headers).then(function(response) {
            self.From.easypost_id(response.data.shipment.from_address.id);
            self.To.easypost_id(response.data.shipment.to_address.id);
            self.Parcel.easypost_id(response.data.shipment.parcel.id);
            self.loading(false);
            self.loadingMessage = ko.observable();
            var count = response.data.rates.length;
            for(i=0;i<count;i++){
              var rate = new Rate(response.data.rates[i]);
              self.Rates.push(rate);       
            }       
        }).fail( function() {
            self.loading(false);
            self.loadingMessage = ko.observable();
            toastr["error"]("An error occurred, please check fields for accuracy");
        });
      }  
      else {
        toastr["error"]("Please check required parameters " + ko.validation.group(self, { deep: true })());
      } 
    };
    self.isValid = function() {
      if(ko.validation.group(self)().length){
        ko.validation.group(self).showAllMessages(true);
        return false;
      }
      else {
        return true;
      }
    };
    self.clear = function() {
      self.From.clear();
      self.To.clear();
      self.Rates([]);
    }
    self.edit = function() {
      self.Rates([]);
    }
  };

  return Shipment;
});