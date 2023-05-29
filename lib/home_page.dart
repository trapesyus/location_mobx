import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:locate_test/background/bg_service.dart';
import 'package:flutter/material.dart';
import 'package:locate_test/locate/geolocator_locate.dart';
import 'package:locate_test/location_page.dart';
import 'package:locate_test/database/database_helper.dart';
import 'dart:developer';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BgService bgService = BgService();

  GeolocatorLocate geolocatorLocate = GeolocatorLocate();
  late DataBaseHelper database;
  @override
  void initState() {
    database = DataBaseHelper();
    database.initializedDB().whenComplete(() {});
    geolocatorLocate.handleLocationPermission();
    setState(() {
      geolocatorLocate.currentAddress;
      geolocatorLocate.currentPosition;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          children: [
            buttonEdit('İŞLEMİ BAŞLAT', () {
              bgService.mainBgService();
            }),
            buttonEdit('LİSTELE', () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LocationPage(),
                  ));
            }),
            buttonEdit('İŞLEMİ DURDUR', () {
              _appOut();
            }),
            buttonEdit('TABLOYU TEMİZLE', () {
              database.deleteRow(0);
            }),
          ],
        ),
      ),
    ));
  }

  ElevatedButton buttonEdit(String text, onTap) {
    return ElevatedButton(onPressed: onTap, child: Text(text));
  }

  void _appOut() async {
    final isRunning = await bgService.service.isRunning();
    if (isRunning) {
      bgService.service.invoke('stopService');
      log('Servis Durduruldu');
    }
  }
}
