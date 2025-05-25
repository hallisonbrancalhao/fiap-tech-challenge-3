import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_challenge_3/common/bloc/button/button_state_cubit.dart';

import '../../bloc/button/button_state.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? shadowColor;
  const BasicAppButton({
    required this.onPressed,
    this.title = '',
    this.height,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.shadowColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonStateCubit, ButtonState>(
      builder: (context, state) {
        if (state is ButtonLoadingState) {
          return _loading(context);
        }
        return _initial(context);
      },
    );
  }

  Widget _loading(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: Colors.grey,
        minimumSize: Size(
          width ?? MediaQuery.of(context).size.width,
          height ?? 60,
        ),
      ),
      child: const CircularProgressIndicator(color: Colors.white),
    );
  }

  Widget _initial(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? Colors.white;
    final effectiveTextColor = textColor ?? Colors.blue;
    final effectiveShadowColor =
        shadowColor ?? const Color(0xff3461FD).withOpacity(0.8);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: effectiveShadowColor,
            offset: const Offset(0, 5),
            blurRadius: 17,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          minimumSize: Size(
            width ?? MediaQuery.of(context).size.width,
            height ?? 60,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: effectiveTextColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
