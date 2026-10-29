import '../models/event_item.dart';

const List<String> eventCategories = ['AI', 'Mobile', 'IoT', 'Cybersecurity'];

DateTime _day(int offset) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day).add(Duration(days: offset));
}

final List<EventItem> sampleEvents = [
  EventItem(
    id: 'E01',
    title: 'Generative AI untuk Developer',
    category: 'AI',
    speaker: 'Dr. Rina Kusuma',
    date: _day(7),
    time: '09:00 - 12:00',
    location: 'Aula Utama',
    description:
        'Pengenalan LLM, prompt engineering, dan integrasi API AI ke aplikasi.',
    quota: 150,
    price: 0,
  ),
  EventItem(
    id: 'E02',
    title: 'Workshop Flutter: Dari Nol ke Rilis',
    category: 'Mobile',
    speaker: 'Nugraha, M.Kom',
    date: _day(9),
    time: '13:00 - 17:00',
    location: 'Lab Komputer 2',
    description:
        'Membangun aplikasi Flutter lengkap dengan navigasi, state, dan deploy.',
    quota: 40,
    price: 50000,
  ),
  EventItem(
    id: 'E03',
    title: 'IoT Smart Home dengan ESP32',
    category: 'IoT',
    speaker: 'Budi Hartono, S.T.',
    date: _day(10),
    time: '09:00 - 15:00',
    location: 'IoT Lab',
    description: 'Praktik sensor, MQTT, dan dashboard monitoring real-time.',
    quota: 30,
    price: 75000,
  ),
  EventItem(
    id: 'E04',
    title: 'Dasar Ethical Hacking',
    category: 'Cybersecurity',
    speaker: 'Andi Pratama, CEH',
    date: _day(12),
    time: '10:00 - 14:00',
    location: 'Ruang Seminar 1',
    description:
        'Konsep penetration testing, reconnaissance, dan pengamanan aplikasi web.',
    quota: 80,
    price: 25000,
  ),
  EventItem(
    id: 'E05',
    title: 'Machine Learning untuk Pemula',
    category: 'AI',
    speaker: 'Yulhan Wahyudin, M.Kom',
    date: _day(14),
    time: '09:00 - 12:00',
    location: 'Ruang Seminar 2',
    description:
        'Pengenalan supervised learning, evaluasi model, dan studi kasus Python.',
    quota: 100,
    price: 0,
  ),
  EventItem(
    id: 'E06',
    title: 'Firebase & Flutter: Realtime App',
    category: 'Mobile',
    speaker: 'Sari Melati, S.Kom',
    date: _day(15),
    time: '13:00 - 16:00',
    location: 'Lab Komputer 1',
    description: 'Autentikasi, Firestore, dan push notification pada Flutter.',
    quota: 50,
    price: 35000,
  ),
  EventItem(
    id: 'E07',
    title: 'Keamanan Perangkat IoT',
    category: 'IoT',
    speaker: 'Dimas Aryo, M.T.',
    date: _day(17),
    time: '10:00 - 12:00',
    location: 'Aula Utama',
    description:
        'Ancaman umum pada perangkat IoT dan cara mengamankan komunikasinya.',
    quota: 120,
    price: 0,
  ),
  EventItem(
    id: 'E08',
    title: 'Digital Forensics & Incident Response',
    category: 'Cybersecurity',
    speaker: 'Laras Wulandari, CHFI',
    date: _day(19),
    time: '09:00 - 15:00',
    location: 'Ruang Seminar 1',
    description:
        'Akuisisi bukti digital, chain of custody, dan analisis insiden siber.',
    quota: 60,
    price: 60000,
  ),
];