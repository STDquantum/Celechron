import 'dart:io';

import 'package:celechron/utils/platform_features.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:celechron/http/zjuServices/zjuam.dart';
import 'package:celechron/http/zjuServices/ecard.dart';

import '../utils/utils.dart';

class ECardWidgetMessenger {
  static Future<void> update() async {
    var secureStorage = const FlutterSecureStorage();
    var username = await secureStorage.read(key: 'username', iOptions: secureStorageIOSOptions);
    var password = await secureStorage.read(key: 'password', iOptions: secureStorageIOSOptions);
    if (username == null || password == null) return;

    // 如果是测试账号，则直接写入
    if (username == "3200000000") {
      await secureStorage.write(key: 'synjonesAuth',
          value: "3200000000",
          iOptions: secureStorageIOSOptions);
      await secureStorage.write(key: 'eCardAccount',
          value: "3200000000",
          iOptions: secureStorageIOSOptions);

      if (Platform.isIOS || Platform.isAndroid) {
        const platform = MethodChannel('top.celechron.celechron/ecardWidget');
        await platform.invokeMethod('update');
      }
    }

    var httpClient = HttpClient();
    httpClient.userAgent = "E-CampusZJU/2.3.20 (iPhone; iOS 17.5.1; Scale/3.00)";

    try {
      var iPlanetDirectoryPro = await ZjuAm.getSsoCookie(
          httpClient, username, password).catchError((e) => null);
      var synjonesAuth = await ECard.getSynjonesAuth(
          httpClient, iPlanetDirectoryPro);
      var eCardAccount = await ECard.getAccount(httpClient, synjonesAuth);
      await secureStorage.write(key: 'synjonesAuth',
          value: synjonesAuth,
          iOptions: secureStorageIOSOptions);
      await secureStorage.write(key: 'eCardAccount',
          value: eCardAccount,
          iOptions: secureStorageIOSOptions);

      if (PlatformFeatures.hasWidgetSupport) {
        const platform = MethodChannel('top.celechron.celechron/ecardWidget');
        await platform.invokeMethod('update');
      }
    } catch(e) {
      return;
    }
  }

  static Future<void> logout() async {
    var secureStorage = const FlutterSecureStorage();
    await secureStorage.delete(key: 'synjonesAuth', iOptions: secureStorageIOSOptions);

    if(PlatformFeatures.hasWidgetSupport) {
      const platform = MethodChannel('top.celechron.celechron/ecardWidget');
      await platform.invokeMethod('logout');
    }
  }
}