import 'package:json_annotation/json_annotation.dart';

part 'realdebrid.g.dart';

@JsonSerializable()
class RealDebrid {
  String id;
  String filename;
  int filesize;
  String download;
  List<String> info;

  RealDebrid(
      {this.id = '',
      this.filename = '',
      this.filesize = 0,
      this.download = '',
      this.info = const []});

  factory RealDebrid.fromJson(Map<String, dynamic> json) =>
      _$RealDebridFromJson(json);
}
