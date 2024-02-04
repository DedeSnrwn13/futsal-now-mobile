import 'package:futsal_now_mobile/pages/dashboard_views/account_view.dart';
import 'package:futsal_now_mobile/pages/dashboard_views/home_view.dart';
import 'package:futsal_now_mobile/pages/dashboard_views/my_booking_view.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static const appName = 'FutsalNow';

  static const _host = 'http://50.50.0.171:8000';

  static const baseURL = '$_host/api/auth';

  static const baseImageURL = '$_host/storage';

  static const paymentStatus = ['All', 'pending', 'success', 'failed'];

  static const orderStatus = ['All', 'processing', 'finished', 'canceled'];

  static List<Map> navMenuDashboard = [
    {
      'view': const HomeView(),
      'icon': Icons.home_filled,
      'label': 'Home',
    },
    {
      'view': const MyBookingView(),
      'icon': Icons.sports_soccer_outlined,
      'label': 'My Booking',
    },
    {
      'view': const AccountView(),
      'icon': Icons.account_circle,
      'label': 'Account',
    }
  ];

  static const homeCategories = ['All', 'Standar', 'Mini', 'Indoor', 'Outdoor', 'Rumput Sintetis'];
}
