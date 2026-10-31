class AcademicModel {
  final int? id;
  final String title;
  final String description;
  final String category;
  final String image;
  final String additionalInfo;

  const AcademicModel({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.image,
    required this.additionalInfo,
  });

  // Mengubah objek menjadi Map untuk disimpan ke SQLite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'image': image,
      'additional_info': additionalInfo,
    };
  }

  // Mengubah data Map dari SQLite menjadi objek.
  factory AcademicModel.fromMap(Map<String, dynamic> map) {
    return AcademicModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      image: map['image'] as String,
      additionalInfo: map['additional_info'] as String,
    );
  }

  // Membuat salinan data dengan perubahan tertentu.
  AcademicModel copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    String? image,
    String? additionalInfo,
  }) {
    return AcademicModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }
}
