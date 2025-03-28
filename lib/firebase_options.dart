// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCPQoJUGvtzhbpFF0nuBuso9VrVvFCpKco',
    appId: '1:109599746267:android:0ca35af31374e3e8e644fe',
    messagingSenderId: '109599746267',
    projectId: 'fir-kpi-9f606',
    databaseURL: 'https://fir-kpi-9f606-default-rtdb.firebaseio.com',
    storageBucket: 'fir-kpi-9f606.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC1dT7ysF1ss5J5JUK24I5_V5RLtUWKnFk',
    appId: '1:109599746267:ios:b98eff3dc1679501e644fe',
    messagingSenderId: '109599746267',
    projectId: 'fir-kpi-9f606',
    databaseURL: 'https://fir-kpi-9f606-default-rtdb.firebaseio.com',
    storageBucket: 'fir-kpi-9f606.firebasestorage.app',
    iosClientId: '109599746267-i3tfl0p9ev8s7h3t35tcvimd0lu0fkd5.apps.googleusercontent.com',
    iosBundleId: 'com.example.kpi',
  );
}
