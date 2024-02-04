import 'package:futsal_now_mobile/models/ground_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sportArenaGroundStatusProvider = StateProvider.autoDispose((ref) => '');

setSportArenaGroundStatus(WidgetRef ref, String newStatus) {
  ref.read(sportArenaGroundStatusProvider.notifier).state = newStatus;
}

final groundStatusProvider = StateProvider.autoDispose((ref) => '');

setGroundStatus(WidgetRef ref, String newStatus) {
  ref.read(groundStatusProvider.notifier).state = newStatus;
}

final sportArenaGroundListProvider = StateNotifierProvider.autoDispose<SportArenaGroundList, List<GroundModel>>((ref) => SportArenaGroundList([]));

class SportArenaGroundList extends StateNotifier<List<GroundModel>> {
  SportArenaGroundList(super.state);

  setData(List<GroundModel> newData) {
    state = newData;
  }
}
