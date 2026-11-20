import 'package:flutter/material.dart';

import '../models/ensiklopedia_model.dart';

class EnsiklopediaDetailPage extends StatelessWidget {
  final NegaraModel negara;

  const EnsiklopediaDetailPage({super.key, required this.negara});

  String _formatRibuan(num angka) {
    final str = angka.toStringAsFixed(0);
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]}.');
  }

  String _gabungList(List<String> items) {
    final bersih = items.where((e) => e.trim().isNotEmpty).toList();
    return bersih.isEmpty ? '-' : bersih.join(', ');
  }

  Widget info(String judul, String isi, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F4C81).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: const Color(0xFF0F4C81)),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isi.trim().isEmpty ? '-' : isi,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1D24),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Text(
          negara.nama,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF0F4C81),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Header Bendera & Nama Negara
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F4C81), Color(0xFF1E6BB8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F4C81).withValues(alpha: 0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: negara.bendera.isNotEmpty
                          ? Image.network(
                              negara.bendera,
                              width: 220,
                              height: 135,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox(
                                  width: 220,
                                  height: 135,
                                  child: Icon(
                                    Icons.flag_rounded,
                                    size: 72,
                                    color: Colors.black38,
                                  ),
                                );
                              },
                            )
                          : const SizedBox(
                              width: 220,
                              height: 135,
                              child: Icon(
                                Icons.flag_rounded,
                                size: 72,
                                color: Colors.black38,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    negara.nama,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  if (negara.namaResmi.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      negara.namaResmi,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Kartu Tentang Negara (About)
            if (negara.about.trim().isNotEmpty) ...[
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.06),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F4C81)
                                .withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: Color(0xFF0F4C81),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Tentang Negara',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1D24),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      negara.about,
                      style: const TextStyle(
                        fontSize: 14.5,
                        color: Color(0xFF333842),
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 18),

            // Kartu Informasi Negara
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  info(
                    'Nama resmi',
                    negara.namaResmi,
                    icon: Icons.badge_outlined,
                  ),
                  const Divider(height: 1),
                  info(
                    'Ibu kota',
                    negara.ibuKota,
                    icon: Icons.location_city_rounded,
                  ),
                  const Divider(height: 1),
                  info('Wilayah', negara.wilayah, icon: Icons.public_rounded),
                  const Divider(height: 1),
                  info(
                    'Subwilayah',
                    negara.subWilayah,
                    icon: Icons.map_outlined,
                  ),
                  const Divider(height: 1),
                  info(
                    'Populasi',
                    _formatRibuan(negara.populasi),
                    icon: Icons.groups_rounded,
                  ),
                  const Divider(height: 1),
                  info(
                    'Luas wilayah',
                    '${_formatRibuan(negara.luasWilayah)} km²',
                    icon: Icons.straighten_rounded,
                  ),
                  const Divider(height: 1),
                  info(
                    'Bahasa',
                    _gabungList(negara.bahasa),
                    icon: Icons.translate_rounded,
                  ),
                  const Divider(height: 1),
                  info(
                    'Mata uang',
                    _gabungList(negara.mataUang),
                    icon: Icons.payments_outlined,
                  ),
                  const Divider(height: 1),
                  info(
                    'Negara perbatasan',
                    _gabungList(negara.perbatasan),
                    icon: Icons.border_all_rounded,
                  ),
                  const Divider(height: 1),
                  info(
                    'Zona waktu',
                    _gabungList(negara.zonaWaktu),
                    icon: Icons.schedule_rounded,
                  ),
                ],
              ),
            ),

            // Lambang Negara
            if (negara.lambangNegara.isNotEmpty) ...[
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.06),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 20,
                          color: Color(0xFF0F4C81),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Lambang Negara',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1D24),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Image.network(
                      negara.lambangNegara,
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text(
                          'Lambang tidak tersedia',
                          style: TextStyle(color: Colors.black54),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],

            // Google Maps
            if (negara.peta.isNotEmpty) ...[
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.06),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: info(
                  'Google Maps',
                  negara.peta,
                  icon: Icons.pin_drop_outlined,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
