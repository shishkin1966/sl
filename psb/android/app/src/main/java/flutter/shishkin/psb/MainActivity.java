package flutter.shishkin.psb;

import android.os.Bundle;


import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    public static String CHANNEL_SECURE = "flutter.shishkin.psb/secure";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL_SECURE).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("encode")) {
                        String value = call.arguments.toString();
                        String encoded = Secure.getInstance(this.getApplicationContext()).encode(value);
                        result.success(encoded);
                    } else if (call.method.equals("decode")){
                        String value = call.arguments.toString();
                        String decoded = Secure.getInstance(this.getApplicationContext()).decode(value);
                        result.success(decoded);
                    } else {
                        result.notImplemented();
                    }
                });
    }
}
