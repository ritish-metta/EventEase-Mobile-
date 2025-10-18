import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'The Great Stage - Reminder',
      'message': 'Your event starts in 2 days!',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'icon': Icons.event_available,
      'read': false,
    },
    {
      'id': 2,
      'title': 'Summer Music Festival - Special Offer',
      'message': 'Get 20% off on premium tickets',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'icon': Icons.local_offer,
      'read': false,
    },
    {
      'id': 3,
      'title': 'Booking Confirmed',
      'message': 'Your tickets for Jazz Night are confirmed',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.check_circle,
      'read': true,
    },
    {
      'id': 4,
      'title': 'Event Update - Ballet Performance',
      'message': 'Venue changed to Dorothy Chandler Pavilion',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'icon': Icons.info,
      'read': true,
    },
    {
      'id': 5,
      'title': 'New Events Near You',
      'message': 'Check out these 5 new concerts in Los Angeles',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'icon': Icons.explore,
      'read': true,
    },
  ];

  void _markAsRead(int id) {
    setState(() {
      final notification = _notifications.firstWhere((n) => n['id'] == id);
      notification['read'] = true;
    });
  }

  void _deleteNotification(int id) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == id);
    });
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n['read']).length;

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
                        'Notifications',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        unreadCount > 0
                            ? '$unreadCount new notification${unreadCount > 1 ? 's' : ''}'
                            : 'All caught up',
                        style: const TextStyle(
                          color: Color(0xFFB8A0D4),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
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

            // Notifications List
            Expanded(
              child: _notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none_rounded,
                            size: 60,
                            color: const Color(0xFFB8A0D4),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No notifications yet',
                            style: TextStyle(
                              color: Color(0xFFB8A0D4),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        return _buildNotificationCard(_notifications[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['read'] as bool;

    return Dismissible(
      key: Key(notification['id'].toString()),
      onDismissed: (direction) {
        _deleteNotification(notification['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification deleted')),
        );
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isRead ? const Color(0xFF2D1B4E) : const Color(0xFF3D2461),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead
                ? Colors.transparent
                : const Color(0xFFFF6B3D).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF7546A8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  notification['icon'] as IconData,
                  color: const Color(0xFFFF6B3D),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'] as String,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF6B3D),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification['message'] as String,
                      style: const TextStyle(
                        color: Color(0xFFB8A0D4),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTime(notification['timestamp'] as DateTime),
                          style: const TextStyle(
                            color: Color(0xFF8E8E93),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (!isRead)
                          GestureDetector(
                            onTap: () =>
                                _markAsRead(notification['id'] as int),
                            child: const Text(
                              'Mark as read',
                              style: TextStyle(
                                color: Color(0xFFFF6B3D),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
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
}