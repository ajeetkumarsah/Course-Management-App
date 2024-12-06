class CourseModel {
  int id;
  String title;
  String author;
 
  String description;
  String coverImage;

  CourseModel({
    required this.id,
    required this.title,
    required this.author,
   
    required this.description,
    required this.coverImage,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        id: int.tryParse(json["id"].toString()) ?? 0,
        title: json["title"],
        author: json["author"],
        
        description: json["description"],
        coverImage: json["cover_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "author": author,
        
        "description": description,
        "cover_image": coverImage,
      };
}
