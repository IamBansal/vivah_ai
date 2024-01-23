class Ceremony {
  String title;
  String description;
  String url;
  String location;
  String date;
  String userId;
  String hashtag;
  String ceremonyId;
  double longitude;
  double latitude;

  Ceremony({
    required this.title,
    required this.description,
    required this.url,
    required this.location,
    required this.date,
    required this.userId,
    required this.hashtag,
    required this.ceremonyId,
    required this.longitude,
    required this.latitude,
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
      longitude: map['longitude'],
      latitude: map['latitude'],
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
      'ceremonyId': ceremonyId,
      'longitude': longitude,
      'latitude': latitude
    };
  }
}