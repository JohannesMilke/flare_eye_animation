import 'package:flare_eye_animation/utils.dart';
import 'package:flare_eye_animation/widget/face/face_controller.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class FaceWidget extends StatefulWidget {
  @override
  FaceWidgetState createState() => FaceWidgetState();
}

class FaceWidgetState extends State<FaceWidget> {
  FaceController _faceController;
  bool hairsVisible;

  @override
  void initState() {
    super.initState();

    hairsVisible = true;
    _faceController = FaceController();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onPanStart: (details) => onPanUpdate(details.globalPosition),
        onPanUpdate: (details) => onPanUpdate(details.globalPosition),
        child: ListView(
          children: <Widget>[
            buildFace(),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildHairVisibilityButton(),
                buildWaveHeadButton(),
              ],
            )
          ],
        ),
      );

  Widget buildFace() => Container(
        height: 400,
        color: Colors.red.withOpacity(0.75),
        child: FlareActor(
          "assets/face.flr",
          animation: '',
          shouldClip: false,
          fit: BoxFit.contain,
          controller: _faceController,
        ),
      );

  Widget buildWaveHeadButton() => RaisedButton(
        child: Text('Wave head'),
        onPressed: waveHead,
      );

  Widget buildHairVisibilityButton() => RaisedButton(
        child: Text(hairsVisible ? 'Hide hairs' : 'Show hairs'),
        onPressed: changeHairstyle,
      );

  void waveHead() => _faceController.play('head_rotation');

  void changeHairstyle() {
    setState(() {
      hairsVisible = !hairsVisible;
    });

    _faceController.showHair(visible: hairsVisible);
  }

  void onPanUpdate(Offset globalPosition) {
    final Offset offset = Utils.localPosition(context, globalPosition);
    print(offset);
    _faceController.lookAt(offset);
  }
}
