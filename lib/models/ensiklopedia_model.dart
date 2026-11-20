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
  });

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

      // Mengambil URL gambar bendera
      bendera: flags['png'] ?? '',

      lambangNegara: '',

      perbatasan: List<String>.from(json['borders'] ?? []),

      zonaWaktu: List<String>.from(json['timezones'] ?? []),

      peta: json['maps']?['googleMaps'] ?? '',
    );
  }
}
