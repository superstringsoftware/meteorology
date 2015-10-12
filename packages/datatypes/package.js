Package.describe({
  name: 'superstringsoft:datatypes',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.0.2');

  var both = ['client', 'server'];
  api.use(['ecmascript', 'coffeescript', 'ejson', 'check', 'mongo'], both);
  // api.use('accounts-password', 'server');

  api.add_files('DataType.coffee', both);
  api.add_files('TypedCollection.coffee', both);
  api.add_files('TypedCursor.coffee', both);
  // api.add_files(['lib/Observatory.coffee'], both);


  //Npm.require('fs');
});

Package.onTest(function(api) {
  api.use('ecmascript');
  api.use('tinytest');
  api.use('superstringsoft:datatypes');
  api.addFiles('datatypes-tests.js');

});
