
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/academic_model.dart';
import 'detail_screen.dart';
import 'login_screen.dart';
import 'form_academic_screen.dart';

const Color obsidianBloom = Color(0xFF4C1413);
const Color guavaGlow = Color(0xFFEA6B7E);
const Color blossomVapor = Color(0xFFFFDBED);
const Color softBackground = Color(0xFFFFF5F8);

class DashboardScreen extends StatefulWidget {
  final String userName;

  const DashboardScreen({
    super.key,
    required this.userName,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late Future<List<AcademicModel>> _academicFuture;

  @override
  void initState() {
    super.initState();
    _refreshAcademicData();
  }

  void _refreshAcademicData() {
    _academicFuture = DatabaseHelper.instance.getAcademicItems();
  }

  Future<void> _openAddForm() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const FormAcademicScreen(),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      setState(_refreshAcademicData);
    }
  }

  Future<void> _openDetail(AcademicModel item) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(item: item),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      setState(_refreshAcademicData);
    }
  }

  // Konfirmasi sebelum keluar dari akun.
  Future<void> _logout() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Konfirmasi Keluar',
          style: TextStyle(
            color: obsidianBloom,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Yakin ingin keluar dari akun kamu?',
          style: TextStyle(
            color: Colors.black87,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text(
              'Batal',
              style: TextStyle(
                color: obsidianBloom,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: guavaGlow,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Ya'),
          ),
        ],
      ),
    );

    // Jika memilih Batal atau menutup dialog, tetap di halaman Profil.
    if (konfirmasi != true || !mounted) return;

    // Jika memilih Ya, kembali ke halaman Login.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  Widget _buildHomePage() {
    return RefreshIndicator(
      color: guavaGlow,
      onRefresh: () async {
        setState(_refreshAcademicData);
        await _academicFuture;
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        children: [
          // Header sambutan.
          Container(
            padding: const EdgeInsets.all(21),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  obsidianBloom,
                  Color(0xFF762D36),
                  guavaGlow,
                ],
              ),
              borderRadius: BorderRadius.circular(27),
              boxShadow: [
                BoxShadow(
                  color: obsidianBloom.withValues(alpha: 0.16),
                  blurRadius: 17,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: blossomVapor,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/profile_mahasiswa.jpeg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.school_rounded,
                              size: 32,
                              color: obsidianBloom,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SELAMAT DATANG ♡',
                            style: TextStyle(
                              color: blossomVapor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.userName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 23),
                const Text(
                  'Your academic journey starts here.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pantau informasi perkuliahanmu dengan lebih mudah.',
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.5,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: _openAddForm,
                    style: FilledButton.styleFrom(
                      backgroundColor: blossomVapor,
                      foregroundColor: obsidianBloom,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 11,
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text(
                      'Tambah Informasi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 27),

          // Judul section.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 5,
                height: 35,
                decoration: BoxDecoration(
                  color: guavaGlow,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Akademik',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: obsidianBloom,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Semua informasi perkuliahan dalam satu tempat.',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.auto_awesome_rounded,
                color: guavaGlow,
                size: 25,
              ),
            ],
          ),

          const SizedBox(height: 18),

          FutureBuilder<List<AcademicModel>>(
            future: _academicFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(45),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: guavaGlow,
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 42,
                        color: guavaGlow,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Informasi gagal dimuat',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: obsidianBloom,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(_refreshAcademicData);
                        },
                        child: const Text(
                          'Coba Lagi',
                          style: TextStyle(color: guavaGlow),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final items = snapshot.data ?? [];

              if (items.isEmpty) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(23),
                    border: Border.all(color: blossomVapor),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: const BoxDecoration(
                          color: blossomVapor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          size: 39,
                          color: obsidianBloom,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Belum Ada Informasi',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: obsidianBloom,
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'Yuk, tambahkan informasi akademik '
                        'pertamamu!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 17),
                      FilledButton.icon(
                        onPressed: _openAddForm,
                        style: FilledButton.styleFrom(
                          backgroundColor: guavaGlow,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Informasi'),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: blossomVapor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${items.length} informasi tersedia',
                        style: const TextStyle(
                          color: obsidianBloom,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),
                  ListView.builder(
                    itemCount: items.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(21),
                          border: Border.all(
                            color: blossomVapor,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: obsidianBloom.withValues(
                                alpha: 0.045,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(21),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => _openDetail(item),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.asset(
                                          item.image,
                                          width: 100,
                                          height: 112,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              width: 100,
                                              height: 112,
                                              color: blossomVapor,
                                              child: const Icon(
                                                Icons.menu_book_rounded,
                                                size: 40,
                                                color: obsidianBloom,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        top: 6,
                                        left: 6,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.92,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.auto_awesome_rounded,
                                            size: 13,
                                            color: guavaGlow,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 9,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: blossomVapor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            item.category,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: obsidianBloom,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 9),
                                        Text(
                                          item.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                            height: 1.3,
                                            color: obsidianBloom,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          item.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                            height: 1.45,
                                          ),
                                        ),
                                        const SizedBox(height: 9),
                                        const Row(
                                          children: [
                                            Text(
                                              'Lihat detail',
                                              style: TextStyle(
                                                color: guavaGlow,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 14,
                                              color: guavaGlow,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 25),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                obsidianBloom,
                Color(0xFF762D36),
                guavaGlow,
              ],
            ),
            borderRadius: BorderRadius.circular(27),
          ),
          child: Column(
            children: [
              Container(
                width: 118,
                height: 118,
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: blossomVapor,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile_mahasiswa.jpeg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person_rounded,
                        size: 65,
                        color: obsidianBloom,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 17),
              Text(
                widget.userName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Mahasiswa NABILA APPS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: blossomVapor,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: blossomVapor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'ACADEMIC INFORMATION',
                  style: TextStyle(
                    color: obsidianBloom,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          'Tentang Aplikasi',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: obsidianBloom,
          ),
        ),

        const SizedBox(height: 13),

        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: blossomVapor),
          ),
          child: const Row(
            children: [
              CircleAvatar(
                backgroundColor: blossomVapor,
                child: Icon(
                  Icons.school_rounded,
                  color: obsidianBloom,
                ),
              ),
              SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NABILA APPS',
                      style: TextStyle(
                        color: obsidianBloom,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Aplikasi Informasi Akademik untuk '
                      'membantu mahasiswa mengakses dan '
                      'mengelola informasi perkuliahan.',
                      style: TextStyle(
                        color: Colors.black54,
                        height: 1.5,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        SizedBox(
          height: 53,
          child: ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded),
            label: const Text(
              'Keluar dari Akun',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: obsidianBloom,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        const Center(
          child: Text(
            'Made with ♡ for your academic journey',
            style: TextStyle(
              color: obsidianBloom,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomePage(),
      _buildProfilePage(),
    ];

    return Scaffold(
      backgroundColor: softBackground,
      appBar: AppBar(
        backgroundColor: obsidianBloom,
        foregroundColor: blossomVapor,
        elevation: 0,
        title: const Row(
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              color: guavaGlow,
              size: 23,
            ),
            SizedBox(width: 9),
            Text(
              'NABILA APPS',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.7,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _openAddForm,
            tooltip: 'Tambah informasi akademik',
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: obsidianBloom.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: guavaGlow,
          unselectedItemColor: Colors.black45,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              activeIcon: Icon(Icons.dashboard_customize_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
