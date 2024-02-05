import 'package:futsal_now_mobile/models/ground_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futsal_now_mobile/models/ground_review_model.dart';

final sportArenaGroundStatusProvider = StateProvider.autoDispose((ref) => '');

setSportArenaGroundStatus(WidgetRef ref, String newStatus) {
  ref.read(sportArenaGroundStatusProvider.notifier).state = newStatus;
}

final groundStatusProvider = StateProvider.autoDispose((ref) => '');

setGroundStatus(WidgetRef ref, String newStatus) {
  ref.read(groundStatusProvider.notifier).state = newStatus;
}

final groundReviewStatusProvider = StateProvider.autoDispose((ref) => '');

setGroundSReviewtatus(WidgetRef ref, String newStatus) {
  ref.read(groundReviewStatusProvider.notifier).state = newStatus;
}

final submitReviewStatusProvider = StateProvider.autoDispose((ref) => '');

setSubmitReviewtatus(WidgetRef ref, String newStatus) {
  ref.read(submitReviewStatusProvider.notifier).state = newStatus;
}

final sportArenaGroundListProvider = StateNotifierProvider.autoDispose<SportArenaGroundList, List<GroundModel>>((ref) => SportArenaGroundList([]));

class SportArenaGroundList extends StateNotifier<List<GroundModel>> {
  SportArenaGroundList(super.state);

  setData(List<GroundModel> newData) {
    state = newData;
  }
}

final groundReviewListProvider = StateNotifierProvider.autoDispose<GroundReviewList, List<GroundReviewModel>>((ref) => GroundReviewList([]));

class GroundReviewList extends StateNotifier<List<GroundReviewModel>> {
  GroundReviewList(super.state);

  setData(List<GroundReviewModel> newData) {
    state = newData;
  }
}
