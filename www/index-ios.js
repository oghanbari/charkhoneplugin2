'use strict';

/*!
 *
 * Author: Alex Disler (alexdisler.com)
 * github.com/alexdisler/cordova-plugin-inapppurchase
 *
 * Licensed under the MIT license. Please see README for more information.
 *
 */

var utils = {};

utils.errors = {
    101: 'invalid argument - productIds must be an array of strings',
    102: 'invalid argument - productId must be a string',
    103: 'invalid argument - product type must be a string',
    104: 'invalid argument - receipt must be a string of a json',
    105: 'invalid argument - signature must be a string'
};

utils.validArrayOfStrings = function (val) {
    return val && Array.isArray(val) && val.length > 0 && !val.find(function (i) {
        return !i.length || typeof i !== 'string';
    });
};

utils.validString = function (val) {
    return val && val.length && typeof val === 'string';
};

utils.chunk = function (array, size) {
    if (!Array.isArray(array)) {
        throw new Error('Invalid array');
    }

    if (typeof size !== 'number' || size < 1) {
        throw new Error('Invalid size');
    }

    var times = Math.ceil(array.length / size);
    return Array.apply(null, Array(times)).reduce(function (result, val, i) {
        return result.concat([array.slice(i * size, (i + 1) * size)]);
    }, []);
};
'use strict';

/*!
 *
 * Author: Alex Disler (alexdisler.com)
 * github.com/alexdisler/cordova-plugin-inapppurchase
 *
 * Licensed under the MIT license. Please see README for more information.
 *
 */

var inAppPurchase = { utils: utils };

var nativeCall = function nativeCall(name) {
    var args = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : [];

    return new Promise(function (resolve, reject) {
        window.cordova.exec(function (res) {
            resolve(res);
        }, function (err) {
            reject(err);
        }, 'PaymentsPlugin', name, args);
    });
};

inAppPurchase.getProducts = function (productIds) {
    return new Promise(function (resolve, reject) {
        if (!inAppPurchase.utils.validArrayOfStrings(productIds)) {
            reject(new Error(inAppPurchase.utils.errors[101]));
        } else {
            return nativeCall('getProducts', [productIds]).then(function (res) {
                if (!res || !res.products) {
                    resolve([]);
                } else {
                    var arr = res.products.map(function (val) {
                        return {
                            productId: val.productId,
                            title: val.title,
                            description: val.description,
                            price: val.price,
                            currency: val.currency,
                            priceAsDecimal: val.priceAsDecimal,
                        };
                    });
                    resolve(arr);
                }
            }).catch(reject);
        }
    });
};

inAppPurchase.buy = function (productId) {
    return new Promise(function (resolve, reject) {
        if (!inAppPurchase.utils.validString(productId)) {
            reject(new Error(inAppPurchase.utils.errors[102]));
        } else {
            nativeCall('buy', [productId]).then(function (res) {
                resolve({
                    transactionId: res.transactionId,
                    receipt: res.receipt
                });
            }).catch(reject);
        }
    });
};

inAppPurchase.ibuy = function (sku, msisdn, editable, developerPayload) {
    return new Promise(function (resolve, reject) {
        return nativeCall('launchPurchaseFlow', [sku, msisdn, editable, developerPayload]).then(function (res) {

            var arr = res.products.map(function (val) {
                return {
                    ItemType: val.ItemType,
                    OrderId: val.OrderId,
                    PackageName: val.PackageName,
                    Sku: val.Sku,
                    PurchaseTime: val.PurchaseTime,
                    PurchaseState: val.PurchaseState,

                    DeveloperPayload: val.DeveloperPayload,
                    Token: val.Token,
                    OriginalJson: val.OriginalJson,
                    Signature: val.Signature,
                    MSISDN: val.MSISDN,
                    PurchaseToken: val.PurchaseToken,
                    Message: val.Message,
                    Response: val.Response,
                };
            });
            resolve(arr);
        }).catch(reject);
    });
};

