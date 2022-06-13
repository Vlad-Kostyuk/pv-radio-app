import 'dart:convert';

class StreamQualityModel {
  String title;
  String description;
  String url;
  StreamQualityModel({
    required this.title,
    required this.description,
    required this.url,
  });

  StreamQualityModel copyWith({
    String? title,
    String? description,
    String? url,
  }) {
    return StreamQualityModel(
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'url': url,
    };
  }

  factory StreamQualityModel.fromMap(Map<String, dynamic> map) {
    return StreamQualityModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      url: map['url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StreamQualityModel.fromJson(String source) => StreamQualityModel.fromMap(json.decode(source));

  @override
  String toString() => 'StreamQualityModel(title: $title, description: $description, url: $url)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is StreamQualityModel &&
      other.title == title &&
      other.description == description &&
      other.url == url;
  }

  @override
  int get hashCode => title.hashCode ^ description.hashCode ^ url.hashCode;
}
