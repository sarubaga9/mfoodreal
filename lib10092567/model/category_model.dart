import 'package:flutter/cupertino.dart';

class CategoryModel with ChangeNotifier {
  final String? categoryId;
  final String? nameCategory;
  final String? imageUrl;
  final List<String>? listOfCategory;
  final List<String>? listImageGroup;

  CategoryModel({
    this.categoryId,
    this.nameCategory,
    this.imageUrl,
    this.listOfCategory,
    this.listImageGroup,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        categoryId: json['CategoryId'],
        nameCategory: json['NameCategory'],
        imageUrl: json['ImageUrl'],
        listOfCategory: List<String>.from(json['ListOfCategory']),
        listImageGroup: List<String>.from(json['ListImageGroup']),
      );

  Map<String, dynamic> toJson() => {
        'CategoryId': categoryId,
        'NameCategory': nameCategory,
        'ImageUrl': imageUrl,
        'ListOfCategory': List<dynamic>.from(listOfCategory!),
        'ListImageGroup': List<dynamic>.from(listImageGroup!),
      };
}
