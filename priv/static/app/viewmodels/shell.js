define(['plugins/router', 'durandal/app', 'knockout'], function (router, app, ko) {
    return {
        router: router,
        toggleMenu: function() {
            $("#mobile-menu").toggle();
            return true;
        },
        activate: function () {
            router.map([
                { route: '', title:'Welcome', moduleId: 'viewmodels/welcome', nav: true },
                { route: 'addresses', moduleId: 'viewmodels/addresses', nav: true },
                { route: 'parcels', moduleId: 'viewmodels/parcels', nav: true },
                { route: 'shipments', moduleId: 'viewmodels/shipments', nav: true },
                { route: 'quote', moduleId: 'viewmodels/quote', nav: true },
                { route: 'customs', moduleId: 'viewmodels/customs', nav: false },
                { route: 'rates', moduleId: 'viewmodels/rates', nav: false },
            ]).buildNavigationModel();
           
            return router.activate();          
        }, 
    };
});