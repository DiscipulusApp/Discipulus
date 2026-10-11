package dev.harrydekat.discipulus

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugins.GeneratedPluginRegistrant
import com.istornz.live_activities.LiveActivityManagerHolder

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        LiveActivityManagerHolder.instance = CustomLiveActivityManager(this)
        flutterEngine.plugins.add(DNDManagerPlugin())
        FlutterEngineCache.getInstance().put("default_engine", flutterEngine)
    }
}
