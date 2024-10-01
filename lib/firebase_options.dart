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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBYiOLg3TwE1AMNu6mDmR34yIfPkqO40mI',
    appId: '1:269662949777:web:0a14c057306e2827a4ca30',
    messagingSenderId: '269662949777',
    projectId: 'tbapp-b8133',
    authDomain: 'tbapp-b8133.firebaseapp.com',
    storageBucket: 'tbapp-b8133.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAsuDDWM1z7Eg9-l6PjCWm0ZYUKXW5CMKY',
    appId: '1:269662949777:android:51fe16659fc0ddbea4ca30',
    messagingSenderId: '269662949777',
    projectId: 'tbapp-b8133',
    storageBucket: 'tbapp-b8133.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB1SE2Og0b7xwbtopuk4dUL7P0eLOmdS0A',
    appId: '1:269662949777:ios:5e84664bc72ecc80a4ca30',
    messagingSenderId: '269662949777',
    projectId: 'tbapp-b8133',
    storageBucket: 'tbapp-b8133.appspot.com',
    iosBundleId: 'com.example.tuberculosisapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB1SE2Og0b7xwbtopuk4dUL7P0eLOmdS0A',
    appId: '1:269662949777:ios:5e84664bc72ecc80a4ca30',
    messagingSenderId: '269662949777',
    projectId: 'tbapp-b8133',
    storageBucket: 'tbapp-b8133.appspot.com',
    iosBundleId: 'com.example.tuberculosisapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBYiOLg3TwE1AMNu6mDmR34yIfPkqO40mI',
    appId: '1:269662949777:web:f314526248cc71bba4ca30',
    messagingSenderId: '269662949777',
    projectId: 'tbapp-b8133',
    authDomain: 'tbapp-b8133.firebaseapp.com',
    storageBucket: 'tbapp-b8133.appspot.com',
  );
}
