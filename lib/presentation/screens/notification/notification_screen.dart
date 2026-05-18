import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/core/providers/notification_provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifikasi', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              context.read<NotificationProvider>().markAllRead();
            },
            child: const Text('Tandai Dibaca', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          final notifications = provider.notifications;
          
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.textHint.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text('Belum ada notifikasi', style: TextStyle(color: AppColors.textSub, fontSize: 16)),
                ],
              ),
            );
          }
          
          return ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.divider),
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return _buildNotificationItem(context, notif);
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, dynamic notif) {
    IconData iconData;
    Color iconColor;
    
    switch (notif.type) {
      case 'alert':
        iconData = Icons.warning_amber_rounded;
        iconColor = AppColors.error;
        break;
      case 'success':
        iconData = Icons.check_circle_outline_rounded;
        iconColor = AppColors.success;
        break;
      case 'promo':
        iconData = Icons.local_offer_outlined;
        iconColor = AppColors.accent;
        break;
      case 'info':
      default:
        iconData = Icons.info_outline_rounded;
        iconColor = AppColors.primary;
        break;
    }

    return InkWell(
      onTap: () {
        context.read<NotificationProvider>().markAsRead(notif.id);
        if (notif.actionRoute != null) {
          Navigator.pushNamed(context, notif.actionRoute!);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        color: notif.isRead ? AppColors.surface : AppColors.primaryBg,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif.title,
                    style: TextStyle(
                      fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.w700,
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.body,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('dd MMM yyyy, HH:mm').format(notif.createdAt),
                    style: const TextStyle(color: AppColors.textHint, fontSize: 11),
                  ),
                ],
              ),
            ),
            if (!notif.isRead)
              Container(
                width: 8, height: 8,
                margin: const EdgeInsets.only(top: 8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
