import 'package:json_annotation/json_annotation.dart';
import 'package:odin/data/entities/tmdb.dart';

import 'imdb.dart';

part 'trakt.g.dart';

@JsonSerializable(explicitToJson: true)
class TraktIds {
  final int trakt;
  final String slug;
  final String imdb;
  final int tmdb;
  final int tvdb;
  const TraktIds(
      {this.trakt = 0,
      this.slug = '',
      this.imdb = '',
      this.tmdb = 0,
      this.tvdb = 0});
  factory TraktIds.fromJson(Map<String, dynamic> json) =>
      _$TraktIdsFromJson(json);

  Map<String, dynamic> toJson() => _$TraktIdsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TraktEpisode {
  String title;
  int season;
  int number;
  bool watched;
  TraktEpisode(
      {this.title = '',
      this.season = 0,
      this.number = 0,
      this.watched = false});

  TraktEpisode setWatched(bool w) {
    watched = w;
    return this;
  }

  factory TraktEpisode.fromJson(Map<String, dynamic> json) =>
      _$TraktEpisodeFromJson(json);
  Map<String, dynamic> toJson() => _$TraktEpisodeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Trakt {
  String type;
  TraktIds ids;
  String title;
  int year;
  Trakt? show;
  String language;
  double rating;
  int votes;
  List<String> genres;
  String overview;
  int runtime;
  String country;
  String trailer;
  bool watched;
  TraktEpisode? episode;
  @JsonKey(name: 'seasons')
  List<Trakt> seasons;
  List<Trakt> episodes;
  @JsonKey(name: 'tmdb')
  Tmdb? tmdb;
  Imdb? imdb;

  DateTime released;
  String tagline;

  @JsonKey(name: 'first_aired')
  DateTime firstAired;
  String network;
  String status;

  int number;
  @JsonKey(name: 'episode_count')
  int episodeCount;
  @JsonKey(name: 'aired_episodes')
  int airedEpisodes;
  int season;

  bool get isMovie => type == 'movie';
  bool get isShow => type == 'show';
  bool get isSeason => type == 'season';
  bool get isEpisode => type == 'episode';

  Trakt setType(String t) {
    type = t;
    return this;
  }

  Trakt setWatched(bool w) {
    watched = w;
    return this;
  }

  double get roundedRating => double.parse(rating.toStringAsFixed(1));

  Trakt(
      {this.ids = const TraktIds(),
      this.type = '',
      this.watched = false,
      this.title = '',
      this.year = 0,
      this.rating = 0.0,
      this.votes = 0,
      this.genres = const [],
      this.country = '',
      this.trailer = '',
      this.network = '',
      this.status = '',
      this.language = '',
      this.overview = 'No overview',
      this.number = 0,
      this.season = 0,
      this.runtime = 0,
      this.episodeCount = 0,
      this.airedEpisodes = 0,
      this.seasons = const [],
      this.episodes = const [],
      this.show,
      this.tagline = '',
      DateTime? released,
      DateTime? firstAired})
      : released = released ?? DateTime.now(),
        firstAired = firstAired ?? DateTime.now();

  factory Trakt.fromJson(Map<String, dynamic> json) => _$TraktFromJson(json);
  Map<String, dynamic> toJson() => _$TraktToJson(this);
}
