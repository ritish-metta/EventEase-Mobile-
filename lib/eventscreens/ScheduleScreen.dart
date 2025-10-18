import 'package:eventease/bottom_sheets/EventDetailBottomSheet.dart';
import 'package:eventease/services/EventDataService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Use EventDataService instead of local data
  final EventDataService _eventService = EventDataService();

  late List<Map<String, dynamic>> _upcomingEvents;
  late List<Map<String, dynamic>> _ongoingEvents;
  late List<Map<String, dynamic>> _completedEvents;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _upcomingEvents = [];
    _ongoingEvents = [];
    _completedEvents = [];
    _categorizeEvents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _categorizeEvents() async {
    final now = DateTime.now();
    
    // Get all events from the service asynchronously
    final allEvents = await _eventService.getAllEvents();

    final upcoming = <Map<String, dynamic>>[];
    final ongoing = <Map<String, dynamic>>[];
    final completed = <Map<String, dynamic>>[];

    for (var event in allEvents) {
      final startDate = event['startDate'] as DateTime;
      final endDate = event['endDate'] as DateTime;

      if (endDate.isBefore(now)) {
        completed.add(event);
      } else if (startDate.isBefore(now) && endDate.isAfter(now)) {
        ongoing.add(event);
      } else {
        upcoming.add(event);
      }
    }

    upcoming.sort((a, b) =>
        (a['startDate'] as DateTime).compareTo(b['startDate'] as DateTime));

    setState(() {
      _upcomingEvents = upcoming;
      _ongoingEvents = ongoing;
      _completedEvents = completed;
    });
  }

  String _getEventStatus(DateTime startDate, DateTime endDate) {
    final now = DateTime.now();
    if (endDate.isBefore(now)) {
      return 'Completed';
    } else if (startDate.isBefore(now) && endDate.isAfter(now)) {
      return 'Ongoing';
    } else {
      return 'Upcoming';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Upcoming':
        return const Color(0xFFFF6B3D);
      case 'Ongoing':
        return const Color(0xFF4CAF50);
      case 'Completed':
        return const Color(0xFF8E8E93);
      default:
        return const Color(0xFFB8A0D4);
    }
  }

  void _showEventDetails(Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EventDetailBottomSheet(event: event),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 66, 24, 102),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Schedule',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: const [
                          Icon(
                            Icons.calendar_today,
                            color: Color(0xFFB8A0D4),
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Los Angeles, USA',
                            style: TextStyle(
                              color: Color(0xFFB8A0D4),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=47',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF7546A8),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFFFF6B3D),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFFD4C5E8),
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: [
                  Tab(text: 'Upcoming (${_upcomingEvents.length})'),
                  Tab(text: 'Ongoing (${_ongoingEvents.length})'),
                  Tab(text: 'Completed (${_completedEvents.length})'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEventsList(_upcomingEvents, 'Upcoming'),
                  _buildEventsList(_ongoingEvents, 'Ongoing'),
                  _buildEventsList(_completedEvents, 'Completed'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList(List<Map<String, dynamic>> events, String status) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              status == 'Completed'
                  ? Icons.check_circle_outline
                  : status == 'Ongoing'
                      ? Icons.event_available
                      : Icons.event_note,
              size: 60,
              color: const Color(0xFFB8A0D4),
            ),
            const SizedBox(height: 16),
            Text(
              'No $status events',
              style: const TextStyle(
                color: Color(0xFFB8A0D4),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _buildEventCard(events[index], status);
      },
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event, String status) {
    final startDate = event['startDate'] as DateTime;
    final endDate = event['endDate'] as DateTime;
    final dateRange = _formatDateRange(startDate, endDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: const Color(0xFF2D1B4E),
          child: Row(
            children: [
              // Event Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Image.network(
                  event['image'] as String,
                  width: 120,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              // Event Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              event['title'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getStatusColor(status),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: _getStatusColor(status),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Color(0xFFB8A0D4),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            dateRange,
                            style: const TextStyle(
                              color: Color(0xFFB8A0D4),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Color(0xFFB8A0D4),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              event['location'] as String,
                              style: const TextStyle(
                                color: Color(0xFFB8A0D4),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${(event['price'] as double).toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Color(0xFFFF6B3D),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showEventDetails(event),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF6B3D),
                                    Color(0xFFFF8A5C)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'View Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateRange(DateTime startDate, DateTime endDate) {
    final formatter = DateFormat('MMM dd');
    if (startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day) {
      return formatter.format(startDate);
    }
    return '${formatter.format(startDate)} - ${formatter.format(endDate)}';
  }
}