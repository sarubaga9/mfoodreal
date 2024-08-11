class NewsModel {
  final String id;
  final String title;
  final String detail;
  final String by;
  final DateTime dateCreate;
  final List<String> image;
  final String sharedUrl;
  final String sharedSubject;

  NewsModel({
    required this.id,
    required this.title,
    required this.detail,
    required this.by,
    required this.dateCreate,
    required this.image,
    required this.sharedUrl,
    required this.sharedSubject,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['ID'],
      title: json['Title'],
      detail: json['Detail'],
      by: json['By'],
      dateCreate: DateTime.fromMillisecondsSinceEpoch(
          json['DateCreate'].millisecondsSinceEpoch),
      image: List<String>.from(json['Image']),
      sharedSubject: json['SharedSubject'],
      sharedUrl: json['SharedUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Title': title,
      'Detail': detail,
      'By': by,
      'DateCreate': dateCreate.toUtc().toIso8601String(),
      'Image': image,
      'SharedUrl': sharedUrl,
      'SharedSubject': sharedSubject,
    };
  }
}
