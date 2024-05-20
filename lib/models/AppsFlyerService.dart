import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:synergy/Helpers/logger.dart';

class AppsFlyerService {
  late final AppsFlyerOptions _appsFlyerOptions;
  late final AppsflyerSdk _appsflyerSdk;

  static final AppsFlyerService _instance = AppsFlyerService._internal();

  factory AppsFlyerService() {
    return _instance;
  }

  AppsFlyerService._internal() {
    _initializeOptions();
    _initializeSdk();
  }

  void _initializeOptions() {
    _appsFlyerOptions = AppsFlyerOptions(
      afDevKey: dotenv.env['DEV_KEY']!,
      appId: dotenv.env['APP_ID']!,
      showDebug: true,
      timeToWaitForATTUserAuthorization: 50, // for iOS 14.5
      disableAdvertisingIdentifier: false, // Optional field
      disableCollectASA: false, // Optional field
    );
  }

  Future<void> _initializeSdk() async {
    _appsflyerSdk = AppsflyerSdk(_appsFlyerOptions);

    await _appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
  }

  Future<bool?> logEvent(String eventName, Map? eventValues) async {
    bool? result;
    try {
      result = await _appsflyerSdk.logEvent(eventName, eventValues);
    } on Exception catch (e) {
      LoggerUtil.log().d('Error logging event to AppsFlyer: $e');
    }
    LoggerUtil.log().d("Result logEvent: $result");
    return result;
  }
}