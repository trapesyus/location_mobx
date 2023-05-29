import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:locate_test/append_operation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:locate_test/database/database_helper.dart';
import 'package:locate_test/locate/geolocator_locate.dart';

GeolocatorLocate geolocatorLocate = GeolocatorLocate();
final Timer timer = Timer.periodic(const Duration(seconds: 10), (timer) {
  log('Çalışıyor:');
  appendOperation.rowAppend(
      geolocatorLocate.currentAddress.toString(),
      geolocatorLocate.currentPosition?.latitude.toString() ?? "konum yok",
      geolocatorLocate.currentPosition?.longitude.toString() ?? "konum yok",
      DateTime.now().toString());
});
final AppendOperation appendOperation = AppendOperation();

class BgService {
  final service = FlutterBackgroundService();
  Future mainBgService() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground', // id
      'MY FOREGROUND SERVICE', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high, // importance must be at low or higher level
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await service.configure(
        iosConfiguration: IosConfiguration(
          onForeground: onStart,
          onBackground: onIosBackground,
          autoStart: true,
        ),
        androidConfiguration:
            AndroidConfiguration(onStart: onStart, isForegroundMode: true));
    service.startService();
  }

  Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
        log('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
      });
    }

    service.on('stopService').listen((event) {
      log('Stop Service Fonksiyonunda');
      timer.cancel();
      log('Timer Kapatıldı');
      service.stopSelf();
    });

    // test using external plugin
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }
    final database = DataBaseHelper();
    database.initializedDB().whenComplete(() async {});
    geolocatorLocate.handleLocationPermission();
    geolocatorLocate.getCurrentPosition();

    timer;
    log(timer.tick.toString());
  }
}
