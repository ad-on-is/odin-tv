import 'package:json_annotation/json_annotation.dart';

part 'tmdb.g.dart';

@JsonSerializable(explicitToJson: true)
class TmdbCast {
  final String name;
  @JsonKey(name: 'profile_path')
  final String profilePath;
  final String character;
  String get profileBig => 'https://image.tmdb.org/t/p/w780$profilePath';
  String get profileSmall => 'https://image.tmdb.org/t/p/w342$profilePath';
  TmdbCast({this.name = '', this.profilePath = '', this.character = ''});
  factory TmdbCast.fromJson(Map<String, dynamic> json) =>
      _$TmdbCastFromJson(json);

  Map<String, dynamic> toJson() => _$TmdbCastToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TmdbCredits {
  final List<TmdbCast> cast;
  const TmdbCredits({this.cast = const []});
  factory TmdbCredits.fromJson(Map<String, dynamic> json) =>
      _$TmdbCreditsFromJson(json);
  Map<String, dynamic> toJson() => _$TmdbCreditsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TmdbProductionCompany {
  @JsonKey(name: 'logo_path')
  String logoPath;
  String name;

  TmdbProductionCompany({this.name = '', this.logoPath = ''});
  factory TmdbProductionCompany.fromJson(Map<String, dynamic> json) =>
      _$TmdbProductionCompanyFromJson(json);
  Map<String, dynamic> toJson() => _$TmdbProductionCompanyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Tmdb {
  int id;
  @JsonKey(name: 'poster_path')
  String posterPath;
  @JsonKey(name: 'backdrop_path')
  String backdropPath;

  @JsonKey(name: 'original_title')
  String originalTitle;

  @JsonKey(name: 'stillPath')
  String stillPath;

  @JsonKey(name: 'episode_number')
  int episodeNumber;

  @JsonKey(name: 'vote_average')
  double voteAverage;

  @JsonKey(name: 'vote_count')
  int voteCount;

  @JsonKey(name: 'credits')
  TmdbCredits credits;

  List<Tmdb> episodes;

  @JsonKey(name: 'production_companies')
  List<TmdbProductionCompany> productionCompanies;

  double get roundedRating => double.parse(voteAverage.toStringAsFixed(1));
  String get smallPath => 'https://image.tmdb.org/t/p/w342';
  String get posterBig => 'https://image.tmdb.org/t/p/w780$posterPath';
  String get posterSmall => 'https://image.tmdb.org/t/p/w342$posterPath';
  String get stillBig => 'https://image.tmdb.org/t/p/w300$stillPath';
  String get stillSmall => 'https://image.tmdb.org/t/p/w185$stillPath';
  String get backdropBig => 'https://image.tmdb.org/t/p/w1280$backdropPath';
  String get backdropSmall => 'https://image.tmdb.org/t/p/w780$backdropPath';

  Tmdb(
      {this.posterPath = '',
      this.id = 0,
      this.backdropPath = '',
      this.stillPath = '',
      this.episodeNumber = 0,
      this.voteCount = 0,
      this.voteAverage = 0.0,
      this.originalTitle = '',
      this.productionCompanies = const [],
      this.episodes = const [],
      this.credits = const TmdbCredits(cast: [])});

  factory Tmdb.fromJson(Map<String, dynamic> json) => _$TmdbFromJson(json);
  Map<String, dynamic> toJson() => _$TmdbToJson(this);
}
