define(['plugins/router', 'durandal/app'], function (router, app) {
    return {
        router: router,
        search: function() {
            //It's really easy to show a message box.
            //You can add custom options too. Also, it returns a promise for the user's response.
            app.showMessage('Search not yet implemented...');
        },
        activate: function () {
            router.map([
                { route: '', title:'Welcome', moduleId: 'viewmodels/welcome', nav: true },
                { route: 'addresses', moduleId: 'viewmodels/addresses', nav: true },
                { route: 'parcels', moduleId: 'viewmodels/parcels', nav: true },
                { route: 'shipments', moduleId: 'viewmodels/shipments', nav: true },
                { route: 'quote', moduleId: 'viewmodels/quote', nav: true },
            ]).buildNavigationModel();
            
            return router.activate();
        }        
    };
});