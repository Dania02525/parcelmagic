define(['knockout', '../app/prototypes/Shipment', 'info'], function (ko, Shipment, info) {

  return {
    token: ko.observable(),
    shipment: new Shipment(),
    info: info,
  };
});