import 'dart:isolate';

import 'package:discipulus/main.dart';
import 'package:discipulus/utils/platform.dart';
import 'package:flutter/services.dart';

class CustomIsolates<T> {
  /// To return data use
  /// ```
  /// data.sendPort.send(...)
  /// ```
  Future<T> createisolate(
    void Function(IsoLateData<T> data) entryPoint, {
    dynamic message,
  }) async {
    if (AppPlatform.isWeb) {
      throw UnsupportedError("Isolates are not supported on web");
    }
    ReceivePort receivePort = ReceivePort();
    IsoLateData<T> data = IsoLateData<T>(
      data: message,
      rootIsolateToken: rootIsolateToken,
      sendPort: receivePort.sendPort,
    );

    Isolate isolate = await Isolate.spawn<IsoLateData<T>>(entryPoint, data);
    T revievedData = await receivePort.first;
    isolate.kill();
    return revievedData;
  }
}

class IsarIsolate<T> extends CustomIsolates {
  @override
  Future<void> createisolate(
    void Function(IsoLateData<T> data) entryPoint, {
    dynamic message,
  }) async {
    if (AppPlatform.isWeb) {
      throw UnsupportedError("Isolates are not supported on web");
    }
    ReceivePort receivePort = ReceivePort();
    IsoLateData<T> data = IsoLateData<T>(
      data: entryPoint,
      rootIsolateToken: rootIsolateToken,
      sendPort: receivePort.sendPort,
    );

    Isolate isolate = await Isolate.spawn<IsoLateData<T>>((data) async {
      if (data.rootIsolateToken != null) {
        BackgroundIsolateBinaryMessenger.ensureInitialized(data.rootIsolateToken!);
      }
      await initIsar(true);
      data.data();
      isar.close();
    }, data);
    isolate.kill();
  }
}

class IsoLateData<T> {
  RootIsolateToken? rootIsolateToken;
  SendPort sendPort;
  dynamic data;

  IsoLateData({
    this.rootIsolateToken,
    this.data,
    required this.sendPort,
  });
}

