class BlogModel {
  final String id;
  final String title;
  final String description;
  final String content;
  final String? author;
  final int viewNumber;
  final String? image1;
  final String? image2;
  final String? image3;
  final String? image4;
  final DateTime? createdTime;

  BlogModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    this.author,
    required this.viewNumber,
    this.image1,
    this.image2,
    this.image3,
    this.image4,
    this.createdTime
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      author: json['author']?.toString(),
      viewNumber: (json['viewNumber'] as num?)?.toInt() ?? 0,
      image1: json['image1']?.toString(),
      image2: json['image2']?.toString(),
      image3: json['image3']?.toString(),
      image4: json['image4']?.toString(),
      createdTime: json['createdTime'] != null
        ? DateTime.tryParse(json['createdTime'].toString())
          : null, //parse ngày tạo
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'author': author,
      'viewNumber': viewNumber,
      'image1': image1,
      'image2': image2,
      'image3': image3,
      'image4': image4,
      'createdTime': createdTime?.toIso8601String(), //serialize lại
    };
  }
}