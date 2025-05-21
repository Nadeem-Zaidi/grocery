package com.example.grocery_app

import android.Manifest
import android.annotation.SuppressLint
import android.content.pm.PackageManager
import android.location.Location
import android.os.Bundle
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.grocery_app/location"
    private lateinit var fusedLocationClient: FusedLocationProviderClient

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getDeviceLocation") {
                getLastLocation(result)
            } else {
                result.notImplemented()
            }
        }
    }

    @SuppressLint("MissingPermission")
    private fun getLastLocation(result: MethodChannel.Result) {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
            != PackageManager.PERMISSION_GRANTED &&
            ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION)
            != PackageManager.PERMISSION_GRANTED) {
            result.error("PERMISSION_DENIED", "Location permission not granted", null)
            return
        }

        fusedLocationClient.lastLocation
            .addOnSuccessListener { location: Location? ->
                if (location != null) {
                    val locationMap = mapOf(
                        "latitude" to location.latitude,
                        "longitude" to location.longitude
                    )
                    result.success(locationMap)
                } else {
                    result.error("LOCATION_ERROR", "Location is null", null)
                }
            }
            .addOnFailureListener {
                result.error("LOCATION_ERROR", "Failed to get location", it.localizedMessage)
            }
    }
}
