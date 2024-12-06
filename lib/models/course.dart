class CourseModel {
  int id;
  String title;
  String author;
  List<String> genre;
  String description;
  String coverImage;

  CourseModel({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.description,
    required this.coverImage,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        id: int.tryParse(json["id"].toString()) ?? 0,
        title: json["title"],
        author: json["author"],
        genre: List<String>.from(json["genre"].map((x) => x)),
        description: json["description"],
        coverImage: json["cover_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "author": author,
        "genre": List<dynamic>.from(genre.map((x) => x)),
        "description": description,
        "cover_image": coverImage,
      };
}
