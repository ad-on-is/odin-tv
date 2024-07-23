import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/models/item_model.dart';
import 'package:odin/data/services/api.dart';
import 'package:odin/data/services/trakt_service.dart';

final homeSectionProvider =
    FutureProvider.autoDispose<List<SectionItem>>((ref) async {
  ref.watch(watchedProvider);
  final api = ref.watch(apiProvider);
  final u = await api.get('/user');

  if (u.isLeft()) {
    return [];
  }

  return List.from(
          u.getRight().fold(() => null, (r) => r)["trakt_sections"]["home"])
      .map((e) => SectionItem(
          title: e["title"],
          url: e["url"],
          paginate: e["paginate"] ?? false,
          big: e["big"] ?? false))
      .toList();
});
