define(['plugins/http', 'durandal/app', 'knockout', 'session', 'materialize'], function (http, app, ko, session, materialize) {
    //Note: This module exports an object.
    //That means that every module that "requires" it will get the same object instance.
    //If you wish to be able to create multiple instances, instead export a function.
    //See the "welcome" module for an example of function export.

  function vm(){
    
    var self = this;
    self.displayName = 'Shipping Quote';
    self.FromNew = ko.observable(false);
    self.ToNew = ko.observable(false);
    self.ParcelNew = ko.observable(false);
    self.activate = function () {

    }
    self.attached = function(view) {

    }

  }

  return new vm();

});