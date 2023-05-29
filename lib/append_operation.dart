import 'package:locate_test/database/database_helper.dart';

import 'model/database_model.dart';

class AppendOperation {
  DataBaseHelper databaseHandler = DataBaseHelper();

  Future<int> rowAppend(konum, enlem, boylam, zaman) async {
    return await databaseHandler.insertTable(
      DatabaseModel(
        cKonum: konum,
        cEnlem: enlem,
        cBoylam: boylam,
        cZaman: zaman,
      ) as List<DatabaseModel>,
    );
  }
}
