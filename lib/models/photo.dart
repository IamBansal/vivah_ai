class PhotoItem {
  String addedBy;
  String category;
  String image;
  String hashtag;

  PhotoItem({
    required this.addedBy,
    required this.category,
    required this.image,
    required this.hashtag
  });

  factory PhotoItem.fromMap(Map<String, dynamic> map) {
    return PhotoItem(
      addedBy: map['addedBy'],
      category: map['category'],
      image: map['image'],
      hashtag: map['hashtag'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'addedBy': addedBy,
      'category': category,
      'image': image,
      'hashtag': hashtag
    };
  }
}