define(['plugins/http', 'plugins/router', 'durandal/app', 'knockout'], function(http, router, app, ko){

  var CustomsItem = function(data){
    var self = this;
    self.reference = ko.observable(data.reference);
    self.description = ko.observable(data.description).extend({ required: true});
    self.weight = ko.observable(data.weight).extend({ required: true, number: true});
    self.value = ko.observable(data.value).extend({ required: true, number: true});
    self.quantity = ko.observable(data.quantity).extend({ required: true, number: true});
    self.hs_tariff = ko.observable(data.hs_tariff).extend({ required: true});
    self.origin_country = ko.observable(data.origin_country).extend({ required: true});
    self.easypost_id = ko.observable(data.easypost_id);
    self.searchterm = ko.observable().extend({ rateLimit: { method: "notifyWhenChangesStop", timeout: 400 } });
    self.suggestions = ko.observableArray([]);
    self.select = function(selection) {
      if( !selection.disabled ){
        self.description(selection.description);
        self.weight(selection.weight);
        self.value(selection.value);
        self.hs_tariff(selection.hs_tariff);
        self.origin_country(selection.origin_country);
        self.easypost_id(selection.easypost_id);
      }
    };
    self.clear = function(){
      self.select({});
      self.searchterm('');
      return true;
    };
    ko.computed(function(){
      var query = self.searchterm();
      if(self.searchterm()){
        var headers = {contentType: "application/json", authorization: "Bearer " + session.token()};
        http.get('api/customs_items', "query=" + query + "&limit=6", headers).then(function(response) {
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
  };

  return CustomsItem;
});