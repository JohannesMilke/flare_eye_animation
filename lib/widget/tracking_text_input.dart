import 'package:flare_eye_animation/widget/input_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef void CaretMoved(Offset globalCaretPosition);

class TrackingTextInput extends StatefulWidget {
  final CaretMoved onCaretMoved;
  final ValueChanged<String> onTextChanged;
  final String hint;
  final String label;
  final bool isObscured;

  const TrackingTextInput({
    Key key,
    this.onCaretMoved,
    this.onTextChanged,
    this.hint,
    this.label,
    this.isObscured = false,
  }) : super(key: key);

  @override
  _TrackingTextInputState createState() => _TrackingTextInputState();
}

class _TrackingTextInputState extends State<TrackingTextInput> {
  final GlobalKey _fieldKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _textController.addListener(() {
      _updateCaretPosition();
      _updateText();
    });
    super.initState();
  }

  void _updateCaretPosition() {
    final BuildContext context = _fieldKey.currentContext;
    if (context == null) return;

    final RenderObject fieldBox = context.findRenderObject();
    final caretPosition = getCaretPosition(fieldBox);

    if (widget.onCaretMoved != null) {
      widget.onCaretMoved(caretPosition);
    }
  }

  void _updateText() {
    if (widget.onTextChanged != null) {
      widget.onTextChanged(_textController.text);
    }
  }

  @override
  void dispose() {
    _textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: TextFormField(
          decoration: InputDecoration(
            hintText: widget.hint,
            labelText: widget.label,
          ),
          key: _fieldKey,
          controller: _textController,
          obscureText: widget.isObscured,
          validator: (value) {},
        ),
      );
}
