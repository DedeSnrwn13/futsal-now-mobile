import 'package:flutter_riverpod/flutter_riverpod.dart';

final feebackStatusProvider = StateProvider.autoDispose((ref) => '');

setfeedbackStatus(WidgetRef ref, String newStatus) {
  ref.read(feebackStatusProvider.notifier).state = newStatus;
}
