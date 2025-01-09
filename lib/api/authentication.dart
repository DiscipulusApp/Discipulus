import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart' as castle;
import 'package:dio/dio.dart';
import 'package:discipulus/models/account.dart';

class Authentication {
  final String _codeVerifier = _generateRandomString();

  /// Generate a login URL.
  /// This will redirect to "m6loapp://", so using it in a browser environment is impossible.
  Uri generateLoginURL(
      {String? tenant,
      String? username,
      List<String> scopes = const [
        "openid",
        "profile",
        "offline_access",
        "magister.mobile",
        "magister.ecs",
      ]}) {
    assert(
        tenant == null ||
            tenant.startsWith(RegExp("[A-Za-z|-]+.magister.net")),
        "Tenant needs to follow school.magister.net pattern!");
    assert(username == null || tenant != null,
        "Tenant has to be set, if the username parameter is used!");

    String generateRandomBase64(length) {
      var r = Random.secure();
      var chars = 'abcdef0123456789';
      return Iterable.generate(length, (_) => chars[r.nextInt(chars.length)])
          .join();
    }

    String nonce = generateRandomBase64(32);
    String state = _generateRandomString();
    String codeChallenge = base64Url
        .encode(castle.SHA256Digest()
            .process(Uint8List.fromList(_codeVerifier.codeUnits)))
        .replaceAll('=', '');
    return Uri.parse(
        "https://accounts.magister.net/connect/authorize?client_id=M6LOAPP&redirect_uri=m6loapp%3A%2F%2Foauth2redirect%2F&scope=${scopes.join("%20")}&response_type=code%20id_token&state=$state&nonce=$nonce&code_challenge=$codeChallenge&code_challenge_method=S256${tenant != null ? "&acr_values=tenant:$tenant&prompt=select_account${username != null ? "&login_hint=$username" : ""}" : ""}");
  }

  /// Turn the Magister return URL into a [TokenSet]
  Future<TokenSet> returnURLToTokenSet(Uri uri) async {
    String? code =
        Uri.parse(uri.toString().replaceAll("#", "?")).queryParameters["code"];

    Response<Map> res = await Dio().post(
      "https://accounts.magister.net/connect/token",
      options: Options(
        contentType: "application/x-www-form-urlencoded",
      ),
      data:
          "code=$code&redirect_uri=m6loapp://oauth2redirect/&client_id=M6LOAPP&grant_type=authorization_code&code_verifier=$_codeVerifier",
    );
    return TokenSet.fromJSON(res.data!);
  }

  /// Retrieve the api endpoint for a [tokenSet]
  static Future<Uri> apiEndpoint(TokenSet tokenSet) async {
    Map body = (await Dio().get(
            "https://magister.net/.well-known/host-meta.json?rel=magister-api",
            options: Options(
                headers: {"Authorization": "Bearer ${tokenSet.accessToken}"})))
        .data;
    return Uri.parse(body["links"].first["href"]);
  }
}

String _generateRandomString() {
  var r = Random.secure();
  var chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  return Iterable.generate(50, (_) => chars[r.nextInt(chars.length)]).join();
}

class AuthException extends DioException {
  String cause;
  AuthException(this.cause, {required super.requestOptions});
}

class ExpiredTokenException extends DioException {
  String cause;
  ExpiredTokenException(this.cause, {required super.requestOptions});
}
