// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:ui/ui.dart';
import 'package:ui/src/engine.dart';
import 'package:test/test.dart';

import '../mock_engine_canvas.dart';

void main() {

  RecordingCanvas underTest;
  MockEngineCanvas mockCanvas;

  setUp(() {
    underTest = RecordingCanvas(Rect.largest);
    mockCanvas = MockEngineCanvas();
  });

  group('drawDRRect', () {
    final RRect rrect = RRect.fromLTRBR(10, 10, 50, 50, Radius.circular(3));
    final Paint somePaint = Paint()..color = const Color(0xFFFF0000);

    test('Happy case', () {
      underTest.drawDRRect(rrect, rrect.deflate(1), somePaint);
      underTest.apply(mockCanvas);
      // Expect drawDRRect to be called
      expect(mockCanvas.methodCallLog.length, equals(1));
      MockCanvasCall mockCall = mockCanvas.methodCallLog[0];
      expect(mockCall.methodName, equals('drawDRRect'));
      expect(mockCall.arguments, equals({
          'outer': rrect,
          'inner': rrect.deflate(1),
          'paint': somePaint.webOnlyPaintData,
        }));
    });

    test('Inner RRect > Outer RRect', () {
      underTest.drawDRRect(rrect, rrect.inflate(1), somePaint);
      underTest.apply(mockCanvas);
      // Expect nothing to be called
      expect(mockCanvas.methodCallLog.length, equals(0));
    });

    test('Inner RRect not completely inside Outer RRect', () {
      underTest.drawDRRect(rrect, rrect.deflate(1).shift(const Offset(0.0, 10)), somePaint);
      underTest.apply(mockCanvas);
      // Expect nothing to be called
      expect(mockCanvas.methodCallLog.length, equals(0));
    });

    test('Inner RRect same as Outer RRect', () {
      underTest.drawDRRect(rrect, rrect, somePaint);
      underTest.apply(mockCanvas);
      // Expect nothing to be called
      expect(mockCanvas.methodCallLog.length, equals(0));
    });
  });
}
