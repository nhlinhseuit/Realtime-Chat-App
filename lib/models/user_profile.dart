// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserProfile {
  String? uid;
  String? name;
  String? pfpUrl;

  UserProfile({
    this.uid,
    this.name,
    this.pfpUrl,
  });

  UserProfile copyWith({
    String? uid,
    String? name,
    String? pfpUrl,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      pfpUrl: pfpUrl ?? this.pfpUrl,
    );
  }

  // JSON LÀ 1 MAP Ở DẠNG KHÔNG CÁCH DÒNG, VIẾT LIỀN
  // MAP LÀ MAP

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'pfpUrl': pfpUrl,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      pfpUrl: map['pfpUrl'] != null ? map['pfpUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserProfile(uid: $uid, name: $name, pfpUrl: $pfpUrl)';
}
