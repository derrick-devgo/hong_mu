class UserProfile{
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUal,
  }){
    return UserProfile(
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        avatarUrl: avatarUrl?? this.avatarUrl,
    );
  }

  Map<String,dynamic> toJson()=>{
    'name':name,
    'email':email,
    'phone':phone,
    'avatarUrl':avatarUrl
  };
}