import 'package:flutter/material.dart';

import '../models/event_item.dart';

Color categoryColor(String category) {
  switch (category) {
    case 'AI':
      return Colors.deepPurple;
    case 'Mobile':
      return Colors.teal;
    case 'IoT':
      return Colors.orange.shade800;
    case 'Cybersecurity':
      return Colors.red.shade700;
    default:
      return Colors.indigo;
  }
}

IconData categoryIcon(String category) {
  switch (category) {
    case 'AI':
      return Icons.psychology;
    case 'Mobile':
      return Icons.phone_android;
    case 'IoT':
      return Icons.sensors;
    case 'Cybersecurity':
      return Icons.security;
    default:
      return Icons.event;
  }
}

/// Kartu seminar interaktif memakai InkWell.
class EventCard extends StatelessWidget {
  final EventItem event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(event.category);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color.withAlpha(30),
                child: Icon(categoryIcon(event.category), color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.speaker,
                      style: textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _Meta(Icons.calendar_today, formatDate(event.date)),
                        _Meta(Icons.schedule, event.time),
                        _Meta(Icons.place, event.location),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Chip(
                          label: Text(event.category),
                          visualDensity: VisualDensity.compact,
                          side: BorderSide(color: color),
                          labelStyle: TextStyle(color: color, fontSize: 12),
                        ),
                        Chip(
                          label: Text(event.isFree
                              ? 'Gratis'
                              : 'Rp ${event.price}'),
                          visualDensity: VisualDensity.compact,
                          labelStyle: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Meta(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}