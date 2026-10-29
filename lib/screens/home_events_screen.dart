import 'package:flutter/material.dart';

import '../data/sample_events.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import '../widgets/event_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/venue_map_viewer.dart';
import 'event_registration_screen.dart';
import '../screens/registered_tickets_screen.dart';

class HomeEventsScreen extends StatefulWidget {
  const HomeEventsScreen({super.key});

  @override
  State<HomeEventsScreen> createState() => _HomeEventsScreenState();
}

class _HomeEventsScreenState extends State<HomeEventsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  String _selectedCategory = 'Semua';
  final List<RegistrationTicket> _tickets = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<EventItem> get _filteredEvents => _selectedCategory == 'Semua'
      ? sampleEvents
      : sampleEvents.where((e) => e.category == _selectedCategory).toList();

  Future<void> _openRegistration(EventItem event) async {
    final ticket = await Navigator.push<RegistrationTicket>(
      context,
      MaterialPageRoute(
        builder: (_) => EventRegistrationScreen(event: event),
      ),
    );
    if (ticket != null && mounted) {
      setState(() => _tickets.add(ticket));
      _tabController.animateTo(2);
    }
  }

  Future<void> _openFilter() async {
    final result = await showFilterBottomSheet(context, _selectedCategory);
    if (result != null) setState(() => _selectedCategory = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaEvent Hub'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            const Tab(icon: Icon(Icons.mic), text: 'Seminar & Workshop'),
            const Tab(icon: Icon(Icons.photo_library), text: 'Galeri & Denah'),
            Tab(
              icon: const Icon(Icons.confirmation_number),
              text: 'Tiket (${_tickets.length})',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSeminarTab(),
          _buildGalleryTab(),
          RegisteredTicketsScreen(
            tickets: _tickets,
            onCancel: (t) => setState(() => _tickets.remove(t)),
          ),
        ],
      ),
    );
  }

  // ---------------- Tab 1: Seminar & Workshop ----------------
  Widget _buildSeminarTab() {
    final events = _filteredEvents;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    const Text('Kategori:'),
                    Chip(
                      label: Text(_selectedCategory),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: _openFilter,
                icon: const Icon(Icons.filter_list),
                label: const Text('Filter'),
              ),
            ],
          ),
        ),
        Expanded(
          child: events.isEmpty
              ? const Center(child: Text('Tidak ada seminar untuk kategori ini'))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return EventCard(
                      event: event,
                      onTap: () => _openRegistration(event),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ---------------- Tab 2: Galeri & Denah Venue ----------------
  Widget _buildGalleryTab() {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text('Galeri Poster', style: textTheme.titleLarge),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sampleEvents.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final event = sampleEvents[index];
            return _PosterTile(
              event: event,
              onTap: () => _openRegistration(event),
            );
          },
        ),
        const SizedBox(height: 20),
        Text('Denah Venue', style: textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(
          clipBehavior: Clip.antiAlias,
          child: const SizedBox(height: 340, child: VenueMapViewer()),
        ),
      ],
    );
  }
}

class _PosterTile extends StatelessWidget {
  final EventItem event;
  final VoidCallback onTap;

  const _PosterTile({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(event.category);

    return Material(
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withAlpha(150)],
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(categoryIcon(event.category),
                    size: 40, color: Colors.white),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDate(event.date),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}