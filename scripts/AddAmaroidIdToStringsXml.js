var fs = require('fs');
var path = require('path');

module.exports = function (context) {

    console.log('***Hook: Add amaroidId To Strings.xml***');

    //console.log(context);

    //This gives us promises!
    var Q = context.requireCordovaModule('q');

    var defer = Q.defer();

    var projectRoot = context.opts.projectRoot;
    var platformRoot = path.join(context.opts.projectRoot, 'platforms/android');

    var sourceFile = path.join(projectRoot , 'www/Amaroid.xml');

    var destFile;

    //for sdk 26
    //destFile = path.join(platformRoot, 'res/values/Amaroid.xml');

    //for sdk 28
    destFile = path.join(platformRoot, 'app/src/main/res/values/Amaroid.xml');

    var readStream = fs.createReadStream(sourceFile);
    var writeStream = fs.createWriteStream(destFile);

    readStream.on('error', function (err) {
        defer.reject('Could not copy\n' + sourceFile + '\nto\n' + destFile);
    });

    writeStream.on('error', function (err) {
        defer.reject('Could not copy\n' + sourceFile + '\nto\n' + destFile);
    });

    writeStream.on('close', function () {
        console.log('Copied successfully!');
        defer.resolve();
    });

    readStream.pipe(writeStream);

    return defer.promise;
}