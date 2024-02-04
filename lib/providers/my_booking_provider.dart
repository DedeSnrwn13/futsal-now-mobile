import 'package:futsal_now_mobile/models/booking_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myBookingStatusProvider = StateProvider.autoDispose((ref) => '');

setMyBookingStatus(WidgetRef ref, String newStatus) {
  ref.read(myBookingStatusProvider.notifier).state = newStatus;
}

final bookingStatusProvider = StateProvider.autoDispose((ref) => '');

setBookingStatus(WidgetRef ref, String newStatus) {
  ref.read(bookingStatusProvider.notifier).state = newStatus;
}

final myBookingCategoryProvider = StateProvider.autoDispose((ref) => 'All');

setMyBookingCategory(WidgetRef ref, String newCategory) {
  ref.read(myBookingCategoryProvider.notifier).state = newCategory;
}

final myBookingListProvider = StateNotifierProvider.autoDispose<MyBookingList, List<BookingModel>>(
  (ref) => MyBookingList([]),
);

class MyBookingList extends StateNotifier<List<BookingModel>> {
  MyBookingList(super.state);

  setData(List<BookingModel> newList) {
    state = newList;
  }
}
