import 'package:flutter/material.dart';

import '../models/event_item.dart';
import '../models/registration_ticket.dart';

/// Formulir pendaftaran. Mengembalikan [RegistrationTicket] lewat Navigator.pop.
class EventRegistrationScreen extends StatefulWidget {
  final EventItem event;

  const EventRegistrationScreen({super.key, required this.event});

  @override
  State<EventRegistrationScreen> createState() =>
      _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameC = TextEditingController();
  final _nimC = TextEditingController();
  final _emailC = TextEditingController();
  final _waC = TextEditingController();
  final _dateC = TextEditingController();

  static const _participantTypes = ['Mahasiswa', 'Dosen', 'Umum'];

  String _participantType = 'Mahasiswa';
  DateTime? _attendanceDate;
  bool _seminarKit = false;
  double _donation = 0;
  bool _agree = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameC.dispose();
    _nimC.dispose();
    _emailC.dispose();
    _waC.dispose();
    _dateC.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = widget.event.date;
    final first = DateTime(d.year, d.month, d.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _attendanceDate ?? first,
      firstDate: first,
      lastDate: first.add(const Duration(days: 2)),
      helpText: 'Pilih tanggal kehadiran',
    );
    if (picked != null) {
      setState(() {
        _attendanceDate = picked;
        _dateC.text = formatDate(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2)); // simulasi kirim data
    if (!mounted) return;

    final ticket = RegistrationTicket(
      id: 'NEH-${DateTime.now().millisecondsSinceEpoch % 1000000}',
      event: widget.event,
      name: _nameC.text.trim(),
      nim: _nimC.text.trim(),
      email: _emailC.text.trim(),
      whatsapp: _waC.text.trim(),
      participantType: _participantType,
      attendanceDate: _attendanceDate!,
      seminarKit: _seminarKit,
      donation: _donation.round(),
      registeredAt: DateTime.now(),
    );

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _loading = false);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Pendaftaran berhasil! Tiket ${ticket.id} dibuat.'),
        ),
      );
    Navigator.pop(context, ticket);
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Pendaftaran Tiket')),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: _loading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.title,
                                    style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text('${e.speaker} • ${formatDate(e.date)}'),
                                Text('${e.time} • ${e.location}'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameC,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Nama Lengkap',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            final s = v?.trim() ?? '';
                            if (s.isEmpty) return 'Nama wajib diisi';
                            if (s.length < 3) return 'Nama minimal 3 karakter';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nimC,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'NIM',
                            prefixIcon: Icon(Icons.badge),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            final s = v?.trim() ?? '';
                            if (s.isEmpty) return 'NIM wajib diisi';
                            if (!RegExp(r'^\d{8,12}$').hasMatch(s)) {
                              return 'NIM harus 8-12 digit angka';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailC,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            final s = v?.trim() ?? '';
                            if (s.isEmpty) return 'Email wajib diisi';
                            if (!RegExp(r'^[\w\.\-+]+@[\w\-]+(\.[\w\-]+)+$')
                                .hasMatch(s)) {
                              return 'Format email tidak valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _waC,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Nomor WhatsApp',
                            hintText: '08xxxxxxxxxx',
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            final s = (v ?? '').trim();
                            if (s.isEmpty) return 'Nomor WhatsApp wajib diisi';
                            if (!RegExp(r'^(08|\+628|628)\d{8,11}$')
                                .hasMatch(s)) {
                              return 'Gunakan format 08xx / +628xx (10-13 digit)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Text('Tipe Peserta', style: textTheme.titleSmall),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            for (final t in _participantTypes)
                              ChoiceChip(
                                label: Text(t),
                                selected: _participantType == t,
                                onSelected: (_) =>
                                    setState(() => _participantType = t),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _dateC,
                          readOnly: true,
                          onTap: _pickDate,
                          decoration: const InputDecoration(
                            labelText: 'Tanggal Kehadiran',
                            prefixIcon: Icon(Icons.calendar_month),
                            border: OutlineInputBorder(),
                          ),
                          validator: (_) => _attendanceDate == null
                              ? 'Pilih tanggal kehadiran'
                              : null,
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Paket Seminar Kit'),
                          subtitle: const Text('Tote bag, notebook, dan sertifikat'),
                          value: _seminarKit,
                          onChanged: (v) => setState(() => _seminarKit = v),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Donasi: ${_donation == 0 ? "Tidak ada" : formatRupiah(_donation.round())}',
                          style: textTheme.titleSmall,
                        ),
                        Slider(
                          value: _donation,
                          min: 0,
                          max: 100000,
                          divisions: 10,
                          label: formatRupiah(_donation.round()),
                          onChanged: (v) => setState(() => _donation = v),
                        ),
                        FormField<bool>(
                          initialValue: _agree,
                          validator: (_) => _agree
                              ? null
                              : 'Anda harus menyetujui tata tertib',
                          builder: (state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: const Text(
                                      'Saya menyetujui tata tertib acara'),
                                  value: _agree,
                                  onChanged: (v) {
                                    setState(() => _agree = v ?? false);
                                    state.didChange(_agree);
                                  },
                                ),
                                if (state.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text(
                                      state.errorText!,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _loading ? null : _submit,
                            icon: const Icon(Icons.how_to_reg),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text('Daftar Sekarang'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_loading)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black.withAlpha(90),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}