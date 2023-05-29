import 'package:flutter/material.dart';
import 'package:locate_test/background/bg_service.dart';
import 'package:locate_test/database/database_helper.dart';
import 'package:locate_test/locate/geolocator_locate.dart';
import 'package:locate_test/model/database_model.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  BgService bgService = BgService();
  DataBaseHelper database = DataBaseHelper();
  GeolocatorLocate geolocatorLocate = GeolocatorLocate();
  DataBaseHelper handler = DataBaseHelper();
  @override
  void initState() {
    geolocatorLocate.getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          Row(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new)),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: size.width * 0.25,
                ),
                child: _textList('Konum İşlemi'),
              )
            ],
          ),
          Expanded(
            child: StreamBuilder(
                stream: Stream.fromFuture(database.retrieveTable()),
                builder:
                    (context, AsyncSnapshot<List<DatabaseModel>> snapshot) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              height: size.height * 0.15,
                              width: size.width,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _textList(
                                        '${snapshot.data?[index].cKonum}',
                                      ),
                                      _textList(
                                        '${snapshot.data?[index].cEnlem}',
                                      ),
                                      _textList(
                                        '${snapshot.data?[index].cBoylam}',
                                      ),
                                      _textList(
                                        '${snapshot.data?[index].cZaman}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                }),
          ),
        ]),
      ),
    );
  }

  _textList(String sonuc) {
    return Text(
      sonuc,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    );
  }
}
