import 'package:flutter/material.dart';

class PinInput extends StatefulWidget {
  final Function(String) onCompleted;
  const PinInput({super.key, required this.onCompleted});

  @override
  State<PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  final List<String> _pin = ['', '', '', ''];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      _focusNodes.add(FocusNode());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 50,
          child: TextField(
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: const InputDecoration(
              counterText: '',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _pin[index] = value;
              });

              if (value.isNotEmpty && index < 3) {
                _focusNodes[index + 1].requestFocus();
              }

              if (_pin.every((digit) => digit.isNotEmpty)) {
                FocusScope.of(context).unfocus();
                widget.onCompleted(_pin.join());
              }
            },
            onSubmitted: (_) {
              if (index == 3 && _pin.every((digit) => digit.isNotEmpty)) {
                FocusScope.of(context).unfocus();
                widget.onCompleted(_pin.join());
              }
            },
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
