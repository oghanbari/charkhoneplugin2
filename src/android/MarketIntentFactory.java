package com.android.billingclient.util;

import android.content.Context;
import android.content.Intent;
import android.support.annotation.Keep;

@Keep
public interface MarketIntentFactory {

    Intent getIntentService(Context context);

}
