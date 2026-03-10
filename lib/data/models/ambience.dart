class Ambience {
  final String id;
  final String title;
  final String tag;
  final String description;
  final String image;
  final String audioAsset;
  final List<String> sensoryChips;

  Ambience({
    required this.id,
    required this.title,
    required this.tag,
    required this.description,
    required this.image,
    required this.audioAsset,
    required this.sensoryChips,
  });

  factory Ambience.fromJson(Map<String, dynamic> json) {
    return Ambience(
      id: json['id'],
      title: json['title'],
      tag: json['tag'],
      description: json['description'],
      image: json['image'],
      audioAsset: json['audioAsset'],
      sensoryChips: List<String>.from(json['sensoryChips'] ?? []),
    );
  }
}
