/*!
 *
 * Author: Alex Disler (alexdisler.com)
 * github.com/alexdisler/cordova-plugin-inapppurchase
 *
 * Licensed under the MIT license. Please see README for more information.
 *
 */

#import "PaymentsPlugin.h"
#import "RMStore.h"
@import charkhunePayment;
#import <Foundation/Foundation.h>

#define NILABLE(obj) ((obj) != nil ? (NSObject *)(obj) : (NSObject *)[NSNull null])
NSString *szModulus = @"";
NSString *szExp = @"";
NSString *base64EncodedPublicKey = @"";
IabHelper *iab;
@implementation PaymentsPlugin

- (void)pluginInitialize {
}

- (void)launchPurchaseFlow:(CDVInvokedUrlCommand *)command {
    NSString* sku = [command.arguments objectAtIndex:0];
    NSString* msisdn = [command.arguments objectAtIndex:1];
    NSString* editable = [command.arguments objectAtIndex:2];
    BOOL boolValue = [editable boolValue];
    NSString* developerPayload = [command.arguments objectAtIndex:3];
    [self doSomethingWithTheJson];
    [iab launchPurchaseFlowWithAct:self.viewController sku:sku msisdn:msisdn editAble:boolValue delayPayment:0 developerPayload:developerPayload base64EncodedPublicKey:base64EncodedPublicKey finished: ^(Purchase* pur, IabResult* iab) {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        NSMutableArray *validProducts = [NSMutableArray array];
        [validProducts addObject:@{
                                   @"ItemType": NILABLE(pur.getItemType),
                                   @"OrderId": NILABLE(pur.getOrderId),
                                   @"PackageName": NILABLE(pur.getPackageName),
                                   @"Sku": NILABLE(pur.getSku),
                                   @"PurchaseTime": NILABLE(pur.getPurchaseTime_Objc),
                                   @"PurchaseState": NILABLE(pur.getPurchaseState_Objc),
                                   @"DeveloperPayload": NILABLE(pur.getDeveloperPayload),
                                   @"Token": NILABLE(pur.getToken),
                                   @"OriginalJson": NILABLE(pur.getOriginalJson),
                                   @"Signature": NILABLE(pur.getSignature),
                                //   @"IsAutoRenewing": NILABLE([NSNumber numberWithBool:pur.getIsAutoRenewing]),//(BOOL)(pur.getIsAutoRenewing),
                                   @"MSISDN": NILABLE(pur.getMSISDN),
                                   @"PurchaseToken": NILABLE(pur.getpurchaseToken),
                                   @"Message": NILABLE(iab.getMessage),
                                   @"Response": NILABLE([NSNumber numberWithInt: iab.getResponse])//NILABLE(iab.getResponse)
                                   }];
        [result setObject:validProducts forKey:@"products"];
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
            [pluginResult setKeepCallbackAsBool:YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        if (pur != nil) {
            /// consumePurchase(pur, vi);
        }
    }];
}

- (void)launchSubscriptionPurchase:(CDVInvokedUrlCommand *)command {
    NSString* sku = [command.arguments objectAtIndex:0];
    NSString* msisdn = [command.arguments objectAtIndex:1];
    NSString* editable = [command.arguments objectAtIndex:2];
    BOOL boolValue = [editable boolValue];
    NSString* delapyPayment = [command.arguments objectAtIndex:3];
    NSString* developerPayload = [command.arguments objectAtIndex:4];
    [self doSomethingWithTheJson];
    [iab launchSubscriptionPurchaseFlowWithAct:self.viewController sku:sku msisdn:msisdn editAble:boolValue delayPayment:delapyPayment.integerValue developerPayload:developerPayload base64EncodedPublicKey:base64EncodedPublicKey finished: ^(Purchase* pur, IabResult* iab) {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        NSMutableArray *validProducts = [NSMutableArray array];
        [validProducts addObject:@{
                                   @"ItemType": NILABLE(pur.getItemType),
                                   @"OrderId": NILABLE(pur.getOrderId),
                                   @"PackageName": NILABLE(pur.getPackageName),
                                   @"Sku": NILABLE(pur.getSku),
                                   @"PurchaseTime": NILABLE(pur.getPurchaseTime_Objc),
                                   @"PurchaseState": NILABLE(pur.getPurchaseState_Objc),
                                   @"DeveloperPayload": NILABLE(pur.getDeveloperPayload),
                                   @"Token": NILABLE(pur.getToken),
                                   @"OriginalJson": NILABLE(pur.getOriginalJson),
                                   @"Signature": NILABLE(pur.getSignature),
                                   //   @"IsAutoRenewing": NILABLE([NSNumber numberWithBool:pur.getIsAutoRenewing]),//(BOOL)(pur.getIsAutoRenewing),
                                   @"MSISDN": NILABLE(pur.getMSISDN),
                                   @"PurchaseToken": NILABLE(pur.getpurchaseToken),
                                   @"Message": NILABLE(iab.getMessage),
                                   @"Response": NILABLE([NSNumber numberWithInt: iab.getResponse])//NILABLE(iab.getResponse)
                                   }];
        [result setObject:validProducts forKey:@"products"];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        if (pur != nil) {
            /// consumePurchase(pur, vi);
        }
    }];
}

- (void)clearAllData:(CDVInvokedUrlCommand *)command {
    [self doSomethingWithTheJson];
    [iab clearAllData];
}

- (void)querySkuDetailsWithSkusStr:(CDVInvokedUrlCommand *)command {
    [self doSomethingWithTheJson];
    NSString *skuList = [command.arguments objectAtIndex:0];
    [iab querySkuDetailsWithSkusStr:skuList finished:^(NSArray<NSString *>* sku, IabResult* ire) {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        NSMutableArray *validProducts = [NSMutableArray array];
        for(NSString *sk in sku) {
            [validProducts addObject:@{
                                       @"item": NILABLE(sk)
                                       }];
        }

        [validProducts addObject:@{
                                   @"Message": NILABLE(ire.getMessage),
                                   @"Response": NILABLE([NSNumber numberWithInt: ire.getResponse])
                                   }];
        [result setObject:validProducts forKey:@"products"];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

        // NSLog()
    }];
}

- (void)queryPurchasesWithItemType:(CDVInvokedUrlCommand *)command {
    [self doSomethingWithTheJson];
    NSString *itemType = [command.arguments objectAtIndex:0];
    [iab queryPurchasesWithItemType:itemType base64EncodedPublicKey:base64EncodedPublicKey finished:^(NSArray<Purchase *>* pur, IabResult* ire) {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        NSMutableArray *validProducts = [NSMutableArray array];
        for(Purchase *pu in pur) {
            [validProducts addObject:@{
                                       @"ItemType": NILABLE(pu.getItemType),
                                       @"OrderId": NILABLE(pu.getOrderId),
                                       @"PackageName": NILABLE(pu.getPackageName),
                                       @"Sku": NILABLE(pu.getSku),
                                       @"PurchaseTime": NILABLE(pu.getPurchaseTime_Objc),
                                       @"PurchaseState": NILABLE(pu.getPurchaseState_Objc),
                                       @"DeveloperPayload": NILABLE(pu.getDeveloperPayload),
                                       @"Token": NILABLE(pu.getToken),
                                       @"OriginalJson": NILABLE(pu.getOriginalJson),
                                       @"Signature": NILABLE(pu.getSignature),
                                       //   @"IsAutoRenewing": NILABLE([NSNumber numberWithBool:pur.getIsAutoRenewing]),//(BOOL)(pur.getIsAutoRenewing),
                                       @"MSISDN": NILABLE(pu.getMSISDN),
                                       @"PurchaseToken": NILABLE(pu.getpurchaseToken),
                                       }];
        }

        [validProducts addObject:@{
                                   @"Message": NILABLE(ire.getMessage),
                                   @"Response": NILABLE([NSNumber numberWithInt: ire.getResponse])
                                   }];
        [result setObject:validProducts forKey:@"products"];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];

}

- (void)consumePurchase:(CDVInvokedUrlCommand *)command {
    NSString* token = [command.arguments objectAtIndex:0];
    Purchase *purchase = [Purchase alloc];
    [purchase setTokenWithToken:token];
    [self doSomethingWithTheJson];
     [iab consumePurchaseWithPurchase:purchase finished: ^(Purchase* pur, IabResult* iab) {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        NSMutableArray *validProducts = [NSMutableArray array];
        [validProducts addObject:@{
                                   @"ItemType": NILABLE(pur.getItemType),
                                   @"OrderId": NILABLE(pur.getOrderId),
                                   @"PackageName": NILABLE(pur.getPackageName),
                                   @"Sku": NILABLE(pur.getSku),
                                   @"PurchaseTime": NILABLE(pur.getPurchaseTime_Objc),
                                   @"PurchaseState": NILABLE(pur.getPurchaseState_Objc),
                                   @"DeveloperPayload": NILABLE(pur.getDeveloperPayload),
                                   @"Token": NILABLE(pur.getToken),
                                   @"OriginalJson": NILABLE(pur.getOriginalJson),
                                   @"Signature": NILABLE(pur.getSignature),
                                   //   @"IsAutoRenewing": NILABLE([NSNumber numberWithBool:pur.getIsAutoRenewing]),//(BOOL)(pur.getIsAutoRenewing),
                                   @"MSISDN": NILABLE(pur.getMSISDN),
                                   @"PurchaseToken": NILABLE(pur.getpurchaseToken),
                                   @"Message": NILABLE(iab.getMessage),
                                   @"Response": NILABLE([NSNumber numberWithInt: iab.getResponse])//NILABLE(iab.getResponse)
                                   }];
        [result setObject:validProducts forKey:@"products"];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        if (pur != nil) {
            /// consumePurchase(pur, vi);
        }
    }];
}


- (void)doSomethingWithTheJson
{
    NSDictionary *dict = [self JSONFromFile];

    szModulus = [dict objectForKey:@"charkhone_secret_one"];
    szExp = [dict objectForKey:@"charkhone_secret_two"];
    base64EncodedPublicKey = [dict objectForKey:@"jhoobin_store_key"];
    iab = [[IabHelper alloc] initWithSzModulus: szModulus szExp: szExp];

}

- (NSDictionary *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"manifest" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}


- (void)getProducts:(CDVInvokedUrlCommand *)command {
  id productIds = [command.arguments objectAtIndex:0];

  if (![productIds isKindOfClass:[NSArray class]]) {
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"ProductIds must be an array"];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return;
  }

  NSSet *products = [NSSet setWithArray:productIds];
  [[RMStore defaultStore] requestProducts:products success:^(NSArray *products, NSArray *invalidProductIdentifiers) {

    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSMutableArray *validProducts = [NSMutableArray array];
    for (SKProduct *product in products) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        NSString *currencyCode = [numberFormatter currencyCode];
        
        [validProducts addObject:@{
                                 @"productId": NILABLE(product.productIdentifier),
                                 @"title": NILABLE(product.localizedTitle),
                                 @"description": NILABLE(product.localizedDescription),
                                 @"priceAsDecimal": NILABLE(product.price),
                                 @"price": NILABLE([RMStore localizedPriceOfProduct:product]),
                                 @"currency": NILABLE(currencyCode)
                                 }];
    }
    [result setObject:validProducts forKey:@"products"];
    [result setObject:invalidProductIdentifiers forKey:@"invalidProductsIds"];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  } failure:^(NSError *error) {
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{
                                                                                                                   @"errorCode": NILABLE([NSNumber numberWithInteger:error.code]),
                                                                                                                   @"errorMessage": NILABLE(error.localizedDescription)
                                                                                                                   }];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
}

- (void)buy:(CDVInvokedUrlCommand *)command {
  id productId = [command.arguments objectAtIndex:0];
  if (![productId isKindOfClass:[NSString class]]) {
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"ProductId must be a string"];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return;
  }
  [[RMStore defaultStore] addPayment:productId success:^(SKPaymentTransaction *transaction) {
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSString *encReceipt = [receiptData base64EncodedStringWithOptions:0];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{
                                                                                                                   @"transactionId": NILABLE(transaction.transactionIdentifier),
                                                                                                                   @"receipt": NILABLE(encReceipt)
                                                                                                                   }];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

  } failure:^(SKPaymentTransaction *transaction, NSError *error) {
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{
                                                                                                                   @"errorCode": NILABLE([NSNumber numberWithInteger:error.code]),
                                                                                                                   @"errorMessage": NILABLE(error.localizedDescription)
                                                                                                                   }];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];

}

