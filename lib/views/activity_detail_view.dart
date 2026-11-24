import 'package:flutter/material.dart';

import '../models/activity_model.dart';
import '../viewmodels/activity_viewmodel.dart';
import 'activity_form_view.dart';

const _ink = Color(0xFF103B32);
const _forest = Color(0xFF08654E);
const _muted = Color(0xFF788B83);
const _lime = Color(0xFFD8F79A);

/// VIEW 3: Detail aktivitas, perubahan counter, reset dan hapus.
class ActivityDetailView extends StatefulWidget {
  const ActivityDetailView({super.key, required this.activityId});

  final int activityId;

  @override
  State<ActivityDetailView> createState() => _ActivityDetailViewState();
}

class _ActivityDetailViewState extends State<ActivityDetailView> {
  void _showSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 1500),
      content: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: _lime, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(message)),
        ],
      ),
    ));
  }

  void _changeCounter({required bool increment}) {
    final viewModel = ActivityScope.of(context);
    final changed = increment
        ? viewModel.incrementCounter(widget.activityId)
        : viewModel.decrementCounter(widget.activityId);
    if (!changed) {
      _showSnackBar('Counter tidak boleh kurang dari 0.');
      return;
    }
    final value = viewModel.activityById(widget.activityId)!.counter;
    _showSnackBar('Counter berubah menjadi $value.');
  }

  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.restart_alt_rounded,
            size: 32, color: _forest),
        title: const Text('Reset hitungan?',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text(
          'Semua hitungan aktivitas ini akan dikembalikan menjadi 0. Lanjutkan?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Ya, reset'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    final changed = ActivityScope.of(context).resetCounter(widget.activityId);
    _showSnackBar(
      changed ? 'Counter berhasil di-reset.' : 'Counter sudah bernilai 0.',
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.delete_outline_rounded,
            size: 32, color: Color(0xFFC93636)),
        title: const Text('Hapus aktivitas?',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text(
          'Aktivitas dan seluruh hitungannya akan dihapus dari daftar.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFC93636),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Ya, hapus'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    final deleted = ActivityScope.of(context).deleteActivity(widget.activityId);
    if (deleted) {
      Navigator.of(context).pop('deleted');
    } else {
      _showSnackBar('Gagal menghapus aktivitas.');
    }
  }

  Future<void> _openEdit() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ActivityFormView(activityId: widget.activityId),
      ),
    );
    if (mounted && saved == true) {
      _showSnackBar('Nama aktivitas berhasil diperbarui.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final activity = ActivityScope.of(context).activityById(widget.activityId);
    if (activity == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Aktivitas')),
        body: const Center(child: Text('Aktivitas tidak ditemukan.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Aktivitas'),
        actions: [
          IconButton(
            tooltip: 'Edit aktivitas',
            onPressed: _openEdit,
            icon: const Icon(Icons.edit_outlined),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFEAF4E6),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ActivityHeader(activity: activity),
              const SizedBox(height: 28),
              _CounterCard(counter: activity.counter),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CounterButton(
                    buttonKey: const Key('decrement_button'),
                    icon: Icons.remove_rounded,
                    tooltip: 'Kurangi counter',
                    isPrimary: false,
                    onPressed: activity.counter > 0
                        ? () => _changeCounter(increment: false)
                        : null,
                  ),
                  const SizedBox(width: 58),
                  _CounterButton(
                    buttonKey: const Key('increment_button'),
                    icon: Icons.add_rounded,
                    tooltip: 'Tambah counter',
                    isPrimary: true,
                    onPressed: () => _changeCounter(increment: true),
                  ),
                ],
              ),
              const SizedBox(height: 27),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      buttonKey: const Key('reset_button'),
                      title: 'Reset',
                      icon: Icons.restart_alt_rounded,
                      foreground: _ink,
                      background: const Color(0xFFE8F3E2),
                      onTap: _confirmReset,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      buttonKey: const Key('delete_button'),
                      title: 'Hapus',
                      icon: Icons.delete_outline_rounded,
                      foreground: const Color(0xFFBB2B2B),
                      background: const Color(0xFFFBE8E5),
                      onTap: _confirmDelete,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityHeader extends StatelessWidget {
  const _ActivityHeader({required this.activity});
  final ActivityModel activity;

  IconData get _icon {
    final name = activity.name.toLowerCase();
    if (name.contains('run') ||
        name.contains('lari') ||
        name.contains('workout') ||
        name.contains('olahraga')) {
      return Icons.directions_run_rounded;
    }
    if (name.contains('read') ||
        name.contains('baca') ||
        name.contains('buku')) {
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
    return Icons.auto_awesome_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F5C3),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Icon(_icon, size: 49, color: _forest),
        ),
        const SizedBox(height: 18),
        Text(
          activity.name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: _ink, fontSize: 27, fontWeight: FontWeight.w900, letterSpacing: -0.7),
        ),
        const SizedBox(height: 7),
        const Text('Hitung setiap progres kecilmu.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, fontSize: 13)),
      ],
    );
  }
}

class _CounterCard extends StatelessWidget {
  const _CounterCard({required this.counter});
  final int counter;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(29),
      child: Container(
        height: 271,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF20876A), Color(0xFF07523D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: -132,
              left: -58,
              child: Container(
                height: 183,
                width: 300,
                decoration: const BoxDecoration(
                  color: Color(0x665CA979),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -125,
              right: -97,
              child: Container(
                height: 185,
                width: 278,
                decoration: const BoxDecoration(
                  color: Color(0x77B1DC94),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 41,
                  width: 41,
                  decoration: const BoxDecoration(
                    color: Color(0x3379D6A8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.adjust_rounded,
                      size: 24, color: _lime),
                ),
                const SizedBox(height: 12),
                const Text(
                  'TOTAL HITUNGAN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 104,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: FittedBox(
                      key: ValueKey<int>(counter),
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '$counter',
                        style: const TextStyle(
                          color: _lime,
                          fontSize: 96,
                          fontWeight: FontWeight.w900,
                          height: 1,
                          letterSpacing: -2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'kali dilakukan',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.buttonKey,
    required this.icon,
    required this.tooltip,
    required this.isPrimary,
    required this.onPressed,
  });

  final Key buttonKey;
  final IconData icon;
  final String tooltip;
  final bool isPrimary;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    const size = 88.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE3F4C4),
        shape: BoxShape.circle,
        boxShadow: isPrimary
            ? const [
                BoxShadow(
                  color: Color(0x4099C95C),
                  blurRadius: 19,
                  offset: Offset(0, 9),
                ),
              ]
            : null,
      ),
      child: IconButton(
        key: buttonKey,
        tooltip: tooltip,
        onPressed: onPressed,
        iconSize: 39,
        color: _forest,
        disabledColor: const Color(0xFFADC3B2),
        icon: Icon(icon),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.buttonKey,
    required this.title,
    required this.icon,
    required this.foreground,
    required this.background,
    required this.onTap,
  });

  final Key buttonKey;
  final String title;
  final IconData icon;
  final Color foreground;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        key: buttonKey,
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          constraints: const BoxConstraints(minHeight: 55),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 23, color: foreground),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
