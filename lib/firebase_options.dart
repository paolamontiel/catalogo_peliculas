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
    apiKey: 'AIzaSyAuaelAmyIrKQUnYfnvTkQijfqMCEW0yfM',
    appId: '1:890669890968:web:367e860e1812368d613fed',
    messagingSenderId: '890669890968',
    projectId: 'app-catalogo-5ad21',
    authDomain: 'app-catalogo-5ad21.firebaseapp.com',
    storageBucket: 'app-catalogo-5ad21.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAa9MKhRndO2hvgG_laVdZm8p1lQZlKi24',
    appId: '1:890669890968:android:766e0d62b919ee8a613fed',
    messagingSenderId: '890669890968',
    projectId: 'app-catalogo-5ad21',
    storageBucket: 'app-catalogo-5ad21.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDnN-ujZa-AH6tiCoDGUbUWVCd-1qXA7gE',
    appId: '1:890669890968:ios:83bf49ba9bab2308613fed',
    messagingSenderId: '890669890968',
    projectId: 'app-catalogo-5ad21',
    storageBucket: 'app-catalogo-5ad21.firebasestorage.app',
    iosBundleId: 'com.example.catalogoDePeliculas',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDnN-ujZa-AH6tiCoDGUbUWVCd-1qXA7gE',
    appId: '1:890669890968:ios:83bf49ba9bab2308613fed',
    messagingSenderId: '890669890968',
    projectId: 'app-catalogo-5ad21',
    storageBucket: 'app-catalogo-5ad21.firebasestorage.app',
    iosBundleId: 'com.example.catalogoDePeliculas',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAuaelAmyIrKQUnYfnvTkQijfqMCEW0yfM',
    appId: '1:890669890968:web:daf0df00a2d3d40a613fed',
    messagingSenderId: '890669890968',
    projectId: 'app-catalogo-5ad21',
    authDomain: 'app-catalogo-5ad21.firebaseapp.com',
    storageBucket: 'app-catalogo-5ad21.firebasestorage.app',
  );
}
