package dev.harrydekat.discipulus

import android.app.Activity
import android.app.NotificationManager
import android.app.NotificationManager.INTERRUPTION_FILTER_NONE
import android.content.Context
import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

class DNDManagerPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    private lateinit var channel : MethodChannel
    private lateinit var context: Context
    private var activity: Activity? = null
    private var pendingResult: Result? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dev.harrydekat.dnd_manager/dnd")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "setDNDMode" -> {
                val silent = call.argument<Boolean>("silent") ?: false
                setDNDMode(silent, result)
            }
            "checkDNDAccess" -> {
                result.success(checkDNDAccess())
            }
            "requestDNDAccess" -> {
                requestDNDAccess(result)
            }
            "isSilentModeOn" -> {
                result.success(isSilentModeOn())
            }
            else -> result.notImplemented()
        }
    }

    private fun setDNDMode(silent: Boolean, result: Result) {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (notificationManager.isNotificationPolicyAccessGranted) {
            try {
                notificationManager.setInterruptionFilter(
                    if (silent) INTERRUPTION_FILTER_NONE
                    else NotificationManager.INTERRUPTION_FILTER_ALL
                )
                result.success(true)
            } catch (e: SecurityException) {
                result.error("SECURITY_EXCEPTION", "Failed to set DND mode", e.message)
            }
        } else {
            result.error("PERMISSION_DENIED", "DND access not granted", null)
        }
    }

    private fun checkDNDAccess(): Boolean {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        return notificationManager.isNotificationPolicyAccessGranted

    }

    private fun requestDNDAccess(result: Result) {

        if (activity == null) {
            result.error("ACTIVITY_NOT_AVAILABLE", "Activity is not available", null)
            return
        }
        pendingResult = result
        val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
        activity?.startActivityForResult(intent, DND_ACCESS_REQUEST_CODE)

    }

    private fun isSilentModeOn(): Boolean {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        return notificationManager.currentInterruptionFilter == INTERRUPTION_FILTER_NONE
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == DND_ACCESS_REQUEST_CODE) {
            pendingResult?.success(checkDNDAccess())
            pendingResult = null
            return true
        }
        return false
    }

    companion object {
        private const val DND_ACCESS_REQUEST_CODE = 123
    }
}