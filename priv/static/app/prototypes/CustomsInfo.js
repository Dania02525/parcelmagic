define(['plugins/http', 'plugins/router', 'durandal/app', 'knockout', './CustomsItem', 'info'], function(http, router, app, ko, CustomsItem, info){

  var CustomsInfo = function(data){
    var self = this;
    self.customs_items = ko.observableArray([new CustomsItem({})]);
    self.contents_type = ko.observable(data.content_type).extend({ required: true});
    self.contents_explanation = ko.observable(data.content_explanation).extend({ 
      required: { 
        onlyIf: function() {return (self.contents_type() == "other")}
      }
    });   
    self.customs_certify = ko.observable(); 
    self.customs_signer = ko.observable(data.customs_signer).extend({ required: true});
    self.restriction_type = "none";
    self.restriction_comments = "";
    self.eel_pfc = "NOEEI 30.37(a)";
    self.show_certify_statement = ko.observable(false);
    self.check_certify = function () {
      if( self.customs_certify() === false ){
        self.show_certify_statement(true);
        return true;
      }
      else if(self.customs_certify() === true){
        self.show_certify_statement(false);
        return true;
      }
      else{  
        return true;
      }
    }
    self.addCustomsItem = function () {
      self.customs_items.push(new CustomsItem({}));
    }
    self.deleteCustomsItem = function (customsItem) {
      if( self.customs_items().length > 1){
        self.customs_items.remove(customsItem);
      } 
    }
    self.isValid = function() {
      if(ko.validation.group([self.customs_items, self])().length){
        ko.validation.group([self.customs_items, self]).showAllMessages(true);
        return false;
      }
      else {
        if( self.customs_certify() === true){
          return true;
        }
        else {
          self.show_certify_statement(true);
          return false;
        }
      }
    };
    self.proceed =  function(){
      if( self.isValid()){
        session.shipment.getQuotes();
      }
    };
    self.clear = function(){
      self.customs_items([new CustomsItem({})]);
      self.contents_type("");
      self.contents_explanation("");
      self.customs_certify(false);
      self.customs_signer("")
      return true;
    };
  
  };

  return CustomsInfo;
});