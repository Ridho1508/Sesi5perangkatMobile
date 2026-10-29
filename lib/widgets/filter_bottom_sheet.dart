import 'package:flutter/material.dart';

import '../data/sample_events.dart';

/// Menampilkan bottom sheet filter kategori.
/// Mengembalikan kategori terpilih ('Semua' = tanpa filter),
/// atau null jika sheet ditutup tanpa memilih.
Future<String?> showFilterBottomSheet(
  BuildContext context,
  String selected,
) {
  final options = ['Semua', ...eventCategories];

  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (ctx) {
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Kategori',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final c in options)
                    ChoiceChip(
                      label: Text(c),
                      selected: c == selected,
                      onSelected: (_) => Navigator.pop(ctx, c),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}