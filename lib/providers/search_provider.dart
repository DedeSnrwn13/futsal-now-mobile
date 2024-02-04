import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futsal_now_mobile/models/sport_arena_model.dart';

final searchStatusProvider = StateProvider.autoDispose((ref) => '');

setSearchStatus(WidgetRef ref, String newStatus) {
  ref.read(searchStatusProvider.notifier).state = newStatus;
}

final searchListProvider = StateNotifierProvider.autoDispose<SearchList, List<SportArenaModel>>(
  (ref) => SearchList([]),
);

class SearchList extends StateNotifier<List<SportArenaModel>> {
  SearchList(super.state);

  setData(newList) {
    state = newList;
  }
}
