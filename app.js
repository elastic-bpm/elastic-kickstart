var msRestAzure = require('ms-rest-azure');
var ComputeClient = require('azure-arm-compute');

if (process.argv.length < 3) {
    console.log("Usage: node app.js <location-to-config> [start/stop]");
    return;
}

var config = require(process.argv[2]);
var clientId = config.CLIENT_ID;
var domain = config.DOMAIN;
var secret = config.APPLICATION_SECRET;
var subscriptionId = config.AZURE_SUBSCRIPTION_ID;

// var clientId = process.env.CLIENT_ID;
// var domain = process.env.DOMAIN;
// var secret = process.env.APPLICATION_SECRET;
// var subscriptionId = process.env.AZURE_SUBSCRIPTION_ID;

var action = process.argv[3] || process.env.ACTION || "stop";


var credentials = new msRestAzure.ApplicationTokenCredentials(clientId, domain, secret);
var computeClient = new ComputeClient(credentials, subscriptionId);

var startMachine = function (resource, name) {
    computeClient.virtualMachines.start(resource, name, function (error) {
        if (error) {
            //console.log(error);
            startMachine(resource, name);
        }
    });
}

var stopMachine = function (resource, name) {
    computeClient.virtualMachines.deallocate(resource, name, function (error) {
        if (error) {
            //console.log(error);
            stopMachine(resource, name);
        }
    });
}

var startAll = function () {
    computeClient.virtualMachines.listAll(function (err, result) {
        if (err) {
            //console.log(err);
            startAll();
        } else {
            result.forEach(function (element) {
                id_arr = element.id.split('/');
                if (action === "stop") {
                    console.log("stopping " + element.name);
                    stopMachine(id_arr[4], element.name);
                } else {
                    console.log("starting " + element.name);
                    startMachine(id_arr[4], element.name);
                }
            });
        }
    });
}

startAll();