/*global cordova, module*/

module.exports = {
	
    setTags: function (arg0, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "AmaroidBridge", "setTags", [arg0]);
    },

    submitEventPageView: function (arg0, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "AmaroidBridge", "submitEventPageView", [arg0]);
    },

    submitEvent: function (arg0, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "AmaroidBridge", "submitEvent", [arg0]);
    }

};