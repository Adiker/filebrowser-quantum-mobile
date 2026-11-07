package com.filebrowser_quantum_mobile

import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterFragmentActivity() {
    private val channelName = "com.adiker.filebrowser_quantum_mobile/update"

    @Suppress("DEPRECATION")
    private fun signers(info: PackageInfo): Set<String> {
        val signatures = if (Build.VERSION.SDK_INT >= 28) {
            info.signingInfo?.apkContentsSigners
        } else info.signatures
        return signatures?.map { it.toByteArray().joinToString("") { b -> "%02x".format(b) } }?.toSet() ?: emptySet()
    }

    @Suppress("DEPRECATION")
    private fun code(info: PackageInfo): Long = if (Build.VERSION.SDK_INT >= 28) info.longVersionCode else info.versionCode.toLong()

    @Suppress("DEPRECATION")
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "install" -> {
                        val target = File(call.argument<String>("path") ?: error("Missing APK" )).canonicalFile
                        val expected = call.argument<String>("version") ?: error("Missing version")
                        val dir = File(filesDir, "updates").canonicalFile
                        require(target.parentFile == dir && target.name == "update.apk" && target.isFile) { "Invalid APK location" }
                        val flags = if (Build.VERSION.SDK_INT >= 28) PackageManager.GET_SIGNING_CERTIFICATES else PackageManager.GET_SIGNATURES
                        val installed = packageManager.getPackageInfo(packageName, flags)
                        val apk = packageManager.getPackageArchiveInfo(target.path, flags) ?: error("Invalid APK")
                        require(apk.packageName == packageName && apk.versionName == expected && code(apk) > code(installed)) { "Incompatible APK package or version" }
                        val currentSigners = signers(installed)
                        require(currentSigners.isNotEmpty() && currentSigners == signers(apk)) { "Incompatible APK signature" }
                        if (Build.VERSION.SDK_INT >= 26 && !packageManager.canRequestPackageInstalls()) {
                            startActivity(Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES, Uri.parse("package:$packageName")))
                            result.success("permission")
                        } else {
                            val uri = FileProvider.getUriForFile(this, "$packageName.updateprovider", target)
                            startActivity(Intent(Intent.ACTION_VIEW).apply {
                                setDataAndType(uri, "application/vnd.android.package-archive")
                                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                            })
                            result.success("launched")
                        }
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                result.error("UPDATE_ERROR", e.message ?: "Update failed", null)
            }
        }
    }
}
