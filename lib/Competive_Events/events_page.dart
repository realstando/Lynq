import 'package:coding_prog/Competive_Events/event_filterchip.dart';
import 'package:flutter/material.dart';
import 'package:coding_prog/Competive_Events/events.dart';
import 'package:coding_prog/Competive_Events/events_format.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';
import 'package:coding_prog/NavigationBar/custom_appbar.dart';
import 'package:coding_prog/Competive_Events/events_list.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key, required this.onNavigate});
  final void Function(int) onNavigate;

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  EventCategory? _selectedCategory;

  // FBLA Enhanced Colors - Better visibility and contrast
  static const fblaNavyDark = Color(0xFF0A2E7F);
  static const fblaNavyLight = Color(0xFF2E5B9E);
  static const fblaGold = Color(0xFFF4AB19); // Original yellow-gold

  Color _getThemeColor(int shade) {
    if (_selectedCategory == EventCategory.objective) {
      return fblaNavyDark.withValues(alpha: shade / 400);
    } else if (_selectedCategory == EventCategory.roleplay) {
      return fblaGold.withValues(alpha: shade / 400);
    } else if (_selectedCategory == EventCategory.presentation) {
      return fblaNavyLight.withValues(alpha: shade / 400);
    }
    // Default when no category selected
    return Colors.grey[shade]!;
  }

  Color _getBackgroundColor() {
    if (_selectedCategory == EventCategory.objective) {
      return Color(0xFFE3EBF7); // Cool blue-grey tint
    } else if (_selectedCategory == EventCategory.roleplay) {
      return Color(0xFFFFF4E6); // Warmer peachy cream
    } else if (_selectedCategory == EventCategory.presentation) {
      return Color(0xFFEDF4FD); // Sky blue tint
    }
    return const Color(0xFFF8F9FA);
  }

  Color _getHeaderColor() {
    if (_selectedCategory == EventCategory.objective) {
      return fblaNavyDark;
    } else if (_selectedCategory == EventCategory.roleplay) {
      return fblaGold;
    } else if (_selectedCategory == EventCategory.presentation) {
      return fblaNavyLight;
    }
    return fblaNavyDark;
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = EventsList.allEvents.where((event) {
      final matchesSearch = event.title.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesCategory =
          _selectedCategory == null || event.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      key: _scaffoldKey,
      drawer: DrawerPage(
        icon: Icons.menu_book_rounded,
        name: 'Competitive Events',
        color: fblaNavyDark,
        onNavigate: widget.onNavigate,
      ),
      appBar: CustomAppBar(
        onNavigate: widget.onNavigate,
        name: 'Competitive Events',
        color: _getThemeColor(300),
        scaffoldKey: _scaffoldKey,
      ),
      body: Column(
        children: [
          // Header
          Container(
            color: _getHeaderColor(),
            child: Column(
              children: [
                // Title and subtitle
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search for Events',
                        style: TextStyle(
                          color: _selectedCategory == EventCategory.roleplay
                              ? Colors.black
                              : Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Explore 73 FBLA events to showcase your skills',
                        style: TextStyle(
                          color: _selectedCategory == EventCategory.roleplay
                              ? Colors.black.withOpacity(0.7)
                              : Colors.white.withOpacity(0.85),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search events...",
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: _selectedCategory == null
                              ? Color(0xFF2E5B9E)
                              : _selectedCategory == EventCategory.objective
                              ? Color(0xFF0A2E7F)
                              : _selectedCategory == EventCategory.roleplay
                              ? Color(0xFFF4AB19)
                              : Color(0xFF4A7BC8),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: 20,
                                  color: _selectedCategory == null
                                      ? Color(0xFF2E5B9E)
                                      : _selectedCategory ==
                                            EventCategory.objective
                                      ? Color(0xFF0A2E7F)
                                      : _selectedCategory ==
                                            EventCategory.roleplay
                                      ? Color(0xFFF4AB19)
                                      : Color(0xFF4A7BC8),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ),

                // Category Filter Chips with counts
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      CustomFilterChip(
                        label: 'All Events',
                        count: 73,
                        isSelected: _selectedCategory == null,
                        color: Color(0xFF5A6C7D),
                        icon: Icons.apps,
                        onTap: () {
                          setState(() {
                            _selectedCategory = null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      CustomFilterChip(
                        label: 'OBJECTIVE',
                        count: 31,
                        isSelected:
                            _selectedCategory == EventCategory.objective,
                        color: Color(0xFF0A2E7F),
                        icon: Icons.quiz_outlined,
                        onTap: () {
                          setState(() {
                            _selectedCategory =
                                _selectedCategory == EventCategory.objective
                                ? null
                                : EventCategory.objective;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      CustomFilterChip(
                        label: 'ROLEPLAY',
                        count: 12,
                        isSelected: _selectedCategory == EventCategory.roleplay,
                        color: Color(0xFFD4921F),
                        icon: Icons.groups_outlined,
                        onTap: () {
                          setState(() {
                            _selectedCategory =
                                _selectedCategory == EventCategory.roleplay
                                ? null
                                : EventCategory.roleplay;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      CustomFilterChip(
                        label: 'PRESENTATION',
                        count: 31,
                        isSelected:
                            _selectedCategory == EventCategory.presentation,
                        color: Color(0xFF4A7BC8),
                        icon: Icons.present_to_all_outlined,
                        onTap: () {
                          setState(() {
                            _selectedCategory =
                                _selectedCategory == EventCategory.presentation
                                ? null
                                : EventCategory.presentation;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${filteredEvents.length} event${filteredEvents.length != 1 ? 's' : ''} found',
                  style: TextStyle(
                    color: _selectedCategory == null
                        ? Color(0xFF0B1F3F)
                        : _selectedCategory == EventCategory.objective
                        ? Color(0xFF1A3A6B)
                        : _selectedCategory == EventCategory.roleplay
                        ? Color(0xFFB87A15)
                        : Color(0xFF2E5B9E),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Events List
          Expanded(
            child: filteredEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: _selectedCategory == null
                              ? Colors.grey[400]
                              : _selectedCategory == EventCategory.objective
                              ? Color(0xFF0B1F3F).withOpacity(0.4)
                              : _selectedCategory == EventCategory.roleplay
                              ? Color(0xFFD4921F).withOpacity(0.4)
                              : Color(0xFF4A7BC8).withOpacity(0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No events found',
                          style: TextStyle(
                            fontSize: 18,
                            color: _selectedCategory == null
                                ? Colors.grey[700]
                                : _selectedCategory == EventCategory.objective
                                ? Color(0xFF0B1F3F)
                                : _selectedCategory == EventCategory.roleplay
                                ? Color(0xFFB87A15)
                                : Color(0xFF2E5B9E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      return EventsFormat(event: filteredEvents[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
