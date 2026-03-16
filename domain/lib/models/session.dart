class Session {
  final String id;
  final String userId;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String provider;
  final String providerUid;
  final bool current;

  const Session({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.expiresAt,
    required this.provider,
    required this.providerUid,
    required this.current,
  });

  Session copyWith({
    String? id,
    String? userId,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? provider,
    String? providerUid,
    bool? current,
  }) {
    return Session(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      provider: provider ?? this.provider,
      providerUid: providerUid ?? this.providerUid,
      current: current ?? this.current,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'provider': provider,
      'providerUid': providerUid,
      'current': current,
    };
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      provider: json['provider'] as String,
      providerUid: json['providerUid'] as String,
      current: json['current'] as bool,
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Session &&
        other.id == id &&
        other.userId == userId &&
        other.createdAt == createdAt &&
        other.expiresAt == expiresAt &&
        other.provider == provider &&
        other.providerUid == providerUid &&
        other.current == current;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      createdAt,
      expiresAt,
      provider,
      providerUid,
      current,
    );
  }

  @override
  String toString() {
    return 'Session(id: $id, userId: $userId, createdAt: $createdAt, expiresAt: $expiresAt, provider: $provider, providerUid: $providerUid, current: $current)';
  }
}
