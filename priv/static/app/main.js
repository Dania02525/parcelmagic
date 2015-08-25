requirejs.config({
    paths: {
        'text': '../lib/require/text',
        'durandal':'../lib/durandal/js',
        'plugins' : '../lib/durandal/js/plugins',
        'transitions' : '../lib/durandal/js/transitions',
        'knockout': '../lib/knockout/knockout-3.3.0',
        'knockout.validation': '../lib/knockout/knockout.validation',
        'jquery': '../lib/jquery/jquery-1.9.1',
        'materialize': '../lib/materialize/js/materialize.amd',
        'session': '../lib/session',
        'images': '../lib/images',
        'data': '../lib/data',
        'toastr': '../lib/toastr/toastr.min'
        
    },
    shim: {
        'jquery': {
            exports: '$'
        },
        'materialize': {
            deps: ['jquery']
        },
        'toastr': {
            deps: ['jquery']
        },
        'knockout.validation': {
            deps: ['knockout']
        }
    }
});

define(['durandal/system', 'durandal/app', 'durandal/viewLocator'],  function (system, app, viewLocator) {
    //>>excludeStart("build", true);
    system.debug(true);
    //>>excludeEnd("build");

    app.title = 'Parcelmagic';

    app.configurePlugins({
        router:true,
        dialog: true
    });

    app.start().then(function() {
        //Replace 'viewmodels' in the moduleId with 'views' to locate the view.
        //Look for partial views in a 'views' folder in the root.
        viewLocator.useConvention();

        //Show the app by setting the root view model for our application with a transition.
        app.setRoot('viewmodels/shell', 'entrance');
    });
});