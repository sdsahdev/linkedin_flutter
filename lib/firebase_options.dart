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
    apiKey: 'AIzaSyCmCcWTTUgUb9LoHtUD6SPsZ-KtWLyLBQE',
    appId: '1:517684262329:web:e9a5aaaa72434cafdaf268',
    messagingSenderId: '517684262329',
    projectId: 'fir-projectactivity',
    authDomain: 'fir-projectactivity.firebaseapp.com',
    databaseURL: 'https://fir-projectactivity-default-rtdb.firebaseio.com',
    storageBucket: 'fir-projectactivity.appspot.com',
    measurementId: 'G-3MNT907LJ2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAfkxyNcLe90MNz2K4FDemyqdjOl_jQYNg',
    appId: '1:517684262329:android:29adf8a83daf7009daf268',
    messagingSenderId: '517684262329',
    projectId: 'fir-projectactivity',
    databaseURL: 'https://fir-projectactivity-default-rtdb.firebaseio.com',
    storageBucket: 'fir-projectactivity.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDeb5rnebnNQVhfsatqU-lJNmYMs9LFaNY',
    appId: '1:517684262329:ios:35735e8d8e6cd73fdaf268',
    messagingSenderId: '517684262329',
    projectId: 'fir-projectactivity',
    databaseURL: 'https://fir-projectactivity-default-rtdb.firebaseio.com',
    storageBucket: 'fir-projectactivity.appspot.com',
    androidClientId:
        '517684262329-dtels3tllo1hmtp8tbdq78jgt28vbr64.apps.googleusercontent.com',
    iosClientId:
        '517684262329-ee81s1jqthmes4dmo6q1nnqaumc3ond8.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDeb5rnebnNQVhfsatqU-lJNmYMs9LFaNY',
    appId: '1:517684262329:ios:35735e8d8e6cd73fdaf268',
    messagingSenderId: '517684262329',
    projectId: 'fir-projectactivity',
    databaseURL: 'https://fir-projectactivity-default-rtdb.firebaseio.com',
    storageBucket: 'fir-projectactivity.appspot.com',
    androidClientId:
        '517684262329-dtels3tllo1hmtp8tbdq78jgt28vbr64.apps.googleusercontent.com',
    iosClientId:
        '517684262329-ee81s1jqthmes4dmo6q1nnqaumc3ond8.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCmCcWTTUgUb9LoHtUD6SPsZ-KtWLyLBQE',
    appId: '1:517684262329:web:077a3cc944fec335daf268',
    messagingSenderId: '517684262329',
    projectId: 'fir-projectactivity',
    authDomain: 'fir-projectactivity.firebaseapp.com',
    databaseURL: 'https://fir-projectactivity-default-rtdb.firebaseio.com',
    storageBucket: 'fir-projectactivity.appspot.com',
    measurementId: 'G-XVX7RN14CV',
  );
}
