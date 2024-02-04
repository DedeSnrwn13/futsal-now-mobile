import 'package:futsal_now_mobile/models/promo_model.dart';
import 'package:futsal_now_mobile/models/sport_arena_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeCategoryProvider = StateProvider.autoDispose((ref) => 'All');
final homePromoStatusProvider = StateProvider.autoDispose((ref) => '');
final homeRecommendationStatusProvider = StateProvider.autoDispose((ref) => '');

setHomeCategory(WidgetRef ref, String newCategory) {
  ref.read(homeCategoryProvider.notifier).state = newCategory;
}

setHomePromoStatus(WidgetRef ref, String newStatus) {
  ref.read(homePromoStatusProvider.notifier).state = newStatus;
}

setHomeRecommendationStatus(WidgetRef ref, String newStatus) {
  ref.read(homeRecommendationStatusProvider.notifier).state = newStatus;
}

final homePromoListProvider = StateNotifierProvider.autoDispose<HomePromoList, List<PromoModel>>((ref) => HomePromoList([]));

class HomePromoList extends StateNotifier<List<PromoModel>> {
  HomePromoList(super.state);

  setData(List<PromoModel> newData) {
    state = newData;
  }
}

final homeRecommendationListProvider =
    StateNotifierProvider.autoDispose<HomeRecommendationList, List<SportArenaModel>>((ref) => HomeRecommendationList([]));

class HomeRecommendationList extends StateNotifier<List<SportArenaModel>> {
  HomeRecommendationList(super.state);

  setData(List<SportArenaModel> newData) {
    state = newData;
  }
}
