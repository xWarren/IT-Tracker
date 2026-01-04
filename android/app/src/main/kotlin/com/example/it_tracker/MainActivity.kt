package com.example.it_tracker

import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File

class MainActivity : FlutterActivity() {

    private val CHANNEL = Keys.installedAppsKey

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->

            if (call.method == Keys.getInstalledAppsKey) {
                result.success(getInstalledApps())
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getInstalledApps(): List<Map<String, Any>> {

        val pm: PackageManager = packageManager
        val apps: List<ApplicationInfo> =
            pm.getInstalledApplications(PackageManager.GET_META_DATA)

        val result: MutableList<Map<String, Any>> = mutableListOf()

        for (app: ApplicationInfo in apps) {

            // ❌ Exclude system apps
            if ((app.flags and ApplicationInfo.FLAG_SYSTEM) != 0) continue
            if ((app.flags and ApplicationInfo.FLAG_UPDATED_SYSTEM_APP) != 0) continue

            // ❌ Exclude split APKs (cannot be shared as single APK)
            if (app.splitSourceDirs != null) continue

            // ❌ Exclude non-launchable apps
            if (pm.getLaunchIntentForPackage(app.packageName) == null) continue

            // ❌ Exclude invalid APK
            val apkFile = File(app.sourceDir)
            if (!apkFile.exists() || !apkFile.canRead() || apkFile.length() <= 0) continue

            val name: String = pm.getApplicationLabel(app).toString()
            val iconDrawable: Drawable = pm.getApplicationIcon(app)

            val width = if (iconDrawable.intrinsicWidth > 0) iconDrawable.intrinsicWidth else 1
            val height = if (iconDrawable.intrinsicHeight > 0) iconDrawable.intrinsicHeight else 1

            val bitmap: Bitmap = Bitmap.createBitmap(
                width,
                height,
                Bitmap.Config.ARGB_8888
            )

            val canvas = Canvas(bitmap)
            iconDrawable.setBounds(0, 0, canvas.width, canvas.height)
            iconDrawable.draw(canvas)

            val stream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)

            val apkSizeBytes = apkFile.length()
            val apkSizeMB = String.format("%.2f", apkSizeBytes / (1024.0 * 1024.0))

            val map: MutableMap<String, Any> = mutableMapOf()
            map["appName"] = name
            map["packageName"] = app.packageName
            map["sourceDir"] = app.sourceDir
            map["icon"] = stream.toByteArray()
            map["appSizeBytes"] = apkSizeBytes
            map["appSizeMB"] = apkSizeMB
            map["isSendable"] = true

            result.add(map)
        }

        return result
    }
}
