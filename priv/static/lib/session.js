define(['knockout', '../app/prototypes/Shipment'], function (ko, Shipment) {

  return {
    token: ko.observable(),
    shipment: new Shipment()
  };
});