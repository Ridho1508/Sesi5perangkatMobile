import 'event_item.dart';

/// Model tiket hasil pendaftaran peserta.
class RegistrationTicket {
  final String id;
  final EventItem event;
  final String name;
  final String nim;
  final String email;
  final String whatsapp;
  final String participantType;
  final DateTime attendanceDate;
  final bool seminarKit;
  final int donation;
  final DateTime registeredAt;

  const RegistrationTicket({
    required this.id,
    required this.event,
    required this.name,
    required this.nim,
    required this.email,
    required this.whatsapp,
    required this.participantType,
    required this.attendanceDate,
    required this.seminarKit,
    required this.donation,
    required this.registeredAt,
  });
}

/// 25000 -> "Rp 25.000"
String formatRupiah(int value) {
  final s = value.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp $buf';
}