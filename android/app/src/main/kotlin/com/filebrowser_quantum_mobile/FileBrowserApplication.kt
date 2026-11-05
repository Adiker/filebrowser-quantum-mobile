package com.filebrowser_quantum_mobile

import io.flutter.app.FlutterApplication
import java.net.HttpURLConnection

// Workers may start in a fresh process without a foreground Activity.
class FileBrowserApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        HttpURLConnection.setFollowRedirects(false)
    }
}
