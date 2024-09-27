package `in`.breeze.blaze_sdk_flutter

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import `in`.breeze.blaze.Blaze
import org.json.JSONObject
import android.app.Activity
import android.webkit.WebView


/** BlazeSdkFlutterPlugin */
class BlazeSdkFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var blaze: Blaze
  private var activity: Activity? = null
 
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "blaze_sdk_flutter")
    channel.setMethodCallHandler(this)
    WebView.setWebContentsDebuggingEnabled(true);
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "initiate" -> {
        initiate(call.arguments)
        result.success(true)
      }
      "process" -> {
        process(call.arguments)
        result.success(true)
      }
      "handleBackPress" -> {
        result.success(handleBackPress())
      }
      "terminate" -> {
        terminate()
        result.success(true)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  // Utils

  fun safeParseJson(jsonString: Any): JSONObject {
    try {
      if(jsonString is String) {
        return JSONObject(jsonString)
      }
    } catch (e: Exception) {
      println("BlazeSDK: Failure in parsing JSON: ${e}")
    }
    return JSONObject()
  }
  
  // Exposed Bridge Methods

  fun initiate(initiatePayload: Any) {
    blaze = Blaze()
    if(activity != null) {
      val initiatePayloadJson = safeParseJson(initiatePayload)
      blaze.initiate(activity!!, initiatePayloadJson) { result ->
        activity?.runOnUiThread {
          channel.invokeMethod("blaze-callback", result.toString())
        }
      }
    } else {
      println("BlazeSDK: Activity is null")
    }
  }

  fun process(processPayload: Any) {
    val processPayloadJson = safeParseJson(processPayload)
    blaze.process(processPayloadJson)
  }

  fun handleBackPress(): Boolean  {
    return blaze.handleBackPress()
  }

  fun terminate() {
    blaze.terminate();
  }

}