inAppPurchase.ibuySubscriber = function (sku, msisdn, editable, delay, developerPayload) {
    return new Promise(function (resolve, reject) {
        return nativeCall('launchSubscriptionPurchase', [sku, msisdn, editable, delay, developerPayload]).then(function (res) {

            var arr = res.products.map(function (val) {
                return {
                    ItemType: val.ItemType,
                    OrderId: val.OrderId,
                    PackageName: val.PackageName,
                    Sku: val.Sku,
                    PurchaseTime: val.PurchaseTime,
                    PurchaseState: val.PurchaseState,

                    DeveloperPayload: val.DeveloperPayload,
                    Token: val.Token,
                    OriginalJson: val.OriginalJson,
                    Signature: val.Signature,
                    MSISDN: val.MSISDN,
                    PurchaseToken: val.PurchaseToken,
                    Message: val.Message,
                    Response: val.Response,
                };
            });
            resolve(arr);
        }).catch(reject);
    });
};

inAppPurchase.iclearAllData = function () {
    return nativeCall('clearAllData').then(function (res) {
        log('clear Data')
    })
};

inAppPurchase.iSkuDetails = function (skuList) {
    return new Promise(function (resolve, reject) {
        return nativeCall('querySkuDetailsWithSkusStr', [skuList]).then(function (res) {

            var arr = res.products.map(function (val) {
                return {
                    item: val.item,
                    Message: val.Message,
                    Response: val.Response,
                };
            });
            resolve(arr);
        }).catch(reject);
    });
};

inAppPurchase.iqueryPurchasesWithItemType = function (itemType) {
    return new Promise(function (resolve, reject) {
        return nativeCall('queryPurchasesWithItemType', [itemType]).then(function (res) {

            var arr = res.products.map(function (val) {
                return {
                    ItemType: val.ItemType,
                    OrderId: val.OrderId,
                    PackageName: val.PackageName,
                    Sku: val.Sku,
                    PurchaseTime: val.PurchaseTime,
                    PurchaseState: val.PurchaseState,

                    DeveloperPayload: val.DeveloperPayload,
                    Token: val.Token,
                    OriginalJson: val.OriginalJson,
                    Signature: val.Signature,
                    MSISDN: val.MSISDN,
                    PurchaseToken: val.PurchaseToken,
                    Message: val.Message,
                    Response: val.Response,
                };
            });
            resolve(arr);
        }).catch(reject);
    });
};

inAppPurchase.iconsumePurchase = function (token) {
    return new Promise(function (resolve, reject) {
        return nativeCall('consumePurchase', [token]).then(function (res) {
            log('datatatatatta2222222res',res)
            var arr = res.products.map(function (val) {
                return {

                    Message: val.Message,
                    Response: val.Response,
                };
            });
            log('datatatatatta2222222',arr)
            resolve(arr[0]);
        }).catch(reject);
    });
};


/**
 * This function exists so that the iOS plugin API will be compatible with that of Android -
 * where this function is required.
 * See README for more details.
 */
inAppPurchase.subscribe = function (productId) {
    return inAppPurchase.buy(productId);
};

/**
 * This function exists so that the iOS plugin API will be compatible with that of Android -
 * where this function is required.
 * See README for more details.
 */
inAppPurchase.consume = function () {
    return Promise.resolve();
};

inAppPurchase.getReceipt = function () {
    return nativeCall('getReceipt').then(function (res) {
        var receipt = '';
        if (res && res.receipt) {
            receipt = res.receipt;
        }
        return receipt;
    });
};

inAppPurchase.restorePurchases = function () {
    return nativeCall('restorePurchases').then(function (res) {
        var arr = [];
        if (res && res.transactions) {
            arr = res.transactions.map(function (val) {
                return {
                    productId: val.productId,
                    date: val.date,
                    transactionId: val.transactionId,
                    state: val.transactionState
                };
            });
        }
        return arr;
    });
};

// inAppPurchase.initSDK = function () {
//         return nativeCall('iosTest').then(function (res) {
//             log(res)
//             log('hoooooyyyoyoyooyoyoyo')
//             var arr = res.products.map(function (val) {
//               log(val.ItemType)
//
//             });
//
//         });
// };

inAppPurchase.printMessage = function () {
    log('alooooooo')
};

module.exports = inAppPurchase;