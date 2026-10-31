
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/academic_model.dart';

const Color obsidianBloom = Color(0xFF4C1413);
const Color guavaGlow = Color(0xFFEA6B7E);
const Color blossomVapor = Color(0xFFFFDBED);
const Color softBackground = Color(0xFFFFF5F8);

class FormAcademicScreen extends StatefulWidget {
  final AcademicModel? item;

  const FormAcademicScreen({
    super.key,
    this.item,
  });

  @override
  State<FormAcademicScreen> createState() =>
      _FormAcademicScreenState();
}

class _FormAcademicScreenState extends State<FormAcademicScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();
  final _additionalInfoController = TextEditingController();

  String? _selectedCategory;
  bool _isLoading = false;

  final List<String> _categories = [
    'Informasi',
    'Jadwal Kuliah',
    'Mata Kuliah',
    'Nilai Akademik',
    'Seminar',
    'Pengumuman',
    'Beasiswa',
    'Lainnya',
  ];

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();

    final item = widget.item;

    if (item != null) {
      _titleController.text = item.title;
      _descriptionController.text = item.description;
      _imageController.text = item.image;
      _additionalInfoController.text = item.additionalInfo;

      _selectedCategory = _categories.contains(item.category)
          ? item.category
          : 'Lainnya';
    } else {
      _selectedCategory = 'Informasi';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  InputDecoration _decoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: guavaGlow),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      labelStyle: const TextStyle(color: obsidianBloom),
      hintStyle: const TextStyle(color: Colors.black38),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: blossomVapor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: guavaGlow,
          width: 1.8,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: obsidianBloom,
        ),
      ),
    );
  }

  Future<void> _simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih kategori informasi'),
          backgroundColor: guavaGlow,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final data = AcademicModel(
        id: widget.item?.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory!,
        image: _imageController.text.trim(),
        additionalInfo: _additionalInfoController.text.trim(),
      );

      if (_isEditing) {
        await DatabaseHelper.instance.updateAcademic(data);
      } else {
        await DatabaseHelper.instance.insertAcademic(data);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Informasi akademik berhasil diperbarui'
                : 'Informasi akademik berhasil ditambahkan',
          ),
          backgroundColor: obsidianBloom,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Gagal menyimpan data. Silakan coba kembali.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBackground,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Informasi' : 'Tambah Informasi',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: obsidianBloom,
        foregroundColor: blossomVapor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            children: [
              // Header halaman.
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: obsidianBloom,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        color: blossomVapor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isEditing
                            ? Icons.edit_note_rounded
                            : Icons.add_box_rounded,
                        size: 32,
                        color: obsidianBloom,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isEditing
                                ? 'Perbarui Informasi ♡'
                                : 'Informasi Baru ♡',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: blossomVapor,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            'Lengkapi data akademik di bawah ini.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              _label('Judul Informasi'),
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: _decoration(
                  label: 'Judul',
                  hint: 'Contoh: Jadwal Kuliah Semester 5',
                  icon: Icons.title_rounded,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul informasi wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _label('Kategori'),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                isExpanded: true,
                decoration: _decoration(
                  label: 'Pilih Kategori',
                  hint: 'Pilih kategori informasi',
                  icon: Icons.category_outlined,
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Kategori wajib dipilih';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _label('Deskripsi Informasi'),
              TextFormField(
                controller: _descriptionController,
                minLines: 3,
                maxLines: 6,
                textCapitalization: TextCapitalization.sentences,
                decoration: _decoration(
                  label: 'Deskripsi',
                  hint: 'Jelaskan informasi akademik di sini...',
                  icon: Icons.description_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _label('Path Gambar Aset'),
              TextFormField(
                controller: _imageController,
                keyboardType: TextInputType.text,
                decoration: _decoration(
                  label: 'Path Gambar',
                  hint: 'assets/images/jadwal_kuliah.jpg',
                  icon: Icons.image_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Path gambar wajib diisi';
                  }
                  if (!value.trim().startsWith('assets/images/')) {
                    return 'Gunakan path dari assets/images/';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 9),

              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: blossomVapor.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: obsidianBloom,
                      size: 20,
                    ),
                    SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'Masukkan path gambar yang sudah ada di '
                        'folder assets/images/. Contoh: '
                        'assets/images/jadwal_kuliah.jpg',
                        style: TextStyle(
                          color: obsidianBloom,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _label('Informasi Tambahan'),
              TextFormField(
                controller: _additionalInfoController,
                minLines: 2,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: _decoration(
                  label: 'Informasi Tambahan',
                  hint: 'Contoh: Pendaftaran dibuka sampai 31 Oktober',
                  icon: Icons.notes_rounded,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informasi tambahan wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 29),

              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _simpanData,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 21,
                          height: 21,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.favorite_rounded),
                  label: Text(
                    _isLoading
                        ? 'Menyimpan...'
                        : _isEditing
                            ? 'Simpan Perubahan'
                            : 'Simpan Informasi',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: guavaGlow,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        guavaGlow.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: _isLoading
                    ? null
                    : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: obsidianBloom,
                  side: const BorderSide(color: guavaGlow),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: const Text('Batal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
