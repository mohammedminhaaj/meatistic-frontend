// const String baseUrl = "10.0.2.2:8000";
const String baseUrl = "dev.meatistic.com";
const String wsUrl = "ws://$baseUrl/";
const Map<String, String> requestHeader = {
  "Content-Type": "application/json",
};
const String gmapApi = "AIzaSyBE7UlAGmlECI-mu_O7If-rYcC0mQ3NUtE";

Map<String, String> getAuthorizationHeaders(String authToken) {
  return {
    ...requestHeader,
    "Authorization": "Token $authToken",
  };
}

Uri getUri(String url, [Map<String, String>? params]) {
  return Uri.https(baseUrl, url, params);
}
