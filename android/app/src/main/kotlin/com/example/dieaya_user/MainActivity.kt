package com.dieayaplus.user

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    private var initialLink: String? = null
    private var pendingLink: String? = null
    private lateinit var methodChannel: MethodChannel
    private val handler = Handler(Looper.getMainLooper())

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Save deep link if the app was launched cold
        intent?.data?.let { uri ->
            initialLink = uri.toString()
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Initialize MethodChannel
        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.dieayaplus.user/links"
        )

        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialLink" -> {
                    // Return cached deep link if cold-started with one
                    result.success(initialLink)
                    initialLink = null // Clear the initial link after using it
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        // Update the intent
        setIntent(intent)

        // Handle runtime deep link (foreground/background)
        intent.data?.let { uri ->
            // Store the pending link
            pendingLink = uri.toString()
        }
    }

    override fun onResume() {
        super.onResume()

        // Handle any pending deep link after activity is resumed
        pendingLink?.let { link ->
            if (::methodChannel.isInitialized) {
                // Add a small delay to ensure Flutter is fully ready
                handler.postDelayed({
                    methodChannel.invokeMethod(
                        "onLinkOpened",
                        mapOf("url" to link)
                    )
                    pendingLink = null
                }, 200) // 200ms delay
            }
        }
    }
}
