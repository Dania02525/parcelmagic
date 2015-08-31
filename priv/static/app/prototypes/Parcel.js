define(['plugins/http', 'plugins/router', 'durandal/app'], function(http, router, app){

  var Parcel = function(data){
    var self = this;
    self.reference = ko.observable(data.reference);
    self.isnew = ko.observable(false);
    self.length = ko.observable(data.length).extend({ required: true, number: true});
    self.width = ko.observable(data.width).extend({ required: true, number: true});
    self.height = ko.observable(data.height).extend({ required: true, number: true});
    self.weight = ko.observable(data.weight).extend({ required: true, number: true});
    self.easypost_id = ko.observable(data.easypost_id);
    self.searchterm = ko.observable().extend({ rateLimit: { method: "notifyWhenChangesStop", timeout: 400 } });
    self.suggestions = ko.observableArray([]);
    self.asText = ko.computed( function(){
      return self.reference() + '<br>' + self.length() + 'in x ' + self.width() + 'in x ' + self.height() + 'in <br>' + self.weight() + 'oz';
    });
    self.select = function(selection) {
      self.suggestions([]);
      if( !selection.disabled ){ 
        self.reference(selection.reference);
        self.length(selection.length);
        self.width(selection.width);
        self.height(selection.height);
        self.weight(selection.weight);
        self.easypost_id(selection.easypost_id);
      }    
    }
    self.clear = function(){
      self.select({});
      self.searchterm('');
      return true;
    };   
    ko.computed(function(){
      var query = self.searchterm();
      if(self.searchterm()){
        var headers = {contentType: "application/json", authorization: "Bearer " + session.token()};
        http.get('api/parcels', "query=" + query + "&limit=6", headers).then(function(response) {
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
        })
      }
    })
  };

  return Parcel;
});