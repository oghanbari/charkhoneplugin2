/*!
 *
 * Author: Alex Disler (alexdisler.com)
 * github.com/alexdisler/cordova-plugin-inapppurchase
 *
 * Licensed under the MIT license. Please see README for more information.
 *
 */

const inAppPurchase = { utils };

const nativeCall = (name, args = []) => {
    return new Promise((resolve, reject) => {
        window.cordova.exec((res) => {
            resolve(res);
        }, (err) => {
            reject(err);
        }, 'PaymentsPlugin', name, args);
    });
};

inAppPurchase.getProducts = (productIds) => {
    return new Promise((resolve, reject) => {
        if(!inAppPurchase.utils.validArrayOfStrings(productIds)) {
            reject(new Error(inAppPurchase.utils.errors[101]));
        } else {
            return nativeCall('getProducts', [productIds]).then((res) => {
                if (!res || !res.products) {
                    resolve([]);
                } else {
                    const arr = res.products.map((val) => {
                        return {
                            productId   : val.productId,
                            title       : val.title,
                            description : val.description,
                            priceAsDecimal : val.priceAsDecimal,
                            price       : val.price,
                            currency    : val.currency,
                        };
                    });
                    resolve(arr);
                }
            }).catch(reject);
        }
    });
};

inAppPurchase.buy = (productId) => {
    return new Promise((resolve, reject) => {
        if(!inAppPurchase.utils.validString(productId)) {
            reject(new Error(inAppPurchase.utils.errors[102]));
        } else {
            nativeCall('buy', [productId]).then((res) => {
                resolve({
                    transactionId : res.transactionId,
                    receipt       : res.receipt,
                });
            }).catch(reject);
        }
    });
};

/**
 * This function exists so that the iOS plugin API will be compatible with that of Android -
 * where this function is required.
 * See README for more details.
 */
inAppPurchase.subscribe = (productId) => {
    return inAppPurchase.buy(productId);
};

/**
 * This function exists so that the iOS plugin API will be compatible with that of Android -
 * where this function is required.
 * See README for more details.
 */
inAppPurchase.consume = () => {
    return Promise.resolve();
};

inAppPurchase.getReceipt = () => {
    return nativeCall('getReceipt').then((res) => {
        let receipt = '';
        if (res && res.receipt) {
            receipt = res.receipt;
        }
        return receipt;
    });
};

inAppPurchase.restorePurchases = () => {
    return nativeCall('restorePurchases').then((res) => {
        let arr = [];
        if (res && res.transactions) {
            arr = res.transactions.map((val) => {
                return {
                    productId     : val.productId,
                    date          : val.date,
                    transactionId : val.transactionId,
                    state         : val.transactionState,
                };
            });
        }
        return arr;
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

module.exports = inAppPurchase;
