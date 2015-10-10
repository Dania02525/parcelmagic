define(['plugins/http', 'plugins/router', 'durandal/app', 'knockout', './CustomsItem', 'info'], function(http, router, app, ko, CustomsItem, info){

  var CustomsInfo = function(data){
    var self = this;
    self.customs_items = ko.observableArray([new CustomsItem({})]);
    self.contents_type = ko.observable(data.content_type).extend({ required: true});
    self.contents_explanation = ko.observable(data.content_explanation).extend({ required: { onlyIf: function() {return self.contents_type() == "other"}}});   
    self.customs_certify = ko.observable(false); //I must manually check this dammit,  the validation wacks the checkbox
    self.customs_signer = ko.observable(data.customs_signer).extend({ required: true});
    self.restriction_type = "none";
    self.restriction_comments = "";
    self.eel_pfc = "NOEEI 30.37(a)";
    self.addCustomsItem = function () {
      self.customs_items.push(new CustomsItem({}));
    }
    self.deleteCustomsItem = function (customsItem) {
      if( self.customs_items().length > 1){
        self.customs_items.remove(customsItem);
      } 
    }
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