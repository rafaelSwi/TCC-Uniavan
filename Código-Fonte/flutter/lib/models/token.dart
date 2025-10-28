import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/utils/json_serializable.dart';

class TokenWithUser implements JsonSerializable {
  final String access_token;
  final String token_type;
  final User user;

  const TokenWithUser({
    required this.access_token,
    required this.token_type,
    required this.user,
  });

  @override
  Map<String, dynamic> toJson() {
    return {'access_token': access_token, 'token_type': token_type, 'user': user.toJson()};
  }

  factory TokenWithUser.fromJson(Map<String, dynamic> json) {
    return TokenWithUser(
      access_token: json['access_token'] as String,
      token_type: json['token_type'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
