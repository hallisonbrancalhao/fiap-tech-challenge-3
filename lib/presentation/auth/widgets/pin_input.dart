import 'package:flutter/material.dart';

class PinInput extends StatefulWidget {
  final Function(String) onCompleted;
  final VoidCallback? onReset;
  const PinInput({super.key, required this.onCompleted, this.onReset});

  @override
  State<PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  final List<String> _pin = ['', '', '', ''];
  final List<FocusNode> _focusNodes = [];
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      _focusNodes.add(FocusNode());
      _controllers.add(TextEditingController());
    }
  }

  void resetPin() {
    setState(() {
      for (int i = 0; i < 4; i++) {
        _pin[i] = '';
        _controllers[i].clear();
      }
    });
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 50,
          child: TextField(
            controller: _controllers[index],
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
                final completedPin = _pin.join();
                FocusScope.of(context).unfocus();
                widget.onCompleted(completedPin);
              }
            },
            onSubmitted: (_) {
              if (index == 3 && _pin.every((digit) => digit.isNotEmpty)) {
                final completedPin = _pin.join();
                FocusScope.of(context).unfocus();
                widget.onCompleted(completedPin);
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
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
