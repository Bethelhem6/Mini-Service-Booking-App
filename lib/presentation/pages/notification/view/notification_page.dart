import 'package:flutter/material.dart';
import 'package:mini_service_booking_app/core/themes/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Booking Confirmed',
      'message':
          'Your cleaning service for tomorrow at 2 PM has been confirmed',
      'time': '10 min ago', // Keeping as String for display
      'timestamp': DateTime.now().subtract(
        const Duration(minutes: 10),
      ), // Adding DateTime for sorting
      'isUnread': true,
      'icon': Icons.cleaning_services,
    },
    {
      'title': 'Special Offer',
      'message': '20% off your next booking - use code CLEAN20',
      'time': '1 hour ago',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'isUnread': true,
      'icon': Icons.local_offer,
    },
    {
      'title': 'Service Reminder',
      'message': 'Your monthly maintenance is due next week',
      'time': '3 days ago',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'isUnread': false,
      'icon': Icons.calendar_today,
    },
  ];

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sort notifications by timestamp (newest first)
    // notifications.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontSize: 16)),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              // Mark all as read
            },
            child: Text(
              'Mark all as read',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // New notifications section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'New',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final notification =
                  notifications.where((n) => n['isUnread']).toList()[index];
              return NotificationItem(
                title: notification['title'],
                message: notification['message'],
                time: notification['time'], // Passing the String time
                isUnread: notification['isUnread'],
                // icon: notification['icon'],
              );
            }, childCount: notifications.where((n) => n['isUnread']).length),
          ),

          // Divider between sections
          const SliverToBoxAdapter(
            child: Divider(height: 1, thickness: 1, color: AppColors.grey300),
          ),

          // Earlier notifications section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Earlier',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,

                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final notification =
                  notifications.where((n) => !n['isUnread']).toList()[index];
              return NotificationItem(
                title: notification['title'],
                message: notification['message'],
                time: notification['time'], // Passing the String time
                isUnread: notification['isUnread'],
                // icon: notification['icon'],
              );
            }, childCount: notifications.where((n) => !n['isUnread']).length),
          ),
        ],
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String time; // Keeping as String
  final bool isUnread;
  // final IconData icon;

  const NotificationItem({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    this.isUnread = true,
    // required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle notification tap
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color:
              isUnread
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon with background
            // Container(
            //   width: 40,
            //   height: 40,
            //   decoration: BoxDecoration(
            //     color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Icon(
            //     icon,
            //     size: 20,
            //     color: Theme.of(context).colorScheme.primary,
            //   ),
            // ),
            // const SizedBox(width: 16),

            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,

                          color:
                              isUnread
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            time, // Using the String time directly
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Theme.of(context).hintColor),
                          ),
                          if (isUnread) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).hintColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