- (void)restorePurchases:(CDVInvokedUrlCommand *)command {
  [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions){
    NSMutableArray *validTransactions = [NSMutableArray array];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    for (SKPaymentTransaction *transaction in transactions) {
      NSString *transactionDateString = [formatter stringFromDate:transaction.transactionDate];
      [validTransactions addObject:@{
                                 @"productId": NILABLE(transaction.payment.productIdentifier),
                                 @"date": NILABLE(transactionDateString),
                                 @"transactionId": NILABLE(transaction.transactionIdentifier),
                                 @"transactionState": NILABLE([NSNumber numberWithInteger:transaction.transactionState])
                                 }];
    }
    [result setObject:validTransactions forKey:@"transactions"];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  } failure:^(NSError *error) {
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{
                                                                                                                   @"errorCode": NILABLE([NSNumber numberWithInteger:error.code]),
                                                                                                                   @"errorMessage": NILABLE(error.localizedDescription)
                                                                                                                   }];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
}

- (void)getReceipt:(CDVInvokedUrlCommand *)command {
  [[RMStore defaultStore] refreshReceiptOnSuccess:^{
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSString *encReceipt = [receiptData base64EncodedStringWithOptions:0];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"receipt": NILABLE(encReceipt) }];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  } failure:^(NSError *error) {
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:@{
                                                                                                                   @"errorCode": NILABLE([NSNumber numberWithInteger:error.code]),
                                                                                                                   @"errorMessage": NILABLE(error.localizedDescription)
                                                                                                                   }];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
}

@end
