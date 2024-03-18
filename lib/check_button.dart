import 'package:flutter/material.dart';
import 'package:poker_game/helpers/const.dart';

class CheckButton extends StatefulWidget {
  Function onPressed;
  String text;
   CheckButton({super.key, required this.onPressed, required this.text});

  @override
  State<CheckButton> createState() => _CheckButtonState();
}

class _CheckButtonState extends State<CheckButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
                            onPressed: () {
                              widget.onPressed();
                              // setState(() {
                              //   // checkNumber(value);
                              // });
                            },
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white),
                            child: Text(widget.text,
                              style: myTextStyle,
                            ));
  }
}