class Ceremony {
  String title;
  String description;
  String url;
  String location;
  String date;
  String userId;
  String hashtag;
  String ceremonyId;

  Ceremony({
    required this.title,
    required this.description,
    required this.url,
    required this.location,
    required this.date,
    required this.userId,
    required this.hashtag,
    required this.ceremonyId
  });

  factory Ceremony.fromMap(Map<String, dynamic> map) {
    return Ceremony(
      title: map['title'],
      description: map['description'],
      url: map['url'],
      location: map['location'],
      date: map['date'],
      userId: map['userId'],
      hashtag: map['hashtag'],
      ceremonyId: map['ceremonyId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'location': location,
      'date': date,
      'userId' : userId,
      'hashtag': hashtag,
      'ceremonyId': ceremonyId
    };
  }
}