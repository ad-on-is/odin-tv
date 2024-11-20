import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/models/item_model.dart';
import 'package:odin/data/services/api.dart';
import 'package:odin/data/services/trakt_service.dart';

final gridSectionProvider = FutureProvider.family
    .autoDispose<List<SectionItem>, String>((ref, type) async {
  ref.watch(watchedProvider);
  final api = ref.watch(apiProvider);
  final u = await api.get('/user');

  if (u.isLeft()) {
    return [];
  }

  return List.from(
          u.getRight().fold(() => null, (r) => r)["trakt_sections"][type])
      .map((e) => SectionItem(
          title: e["title"],
          url: e["url"],
          paginate: e["paginate"] ?? false,
          big: e["big"] ?? false))
      .toList()
    ..add(SectionItem(title: 'GENRE', url: '', type: type, isGenre: true))
    ..toList();

  // var year = DateTime.now().year;
  // final sections = [
  //   SectionItem(
  //     title: 'MOST WATCHED TODAY',
  //     url: '/$type/watched/daily',
  //     big: true,
  //   ),
  //   SectionItem(
  //     title: 'POPULAR $year/${year - 1} RELEASES',
  //     url: '/$type/watched/weekly?years=$year,${year - 1}',
  //     big: true,
  //   ),
  // ];
  // if (type == 'movies') {
  //   sections.add(SectionItem(
  //     title: 'BOX OFFICE',
  //     url: '/$type/boxoffice',
  //     paginate: false,
  //   ));
  // }

  // if (type == 'shows') {
  //   sections.add(SectionItem(
  //     title: 'MOST POPULAR',
  //     url: '/$type/popular',
  //   ));
  // }

  // sections.add(SectionItem(
  //   title: 'YOUR WATCHLIST',
  //   url: '/sync/watchlist/$type/title',
  // ));

  // sections.add(
  //   SectionItem(
  //     title: 'HIGHLY ANTICIPATED',
  //     url: '/$type/anticipated',
  //   ),
  // );
  // return sections;
});
