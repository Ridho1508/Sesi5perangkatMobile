import 'package:flutter/material.dart';

import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import '../widgets/event_card.dart';

/// Daftar tiket aktif. Geser ke kiri untuk membatalkan (Dismissible).
class RegisteredTicketsScreen extends StatelessWidget {
  final List<RegistrationTicket> tickets;
  final void Function(RegistrationTicket ticket) onCancel;

  const RegisteredTicketsScreen({
    super.key,
    required this.tickets,
    required this.onCancel,
  });

  Future<bool> _confirmCancel(BuildContext context, RegistrationTicket t) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded),
        title: const Text('Batalkan Tiket?'),
        content: Text(
          'Pendaftaran untuk "${t.event.title}" atas nama ${t.name} '
          'akan dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Tidak'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.confirmation_number_outlined,
                  size: 72, color: Theme.of(context).colorScheme.outline),
              const SizedBox(height: 12),
              Text(
                'Belum ada tiket',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              const Text(
                'Pilih seminar di tab pertama lalu daftar.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final t = tickets[index];
        return Dismissible(
          key: ValueKey(t.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) => _confirmCancel(context, t),
          onDismissed: (_) {
            onCancel(t);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('Tiket ${t.id} dibatalkan')),
              );
          },
          background: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            padding: const EdgeInsets.only(right: 24),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
          child: _TicketCard(ticket: t),
        );
      },
    );
  }
}

class _TicketCard extends StatelessWidget {
  final RegistrationTicket ticket;
  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final e = ticket.event;
    final color = categoryColor(e.category);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.confirmation_number, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ticket.id,
                    style: textTheme.labelLarge?.copyWith(color: color),
                  ),
                ),
                Chip(
                  label: Text(e.category),
                  visualDensity: VisualDensity.compact,
                  labelStyle: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              e.title,
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Divider(height: 20),
            _row(context, 'Nama', ticket.name),
            _row(context, 'NIM', ticket.nim),
            _row(context, 'Tipe', ticket.participantType),
            _row(context, 'Hadir', formatDate(ticket.attendanceDate)),
            _row(context, 'Seminar Kit', ticket.seminarKit ? 'Ya' : 'Tidak'),
            _row(context, 'Donasi',
                ticket.donation == 0 ? '-' : formatRupiah(ticket.donation)),
            const SizedBox(height: 8),
            Text(
              '← Geser ke kiri untuk membatalkan',
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}