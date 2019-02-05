import 'dart:math';
import 'dart:ui';

import 'package:flare_dart/actor_node_solo.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_dart/math/vec2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controls.dart';

class FaceController extends FlareControls {
  ActorNodeSolo _hair;
  ActorNode _faceControl;

  Mat2D _globalToFlareWorld = Mat2D();

  bool _hasFocus = false;

  Vec2D _appGlobal = Vec2D();
  Vec2D _flareGlobal = Vec2D();

  Vec2D _faceOrigin = Vec2D();
  Vec2D _faceOriginLocal = Vec2D();

  @override
  void initialize(FlutterActorArtboard artboard) {
    super.initialize(artboard);

    _hair = artboard.getNode('hair');

    _faceControl = artboard.getNode('control_face');
    _faceControl.getWorldTranslation(_faceOrigin);
    Vec2D.copy(_faceOriginLocal, _faceControl.translation);
  }

  static const double _projectGaze = 10.0;

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    super.advance(artboard, elapsed);

    Vec2D targetTranslation;
    if (_hasFocus) {
      Vec2D.transformMat2D(_flareGlobal, _appGlobal, _globalToFlareWorld);

      // Eyes will move into both directions
      _flareGlobal[1] +=
          sin(DateTime.now().millisecondsSinceEpoch / 300.0) * 70.0;

      // Compute direction vector.
      Vec2D toCaret = Vec2D.subtract(Vec2D(), _flareGlobal, _faceOrigin);
      Vec2D.normalize(toCaret, toCaret);
      Vec2D.scale(toCaret, toCaret, _projectGaze);

      // Compute the transform that gets us in face "ctrl_face" space.
      Mat2D toFaceTransform = Mat2D();
      if (Mat2D.invert(toFaceTransform, _faceControl.parent.worldTransform)) {
        // Put toCaret in local space, note we're using a direction vector
        // not a translation so transform without translation
        Vec2D.transformMat2(toCaret, toCaret, toFaceTransform);
        // Our final "ctrl_face" position is the original face translation plus this direction vector
        targetTranslation = Vec2D.add(Vec2D(), toCaret, _faceOriginLocal);
      }
    } else {
      targetTranslation = Vec2D.clone(_faceOriginLocal);
    }

    // We could just set _faceControl.translation to targetTranslation, but we want to animate it smoothly to this target
    // so we interpolate towards it by a factor of elapsed time in order to maintain speed regardless of frame rate.
    Vec2D diff =
        Vec2D.subtract(Vec2D(), targetTranslation, _faceControl.translation);
    Vec2D frameTranslation = Vec2D.add(Vec2D(), _faceControl.translation,
        Vec2D.scale(diff, diff, min(1.0, elapsed * 5.0)));

    _faceControl.translation = frameTranslation;

    return true;
  }

  @override
  void setViewTransform(Mat2D viewTransform) =>
      Mat2D.invert(_globalToFlareWorld, viewTransform);

  void showHair({bool visible = true}) =>
      _hair.activeChildIndex = visible ? 1 : 0;

  void lookAt(Offset offset) {
    if (offset == null) {
      _hasFocus = false;
      return;
    }
    _appGlobal = Vec2D.fromValues(offset.dx, offset.dy);
    _hasFocus = true;
  }
}
