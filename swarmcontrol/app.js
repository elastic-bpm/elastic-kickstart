var msRestAzure = require('ms-rest-azure');
var ComputeClient = require('azure-arm-compute');

var clientId = process.env.CLIENT_ID;
var domain = process.env.DOMAIN;
var secret = process.env.APPLICATION_SECRET;
var subscriptionId = process.env.AZURE_SUBSCRIPTION_ID;

var action = process.argv[2] || process.env.ACTION || "stop";


var credentials = new msRestAzure.ApplicationTokenCredentials(clientId, domain, secret);
var computeClient = new ComputeClient(credentials, subscriptionId);

computeClient.virtualMachines.listAll(function (err, result) {
    if (err) {
        console.log(err);
    } else {
        result.forEach(function (element) {
            id_arr = element.id.split('/');
            if (action === "stop") {
                console.log("stopping " + element.name);
                computeClient.virtualMachines.deallocate(id_arr[4], element.name, function(error) {
                    if (error) {
                        console.log(error);
                    }
                });
            } else {
                console.log("starting " + element.name);
                computeClient.virtualMachines.start(id_arr[4], element.name, function(error) {
                    if (error) {
                        console.log(error);
                    }
                });
            }
        });
    }
});