// To parse this JSON data, do
//
//     final mediaModel = mediaModelFromJson(jsonString);

import 'dart:convert';

import 'download_status.dart';

MediaModel mediaModelFromJson(String str) => MediaModel.fromJson(json.decode(str));

String mediaModelToJson(MediaModel data) => json.encode(data.toJson());

class MediaModel {
  List<Category>? categories;

  MediaModel({
    this.categories,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) => MediaModel(
    categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
  };
}

class Category {
  String? name;
  List<Video>? videos;

  Category({
    this.name,
    this.videos,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    name: json["name"],
    videos: json["videos"] == null ? [] : List<Video>.from(json["videos"]!.map((x) => Video.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "videos": videos == null ? [] : List<dynamic>.from(videos!.map((x) => x.toJson())),
  };
}

class Video {
  int? id;
  String? description;
  List<String>? sources;
  String? subtitle;
  String? thumb;
  String? title;
  dynamic downloadedBytes;
  dynamic totalBytes;
  String? status;
  bool? isPause=false;


  Video({
    this.id,
    this.description,
    this.sources,
    this.subtitle,
    this.thumb,
    this.title,
    this.downloadedBytes=  0.0,
    this.totalBytes=  0.0,
    this.status=  '',
    bool? isPause=false,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: json["id"],
    description: json["description"],
    sources: json["sources"] == null ? [] : List<String>.from(json["sources"]!.map((x) => x)),
    subtitle: json["subtitle"],
    thumb: json["thumb"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "sources": sources == null ? [] : List<dynamic>.from(sources!.map((x) => x)),
    "subtitle": subtitle,
    "thumb": thumb,
    "title": title,
  };
}




