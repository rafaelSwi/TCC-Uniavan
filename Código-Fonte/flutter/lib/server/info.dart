import 'package:MegaObra/models/user.dart';

var _baseUrl = "http://0.0.0.0:8000";
// var _baseUrl = "http://192.168.1.102:8000";

var _bearerToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIwMDAwMDAwMDAwMCIsImlkIjoyLCJleHAiOjE3MjgzNDM4NzV9.NuaLO-hsgkS2iJFSkzF3yl1Y0aluqIh9jyEDJZnk29U";

User? loggedUser;

User? setLoggedUser(User user) {
  User new_user = User(
    id: user.id,
    name: user.name,
    cpf: user.cpf,
    role_id: user.role_id,
    schedule_id: user.schedule_id,
    permission_id: user.permission_id,
  );
  loggedUser = new_user;
  return loggedUser;
}

User? logoutUser() {
  loggedUser = null;
  return loggedUser;
}

User? getLoggedUser() {
  return loggedUser;
}

String getBaseUrl() {
  return _baseUrl;
}

void setBaseUrl({required String newUrl}) {
  _baseUrl = newUrl;
}

void setBearerToken(String token) {
  print("A new access token has been defined.");
  _bearerToken = token;
}

String getBearerToken() {
  return _bearerToken;
}
