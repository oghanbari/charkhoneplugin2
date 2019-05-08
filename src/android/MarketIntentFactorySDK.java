package com.android.billingclient.util;

import android.content.Context;
import android.content.Intent;
import android.content.pm.ResolveInfo;
import android.support.annotation.Keep;

import java.util.List;

@Keep
public class MarketIntentFactorySDK implements MarketIntentFactory {

    private static final String[] JHOOBIN_SERVICE_ACTIONS = new String[]{
            "net.jhoobin.jhub.InAppBillingService.BIND",
            "net.jhoobin.jhub.InAppBillingService",
            "net.jhoobin.jhub.billing.InAppBillingService.BIND",
            "net.jhoobin.jhub.billing.InAppBillingService",
            "net.jhoobin.InAppBillingService.BIND",
            "net.jhoobin.InAppBillingService",
            "net.jhoobin.billing.InAppBillingService.BIND",
            "net.jhoobin.billing.InAppBillingService"
    };

    public MarketIntentFactorySDK() {
    }

    public MarketIntentFactorySDK(boolean forceToUseSDK) {
        MarketIntentFactorySDK.forceToUseSDK = forceToUseSDK;
    }

    private static boolean forceToUseSDK = false;

    @Keep
    public boolean isForceToUseSDK() {
        return forceToUseSDK;
    }

    @Keep
    @Deprecated
    public static void setForceToUseSDK(boolean forceToUseSDK) {
        MarketIntentFactorySDK.forceToUseSDK = forceToUseSDK;
    }

    public Intent getIntentService(Context context) {
        return getCharkhuneSDKIntentService(context, 0, forceToUseSDK);
//        return getJhoobinIntentService(context, 0);
    }

    private Intent getJhoobinIntentService(Context context, int index) {
        try {
            Intent serviceIntent = new Intent(JHOOBIN_SERVICE_ACTIONS[index]);
            List<ResolveInfo> resolveInfos = context.getPackageManager().queryIntentServices(serviceIntent, 0);
            if (resolveInfos != null && !resolveInfos.isEmpty()) {
                //check packageName for block LuckyPatcher
                if (resolveInfos.get(0).serviceInfo.packageName.contains("net.jhoobin.jhub")) {
                    serviceIntent.setPackage(resolveInfos.get(0).serviceInfo.packageName);
                    return serviceIntent;
                } else return getJhoobinIntentService(context, ++index);
            } else return getJhoobinIntentService(context, ++index);
        } catch (Exception e) {
            return null;
        }
    }

    private Intent getCharkhuneSDKIntentService(Context context, int index, boolean forceToUseSDK) {
        if (forceToUseSDK) {
            return getInAppSDKIntentService(context);
        } else {
            try {
                Intent serviceIntent = new Intent(JHOOBIN_SERVICE_ACTIONS[index]);
                serviceIntent.setPackage("net.jhoobin.jhub.charkhune");
                List<ResolveInfo> resolveInfos = context.getPackageManager().queryIntentServices(serviceIntent, 0);
                if (resolveInfos != null && !resolveInfos.isEmpty()) {
                    //check packageName for block LuckyPatcher
                    if (resolveInfos.get(0).serviceInfo.packageName.contains("net.jhoobin.jhub.charkhune")) {
                        return serviceIntent;
                    } else return getCharkhuneSDKIntentService(context, ++index, false);
                } else return getCharkhuneSDKIntentService(context, ++index, false);
            } catch (Exception e) {
                //charkhone not installed
                return getInAppSDKIntentService(context);
            }
        }
    }

    private Intent getInAppSDKIntentService(Context context) {
        //connect to charkhone inapp sdk implemented inside this
        Intent serviceIntent = new Intent("net.jhoobin.jhub.inappsdk.InAppBillingService.BIND");
        serviceIntent.setPackage(context.getPackageName());
        List<ResolveInfo> resolveInfos = context.getPackageManager().queryIntentServices(serviceIntent, 0);
        if (resolveInfos != null && !resolveInfos.isEmpty()) {
            //check packageName for block LuckyPatcher
            if (resolveInfos.get(0).serviceInfo.packageName.contains(context.getPackageName())) {
                return serviceIntent;
            }
        }
        //incorrect sdk configuration
        return null;
    }

}
