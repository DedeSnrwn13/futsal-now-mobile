import 'package:futsal_now_mobile/pages/dashboard_views/account_view.dart';
import 'package:futsal_now_mobile/pages/dashboard_views/home_view.dart';
import 'package:futsal_now_mobile/pages/dashboard_views/my_booking_view.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static const appName = 'FutsalNow';

  static const _host = 'http://127.0.0.1:8000';

  static const baseURL = '$_host/api/auth';

  static const baseImageURL = '$_host/storage';

  static const paymentStatus = ['Pending', 'Success', 'Failed'];

  static const orderStatus = ['Processing', 'Finished', 'Canceled'];

  static List<Map> navMenuDashboard = [
    {
      'view': const HomeView(),
      'icon': Icons.home_filled,
      'label': 'Home',
    },
    {
      'view': const MyBookingView(),
      'icon': Icons.sports_soccer_outlined,
      'label': 'My Laundry',
    },
    {
      'view': const AccountView(),
      'icon': Icons.account_circle,
      'label': 'Account',
    }
  ];

  static const homeCategories = ['All', 'Standar', 'Mini', 'Indoor', 'Outdoor', 'Rumput Sintetis'];
}
