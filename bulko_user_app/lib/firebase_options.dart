// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC8zXQwEqQFICc-6LkkW53xtCB1PtlWlSw',
    appId: '1:417010229849:web:114cdc0aa75f98aeb00748',
    messagingSenderId: '417010229849',
    projectId: 'bulkotest',
    authDomain: 'bulkotest.firebaseapp.com',
    storageBucket: 'bulkotest.appspot.com',
    measurementId: 'G-DLY1HG98W4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBY-E2b8T6VdhTdr4rXZ3BvjAvQIhaYZ54',
    appId: '1:417010229849:android:a480b3ecca03dc2eb00748',
    messagingSenderId: '417010229849',
    projectId: 'bulkotest',
    storageBucket: 'bulkotest.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCgKxdixnPF9MPa1mwwINqujC-heJOTreg',
    appId: '1:417010229849:ios:906737be1d3c063cb00748',
    messagingSenderId: '417010229849',
    projectId: 'bulkotest',
    storageBucket: 'bulkotest.appspot.com',
    iosBundleId: 'com.bitinfusion.bulko.user',
  );
}
