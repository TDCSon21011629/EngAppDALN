import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Sau khi đăng xuất thành công, điều hướng về màn hình đăng nhập
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/', // Route của màn hình đăng nhập
            (Route<dynamic> route) => false, // Loại bỏ tất cả các route trước đó
      );
    } catch (e) {
      // Xử lý lỗi nếu có (ví dụ: hiển thị thông báo lỗi cho người dùng)
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _signOut,
          child: Text('Đăng xuất'),
        ),
      ),
    );
  }
}
