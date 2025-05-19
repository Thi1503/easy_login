import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'auth_token';

  /// Lưu token (sau khi login thành công)
  static Future<void> saveToken(String token) =>
      _storage.write(key: _keyToken, value: token);

  /// Đọc token (khi cần gửi kèm header)
  static Future<String?> readToken() => _storage.read(key: _keyToken);

  /// Xoá token (khi logout)
  static Future<void> deleteToken() => _storage.delete(key: _keyToken);
}
