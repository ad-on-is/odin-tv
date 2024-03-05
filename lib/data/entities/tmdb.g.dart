// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TmdbCast _$TmdbCastFromJson(Map<String, dynamic> json) => TmdbCast(
      name: json['name'] as String? ?? '',
      profilePath: json['profile_path'] as String? ?? '',
      character: json['character'] as String? ?? '',
    );

Map<String, dynamic> _$TmdbCastToJson(TmdbCast instance) => <String, dynamic>{
      'name': instance.name,
      'profile_path': instance.profilePath,
      'character': instance.character,
    };

TmdbCredits _$TmdbCreditsFromJson(Map<String, dynamic> json) => TmdbCredits(
      cast: (json['cast'] as List<dynamic>?)
              ?.map((e) => TmdbCast.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TmdbCreditsToJson(TmdbCredits instance) =>
    <String, dynamic>{
      'cast': instance.cast.map((e) => e.toJson()).toList(),
    };

TmdbProductionCompany _$TmdbProductionCompanyFromJson(
        Map<String, dynamic> json) =>
    TmdbProductionCompany(
      name: json['name'] as String? ?? '',
      logoPath: json['logo_path'] as String? ?? '',
    );

Map<String, dynamic> _$TmdbProductionCompanyToJson(
        TmdbProductionCompany instance) =>
    <String, dynamic>{
      'logo_path': instance.logoPath,
      'name': instance.name,
    };

Tmdb _$TmdbFromJson(Map<String, dynamic> json) => Tmdb(
      posterPath: json['poster_path'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      backdropPath: json['backdrop_path'] as String? ?? '',
      stillPath: json['stillPath'] as String? ?? '',
      episodeNumber: json['episode_number'] as int? ?? 0,
      voteCount: json['vote_count'] as int? ?? 0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      originalTitle: json['original_title'] as String? ?? '',
      productionCompanies: (json['production_companies'] as List<dynamic>?)
              ?.map((e) =>
                  TmdbProductionCompany.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      episodes: (json['episodes'] as List<dynamic>?)
              ?.map((e) => Tmdb.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      credits: json['credits'] == null
          ? const TmdbCredits(cast: [])
          : TmdbCredits.fromJson(json['credits'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TmdbToJson(Tmdb instance) => <String, dynamic>{
      'id': instance.id,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'original_title': instance.originalTitle,
      'stillPath': instance.stillPath,
      'episode_number': instance.episodeNumber,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'credits': instance.credits.toJson(),
      'episodes': instance.episodes.map((e) => e.toJson()).toList(),
      'production_companies':
          instance.productionCompanies.map((e) => e.toJson()).toList(),
    };
