import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_project/controllers/auth_controller.dart';
import 'package:tiktok_project/views/screens/add_video_screen.dart';

//LIST OF PAGES WE HAVE

final pages = [
  Text('Home Page'),
  Text('Search Page'),
  AddVideoScreen(),
  Text('Message Page'),
  Text('Profile  Page'),
];

//Colors
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];

//FIREBASE

var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

//Controller

var authController = AuthController.instance;
