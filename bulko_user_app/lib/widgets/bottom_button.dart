import 'package:flutter/material.dart';

class BottomButton extends StatefulWidget {
  final Widget? child;
  final Function()? onPressed;
  @required
  final bool? loadingState;
  final bool? disabledState;
  final Key? key;

  BottomButton({this.child, this.loadingState, this.disabledState, this.onPressed, this.key}) : super();
  @override
  _BottomButtonState createState() => _BottomButtonState(child: child, onPressed: onPressed, loadingState: loadingState, disabledState: disabledState, key: key);
}

class _BottomButtonState extends State<BottomButton> {
  Widget? child;
  Function()? onPressed;
  bool? loadingState;
  bool? disabledState;
  var key;

  _BottomButtonState({this.child, this.loadingState, this.disabledState, this.onPressed, this.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: FilledButton(
        child: !loadingState!
            ? child
            : SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                ),
              ),
        onPressed: loadingState! || disabledState! ? null : onPressed,
      ),
    );
  }
}
