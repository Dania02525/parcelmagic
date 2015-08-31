define(['plugins/http', 'plugins/router', 'durandal/app'], function(http, router, app){

  var Rate = function(data){
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
  };

  return Rate;

});