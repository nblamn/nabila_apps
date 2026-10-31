import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/academic_model.dart';
import 'form_academic_screen.dart';

class DetailScreen extends StatelessWidget {
  final AcademicModel item;

  const DetailScreen({
    super.key,
    required this.item,
  });

  static const obsidianBloom = Color(0xFF4C1413);
  static const guavaGlow = Color(0xFFEA6B7E);
  static const blossomVapor = Color(0xFFFFDBED);
  static const softBackground = Color(0xFFFFF5F8);

  Future<void> _hapusData(BuildContext context) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Hapus Informasi',
          style: TextStyle(
            color: obsidianBloom,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Apakah kamu yakin ingin menghapus "${item.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(
              'Batal',
              style: TextStyle(color: obsidianBloom),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: guavaGlow,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Ya'),
          ),
        ],
      ),
    );

    if (konfirmasi != true || item.id == null) return;

    final hasil =
        await DatabaseHelper.instance.deleteAcademic(item.id!);

    if (!context.mounted) return;

    if (hasil > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informasi akademik berhasil dihapus'),
          backgroundColor: obsidianBloom,
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data tidak ditemukan atau gagal dihapus'),
          backgroundColor: guavaGlow,
        ),
      );
    }
  }

  Future<void> _editData(BuildContext context) async {
    final hasil = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FormAcademicScreen(item: item),
      ),
    );

    if (hasil == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  void _lihatFoto(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: obsidianBloom,
          appBar: AppBar(
            backgroundColor: obsidianBloom,
            foregroundColor: blossomVapor,
            title: const Text('Foto Informasi'),
          ),
          body: SizedBox.expand(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              child: Center(
                child: Image.asset(
                  item.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'Foto gagal dimuat',
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBackground,
      appBar: AppBar(
        title: const Text('Detail Akademik'),
        backgroundColor: obsidianBloom,
        foregroundColor: blossomVapor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GestureDetector(
            onTap: () => _lihatFoto(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Image.asset(
                    item.image,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 220,
                        width: double.infinity,
                        color: blossomVapor,
                        child: const Icon(
                          Icons.school_rounded,
                          size: 90,
                          color: obsidianBloom,
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: obsidianBloom.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.zoom_in,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Lihat foto',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              label: Text(item.category),
              backgroundColor: blossomVapor,
              labelStyle: const TextStyle(
                color: obsidianBloom,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide.none,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            item.title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: obsidianBloom,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Deskripsi Informasi',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: obsidianBloom,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            item.description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.7,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Informasi Tambahan',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: obsidianBloom,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: blossomVapor),
            ),
            child: Text(
              item.additionalInfo,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 30),

          ElevatedButton.icon(
            onPressed: () => _editData(context),
            icon: const Icon(Icons.edit),
            label: const Text('Edit Informasi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: guavaGlow,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(17),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: () => _hapusData(context),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Hapus Informasi'),
            style: OutlinedButton.styleFrom(
              foregroundColor: obsidianBloom,
              side: const BorderSide(color: obsidianBloom),
              padding: const EdgeInsets.all(17),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
