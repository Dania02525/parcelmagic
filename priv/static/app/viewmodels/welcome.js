define(['plugins/http', 'durandal/app', 'knockout', 'session', 'materialize', './login'], function (http, app, ko, session, materialize, login) {
    //Note: This module exports an object.
    //That means that every module that "requires" it will get the same object instance.
    //If you wish to be able to create multiple instances, instead export a function.
    //See the "welcome" module for an example of function export.

  function vm(){
    var self = this;
    self.displayName = 'Welcome to Parcelmagic';
    self.activate = function () {
      login.show();
    }
    self.attached = function(view) {
        $(document).ready(function() {
          $('select').material_select();
        });
    }

  }

  return new vm();

});