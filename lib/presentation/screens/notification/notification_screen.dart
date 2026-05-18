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
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Notifikasi', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, letterSpacing: -0.3)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          TextButton(
            onPressed: () {
              context.read<NotificationProvider>().markAllRead();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            child: const Text('Tandai Dibaca'),
          ),
          const SizedBox(width: 8),
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
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      boxShadow: AppColors.shadowSm,
                    ),
                    child: Icon(Icons.notifications_off_rounded, size: 48, color: AppColors.textHint.withOpacity(0.5)),
                  ),
                  const SizedBox(height: 24),
                  const Text('Belum Ada Notifikasi', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
                  const SizedBox(height: 8),
                  const Text('Anda akan menerima pemberitahuan di sini', style: TextStyle(color: AppColors.textSub, fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            );
          }
          
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
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
        iconColor = AppColors.gold;
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        color: notif.isRead ? AppColors.surface : AppColors.primaryBg,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: notif.isRead ? iconColor.withOpacity(0.05) : iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(iconData, color: notif.isRead ? iconColor.withOpacity(0.7) : iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: TextStyle(
                            fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.w700,
                            color: notif.isRead ? AppColors.textPrimary : AppColors.textPrimary,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (!notif.isRead)
                        Container(
                          width: 8, height: 8,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notif.body,
                    style: TextStyle(color: notif.isRead ? AppColors.textSub : AppColors.textPrimary.withOpacity(0.8), fontSize: 13, height: 1.4, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    DateFormat('dd MMM yyyy • HH:mm').format(notif.createdAt),
                    style: const TextStyle(color: AppColors.textHint, fontSize: 11, fontWeight: FontWeight.w600),
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
