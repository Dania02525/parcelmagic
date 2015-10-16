define(['plugins/http', 'plugins/router', 'durandal/app', 'knockout', 'info'], function(http, router, app, ko, info){

  var Address = function(data){
    var self = this;
    self.reference = ko.observable(data.reference);
    self.object = "Address";
    self.isnew = ko.observable(false);
    self.easypost_id = ko.observable(data.easypost_id);
    self.id_valid = function(){
      return (/^adr+/).test(self.easypost_id());
    };
    self.name = ko.observable(data.name);
    self.company = ko.observable(data.company);
    self.name.extend({
      required: {
        onlyIf: function() {return (!self.company() && !self.id_valid());},
        message: "Name or Company required"
      }
    });
    self.company.extend({
      required: {
        onlyIf: function() {return (!self.name() && !self.id_valid());},
        message: "Name or Company required"
      }
    });
    self.street1 = ko.observable(data.street1).extend({ required: { onlyIf: function() {return !self.id_valid();}}});
    self.street2 = ko.observable(data.street2);
    self.city = ko.observable(data.city).extend({ required: { onlyIf: function() {return !self.id_valid();}}});
    self.state = ko.observable(data.state);
    self.zip = ko.observable(data.zip);
    self.country = ko.observable(data.country).extend({ required: { onlyIf: function() {return !self.id_valid();}}});
    self.phone = ko.observable(data.phone).extend({ required: { onlyIf: function() {return !self.id_valid();}}});
    self.email = ko.observable(data.email);
    self.searchterm = ko.observable().extend({ rateLimit: { method: "notifyWhenChangesStop", timeout: 400 } });
    self.suggestions = ko.observableArray([]);
    self.select = function(selection) {
      self.suggestions([]);
      if( !selection.disabled ){
        self.name(selection.name);
        self.company(selection.company);
        self.street1(selection.street1);
        self.street2(selection.street2);
        self.city(selection.city);
        self.state(selection.state);
        self.zip(selection.zip);
        self.country(selection.country);
        self.phone(selection.phone);
        self.email(selection.email);
        self.easypost_id(selection.easypost_id);
      }
    };
    self.asText = ko.computed( function(){
      var nameparams = [
        self.name(),
        self.company(),
      ];

      var addrparams = [
        self.street1(),
        self.street2(),
        self.city(),
        self.state(),
        self.zip(),
        self.country(),
        self.phone(),
        self.email()
      ];
      var text = '';

      for(i=0;i<nameparams.length;i++){
        if(nameparams[i]){
          text += nameparams[i] + '<br>';
        }
      }

      for(i=0;i<addrparams.length;i++){
        if(addrparams[i]){
          var prev = i-1;
          if( addrparams[prev] && (addrparams[prev] + addrparams[i]).length < 35){
            text += addrparams[i] + ' ';
          }
          else{
            text += addrparams[i] + '<br>';
          }
        }
      }
      return text;
    });
    self.clear = function(){
      self.select({});
      self.searchterm('');
      return true;
    };
    ko.computed(function(){
      var query = self.searchterm();
      if(self.searchterm()){
        var headers = {contentType: "application/json", authorization: "Bearer " + session.token()};
        http.get('api/addresses', "query=" + query + "&limit=6", headers).then(function(response) {
          if( response.data.length > 0 ){
            self.suggestions(response.data);
            setTimeout(function() {
                self.suggestions([]);
              }, 4000);
          }
          else {
            self.suggestions([{reference: "Nothing found", disabled: true}]);
            setTimeout(function() {
                self.suggestions([]);
              }, 4000);
          }
        });
      }
    });
    self.isValid = function(){
      if(ko.validation.group(self)().length){
        ko.validation.group(self).showAllMessages(true);
        return false;
      }
      else{
        return true;
      }
    };
  };
  return Address;
}); //end module definition
