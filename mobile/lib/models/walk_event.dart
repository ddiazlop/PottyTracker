class WalkEvent {
  final String? id;
  final DateTime timestamp;
  final int durationMinutes;
  final int peeCount;
  final int poopCount;
  final String? notes;

  WalkEvent({
    this.id,
    required this.timestamp,
    required this.durationMinutes,
    this.peeCount = 0,
    this.poopCount = 0,
    this.notes,
  });

  factory WalkEvent.fromJson(Map<String, dynamic> json) {
    return WalkEvent(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      durationMinutes: json['duration_minutes'],
      peeCount: json['pee_count'] ?? 0,
      poopCount: json['poop_count'] ?? 0,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'duration_minutes': durationMinutes,
      'pee_count': peeCount,
      'poop_count': poopCount,
      'notes': notes,
    };
  }

  int get totalActivities => peeCount + poopCount;

  bool get hasActivities => totalActivities > 0;

  WalkEvent copyWith({
    String? id,
    DateTime? timestamp,
    int? durationMinutes,
    int? peeCount,
    int? poopCount,
    String? notes,
  }) {
    return WalkEvent(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      peeCount: peeCount ?? this.peeCount,
      poopCount: poopCount ?? this.poopCount,
      notes: notes ?? this.notes,
    );
  }
}