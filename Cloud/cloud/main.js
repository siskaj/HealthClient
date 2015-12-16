
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
// Parse.Cloud.define("hello", function(request, response) {
//   response.success("Hello world!");
// });

var fs = require('fs');
var layer = require('cloud/layer-parse-module/layer-module.js');

var layerProviderID = 'layer:///providers/d04bceaa-9093-11e5-88f8-a26de4023d09';  // Should have the format of layer:///providers/<GUID>
var layerKeyID = 'layer:///keys/4d5b8504-9759-11e5-8627-3a8a16005a40';   // Should have the format of layer:///keys/<GUID>
var privateKey = fs.readFileSync('cloud/layer-parse-module/keys/layer-key.js');
layer.initialize(layerProviderID, layerKeyID, privateKey);

Parse.Cloud.define("generateToken", function(request, response) {
    var currentUser = request.user;
    if (!currentUser) throw new Error('You need to be logged in!');
    var userID = currentUser.id;
    var nonce = request.params.nonce;
    if (!nonce) throw new Error('Missing nonce parameter');
        response.success(layer.layerIdentityToken(userID, nonce));
});

