import 'package:flutter/material.dart';

class MyChip extends StatefulWidget {
  final Function()? onPressed;
  final String? label;
  final bool? isSelected;
  final Key? key;

  MyChip({this.onPressed, this.label, this.isSelected, this.key}) : super();
  @override
  _MyChipState createState() => _MyChipState(onPressed: onPressed, label: label, isSelected: isSelected, key: key);
}

class _MyChipState extends State<MyChip> {
  Function()? onPressed;
  String? label;
  bool? isSelected;
  var key;
  _MyChipState({this.onPressed, this.label, this.isSelected, this.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: key,
      onPressed: onPressed,
      child: Text(
        label!,
        style: TextStyle(
          color: isSelected! ? Theme.of(context).colorScheme.onPrimary : Colors.black,
          fontWeight: FontWeight.normal,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected! ? Theme.of(context).colorScheme.primary : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(
            color: isSelected! ? Theme.of(context).colorScheme.primary : Colors.white,
            width: 0.7,
          ),
        ),
      ),
    );
  }
}
