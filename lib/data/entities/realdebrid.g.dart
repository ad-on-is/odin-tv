// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realdebrid.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RealDebrid _$RealDebridFromJson(Map<String, dynamic> json) => RealDebrid(
      id: json['id'] as String? ?? '',
      filename: json['filename'] as String? ?? '',
      filesize: json['filesize'] as int? ?? 0,
      download: json['download'] as String? ?? '',
      info:
          (json['info'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$RealDebridToJson(RealDebrid instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'filesize': instance.filesize,
      'download': instance.download,
      'info': instance.info,
    };
