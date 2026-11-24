import 'package:flutter/material.dart';
import '../viewmodels/activity_viewmodel.dart';

const _ink = Color(0xFF103B32);
const _forest = Color(0xFF08654E);
const _muted = Color(0xFF788B83);
const _lime = Color(0xFFD8F79A);
const _line = Color(0xFFE3EBE4);

/// VIEW 2: Form untuk menambah atau mengedit nama aktivitas.
class ActivityFormView extends StatefulWidget {
  const ActivityFormView({super.key, this.activityId});

  /// Null: tambah aktivitas. Tidak null: edit aktivitas.
  final int? activityId;

  @override
  State<ActivityFormView> createState() => _ActivityFormViewState();
}

class _ActivityFormViewState extends State<ActivityFormView> {
  final TextEditingController _nameController = TextEditingController();
  bool _initialNameLoaded = false;
  String? _errorText;

  bool get _isEditMode => widget.activityId != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialNameLoaded) return;
    _initialNameLoaded = true;
    if (_isEditMode) {
      final activity = ActivityScope.of(context).activityById(widget.activityId!);
      if (activity != null) _nameController.text = activity.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveActivity() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorText = 'Nama aktivitas tidak boleh kosong.');
      return;
    }

    final viewModel = ActivityScope.of(context);
    final saved = _isEditMode
        ? viewModel.renameActivity(widget.activityId!, name)
        : viewModel.addActivity(name);

    if (saved) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _errorText = 'Gagal menyimpan aktivitas.');
    }
  }

  void _chooseSuggestion(String suggestion) {
    _nameController.value = TextEditingValue(
      text: suggestion,
      selection: TextSelection.collapsed(offset: suggestion.length),
    );
    setState(() => _errorText = null);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _isEditMode;
    final suggestions = <String>['Running', 'Reading', 'Study'];

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Aktivitas' : 'Tambah Aktivitas'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(23, 25, 23, 25),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 110,
                child: Stack(
                  children: [
                    Positioned(
                      left: 30,
                      top: 0,
                      child: Container(
                        width: 85,
                        height: 85,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFECF4E6),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 20,
                      child: Container(
                        height: 84,
                        width: 84,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFE7FDB7), Color(0xFFCBF17C)],
                          ),
                          borderRadius: BorderRadius.circular(29),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x2B9CBE59),
                              blurRadius: 17,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          isEdit ? Icons.edit_rounded : Icons.add_rounded,
                          color: _ink,
                          size: 45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 17),
              Center(
                child: Text(
                isEdit ? 'Edit nama aktivitas' : 'Buat aktivitas baru',
                style: const TextStyle(
                  color: _ink,
                  fontSize: 29,
                  fontWeight: FontWeight.w900,
                  height: 1.14,
                  letterSpacing: -0.9,
                ),
                textAlign: TextAlign.center,
              )),
              const SizedBox(height: 11),
              Center(
                child: Text(
                  isEdit
                    ? 'Ganti nama aktivitas tanpa mengubah hitungan yang sudah tercatat.'
                    : 'Tambahkan aktivitas yang ingin kamu hitung secara rutin.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: _muted, fontSize: 14, height: 1.55),
                ),
              ),
              const SizedBox(height: 27),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 23),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: _line),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D194E3E),
                      blurRadius: 22,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nama Aktivitas',
                      style: TextStyle(
                        color: _ink,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      key: const Key('activity_name_input'),
                      controller: _nameController,
                      maxLength: 60,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _saveActivity(),
                      onChanged: (_) => setState(() => _errorText = null),
                      decoration: InputDecoration(
                        hintText: 'Contoh: Morning Run',
                        prefixIcon: const Icon(Icons.edit_outlined,
                            color: _forest, size: 21),
                        suffixText: '${_nameController.text.length}/60',
                        suffixStyle: const TextStyle(
                          color: _muted,
                          fontSize: 11,
                        ),
                        counterText: '',
                        errorText: _errorText,
                        fillColor: const Color(0xFFFAFCF8),
                      ),
                    ),
                    if (!isEdit) ...[
                      const SizedBox(height: 28),
                      const Text(
                        'Saran Aktivitas',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 13),
                      Row(
                        children: suggestions.map((name) {
                          final selected = _nameController.text.trim() == name;
                          final icon = name == 'Running'
                              ? Icons.directions_run_rounded
                              : name == 'Reading'
                                  ? Icons.menu_book_outlined
                                  : Icons.school_outlined;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: name == 'Study' ? 0 : 8),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(17),
                                onTap: () => _chooseSuggestion(name),
                                child: Container(
                                  height: 94,
                                  decoration: BoxDecoration(
                                    color: selected ? const Color(0xFFE7F8CE) : const Color(0xFFFAFBF8),
                                    borderRadius: BorderRadius.circular(17),
                                    border: Border.all(
                                      color: selected ? _forest : _line,
                                      width: selected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(icon, color: _forest, size: 26),
                                      const SizedBox(height: 9),
                                      Text(name, style: const TextStyle(color: _ink, fontSize: 11.5, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 17, color: _muted),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Nama aktivitas wajib diisi, maksimal 60 karakter.',
                      style: TextStyle(color: _muted, fontSize: 11.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 18),
          child: SizedBox(
            height: 57,
            child: ElevatedButton(
              key: const Key('save_activity_button'),
              onPressed: _saveActivity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      isEdit ? 'Simpan Perubahan' : 'Simpan Aktivitas',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Icon(Icons.save_outlined, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
