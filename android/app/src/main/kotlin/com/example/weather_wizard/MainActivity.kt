package com.example.weather_wizard

import android.content.Intent
import android.net.Uri

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){
    private val channel = "urlLaunching"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            when (call.method) {
                "shareUrl" -> handleShareUrl(call, result)
                "openUrlInBrowser" -> handleOpenUrlInBrowser(call, result)
                else -> result.notImplemented()
            }
        }
    }

    private fun handleShareUrl(call: MethodCall, result: MethodChannel.Result) {
        val url = call.argument<String>("url")
        if (url.isNullOrBlank()) { // Improved check for both null and blank cases
            result.error("INVALID_URL", "Url argument is null or empty", null)
            return
        }
        shareUrl(url, result)
    }

    private fun handleOpenUrlInBrowser(call: MethodCall, result: MethodChannel.Result) {
        val url = call.argument<String>("url")
        if (url.isNullOrBlank()) {
            result.error("INVALID_URL", "Url argument is null or empty", null)
            return
        }
        openUrlInBrowser(url, result)
    }

    private fun shareUrl(url: String, result: MethodChannel.Result) {
        try {
            val sendIntent = Intent().apply {
                action = Intent.ACTION_SEND
                putExtra(Intent.EXTRA_TEXT, url)
                type = "text/plain"
            }

            val chooserIntent = Intent.createChooser(sendIntent, "Share URL")
            startActivity(chooserIntent)
            result.success("URL_SHARED")
        } catch (e: Exception) {
            result.error("SHARE_FAILED", "Error sharing URL: ${e.message}", null)
        }
    }

    private fun openUrlInBrowser(url: String, result: MethodChannel.Result) {
        try {
            val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
            startActivity(browserIntent)
            result.success("URL_OPENED")
        } catch (e: Exception) {
            result.error("URL_ERROR", "Could not open URL: ${e.message}", null)
        }
    }
}

