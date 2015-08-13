define(['plugins/http', 'plugins/dialog', 'knockout', 'materialize'], function (http, dialog, ko, materialize) {

  var Login = function() {
    this.email = ko.observable('');
    this.password = ko.observable('');
    this.loading = ko.observable(false);
    this.errorMessage = ko.observable(false);
  };

  Login.prototype.go = function() {
    this.loading(true);
    var self = this;
    http.post('/login', {email: this.email, password: this.password}).then(function(response) {
        self.loading(false);
          //update the session here
          dialog.close(self);
      }).fail( function() {
          self.loading(false);
          self.errorMessage(true);
      }); 
  };

  Login.show = function(){
    return dialog.show(new Login());
  };

  return Login;
});