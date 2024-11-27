import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_magnifier/flutter_magnifier.dart';
import 'package:flutter_magnifier/flutter_magnifier_platform_interface.dart';
import 'package:flutter_magnifier/flutter_magnifier_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterMagnifierPlatform
    with MockPlatformInterfaceMixin
    implements FlutterMagnifierPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterMagnifierPlatform initialPlatform = FlutterMagnifierPlatform.instance;

  test('$MethodChannelFlutterMagnifier is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterMagnifier>());
  });

  test('getPlatformVersion', () async {
    FlutterMagnifier flutterMagnifierPlugin = FlutterMagnifier();
    MockFlutterMagnifierPlatform fakePlatform = MockFlutterMagnifierPlatform();
    FlutterMagnifierPlatform.instance = fakePlatform;

    expect(await flutterMagnifierPlugin.getPlatformVersion(), '42');
  });
}
