import 'package:flutter/material.dart';
import 'package:planetx_client/component/clue_log.dart';
import 'package:planetx_client/component/message_bar.dart';
import 'package:planetx_client/component/op_bar.dart';
import 'package:planetx_client/component/op_log.dart';
import 'package:planetx_client/component/star_map.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom:4.0),
              child: MessageBar(),
            ),
            RoomInfos(),
            OpBar(),
            LayoutBuilder(builder: (context, constraints) {
              // print("width: ${constraints.maxWidth}, height: ${constraints.maxHeight}");
              if (constraints.maxWidth > 1000) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 45, child: const StarMap()),
                    Flexible(
                      flex: 55,
                      child: Column(
                        children: [
                          OpLog(),
                          SizedBox(height: 2),
                          ClueLog(),
                          SizedBox(height: 2),
                          MeetingLog(),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    const StarMap(),
                    OpLog(),
                    SizedBox(height: 2),
                    ClueLog(),
                    SizedBox(height: 2),
                    MeetingLog(),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
