import 'package:json_annotation/json_annotation.dart';
part 'scrape.g.dart';

@JsonSerializable()
class Scrape {
  String url;
  String magnet;
  @JsonKey(name: 'release_title')
  String title;
  @JsonKey(name: 'scraper')
  @JsonKey(defaultValue: 'unknown')
  String scraper;
  String quality;
  List<String> info;
  List<dynamic> realdebrid;

  Scrape(
      {this.url = '',
      this.magnet = '',
      this.title = '',
      this.scraper = '',
      this.quality = '',
      this.realdebrid = const [],
      this.info = const []});

  factory Scrape.fromJson(Map<String, dynamic> json) => _$ScrapeFromJson(json);
}
