import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:eng_app/services/authentication.dart';
import 'package:eng_app/config/configs.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key key,
    this.isTextWhite = false,
    @required this.title,
  }) : super(key: key);

  final String title;
  final bool isTextWhite;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
          child: Text(
            title,
            style: (isTextWhite)
                ? kAppBarStyle.copyWith(color: Colors.white)
                : kAppBarStyle,
          ),
        ),
        Container(
          child: CircleAvatar(
            radius: 20.0,
            backgroundImage: AuthMethod().getProfilePhoto(),
            backgroundColor: Colors.transparent,
            onBackgroundImageError: (exception, stackTrace) =>
                log('$exception \n $stackTrace'),
          ),
        )
      ],
    );
  }
}