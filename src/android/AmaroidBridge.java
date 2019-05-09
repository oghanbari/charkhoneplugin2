package net.jhoobin.cordovabridge;

import android.content.Context;
import android.util.Log;
import com.google.gson.Gson;
import net.jhoobin.amaroidsdk.Amaroid;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

public class AmaroidBridge extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray data, CallbackContext callbackContext) throws JSONException {

        Context context = this.cordova.getActivity();
        String jSon = data.getString(0);

        if (action.equals("submitEventPageView")) {

            submitEventPageView(context, jSon, callbackContext);

            return true;
        } else if (action.equals("setTags")) {

            setTags(jSon, callbackContext);

            return true;
        } else if (action.equals("submitEvent")) {

            submitEvent(context, jSon, callbackContext);

            return true;
        } else {

            return false;

        }
    }

    private void submitEvent(Context context, String jSon, CallbackContext callbackContext) {
        Log.d("AmaroidBridge", "submitEvent: " + jSon);
        if (jSon != null && jSon.length() > 0) {
            try {

                Event event = new Gson().fromJson(jSon, Event.class);
                Amaroid.getInstance().submitEvent(context, event.eventId, event.eventType, event.eventTarget, event.userAction);

                callbackContext.success("success. " + jSon);
            } catch (Exception e) {
                callbackContext.error("Invalid argument.");
            }
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }

    private void setTags(String jSon, CallbackContext callbackContext) {
        Log.d("AmaroidBridge", "setTags: " + jSon);
        if (jSon != null && jSon.length() > 0) {
            try {

                AmaroidTag amaroidTag = new Gson().fromJson(jSon, AmaroidTag.class);
                Log.d("AmaroidBridge", "tag1: " + amaroidTag.tag1 + " tag2: " + amaroidTag.tag2 + " tag3: " + (amaroidTag.tag3 == null ? "null" : amaroidTag.tag3));
                Amaroid.getInstance().setTags(amaroidTag.tag1, amaroidTag.tag2, amaroidTag.tag3);

                callbackContext.success("success. " + jSon);
            } catch (Exception e) {
                callbackContext.error("Invalid argument.");
            }
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }

    private void submitEventPageView(Context context, String jSon, CallbackContext callbackContext) {
        Log.d("AmaroidBridge", "submitEventPageView: " + jSon);
        if (jSon != null && jSon.length() > 0) {
            try {

                pageView pageView = new Gson().fromJson(jSon, pageView.class);
                Amaroid.getInstance().submitEventPageView(context, pageView.pageName);

                callbackContext.success("success. " + jSon);
            } catch (Exception e) {
                callbackContext.error("Invalid argument.");
            }
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }

    public class Event {
        public Long eventId;
        public String eventType;
        public String eventTarget;
        public String userAction;
    }

    public class AmaroidTag {
        public String tag1;
        public String tag2;
        public String tag3;
    }

    public class pageView {
        public String pageName;
    }
}