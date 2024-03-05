import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odin/data/models/auth_model.dart';
import 'package:odin/data/models/item_model.dart';
import 'package:odin/data/services/api.dart';
import 'package:odin/data/services/trakt_service.dart';

final homeSectionProvider = FutureProvider<List<SectionItem>>((ref) async {
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

  // sections = [
  //   SectionItem(
  //     title: 'TRENDING MOVIES',
  //     url: '/movies/trending',
  //     big: true,
  //   ),
  //   SectionItem(
  //     title: 'TRENDING SHOWS',
  //     url: '/shows/trending',
  //     big: true,
  //   ),
  // ];

  // var today = DateTime.now().subtract(const Duration(days: 31));
  // var tomorrow = DateTime.now().add(const Duration(days: 1));

  // sections.add(SectionItem(
  //     big: true,
  //     title: 'YOUR TODAYS EPISODES',
  //     filterWatched: true,
  //     paginate: false,
  //     isTodayTomorrowEpisodes: true,
  //     url:
  //         '/calendars/my/shows/${today.year}-${today.month}-${today.day}/32?limit=100'));

  // sections.add(SectionItem(
  //     big: true,
  //     isTodayTomorrowEpisodes: true,
  //     title: 'YOUR TOMORROWS EPISODES',
  //     paginate: false,
  //     url:
  //         '/calendars/my/shows/${tomorrow.year}-${tomorrow.month}-${tomorrow.day}/1'));
});

final homeSectionProviderx =
    StateProvider.autoDispose<List<SectionItem>>((ref) {
  // await Future.delayed(const Duration(seconds: 1));
  ref.watch(authProvider);
  ref.watch(watchedProvider);

  List<SectionItem> sections = [
    SectionItem(
      title: 'TRENDING MOVIES',
      url: '/movies/trending',
      big: true,
    ),
    SectionItem(
      title: 'TRENDING SHOWS',
      url: '/shows/trending',
      big: true,
    ),
  ];

  var today = DateTime.now().subtract(const Duration(days: 31));
  var tomorrow = DateTime.now().add(const Duration(days: 1));

  sections.add(SectionItem(
      big: true,
      title: 'YOUR TODAYS EPISODES',
      filterWatched: true,
      paginate: false,
      isTodayTomorrowEpisodes: true,
      url:
          '/calendars/my/shows/${today.year}-${today.month}-${today.day}/32?limit=100'));

  sections.add(SectionItem(
      big: true,
      isTodayTomorrowEpisodes: true,
      title: 'YOUR TOMORROWS EPISODES',
      paginate: false,
      url:
          '/calendars/my/shows/${tomorrow.year}-${tomorrow.month}-${tomorrow.day}/1'));

  return sections;
});
