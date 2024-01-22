class BlessingItem {
  String addedBy;
  double duration;
  String video;
  String hashtag;
  String name;
  String blessingId;

  BlessingItem({
    required this.addedBy,
    required this.duration,
    required this.video,
    required this.hashtag,
    required this.name,
    required this.blessingId,
  });

  factory BlessingItem.fromMap(Map<String, dynamic> map) {
    return BlessingItem(
      addedBy: map['addedBy'],
      duration: map['duration'],
      video: map['video'],
      hashtag: map['hashtag'],
      name: map['name'],
      blessingId: map['blessingId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'addedBy': addedBy,
      'duration': duration,
      'video': video,
      'hashtag': hashtag,
      'name': name,
      'blessingId': blessingId,
    };
  }
}