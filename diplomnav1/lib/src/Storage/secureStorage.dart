import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage{
  static final _storage = FlutterSecureStorage();
  static const _keyToken = "accessToken";
  static const _keyOid = "oid";
  String userType = "member";
  //String username = '';


  static Future setToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }
  static Future<String?> getToken() async{
    return await _storage.read(key: _keyToken);
  }
  static Future setOid(String oid) async {
    await _storage.write(key: _keyOid, value: oid);
  }
  static Future<String?> getOid() async{
    return await _storage.read(key: _keyOid);
  }
}