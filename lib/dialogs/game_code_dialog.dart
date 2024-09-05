import 'package:flutter/material.dart';

class GameCodeDialog extends StatefulWidget {
  const GameCodeDialog({super.key});

  @override
  State<GameCodeDialog> createState() => _GameCodeDialogState();
}

class _GameCodeDialogState extends State<GameCodeDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).dialogBackgroundColor),
      height: MediaQuery.of(context).size.height/3,
    );
  }
}
