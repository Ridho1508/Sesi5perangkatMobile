/// Model data seminar / workshop.
class EventItem {
  final String id;
  final String title;
  final String category; // AI, Mobile, IoT, Cybersecurity
  final String speaker;
  final DateTime date;
  final String time;
  final String location;
  final String description;
  final int quota;
  final int price; // 0 = gratis

  const EventItem({
    required this.id,
    required this.title,
    required this.category,
    required this.speaker,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.quota,
    required this.price,
  });

  bool get isFree => price == 0;
}

const List<String> _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

/// Contoh output: 12 Nov 2026
String formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';