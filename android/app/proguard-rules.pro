# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Keep Flutter and Dart classes
-keep class io.flutter.** { *; }
-keep class androidx.** { *; }
-dontwarn io.flutter.**

# Keep HTTP and networking classes
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# Keep cached_network_image related classes
-keep class com.davemorrissey.labs.subscaleview.** { *; }
-keep class com.github.bumptech.glide.** { *; }

# Keep JSON serialization classes
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Keep reflection for Flutter plugins
-keep class * extends io.flutter.plugin.common.PluginRegistry$Registrar { *; }
-keep class * extends io.flutter.embedding.engine.plugins.FlutterPlugin { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}
# Network security for HTTPS
-keep class org.conscrypt.** { *; }
-dontwarn org.conscrypt.**

# Keep SSL and TLS classes
-keep class javax.net.ssl.** { *; }
-keep class org.apache.http.** { *; }

# Keep HTTP client implementations
-keep class com.android.org.conscrypt.** { *; }
-dontwarn com.android.org.conscrypt.**

# Google Play Core API (новые версии)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Flutter Play Store Split Application (если используется)
-keep class io.flutter.embedding.android.FlutterPlayStoreSplitApplication { *; }

# Play Store Deferred Component Manager (если используется)
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

# Google Play новые модули
-keep class com.google.android.play.core.appupdate.** { *; }
-keep class com.google.android.play.core.review.** { *; }
-keep class com.google.android.play.core.common.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
