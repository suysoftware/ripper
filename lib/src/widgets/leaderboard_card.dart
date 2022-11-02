import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LeaderBoardCard extends StatelessWidget {
  final String userName;
  final String userYear;
  const LeaderBoardCard(this.userName, this.userYear, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Text(''),
    );
  }
}
