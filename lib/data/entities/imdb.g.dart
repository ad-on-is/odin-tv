// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imdb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Imdb _$ImdbFromJson(Map<String, dynamic> json) => Imdb(
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      votes: json['votes'] as int? ?? 0,
      lastRating: (json['lastRating'] as num?)?.toDouble() ?? 0,
      lastComment: json['lastComment'] as String? ?? '',
      thumbUrl: json['thumbUrl'] as String? ?? '',
    );

Map<String, dynamic> _$ImdbToJson(Imdb instance) => <String, dynamic>{
      'rating': instance.rating,
      'votes': instance.votes,
      'lastRating': instance.lastRating,
      'lastComment': instance.lastComment,
      'thumbUrl': instance.thumbUrl,
    };
