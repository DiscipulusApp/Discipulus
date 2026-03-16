import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:discipulus/utils/account_manager.dart';

class AdService {
  /// Initializes the AdMob SDK and handles the Consent Management Platform (CMP)
  /// flow via the User Messaging Platform (UMP) SDK on iOS.
  static Future<void> initialize() async {
    // If the active profile is underage, we do not initialize ads.
    // This also prevents UMP consent forms from showing up for children.
    try {
      if (activeProfile.isUnderage) {
        return;
      }
    } catch (e) {
      // In case activeProfile is not available yet (e.g. during first-time setup)
      // we might want to proceed or wait. For now, we proceed to handle the first-time logic.
    }

    if (Platform.isIOS) {
      final completer = Completer<void>();

      final params = ConsentRequestParameters();

      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        () async {
          ConsentForm.loadAndShowConsentFormIfRequired(
            (formError) async {
              if (formError != null) {
                // Consent gathering failed.
                debugPrint('${formError.errorCode}: ${formError.message}');
              }

              // Proceed to ATT request after consent flow (required or not).
              await _requestATTIfNeeded();

              // Initialize AdMob.
              unawaited(MobileAds.instance.initialize());

              completer.complete();
            },
          );
        },
        (FormError error) {
          // Handle error in requesting consent info update.
          debugPrint('${error.errorCode}: ${error.message}');

          // Even if consent info update fails, try to initialize ads.
          _requestATTIfNeeded().then((_) {
            unawaited(MobileAds.instance.initialize());
            completer.complete();
          });
        },
      );

      return completer.future;
    } else if (Platform.isAndroid) {
      // For now, only basic initialization for Android.
      // CMP can be added here later if needed.
      unawaited(MobileAds.instance.initialize());
    }
  }

  /// Requests App Tracking Transparency authorization if it hasn't been determined yet.
  static Future<void> _requestATTIfNeeded() async {
    if (Platform.isIOS) {
      if (await AppTrackingTransparency.trackingAuthorizationStatus ==
          TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    }
  }
}
