import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:navigation_view/item_navigation_view.dart';
import 'package:navigation_view/navigation_view.dart';
import '../main.dart';

class AppBBN extends StatefulWidget {
  const AppBBN({
    Key? key,
    required this.atBottom,
    required this.onTap,
  }) : super(key: key);

  final bool atBottom;
  final Function(int) onTap;

  @override
  _AppBBNState createState() => _AppBBNState();
}

class _AppBBNState extends State<AppBBN> {
  int _selectedIndex = 4;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return NavigationView(
      onChangePage: _onItemTapped,
      curve: Curves.fastEaseInToSlowEaseOut,
      durationAnimation: const Duration(milliseconds: 400),
      backgroundColor: theme.scaffoldBackgroundColor,
      borderTopColor: Theme.of(context).brightness == Brightness.light
          ? widget.atBottom
          ? theme.primaryColor
          : null
          : null,
      color: theme.primaryColor,
      items: [
        _buildNavigationItem(IconlyBold.setting, IconlyBroken.setting, "Settings", 0),
        _buildNavigationItem(IconlyBold.bookmark, IconlyBroken.bookmark, "Quiz", 1),
        _buildNavigationItem(IconlyBold.chat, IconlyBroken.chat, "Dịch", 2),
        _buildNavigationItem(IconlyBold.search, IconlyBroken.search, "Tìm kiếm", 3),
        _buildNavigationItem(IconlyBold.home, IconlyBroken.home, "Home", 4),
      ],
    );
  }

  ItemNavigationView _buildNavigationItem(IconData iconAfter, IconData iconBefore, String label, int index) {
    final ThemeData theme = Theme.of(context);
    final bool isSelected = _selectedIndex == index;

    return ItemNavigationView(
      childAfter: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconAfter,
            color: isSelected ? theme.primaryColor : theme.dialogBackgroundColor,
            size: isSelected ? 35 : 30,
          ),
          if (isSelected)
            Text(
              label,
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 12,
              ),
            ),
        ],
      ),
      childBefore: Icon(
        iconBefore,
        color: isSelected ? theme.primaryColor : theme.dialogBackgroundColor,
        size: isSelected ? 30 : 25,
      ),
    );
  }
}
