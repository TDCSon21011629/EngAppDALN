import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/database.dart';
import '../widget/edit_item.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path/path.dart';
import 'package:path/path.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? gender = "Nam";
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  File? selectedImage;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    selectedImage = File(image!.path);
    setState(() {});
  }




  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    try{
      if (user != null) {
        DocumentSnapshot? userData =
        await DatabaseMethods().getUserData(user.uid);
        if (userData != null && userData.exists) {
          setState(() {
            // Cập nhật giao diện với dữ liệu từ Firestore
            nameController.text = userData['name'] ?? '';
            emailController.text = userData['email'] ?? '';
            gender = userData['gender'] ?? 'Nam';
            ageController.text = userData['age']?.toString() ?? '';
            _imageUrl = userData['imageUrl'];
          });
        }
      }
    }catch (e) {
      print('Error loading user data: $e');

    }

  }


  Future<void> updateProfile(BuildContext context) async {
    try {
      if (user != null) {
        String? imageUrl;

        // Nếu có ảnh mới được chọn
        if (selectedImage != null) {
          Reference firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child("profile_images/${basename(selectedImage!.path)}");

          final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

          var downloadUrl = await (await task).ref.getDownloadURL();
          imageUrl = downloadUrl;
        } else if (_imageUrl != null) {

          imageUrl = _imageUrl;
        }

        Map<String, dynamic> userData = {
          'name': nameController.text,
          'gender': gender,
          'age': int.tryParse(ageController.text) ?? 0,
          'email': emailController.text,
          'imageUrl': imageUrl,
        };

        await DatabaseMethods().updateUserData(userData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật thành công')),
        );
      }
    } catch (e) {
      print('Error updating user data: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật hồ sơ thất bại')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.chevron_back_outline),
        ),
        leadingWidth: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                updateProfile(context);
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                fixedSize: Size(60, 50),
                elevation: 3,
              ),
              icon: Icon(Ionicons.checkmark, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Account",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Photo",
                widget: Column(
                  children: [
                    // Hiển thị ảnh đại diện
                    _imageUrl != null || selectedImage != null
                        ? Center( // Căn giữa ảnh khi hiển thị
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect( // Giữ ảnh trong phạm vi border tròn
                            borderRadius: BorderRadius.circular(20),
                            child: _imageUrl != null
                                ? Image.network(
                              _imageUrl!,
                              fit: BoxFit.cover,
                            )
                                : Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                        : GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Center( // Căn giữa icon khi chưa có ảnh
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (_imageUrl == null &&
                        selectedImage == null) // Chỉ hiển thị nút "Upload Image" nếu chưa có ảnh
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0), // Thêm padding trên nút
                        child: TextButton(
                          onPressed: getImage,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.lightBlueAccent,
                          ),
                          child: const Text("Upload Image"),
                        ),
                      ),
                  ],
                ),
              ),
              EditItem(
                title: "Name",
                widget: TextField(
                  controller: nameController, // Sử dụng controller cho name
                ),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Gender",
                widget: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          gender = "man";
                        });
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: gender == "man"
                            ? Colors.deepPurple
                            : Colors.grey.shade200,
                        fixedSize: const Size(50, 50),
                      ),
                      icon: Icon(
                        Ionicons.male,
                        color: gender == "man" ? Colors.white : Colors.black,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          gender = "woman";
                        });
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: gender == "woman"
                            ? Colors.deepPurple
                            : Colors.grey.shade200,
                        fixedSize: const Size(50, 50),
                      ),
                      icon: Icon(
                        Ionicons.female,
                        color: gender == "woman" ? Colors.white : Colors.black,
                        size: 18,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Age",
                widget: TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Email",
                widget: TextField(
                  controller: emailController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
