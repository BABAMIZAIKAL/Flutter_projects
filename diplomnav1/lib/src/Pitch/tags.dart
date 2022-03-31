
class Tags {
  final String surface;
  final String leisure;
  final String sport;


  Tags({
    required this.surface,
    required this.leisure,
    required this.sport,
  });

  @override
  String toString() {
    return 'Tags{surface: $surface, leisure: $leisure, sport: $sport}';
  }

  factory Tags.fromJson(Map<String, dynamic> json) {
    if(json == null){
      return Tags(leisure: '', surface: '', sport: '');
    }
    return Tags(
      surface: json['surface'] as String,
      leisure: json['leisure'] as String,
      sport: json['sport'] as String,
    );
  }
}