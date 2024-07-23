// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scrape.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Scrape _$ScrapeFromJson(Map<String, dynamic> json) => Scrape(
      url: json['url'] as String? ?? '',
      magnet: json['magnet'] as String? ?? '',
      title: json['release_title'] as String? ?? '',
      scraper: json['scraper'] as String? ?? '',
      size: json['size'] as int? ?? 0,
      quality: json['quality'] as String? ?? '',
      realdebrid: json['realdebrid'] as List<dynamic>? ?? const [],
      info:
          (json['info'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$ScrapeToJson(Scrape instance) => <String, dynamic>{
      'url': instance.url,
      'magnet': instance.magnet,
      'release_title': instance.title,
      'scraper': instance.scraper,
      'size': instance.size,
      'quality': instance.quality,
      'info': instance.info,
      'realdebrid': instance.realdebrid,
    };
