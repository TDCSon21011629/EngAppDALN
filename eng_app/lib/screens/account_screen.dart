import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_theme.dart';
import '../services/database.dart';
import '../widget/setting_switch.dart';
import './edit_screen.dart';
import '../widget/forward_button.dart';
import '../widget/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}



class _AccountScreenState extends State<AccountScreen> {
  bool isDarkMode = false;
  String? _userName = "";
  String? _userImageUrl;
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      Navigator.of(context).pushReplacementNamed('/Login');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Tải dữ liệu người dùng khi khởi tạo
    _loadDarkMode();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot? userData = await DatabaseMethods().getUserData(user.uid);
      if (userData != null && userData.exists) {
        setState(() {
          _userName = userData['name'] ?? '';
          _userImageUrl = userData['imageUrl'];
        });
      }
    }
  }

  Future<void> _loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        leadingWidth: 80,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Cài đặt",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Tài khoản",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    // Hiển thị ảnh đại diện, nếu không có thì dùng ảnh mặc định
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: _userImageUrl != null
                          ? NetworkImage(_userImageUrl!)
                          : AssetImage('images/default_avatar.png') as ImageProvider, // Sử dụng ảnh mặc định
                    ),
                    const SizedBox(width: 20),
                    Column( // Sử dụng Column để hiển thị tên người dùng
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName!, // Hiển thị tên người dùng
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                    const Spacer(),
                    ForwardButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditAccountScreen(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Cài đặt",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "Ngôn ngữ",
                icon: Ionicons.earth,
                bgColor: Colors.orange.shade100,
                iconColor: Colors.orange,
                value: "Tiếng Việt",
                onTap: () {},
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "Thông báo ",
                icon: Ionicons.notifications,
                bgColor: Colors.blue.shade100,
                iconColor: Colors.blue,
                onTap: () {},
              ),
              const SizedBox(height: 20),
              SettingSwitch(
                title: "Chế độ tối",
                icon: Ionicons.earth,
                bgColor: Colors.purple.shade100,
                iconColor: Colors.purple,
                value: isDarkMode,
                onTap: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "Trợ giúp",
                icon: Ionicons.nuclear,
                bgColor: Colors.red.shade100,
                iconColor: Colors.red,
                onTap: () {},
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "Đăng xuất",
                icon: Ionicons.log_out_outline,
                bgColor: Colors.red.shade100,
                iconColor: Colors.red,
                onTap: _signOut,
                hasForwardButton: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
