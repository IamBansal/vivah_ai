class PhotoItem {
  String addedBy;
  String category;
  String image;
  String hashtag;
  String name;
  String photoId;

  PhotoItem({
    required this.addedBy,
    required this.category,
    required this.image,
    required this.hashtag,
    required this.name,
    required this.photoId,
  });

  factory PhotoItem.fromMap(Map<String, dynamic> map) {
    return PhotoItem(
      addedBy: map['addedBy'],
      category: map['category'],
      image: map['image'],
      hashtag: map['hashtag'],
      name: map['name'],
      photoId: map['photoId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'addedBy': addedBy,
      'category': category,
      'image': image,
      'hashtag': hashtag,
      'name': name,
      'photoId': photoId,
    };
  }
}