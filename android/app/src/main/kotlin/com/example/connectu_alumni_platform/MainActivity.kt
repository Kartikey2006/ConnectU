package com.example.connectu_alumni_platform

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    
    override fun onBackPressed() {
        // DO NOTHING - This prevents the app from closing
        // Flutter will handle all navigation through WillPopScope
    }
}
