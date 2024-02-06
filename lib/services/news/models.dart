import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class NewsResponse {
  final int? totalResults;
  final List<Article?>? articles;

  const NewsResponse({this.articles, this.totalResults});

  factory NewsResponse.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseFromJson(json);

  Map<String?, dynamic> toJson() => _$NewsResponseToJson(this);
}

@JsonSerializable()
class Article {
  final String? author;
  final String? description;
  final String? title;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  const Article({
    this.author,
    this.description,
    this.title,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String?, dynamic> toJson() => _$ArticleToJson(this);
}
