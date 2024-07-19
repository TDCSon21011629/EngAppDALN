import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:eng_app/AssetWidgets/custom_app_bar.dart';
import 'package:eng_app/config/configs.dart';
import 'package:eng_app/providers/home_provider.dart';
import 'package:provider/provider.dart';

import 'history_card.dart';

final svgAsset = 'Assets/Vectors/empty.svg';

class HistoryScreen extends StatelessWidget {
  bool _atBottom = false;
  int currentPageIndex = 4;

  static const id = 'History_Screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomAppBar(
                title: tr('history'),
                isTextWhite: true,
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Consumer(
                  builder: (BuildContext context, HomeProvider homeProvider,
                      Widget child) {
                    if (homeProvider.historyWords.isNotEmpty) {
                      return ListView.builder(
                        itemCount: homeProvider.historyWords.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return const SizedBox(
                              height: 10.0,
                            );
                          }
                          return HistoryCard(
                            word: homeProvider.historyWords[index - 1]['word']
                                as String,
                            date: homeProvider.historyWords[index - 1]['date']
                                    as String ??
                                '',
                            icon: (homeProvider.favWords.contains(
                                    homeProvider.historyWords[index - 1]))
                                ? Icons.bookmark
                                : Icons.bookmark_outline,
                            onPressed: (homeProvider.favWords.contains(
                                    homeProvider.historyWords[index - 1]))
                                ? () => homeProvider.removeFromFav(
                                    homeProvider.historyWords[index - 1])
                                : () => homeProvider.addtoFavorites(
                                    homeProvider.historyWords[index - 1]
                                        as Map<String, dynamic>),
                          );
                        },
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: SvgPicture.asset(
                              svgAsset,
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            tr('empty'),
                            style: kLargeTextStyle,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBBN(atBottom: _atBottom),
    );
  }
}