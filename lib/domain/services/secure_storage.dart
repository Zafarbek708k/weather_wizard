// import "package:flutter_secure_storage/flutter_secure_storage.dart";
//
// enum StorageKey {
//   accessToken,
//   refreshToken,
//   pinCode,
//   locale,
//   theme,
//   enter,
//   userName,
//   userEmail,
//   userPassword,
//   user,
// }
//
// class AppStorage extends FlutterSecureStorage {
//
//   factory AppStorage() => _service;
//
//   const AppStorage._internal();
//
//   static const AppStorage _service = AppStorage._internal();
//
//   static const FlutterSecureStorage _storage = FlutterSecureStorage();
//
//   static Future<String?> $read({required StorageKey key}) async {
//     final value = await _storage.read(key: key.name);
//     return value;
//   }
//
//   static Future<void> $write({required StorageKey key, required String value}) async {
//     await _storage.write(key: key.name, value: value);
//   }
//
//   static Future<void> clearAllData() async {
//     await _storage.deleteAll();
//   }
//
//   static Future<void> $delete({required StorageKey key}) async {
//     await _storage.delete(key: key.name);
//   }
//
// }
