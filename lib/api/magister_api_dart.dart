import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:discipulus/api/models/account.dart';
import 'package:discipulus/api/routes/messages.dart';
import 'package:discipulus/api/routes/persons.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/screens/introduction/login.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Map<int, Dio> dioInstances = {};

class Magister {
  /// This identifier is used to differentiate between dio instances, which makes
  /// simultaneous token refreshing across multiple accounts possible.
  int? uuid;
  Uri apiEndpoint;
  Future<TokenSet> Function() tokenSet;

  /// When the token is refreshed, this should take care of saving the token.
  Future<void> Function(TokenSet tokenSet)? onTokenRefresh;

  ///Returns the account linked to the current [TokenSet].
  Future<ApiAccount> get account async =>
      ApiAccount.fromMap((await dio.get("account?noCache=0")).data);

  PersonRoute person(int personId) => PersonRoute(this, personId: personId);
  MessagesRoute get messages => MessagesRoute(this);

  Magister({
    this.uuid,
    required this.apiEndpoint,
    required this.tokenSet,
    this.onTokenRefresh,
  });

  Future<void> _refreshToken() async {
    TokenSet? newTokenSet;
    try {
      newTokenSet = await (await tokenSet()).refresh();
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data["error"] == "invalid_grant") {
          // Oh god, something has gone terribly wrong
          if (kDebugMode) {
            print("Token is invalid, you will need to login again");
          }
          if (navKey.currentContext != null) {
            newTokenSet = await showMagisterLoginDialog(navKey.currentContext!);
          }
        }
        // Something else dio related has failed, still, not great
      }
    }

    if (newTokenSet != null) {
      // New tokenSet was provided
      if (kDebugMode) {
        print(
            "Token was refreshed, it will expire on ${newTokenSet.expiredDate}");
      }
      await onTokenRefresh?.call(newTokenSet);
    } else {
      print("Failed to refresh token");
    }
  }

  Dio get dio {
    if (uuid != null && dioInstances[uuid] == null) {
      dioInstances.addAll({uuid!: _createDioInstance()});
    }
    return (dioInstances[uuid] ?? _createDioInstance())
      ..options = BaseOptions(
        baseUrl: "${apiEndpoint.toString()}/",
        connectTimeout: const Duration(seconds: 15),
        persistentConnection: true,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
      );
  }

  Dio _createDioInstance() {
    return Dio()
      ..interceptors.addAll([
        QueuedInterceptorsWrapper(
          onRequest: (options, handler) async {
            // Check if the request token has expired
            TokenSet tokenSet = await this.tokenSet();
            if (DateTime.now().compareTo(tokenSet.expiredDate!) >= 0) {
              // Token has expired, refreshing it
              await _refreshToken();
              tokenSet = await this.tokenSet();
            }

            options.headers["Authorization"] = "Bearer ${tokenSet.accessToken}";
            handler.next(options);
          },
          onError: (error, handler) async {
            if (error.response?.data == "SecurityToken Expired") {
              // The refresh has expired before expected
              await _refreshToken();
              TokenSet tokenSet = await this.tokenSet();
              // Retry the request with the new tokenSet
              error.requestOptions.headers["Authorization"] =
                  "Bearer ${tokenSet.accessToken}";
              await dio.fetch(error.requestOptions).then(
                    (r) => handler.resolve(r),
                    onError: (e) => handler.reject(e),
                  );
            }

            // Show a snackbar with the error when the error is relevant
            if (navKey.currentContext?.mounted ?? false) {
              if (error.response?.statusCode == 429) {
                sendSnackBar(
                  uuid: uuid,
                  SnackBar(
                    duration:
                        Duration(seconds: error.response?.data["secondsLeft"]),
                    content: const Text(
                      "Ophaal limiet bereikt, je zal even moet wachten",
                      maxLines: 2,
                    ),
                  ),
                );
              } else if (error.response?.statusCode == 403) {
                //Not allowed, Magister's messages are a bit too specific
                if (error.response?.data["Fouttype"] ==
                    "OngeldigeSessieStatus") {
                  // It might be that holiday mode has been enabled, we will
                  // check that just to be sure.
                  // if (Settings.holidayMode != null &&
                  //     (await dio.get("/api/m6/applicatietoegang")).statusCode ==
                  //         403) {
                  //   // Holiday mode is indeed activated, skip the snackbar.
                  //   Settings.holidayMode = true;
                  handler.reject(error);
                  return;
                  // }
                }
                sendSnackBar(
                  uuid: uuid,
                  const SnackBar(
                    content: Text(
                      "Je hebt niet de juiste permissies om dit te doen!",
                      maxLines: 2,
                    ),
                  ),
                );
              } else if (![DioExceptionType.cancel].contains(error.type)) {
                if (error.type == DioExceptionType.connectionError) {
                  // The device might be offline
                  if ((await Connectivity().checkConnectivity()).every(
                    (e) => e == ConnectivityResult.none,
                  )) {
                    // Device is offline, do not display an error message
                    return handler.reject(error);
                  }
                }
                sendSnackBar(
                  uuid: uuid,
                  SnackBar(
                    content: Text(
                      error.response?.data["omschrijving"] ??
                          error.message ??
                          "Whoops, er ging wat fout",
                      maxLines: 2,
                    ),
                  ),
                );
              }
            }
            handler.reject(error);
          },
        ),
        QueuedInterceptorsWrapper(
          onError: (error, handler) async {
            if (error.response?.statusCode == 429) {
              // Magister rate limit
              if (kDebugMode) print(error.response?.data["message"]);

              await Future.delayed(
                Duration(seconds: error.response?.data["secondsLeft"]),
              );

              await dio.fetch(error.requestOptions).then(
                    (r) => handler.resolve(r),
                    onError: (e) => handler.reject(e),
                  );
            }
          },
        )
      ]);
  }
}

Future<void> sendSnackBar(SnackBar snackBar, {int? uuid}) async {
  if (uuid != null || uuid == activeProfile.account.value?.uuid) {
    ScaffoldMessenger.of(navKey.currentContext!).removeCurrentSnackBar();
    ScaffoldMessenger.of(navKey.currentContext!).showSnackBar(snackBar);
  }
}

abstract class MagisterBase {
  final Magister magister;

  MagisterBase(this.magister);
}
