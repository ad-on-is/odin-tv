import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpers/helpers/print.dart';
import 'package:odin/data/services/trakt_service.dart';

import 'package:odin/data/entities/trakt.dart';
import 'package:odin/helpers.dart';

var genres = [
  {"name": "Action", "slug": "action"},
  {"name": "Adventure", "slug": "adventure"},
  {"name": "Animation", "slug": "animation"},
  {"name": "Anime", "slug": "anime"},
  {"name": "Comedy", "slug": "comedy"},
  {"name": "Crime", "slug": "crime"},
  {"name": "Documentary", "slug": "documentary"},
  {"name": "Drama", "slug": "drama"},
  {"name": "Family", "slug": "family"},
  {"name": "Fantasy", "slug": "fantasy"},
  {"name": "History", "slug": "history"},
  {"name": "Holiday", "slug": "holiday"},
  {"name": "Horror", "slug": "horror"},
  {"name": "Music", "slug": "music"},
  {"name": "Musical", "slug": "musical"},
  {"name": "Mystery", "slug": "mystery"},
  {"name": "None", "slug": "none"},
  {"name": "Romance", "slug": "romance"},
  {"name": "Science Fiction", "slug": "science-fiction"},
  {"name": "Short", "slug": "short"},
  {"name": "Sporting Event", "slug": "sporting-event"},
  {"name": "Superhero", "slug": "superhero"},
  {"name": "Suspense", "slug": "suspense"},
  {"name": "Thriller", "slug": "thriller"},
  {"name": "War", "slug": "war"},
  {"name": "Western", "slug": "western"}
];

class ListData {
  int page = 1;
  List<Trakt> items = [];
}

class SectionItem {
  String title;
  String url;
  String? type;
  bool? isGenre;
  bool big;
  bool filterWatched;
  bool isTodayTomorrowEpisodes;
  List<Trakt> items = [];
  bool paginate;

  SectionItem({
    this.title = '',
    this.url = '',
    this.type,
    this.isGenre,
    this.big = false,
    this.filterWatched = false,
    this.isTodayTomorrowEpisodes = false,
    this.items = const [],
    this.paginate = true,
  });
}

class ListSetting {
  ListSetting(this.url, this.page);
  String url = '';
  int page = 1;
}

class ItemsProvider extends StateNotifier<List<Trakt>> {
  final Ref ref;
  final ItemsProviderData data;
  final TraktService traktService;
  final dynamic appRefreshProvider;
  int page = 0;
  // final page;
  // List<Trakt> items = [];
  ItemsProvider(this.ref, this.traktService, this.appRefreshProvider, this.data)
      : super([]) {
    init();
  }

  String getUrl(String url) {
    var append = '?';
    if (url.contains('?')) {
      append = '&';
    }
    return '$url${append}limit=30&page=$page';
  }

  void init() async {
    page = 1;
    Future.delayed(const Duration(milliseconds: 100), () {
      appRefreshProvider.state = true;
    });

    // items = await ref.watch(traktProvider).getItems(getUrl(url));
    Future.delayed(const Duration(milliseconds: 100), () {
      appRefreshProvider.state = false;
    });
    List<Trakt> list =
        await ref.watch(traktProvider).getItems(getUrl(data.url));
    if (data.filterWatched) {
      list = list.where((i) => i.watched == false).toList();
    }
    state = list;
  }

  void next() async {
    page++;
    Future.delayed(const Duration(milliseconds: 100), () {
      appRefreshProvider.state = true;
    });
    List<Trakt> list =
        await ref.watch(traktProvider).getItems(getUrl(data.url));

    if (data.filterWatched) {
      list = list.where((i) => i.watched == false).toList();
    }

    state = [...state, ...list];
    Future.delayed(const Duration(milliseconds: 100), () {
      appRefreshProvider.state = false;
    });
  }
}

class ItemsProviderData {
  final String url;
  final bool filterWatched;
  ItemsProviderData(this.url, this.filterWatched);
}

final itemsProvider = AutoDisposeStateNotifierProviderFamily<ItemsProvider,
    List<Trakt>, ItemsProviderData>((ref, data) {
  return ItemsProvider(ref, ref.watch(traktProvider),
      ref.read(appRefreshProvider.notifier), data);
});

final appRefreshProvider = StateProvider.autoDispose<bool>((ref) => false);

final genreProvider =
    StateProvider.autoDispose.family<int, String>((ref, type) => 0);
