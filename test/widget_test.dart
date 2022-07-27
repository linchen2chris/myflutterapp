// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myflutterapp/main.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:async';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('mouse test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('-1'), findsNothing);

    final guesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(guesture.removePointer);
    await guesture.down(tester.getCenter(find.text('decrease').first));
    await tester.pumpAndSettle();

    await guesture.up();

    // await tester.tap(find.text('decrease'));
    await tester.pump();
    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('-1'), findsOneWidget);
  });

  testWidgets("check button width", (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final btn = find.text("decrease").first;

    expect(btn, findsOneWidget);
    expect(tester.getSize(btn).height, 14.0);
    expect(tester.getSize(btn).width, 112.0);
  });

  testWidgets("check button color", (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final btn = find.byType(Image);

    expect(btn, findsOneWidget);
    print(btn.toString());
    final image = tester.widget<Image>(btn);
    print(image.toString());
    final textFinder = tester.widget<Text>(find.byType(Text).first);
    expect(textFinder.style?.color, Colors.red);
    // print("message ${icon.color.toString()}");
    // expect(color, const Color(0xFFFFFFFF));
  });

  testWidgets("check image color", (WidgetTester tester) async {
    Future<ui.Image> loadImageByProvider(
      ImageProvider provider, {
      ImageConfiguration config = ImageConfiguration.empty,
    }) async {
      Completer<ui.Image> completer = Completer<ui.Image>(); //完成的回调
      ImageStreamListener? listener = null;
      ImageStream stream = provider.resolve(config); //获取图片流
      listener = ImageStreamListener((ImageInfo frame, bool sync) {
//监听
        final ui.Image image = frame.image;
        completer.complete(image); //完成
        stream.removeListener(listener!); //移除监听
      });
      stream.addListener(listener); //添加监听
      return completer.future; //返回
    }

    await tester.pumpWidget(const MyApp());
    print("start");
    final btn = find.byType(Image);
    print("btn $btn");

    expect(btn, findsOneWidget);
    final image = tester.widget<Image>(btn).image;
    print("image: $image");
    final uiImage = await loadImageByProvider(image);
    print("dfsdf, $uiImage");
    final imageBytes = await uiImage.toByteData();
    print("jjj, $imageBytes");

    // final textFinder = tester.widget<Text>(find.byType(Text).first);
    // expect(textFinder.style?.color, Colors.red);
    // print("message ${icon.color.toString()}");
    // expect(color, const Color(0xFFFFFFFF));
  });
}
