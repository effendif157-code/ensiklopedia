class NegaraModel {
  final String nama;
  final String namaResmi;
  final String ibuKota;
  final String wilayah;
  final String subWilayah;
  final int populasi;
  final double luasWilayah;
  final List<String> bahasa;
  final List<String> mataUang;
  final String bendera;
  final String lambangNegara;
  final List<String> perbatasan;
  final List<String> zonaWaktu;
  final String peta;
  final String? customAbout;

  NegaraModel({
    required this.nama,
    required this.namaResmi,
    required this.ibuKota,
    required this.wilayah,
    required this.subWilayah,
    required this.populasi,
    required this.luasWilayah,
    required this.bahasa,
    required this.mataUang,
    required this.bendera,
    required this.lambangNegara,
    required this.perbatasan,
    required this.zonaWaktu,
    required this.peta,
    this.customAbout,
  });

  // Menghasilkan deskripsi otomatis sesuai data negara
  String get about {
    if (customAbout != null && customAbout!.isNotEmpty) {
      return customAbout!;
    }

    final teksBahasa = bahasa.isNotEmpty ? bahasa.join(', ') : '-';
    final teksMataUang = mataUang.isNotEmpty ? mataUang.join(', ') : '-';
    final teksLokasi = subWilayah != '-' ? '$subWilayah, $wilayah' : wilayah;

    return '$nama ($namaResmi) adalah sebuah negara yang terletak di kawasan $teksLokasi '
        'dengan ibu kota di $ibuKota. Negara ini memiliki luas wilayah sekitar '
        '${luasWilayah.toStringAsFixed(0)} km² dan populasi sebanyak $populasi jiwa. '
        'Bahasa utama yang digunakan adalah $teksBahasa, dengan mata uang resmi $teksMataUang.';
  }

  factory NegaraModel.fromJson(Map<String, dynamic> json) {
    final flags = json['flags'] ?? {};
    final currencies = json['currencies'] as List? ?? [];
    final languages = json['languages'] as List? ?? [];

    return NegaraModel(
      nama: json['name'] ?? '-',
      namaResmi: json['nativeName'] ?? json['name'] ?? '-',
      ibuKota: json['capital'] ?? '-',
      wilayah: json['region'] ?? '-',
      subWilayah: json['subregion'] ?? '-',
      populasi: (json['population'] ?? 0) as int,
      luasWilayah: (json['area'] ?? 0).toDouble(),
      bahasa: languages
          .map<String>((item) => item['name']?.toString() ?? '-')
          .toList(),
      mataUang: currencies
          .map<String>((item) => item['name']?.toString() ?? '-')
          .toList(),
      bendera: flags['png'] ?? '',
      lambangNegara: '',
      perbatasan: List<String>.from(json['borders'] ?? []),
      zonaWaktu: List<String>.from(json['timezones'] ?? []),
      peta: json['maps']?['googleMaps'] ?? '',
      customAbout: json['about'] ?? json['description'],
    );
  }
}
