import 'package:json_annotation/json_annotation.dart';
part 'imdb.g.dart';

@JsonSerializable()
class Imdb {
  double rating;
  int votes;
  double lastRating;
  String lastComment;
  String thumbUrl;

  Imdb(
      {this.rating = 0,
      this.votes = 0,
      this.lastRating = 0,
      this.lastComment = '',
      this.thumbUrl = ''});

  factory Imdb.fromJson(Map<String, dynamic> json) {
    return Imdb(
        rating: json['aggregateRating'] != null
            ? json['aggregateRating']['ratingValue'] * 1.0
            : 0.0,
        votes: json['aggregateRating'] != null
            ? json['aggregateRating']['ratingCount']
            : 0,
        thumbUrl:
            json['trailer'] != null ? json['trailer']['thumbnailUrl'] : '',
        lastComment:
            json['review'] != null && json['review']['reviewBody'] != null
                ? json['review']['reviewBody']
                : '',
        lastRating:
            json['review'] != null && json['review']['reviewRating'] != null
                ? json['review']['reviewRating']['ratingValue'] * 1.0
                : 0.0);
  }

  Map<String, dynamic> toJson() => _$ImdbToJson(this);
}
