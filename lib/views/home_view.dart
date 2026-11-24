import 'package:flutter/material.dart';

import '../models/activity_model.dart';
import '../viewmodels/activity_viewmodel.dart';
import 'activity_detail_view.dart';
import 'activity_form_view.dart';

const _ink = Color(0xFF103B32);
const _forest = Color(0xFF08654E);
const _muted = Color(0xFF788B83);
const _lime = Color(0xFFD8F79A);
const _line = Color(0xFFE3EBE4);

/// VIEW 1: Dashboard, pencarian, daftar aktivitas, tambah dan edit.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openForm({int? activityId}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ActivityFormView(activityId: activityId),
      ),
    );
    if (!mounted || saved != true) return;
    _showSnackBar(activityId == null
        ? 'Aktivitas berhasil ditambahkan.'
        : 'Nama aktivitas berhasil diperbarui.');
  }

  Future<void> _openDetail(int activityId) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => ActivityDetailView(activityId: activityId),
      ),
    );
    if (mounted && result == 'deleted') {
      _showSnackBar('Aktivitas berhasil dihapus.');
    }
  }

  void _showSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: _lime, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(message)),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ActivityScope.of(context);
    final activities = viewModel.activities;
    final filtered = activities
        .where((activity) =>
            activity.name.toLowerCase().contains(_query.trim().toLowerCase()))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 104),
          children: [
            const _BrandHeader(),
            const SizedBox(height: 24),
            const _WelcomeSection(),
            const SizedBox(height: 24),
            _CombinedStats(
              totalActivities: activities.length,
              totalCounter: viewModel.totalCounter,
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Aktivitasmu',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.75,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF4DF),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    '${activities.length} aktivitas',
                    style: const TextStyle(
                      color: _ink,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            TextField(
              key: const Key('search_activity_input'),
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Cari aktivitas...',
                prefixIcon: const Icon(Icons.search_rounded, color: _muted),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        tooltip: 'Bersihkan pencarian',
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.close_rounded, size: 19),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 13),
            if (activities.isEmpty)
              _EmptyState(
                icon: Icons.playlist_add_rounded,
                title: 'Belum ada aktivitas',
                subtitle: 'Yuk buat aktivitas pertamamu.',
                actionLabel: 'Tambah aktivitas',
                onAction: () => _openForm(),
              )
            else if (filtered.isEmpty)
              _EmptyState(
                icon: Icons.search_off_rounded,
                title: 'Tidak ada hasil',
                subtitle: 'Coba kata kunci aktivitas yang lain.',
                actionLabel: 'Hapus pencarian',
                onAction: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
              )
            else
              ...filtered.map((activity) => Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: _ActivityTile(
                      activity: activity,
                      onTap: () => _openDetail(activity.id),
                      onEdit: () => _openForm(activityId: activity.id),
                    ),
                  )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('add_activity_button'),
        tooltip: 'Tambah aktivitas',
        onPressed: () => _openForm(),
        elevation: 6,
        backgroundColor: _forest,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 31),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 49,
          height: 49,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF18795B), Color(0xFF073E35)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x210A5845),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(Icons.all_inclusive_rounded, color: _lime, size: 28),
        ),
        const SizedBox(width: 13),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ritme',
                style: TextStyle(
                  color: _ink,
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                  height: 1,
                  letterSpacing: -0.8,
                ),
              ),
              SizedBox(height: 4),
              Text('Activity Counter',
                  style: TextStyle(color: _muted, fontSize: 12.5)),
            ],
          ),
        ),
        Container(
          height: 43,
          width: 43,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: _line),
          ),
          child: const Icon(Icons.notifications_none_rounded,
              size: 22, color: _forest),
        ),
      ],
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 19, 12, 19),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFF7FAF5), Color(0xFFF0F8E5)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -107,
              bottom: -96,
              child: Container(
                width: 240,
                height: 240,
                decoration: const BoxDecoration(
                  color: Color(0x3ED0EDBA),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: -135,
              bottom: -114,
              child: Container(
                width: 205,
                height: 205,
                decoration: const BoxDecoration(
                  color: Color(0x5EB2DF9F),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang,',
                  style: TextStyle(color: _muted, fontSize: 15),
                ),
                SizedBox(height: 6),
                Text(
                  'Aktivitas hari ini',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                    height: 1.13,
                    letterSpacing: -0.8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Panel statistik gabungan seperti desain mockup.
class _CombinedStats extends StatelessWidget {
  const _CombinedStats({
    required this.totalActivities,
    required this.totalCounter,
  });

  final int totalActivities;
  final int totalCounter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 157,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF237B62), Color(0xFF064B39)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(color: Color(0x1D135641), blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatMetric(
              icon: Icons.layers_outlined,
              label: 'Total Aktivitas',
              value: '$totalActivities',
            ),
          ),
          Container(width: 1, height: 85, color: const Color(0x80FFFFFF)),
          const SizedBox(width: 24),
          Expanded(
            child: _StatMetric(
              icon: Icons.bar_chart_rounded,
              label: 'Total Hitungan',
              value: '$totalCounter',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatMetric extends StatelessWidget {
  const _StatMetric({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 23),
        const SizedBox(height: 9),
        Text(label,
          maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(value, maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1)),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.activity,
    required this.onTap,
    required this.onEdit,
  });

  final ActivityModel activity;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  IconData get _icon {
    final name = activity.name.toLowerCase();
    if (name.contains('run') ||
        name.contains('lari') ||
        name.contains('olahraga') ||
        name.contains('workout')) {
      return Icons.directions_run_rounded;
    }
    if (name.contains('read') ||
        name.contains('buku') ||
        name.contains('baca')) {
      return Icons.menu_book_rounded;
    }
    if (name.contains('water') ||
        name.contains('air') ||
        name.contains('minum')) {
      return Icons.water_drop_outlined;
    }
    if (name.contains('study') ||
        name.contains('belajar') ||
        name.contains('tugas')) {
      return Icons.school_outlined;
    }
    return Icons.check_circle_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final name = activity.name.toLowerCase();
    final isWater = name.contains('water') || name.contains('air');
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(19),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C153E30),
            blurRadius: 13,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(19),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 9, 7, 9),
            child: Row(
              children: [
                Container(
                  height: 47,
                  width: 47,
                  decoration: BoxDecoration(
                    color: isWater
                        ? const Color(0xFFDDF4F7)
                        : const Color(0xFFE0F6C1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    _icon,
                    color: isWater ? const Color(0xFF168398) : _forest,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: _ink,
                          fontWeight: FontWeight.w900,
                          fontSize: 13.7,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Lihat detail aktivitas',
                        style: TextStyle(color: _muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF7E4),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    '${activity.counter}×',
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Edit ${activity.name}',
                  onPressed: onEdit,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.edit_outlined,
                      color: _muted, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFFE6F4D9),
            child: Icon(icon, size: 29, color: _forest),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _ink,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted, fontSize: 12),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
            label: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}
