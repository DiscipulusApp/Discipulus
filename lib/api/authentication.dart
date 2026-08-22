import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart' as castle;
import 'package:dio/dio.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/utils/login_logger.dart';

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
        tenant == null || tenant.startsWith(RegExp("[A-Za-z|-]+.magister.net")),
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
    final uri = Uri.parse(
        "https://accounts.magister.net/connect/authorize?client_id=M6LOAPP&redirect_uri=m6loapp%3A%2F%2Foauth2redirect%2F&scope=${scopes.join("%20")}&response_type=code%20id_token&state=$state&nonce=$nonce&code_challenge=$codeChallenge&code_challenge_method=S256${tenant != null ? "&acr_values=tenant:$tenant&prompt=select_account${username != null ? "&login_hint=$username" : ""}" : ""}");

    LoginLogger.instance.step("OAuth autorisatie URL gegenereerd");
    LoginLogger.instance.info("Tenant: ${tenant ?? 'Niet ingesteld'}", category: "AUTH");
    return uri;
  }

  /// Turn the Magister return URL into a [TokenSet]
  Future<TokenSet> returnURLToTokenSet(Uri uri) async {
    LoginLogger.instance.step("Redirect URL ontvangen van Magister");
    String? code =
        Uri.parse(uri.toString().replaceAll("#", "?")).queryParameters["code"];

    if (code == null || code.isEmpty) {
      LoginLogger.instance.error("Geen autorisatiecode gevonden in redirect URL: $uri");
      throw Exception("Geen autorisatiecode ontvangen van Magister login redirect.");
    }

    LoginLogger.instance.step("Inwisselen van autorisatiecode voor tokens");
    try {
      Response<Map> res = await Dio().post(
        "https://accounts.magister.net/connect/token",
        options: Options(
          contentType: "application/x-www-form-urlencoded",
        ),
        data:
            "code=$code&redirect_uri=m6loapp://oauth2redirect/&client_id=M6LOAPP&grant_type=authorization_code&code_verifier=$_codeVerifier",
      );
      LoginLogger.instance.http("POST", "https://accounts.magister.net/connect/token",
          statusCode: res.statusCode);

      if (res.data == null) {
        throw Exception("Lege response ontvangen van token server");
      }

      final tokenSet = TokenSet.fromJSON(res.data!);
      LoginLogger.instance.info("TokenSet succesvol ontvangen (verloopt op: ${tokenSet.expiredDate})",
          category: "AUTH");
      return tokenSet;
    } catch (e, s) {
      LoginLogger.instance.error("Fout bij inwisselen van autorisatiecode",
          error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Retrieve the api endpoint for a [tokenSet]
  static Future<Uri> apiEndpoint(TokenSet tokenSet) async {
    LoginLogger.instance.step("Opvragen van Magister API basis-URL via host-meta.json");
    try {
      Response res = await Dio().get(
        "https://magister.net/.well-known/host-meta.json?rel=magister-api",
        options: Options(
          headers: {"Authorization": "Bearer ${tokenSet.accessToken}"},
        ),
      );
      LoginLogger.instance.http("GET", "https://magister.net/.well-known/host-meta.json?rel=magister-api",
          statusCode: res.statusCode);

      Map body = res.data;
      if (body["links"] == null || (body["links"] as List).isEmpty) {
        throw Exception("Geen API links gevonden in host-meta.json response: $body");
      }
      final endpointStr = body["links"].first["href"];
      if (endpointStr == null) {
        throw Exception("API href ontbreekt in host-meta.json: $body");
      }
      final endpoint = Uri.parse(endpointStr);
      LoginLogger.instance.info("Magister API basis-URL vastgesteld: $endpoint", category: "API");
      return endpoint;
    } catch (e, s) {
      LoginLogger.instance.error("Fout bij ophalen van host-meta.json API endpoint",
          error: e, stackTrace: s);
      rethrow;
    }
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
