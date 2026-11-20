import 'package:flutter/material.dart';

import '../models/ensiklopedia_model.dart';
import '../services/post_services.dart';
import 'ensiklopedia_detail_page.dart';

class EnsiklopediaPage extends StatefulWidget {
  const EnsiklopediaPage({super.key});

  @override
  State<EnsiklopediaPage> createState() => _EnsiklopediaPageState();
}

class _EnsiklopediaPageState extends State<EnsiklopediaPage> {
  final PostService _api = PostService();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<NegaraModel>> _futureNegara;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _futureNegara = _api.fetchCountries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void reloadData() {
    setState(() {
      _futureNegara = _api.fetchCountries();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  List<NegaraModel> _filterNegara(List<NegaraModel> sumber) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return sumber;

    return sumber.where((negara) {
      final nama = negara.nama.toLowerCase();
      final ibuKota = negara.ibuKota.toLowerCase();
      final wilayah = negara.wilayah.toLowerCase();
      return nama.contains(query) ||
          ibuKota.contains(query) ||
          wilayah.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ensiklopedia Negara',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            Text(
              'Jelajahi profil & identitas negara dunia',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F4C81),
        foregroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: reloadData,
              tooltip: 'Muat ulang',
              icon: const Icon(Icons.refresh_rounded),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<NegaraModel>>(
        future: _futureNegara,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 14),
                  Text(
                    'Memuat data negara...',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.wifi_off_rounded,
                          size: 36,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Gagal memuat data negara',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Periksa koneksi internet Anda lalu coba lagi.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        onPressed: reloadData,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0F4C81),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final semuaNegara = snapshot.data ?? [];

          if (semuaNegara.isEmpty) {
            return const Center(
              child: Text(
                'Data negara tidak ditemukan',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            );
          }

          final negaraList = _filterNegara(semuaNegara);

          return Column(
            children: [
              // Search Bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Cari negara, ibu kota, atau wilayah...',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black45,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF0F4C81),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: _clearSearch,
                            tooltip: 'Hapus pencarian',
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.black45,
                            ),
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF4F6FA),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF0F4C81),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              // Info jumlah hasil saat mencari
              if (_searchQuery.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ditemukan ${negaraList.length} negara untuk "$_searchQuery"',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: _clearSearch,
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF0F4C81),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Daftar Negara atau Pesan Kosong
              Expanded(
                child: negaraList.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 48,
                                color: Colors.black.withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Negara "$_searchQuery" tidak ditemukan',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Coba kata kunci lain seperti nama negara atau ibu kota.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                        itemCount: negaraList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final negara = negaraList[index];

                          return Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            elevation: 0,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EnsiklopediaDetailPage(negara: negara),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: Colors.black.withValues(alpha: 0.06),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.03,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Hero(
                                      tag: 'bendera_${negara.nama}_$index',
                                      child: Container(
                                        width: 72,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: colorScheme
                                              .surfaceContainerHighest,
                                          border: Border.all(
                                            color: Colors.black.withValues(
                                              alpha: 0.08,
                                            ),
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            11,
                                          ),
                                          child: Image.network(
                                            negara.bendera,
                                            width: 72,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return const Center(
                                                    child: Icon(
                                                      Icons.flag_rounded,
                                                      size: 26,
                                                      color: Colors.black45,
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            negara.nama,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              color: Color(0xFF1A1D24),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_city_rounded,
                                                size: 14,
                                                color: Color(0xFF0F4C81),
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  negara.ibuKota.isEmpty
                                                      ? 'Ibu kota: -'
                                                      : 'Ibu kota: ${negara.ibuKota}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (negara.wilayah.isNotEmpty) ...[
                                            const SizedBox(height: 6),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF0F4C81)
                                                    .withValues(alpha: 0.08),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                negara.wilayah,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF0F4C81),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF4F6FA),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
