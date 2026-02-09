# Flutter embedding
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }

# Play Core (required by Flutter deferred components)
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Optional: suppress warnings if any remain
-dontwarn com.google.android.play.core.**

# ImageIO SPI warnings (fine)
-dontwarn javax.imageio.spi.ImageInputStreamSpi
-dontwarn javax.imageio.spi.ImageOutputStreamSpi
-dontwarn javax.imageio.spi.ImageReaderSpi
-dontwarn javax.imageio.spi.ImageWriterSpi

-dontwarn okhttp3.Call
-dontwarn okhttp3.Dispatcher
-dontwarn okhttp3.OkHttpClient
-dontwarn okhttp3.Request$Builder
-dontwarn okhttp3.Request
-dontwarn okhttp3.Response
-dontwarn okhttp3.ResponseBody