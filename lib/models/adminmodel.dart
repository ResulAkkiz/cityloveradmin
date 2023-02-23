class AdminModel {
  String userID;
  String userEmail;
  bool? status;
  int? role;
  AdminModel({
    required this.userID,
    required this.userEmail,
    this.status,
    this.role,
  });

  AdminModel copyWith({
    String? userID,
    String? userEmail,
    bool? status,
    int? role,
  }) {
    return AdminModel(
      userID: userID ?? this.userID,
      userEmail: userEmail ?? this.userEmail,
      status: status ?? this.status,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userID': userID,
      'userEmail': userEmail,
      'status': status,
      'role': role,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      userID: map['userID'] as String,
      userEmail: map['userEmail'] as String,
      status: map['status'] != null ? map['status'] as bool : null,
      role: map['role'] != null ? map['role'] as int : null,
    );
  }
  @override
  String toString() {
    return 'AdminModel(userID: $userID, userEmail: $userEmail, status: $status, role: $role)';
  }

  @override
  bool operator ==(covariant AdminModel other) {
    if (identical(this, other)) return true;

    return other.userID == userID &&
        other.userEmail == userEmail &&
        other.status == status &&
        other.role == role;
  }

  @override
  int get hashCode {
    return userID.hashCode ^
        userEmail.hashCode ^
        status.hashCode ^
        role.hashCode;
  }
}
