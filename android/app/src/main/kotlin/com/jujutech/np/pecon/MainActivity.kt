package com.jujutech.np.pecon

import io.flutter.embedding.android.FlutterActivity
import android.view.WindowManager.LayoutParams

class MainActivity: FlutterActivity() {
    override fun onResume() {
        super.onResume()
        // Disable screenshots and screen recording
        window.addFlags(LayoutParams.FLAG_SECURE)
    }

    override fun onPause() {
        super.onPause()
        // Re-enable screenshots and screen recording (optional)
        window.clearFlags(LayoutParams.FLAG_SECURE)
    }
}
