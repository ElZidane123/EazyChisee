import 'package:flutter/material.dart';
import 'package:eazychise/core/models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'Trust Score Diperbarui',
      body: 'Trust Score franchise Kopi Kenangan diperbarui: 87/100',
      type: 'info',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      actionRoute: '/trust-score-full',
    ),
    NotificationModel(
      id: '2',
      title: 'Performa Cabang Menurun',
      body: 'Cabang Malang performa di bawah target bulan ini',
      type: 'alert',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      actionRoute: '/franchisor-dashboard',
    ),
    NotificationModel(
      id: '3',
      title: 'Simulasi BEP Tersimpan',
      body: 'Simulasi BEP Anda tersimpan',
      type: 'success',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      actionRoute: '/bep-simulation',
    ),
    NotificationModel(
      id: '4',
      title: 'Verifikasi Berhasil',
      body: 'Verifikasi dokumen berhasil dikirim',
      type: 'success',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      actionRoute: '/verification-status',
    ),
    NotificationModel(
      id: '5',
      title: 'Promo Spesial',
      body: 'Promo: Biaya listing gratis hingga 31 Januari',
      type: 'promo',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  void addNotification(NotificationModel notif) {
    _notifications.insert(0, notif);
    notifyListeners();
  }
}
