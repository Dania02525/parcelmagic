define(['plugins/http', 'plugins/dialog', 'knockout', 'materialize', 'session'], function (http, dialog, ko, materialize, session) {

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
          session.token(response.token);
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