import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  Future addQuizCategory(
      Map<String, dynamic> userQuizCategory, String category) async {
    return await FirebaseFirestore.instance
        .collection(category)
        .add(userQuizCategory);
  }

  Future<Stream<QuerySnapshot>> getCategoryQuiz(String category) async {
    return await FirebaseFirestore.instance.collection(category).snapshots();
  }

  Future<DocumentSnapshot?> getUserData(String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      return snapshot; // Trả về DocumentSnapshot nếu tìm thấy
    } catch (e) {
      print('Error getting user data: $e');
      return null; // Trả về null nếu có lỗi
    }
  }

  Future<void> updateUserData(Map<String, dynamic> userData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(userData);
        print('User data updated successfully!');
      } catch (e) {
        print('Error updating user data: $e');
        // Handle the error (e.g., show a snackbar or dialog to the user)
      }
    }
  }

  // Kiểm tra xem đã có dữ liệu người dùng chưa
  Future<bool> hasUserData(String userId) async {
    DocumentSnapshot? snapshot = await getUserData(userId);
    return snapshot != null && snapshot.exists;
  }

  // Lấy danh sách từ yêu thích của người dùng
  Future<List<Map<String, dynamic>>> getUserFavorites(String userId) async {
    try {
      DocumentSnapshot<Object?>? snapshot = await getUserData(userId);
      if (snapshot != null && snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        if (userData.containsKey('favorites')) {
          List<dynamic> favorites = userData['favorites'];
          return favorites.cast<Map<String, dynamic>>();
        }
      }
      return [];
    } catch (e) {
      print('Error getting user favorites: $e');
      return [];
    }
  }

  // Thêm từ vào danh sách yêu thích của người dùng
  Future<void> addUserFavorite(String userId, Map<String, dynamic> word) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot<Object?>? snapshot = await getUserData(userId);
        List<Map<String, dynamic>> favorites = [];
        if (snapshot != null && snapshot.exists) {
          Map<String, dynamic> userData =
          snapshot.data() as Map<String, dynamic>;
          if (userData.containsKey('favorites')) {
            List<dynamic> favs = userData['favorites'];
            favorites = favs.cast<Map<String, dynamic>>();
          }
        }
        favorites.add(word);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'favorites': favorites});
        print('Favorite word added successfully!');
      } catch (e) {
        print('Error adding favorite word: $e');
      }
    }
  }

  // Xóa từ khỏi danh sách yêu thích của người dùng
  Future<void> removeUserFavorite(String userId, String word) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot<Object?>? snapshot = await getUserData(userId);
        List<Map<String, dynamic>> favorites = [];
        if (snapshot != null && snapshot.exists) {
          Map<String, dynamic> userData =
          snapshot.data() as Map<String, dynamic>;
          if (userData.containsKey('favorites')) {
            List<dynamic> favs = userData['favorites'];
            favorites = favs.cast<Map<String, dynamic>>();
          }
        }
        favorites.removeWhere((item) => item['word'] == word);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'favorites': favorites});
        print('Favorite word removed successfully!');
      } catch (e) {
        print('Error removing favorite word: $e');
      }
    }
  }
}
