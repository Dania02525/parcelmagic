define(['plugins/http', 'plugins/router', 'durandal/app', 'knockout'], function(http, router, app, ko){

  var Rate = function(data){
    var self= this;
    self.id = ko.observable(data.id);
    self.shipment_id = ko.observable(data.shipment_id);
    self.rate = ko.observable(data.rate);
    self.service = ko.observable(data.service);
    self.est_delivery_days = ko.observable(data.est_delivery_days);
    self.carrier = ko.observable(data.carrier);
    self.loading = ko.observable(false);
    self.carrierLogo = ko.computed(function() {
      return info.images[self.carrier()];
    });
    self.buy = function(rate){
      self.loading(true);
      var data = {shipment: session.shipment, rate: rate};
      var headers = {contentType: "application/json", authorization: "Bearer " + session.token()}
      http.post('/api/shipments/buy', data, headers).then(function(response) {  
      self.loading(false);      
          labelpopup = window.open(response.data.label_url, "Postage Label", "width=558,height=837"); 
          labelpopup.print();    
      }).fail( function() {
          toastr["error"]("An error occurred");
      });
    };
  };

  return Rate;

});