import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_project/const.dart';
import 'package:tiktok_project/models/user.dart' as model;
import 'package:tiktok_project/views/screens/auth/login_screen.dart';
import 'package:tiktok_project/views/screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

//Function to pick image from gallery
  late Rx<File?> _pickedImage;
  late Rx<User?> _user;

  File? get profilePhoto => _pickedImage.value;
  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialState);
  }

  _setInitialState(User? user) {
    if (user == null) {
      Get.offAll(LoginScreen());
    } else {
      Get.offAll(HomeScreen());
    }
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      Get.snackbar(
          'Profile Photo', 'Congratulations your image has been uploaded');
    }

    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  Future<String> _uploadImageToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  //registering users
  void registerUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // we want to save the user to auth and to firebase firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String downloadUrl = await _uploadImageToStorage(image);
        model.User user = model.User(
            name: username,
            profilePhoto: downloadUrl,
            email: email,
            uid: cred.user!.uid);
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar('Error creating Account', 'Please enter all fields');
      }
    } catch (e) {
      Get.snackbar('Error creating Account', e.toString());
    }
  }
// RegisterUser function ends here

//Function to login User

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        print('logged in already');
        Get.offAll(HomeScreen());
      } else {
        Get.snackbar('Error logging in', 'Please enter all fields');
      }
    } catch (e) {
      Get.snackbar('Error logging in', e.toString());
    }
  }
}
