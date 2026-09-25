package ua.pp.chds.apuzzle

import android.content.Intent
import android.content.pm.verify.domain.DomainVerificationManager
import android.content.pm.verify.domain.DomainVerificationUserState
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "apuzzle/links").setMethodCallHandler { call, result ->
            when (call.method) {
                "status" -> result.success(linkStatus())
                "openSettings" -> result.success(openLinkSettings())
                else -> result.notImplemented()
            }
        }
    }

    // True when share links open in the app, false when not, null before
    // Android 12 (links show the app chooser there).
    private fun linkStatus(): Boolean? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return null
        val manager = getSystemService(DomainVerificationManager::class.java) ?: return null
        val state = manager.getDomainVerificationUserState(packageName) ?: return null
        if (!state.isLinkHandlingAllowed) return false
        val host = state.hostToStateMap[LINK_HOST] ?: return false
        return host != DomainVerificationUserState.DOMAIN_STATE_NONE
    }

    private fun openLinkSettings(): Boolean {
        val uri = Uri.parse("package:$packageName")
        val intents = listOfNotNull(
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) Intent(Settings.ACTION_APP_OPEN_BY_DEFAULT_SETTINGS, uri) else null,
            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, uri),
        )
        for (intent in intents) {
            try {
                startActivity(intent)
                return true
            } catch (_: Exception) {
            }
        }
        return false
    }

    private companion object {
        const val LINK_HOST = "jncchds.github.io"
    }
}
