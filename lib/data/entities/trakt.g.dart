// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trakt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TraktIds _$TraktIdsFromJson(Map<String, dynamic> json) => TraktIds(
      trakt: json['trakt'] as int? ?? 0,
      slug: json['slug'] as String? ?? '',
      imdb: json['imdb'] as String? ?? '',
      tmdb: json['tmdb'] as int? ?? 0,
      tvdb: json['tvdb'] as int? ?? 0,
    );

Map<String, dynamic> _$TraktIdsToJson(TraktIds instance) => <String, dynamic>{
      'trakt': instance.trakt,
      'slug': instance.slug,
      'imdb': instance.imdb,
      'tmdb': instance.tmdb,
      'tvdb': instance.tvdb,
    };

TraktEpisode _$TraktEpisodeFromJson(Map<String, dynamic> json) => TraktEpisode(
      title: json['title'] as String? ?? '',
      season: json['season'] as int? ?? 0,
      number: json['number'] as int? ?? 0,
      watched: json['watched'] as bool? ?? false,
    );

Map<String, dynamic> _$TraktEpisodeToJson(TraktEpisode instance) =>
    <String, dynamic>{
      'title': instance.title,
      'season': instance.season,
      'number': instance.number,
      'watched': instance.watched,
    };

Trakt _$TraktFromJson(Map<String, dynamic> json) => Trakt(
      ids: json['ids'] == null
          ? const TraktIds()
          : TraktIds.fromJson(json['ids'] as Map<String, dynamic>),
      type: json['type'] as String? ?? '',
      watched: json['watched'] as bool? ?? false,
      title: json['title'] as String? ?? '',
      year: json['year'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      votes: json['votes'] as int? ?? 0,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      country: json['country'] as String? ?? '',
      trailer: json['trailer'] as String? ?? '',
      network: json['network'] as String? ?? '',
      status: json['status'] as String? ?? '',
      language: json['language'] as String? ?? '',
      overview: json['overview'] as String? ?? 'No overview',
      number: json['number'] as int? ?? 0,
      season: json['season'] as int? ?? 0,
      runtime: json['runtime'] as int? ?? 0,
      episodeCount: json['episode_count'] as int? ?? 0,
      airedEpisodes: json['aired_episodes'] as int? ?? 0,
      seasons: (json['seasons'] as List<dynamic>?)
              ?.map((e) => Trakt.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      episodes: (json['episodes'] as List<dynamic>?)
              ?.map((e) => Trakt.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      show: json['show'] == null
          ? null
          : Trakt.fromJson(json['show'] as Map<String, dynamic>),
      tagline: json['tagline'] as String? ?? '',
      released: json['released'] == null
          ? null
          : DateTime.parse(json['released'] as String),
      firstAired: json['first_aired'] == null
          ? null
          : DateTime.parse(json['first_aired'] as String),
    )
      ..episode = json['episode'] == null
          ? null
          : TraktEpisode.fromJson(json['episode'] as Map<String, dynamic>)
      ..tmdb = json['tmdb'] == null
          ? null
          : Tmdb.fromJson(json['tmdb'] as Map<String, dynamic>)
      ..imdb = json['imdb'] == null
          ? null
          : Imdb.fromJson(json['imdb'] as Map<String, dynamic>);

Map<String, dynamic> _$TraktToJson(Trakt instance) => <String, dynamic>{
      'type': instance.type,
      'ids': instance.ids.toJson(),
      'title': instance.title,
      'year': instance.year,
      'show': instance.show?.toJson(),
      'language': instance.language,
      'rating': instance.rating,
      'votes': instance.votes,
      'genres': instance.genres,
      'overview': instance.overview,
      'runtime': instance.runtime,
      'country': instance.country,
      'trailer': instance.trailer,
      'watched': instance.watched,
      'episode': instance.episode?.toJson(),
      'seasons': instance.seasons.map((e) => e.toJson()).toList(),
      'episodes': instance.episodes.map((e) => e.toJson()).toList(),
      'tmdb': instance.tmdb?.toJson(),
      'imdb': instance.imdb?.toJson(),
      'released': instance.released.toIso8601String(),
      'tagline': instance.tagline,
      'first_aired': instance.firstAired.toIso8601String(),
      'network': instance.network,
      'status': instance.status,
      'number': instance.number,
      'episode_count': instance.episodeCount,
      'aired_episodes': instance.airedEpisodes,
      'season': instance.season,
    };
