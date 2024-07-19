import 'package:flutter/material.dart';
import 'package:eng_app/config/configs.dart';
import 'package:eng_app/hive/hive_db.dart';
import 'package:eng_app/providers/home_provider.dart';
import 'package:eng_app/services/utils.dart';
import 'package:provider/provider.dart';

class HistoryCard extends StatelessWidget {
  HistoryCard({
    @required this.word,
    @required this.date,
    @required this.icon,
    @required this.onPressed,
  });

  final String word;
  final String date;
  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        color: kDismissColor,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      key: Key(word),
      onDismissed: (direction) async {
        HiveDB.instance.remove(word);
        Provider.of<HomeProvider>(context, listen: false).getHistory();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  capitalize(word),
                  style: kCardTextStyle,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(date),
              ],
            ),
            IconButton(
              onPressed: onPressed,
              icon: Icon(
                icon,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}