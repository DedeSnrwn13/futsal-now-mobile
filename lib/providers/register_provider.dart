import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:d_method/d_method.dart';

final registerStatusProvider = StateProvider.autoDispose((ref) => '');

setRegisterStatus(WidgetRef ref, String newStatus) {
  DMethod.printTitle('setRegisterStatus', newStatus);
  ref.read(registerStatusProvider.notifier).state = newStatus;
}
