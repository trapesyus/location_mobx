class DatabaseModel {
  final String cKonum;
  final String cEnlem;
  final String cBoylam;
  final String cZaman;

  DatabaseModel({
    required this.cKonum,
    required this.cEnlem,
    required this.cBoylam,
    required this.cZaman,
  });

  DatabaseModel.fromMap(Map<String, dynamic> result)
      : cKonum = result["konum"],
        cEnlem = result["enlem"],
        cBoylam = result["boylam"],
        cZaman = result["zaman"];

  Map<String, Object> toMap() {
    return {
      'konum': cKonum,
      'enlem': cEnlem,
      'boylam': cBoylam,
      'zaman': cZaman
    };
  }
}
