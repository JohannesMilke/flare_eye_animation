import 'package:flare_eye_animation/widget/teddy/teddy_controller.dart';
import 'package:flare_eye_animation/widget/tracking_text_input.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class TeddyWidget extends StatefulWidget {
  @override
  TeddyWidgetState createState() => TeddyWidgetState();
}

class TeddyWidgetState extends State<TeddyWidget> {
  TeddyController _teddyController;
  @override
  void initState() {
    super.initState();

    _teddyController = TeddyController();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Container(
            height: 200,
            child: FlareActor(
              "assets/teddy.flr",
              shouldClip: false,
              alignment: Alignment.bottomCenter,
              fit: BoxFit.contain,
              controller: _teddyController,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TrackingTextInput(
                label: "Email",
                hint: "What's your email address?",
                onCaretMoved: (Offset caret) {
                  _teddyController.lookAt(caret);
                }),
          ),
        ],
      );
}
