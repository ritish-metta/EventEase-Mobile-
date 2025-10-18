import 'package:eventease/bottom_sheets/EventDetailBottomSheet.dart';
import 'package:eventease/booking_states_screen/MyBookingsScreen.dart';
import 'package:eventease/preferencesServices/PreferencesService.dart';
import 'package:eventease/services/EventDataService.dart';
import 'package:flutter/material.dart';

import '../booking_states_screen/booking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Use EventDataService instead of local data
  final EventDataService _eventService = EventDataService();
  
  List<Map<String, dynamic>> _filteredEvents = [];
  final TextEditingController _searchController = TextEditingController();
  
  // Mock bookings count
  int _bookingsCount = 3;
  
  // Store auth token
  String? _authToken;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Load events from service asynchronously
    _loadEvents();
    // Load auth token
    _loadAuthToken();
  }

  Future<void> _loadAuthToken() async {
    final token = await PreferencesService.getAuthToken();
    setState(() {
      _authToken = token;
    });
    
    if (token != null && token.isNotEmpty) {
      print('✅ HomeScreen: Auth token loaded successfully');
    } else {
      print('⚠️ HomeScreen: No auth token found');
    }
  }

  Future<void> _loadEvents() async {
    final events = await _eventService.getFeaturedEvents();
    setState(() {
      _filteredEvents = events;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Pull-to-refresh handler
  Future<void> _refreshEvents() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    if (_searchController.text.isEmpty) {
      await _loadEvents();
    } else {
      final events = await _eventService.searchEvents(_searchController.text);
      setState(() {
        _filteredEvents = events;
      });
    }
  }

  void _filterEvents(String query) async {
    if (query.isEmpty) {
      await _loadEvents();
    } else {
      final events = await _eventService.searchEvents(query);
      setState(() {
        _filteredEvents = events;
      });
    }
  }

  void _showEventDetails(Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EventDetailBottomSheet(event: event),
    ).then((result) {
      if (result == 'book') {
        _navigateToBooking(event);
      }
    });
  }

  void _navigateToBooking(Map<String, dynamic> event) {
    // Check if user is authenticated before navigating
    if (_authToken == null || _authToken!.isEmpty) {
      _showAuthError();
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(
          event: event,
          token: _authToken, // ✅ Pass the actual token
        ),
      ),
    );
  }

  void _navigateToMyBookings() {
    // Check if user is authenticated before navigating
    if (_authToken == null || _authToken!.isEmpty) {
      _showAuthError();
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyBookingsScreen(
          token: _authToken, // ✅ Pass the actual token
        ),
      ),
    );
  }

  void _showAuthError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Please login to continue'),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Login',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 66, 24, 102),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Discover events',
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
                            Icons.location_on,
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

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7546A8),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Color(0xFFD4C5E8), size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: _filterEvents,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  color: Color(0xFFD4C5E8),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                      height: 50,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B3D), Color(0xFFFF8A5C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B3D).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.tune,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // My Bookings Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GestureDetector(
                onTap: _navigateToMyBookings,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B3D), Color(0xFFFF8A5C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B3D).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.confirmation_number,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'My Bookings',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'You have $_bookingsCount active bookings',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white.withOpacity(0.8),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Content with RefreshIndicator
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshEvents,
                color: const Color(0xFFFF6B3D),
                backgroundColor: Colors.white,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 66, 24, 102),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // Featured Section
                        Padding(
                          padding: const EdgeInsets.fromLTRB(22, 24, 22, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Featured',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                'See All',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Featured Events
                        SizedBox(
                          height: 340,
                          child: _filteredEvents.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      'No events found',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.only(left: 22, right: 22),
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: _filteredEvents.length,
                                  itemBuilder: (context, index) {
                                    return _buildFeaturedCard(_filteredEvents[index]);
                                  },
                                ),
                        ),

                        const SizedBox(height: 8),

                        // Categories Section
                        Padding(
                          padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Categories',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                'See All',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Categories Row
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildCategoryItem(Icons.self_improvement, 'Ballet'),
                              _buildCategoryItem(Icons.theater_comedy, 'Comedy'),
                              _buildCategoryItem(Icons.local_activity, 'Theatre'),
                              _buildCategoryItem(Icons.music_note, 'Concert'),
                              _buildCategoryItem(Icons.sports_basketball, 'Music'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(Map<String, dynamic> event) {
    final availableSeats = event['capacity'] - event['bookedSeats'];
    
    return GestureDetector(
      onTap: () => _showEventDetails(event),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.network(
                event['image'],
                width: 200,
                height: 340,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.85),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              
              // Availability Badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: availableSeats > 100 
                        ? Colors.green.withOpacity(0.9)
                        : availableSeats > 50
                            ? Colors.orange.withOpacity(0.9)
                            : Colors.red.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$availableSeats seats',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.white70,
                                size: 12,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                event['date'],
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white70,
                                size: 12,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  event['location'],
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Book Now Button
                    GestureDetector(
                      onTap: () => _navigateToBooking(event),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B3D), Color(0xFFFF8A5C)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B3D).withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Book Now',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: const Color.fromARGB(255, 166, 96, 226),
            size: 30,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}