class Guest {
  String category;
  String contact;
  String hashtag;
  String name;
  String relation;
  String team;
  String url;
  String userId;

  // Constructor
  Guest({
    required this.category,
    required this.contact,
    required this.hashtag,
    required this.name,
    required this.relation,
    required this.team,
    required this.url,
    required this.userId,
  });

  // Factory method to create a Guest instance from a Map
  factory Guest.fromMap(Map<String, dynamic> map) {
    return Guest(
      category: map['category'],
      contact: map['contact'],
      hashtag: map['hashtag'],
      name: map['name'],
      relation: map['relation'],
      team: map['team'],
      url: map['url'],
      userId: map['userId'],
    );
  }

  // Method to convert Guest instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'contact': contact,
      'hashtag': hashtag,
      'name': name,
      'relation': relation,
      'team': team,
      'url': url,
      'userId': userId,
    };
  }
}