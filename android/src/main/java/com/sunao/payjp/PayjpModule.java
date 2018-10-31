package com.sunao.payjp;

import android.support.annotation.NonNull;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;

import jp.pay.android.PayjpToken;
import jp.pay.android.PayjpTokenConfiguration;
import jp.pay.android.Task;
import jp.pay.android.model.Token;

public class PayjpModule extends ReactContextBaseJavaModule {
    private final String ERROR = "error";
    private String publicKey = "";

    public PayjpModule(ReactApplicationContext context) {
        super(context);
    }

    public String getName() {
        return "RNPayjpAndroid";
    }

    @ReactMethod
    public void setPublicKey(String key) {
        publicKey = key;
    }

    @ReactMethod
    public void createToken(
            String number,
            String cvc,
            String expMonth,
            String expYear,
            String name,
            final Promise promise) {
        PayjpToken payjpToken = new PayjpToken(new PayjpTokenConfiguration.Builder(this.publicKey)
                .build());
        Task<Token> createToken = payjpToken.createToken(number, cvc, expMonth, expYear, name);
            createToken.enqueue(new Task.Callback<Token>() {
                @Override
                public void onSuccess(Token data) {
                    promise.resolve(data.getId());
                }

                @Override
                public void onError(@NonNull Throwable throwable) {
                    promise.resolve(ERROR);
                }
            });
    }
}
