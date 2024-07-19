import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final Function()? onTap; // Cho phép onTap là null
  final String? value; // Cho phép value là null
  final bool hasForwardButton; // Thêm thuộc tính để kiểm soát hiển thị ForwardButton

  const SettingItem({
    super.key,
    required this.title,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
    this.onTap,
    this.value,
    this.hasForwardButton = true, // Mặc định là có ForwardButton
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 30,
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (value != null)
              Text(
                value!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            if (hasForwardButton) // Chỉ hiển thị ForwardButton nếu hasForwardButton là true
              const Icon(Ionicons.chevron_forward_outline),
          ],
        ),
      ),
    );
  }
}
