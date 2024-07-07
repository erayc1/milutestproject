import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../models/post_model.dart';

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  List<Post> _userPosts = []; // Kullanıcıya özel gönderiler
  bool _isLoading = false;

  List<Post> get posts => _posts;
  List<Post> get userPosts => _userPosts; // Kullanıcıya özel gönderiler
  bool get isLoading => _isLoading;

  PostProvider() {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    _isLoading = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    // Fake postlar
    _posts = [
      Post(
          id: '1',
          date: '2023-07-07',
          headerText: 'Header 1',
          bodyText: 'Body 1',
          imageUrl: 'assets/images/1.jpg',
          userId: '1'),
      Post(
          id: '2',
          date: '2023-07-06',
          headerText: 'Header 2',
          bodyText: 'Body 2',
          imageUrl: 'assets/images/2.jpg',
          userId: '1'),
      Post(
          id: '3',
          date: '2023-07-05',
          headerText: 'Header 3',
          bodyText: 'Body 3',
          imageUrl: 'assets/images/3.jpg',
          userId: '1'),
      Post(
          id: '4',
          date: '2023-07-04',
          headerText: 'Header 4',
          bodyText: 'Body 4',
          imageUrl: 'assets/images/4.jpg',
          userId: '1'),
      Post(
          id: '5',
          date: '2023-07-03',
          headerText: 'Header 5',
          bodyText: 'Body 5',
          imageUrl: 'assets/images/5.jpg',
          userId: '1'),
      Post(
          id: '6',
          date: '2023-07-02',
          headerText: 'Header 6',
          bodyText: 'Body 6',
          imageUrl: 'assets/images/6.jpg',
          userId: '1'),
      Post(
          id: '7',
          date: '2023-07-01',
          headerText: 'Header 7',
          bodyText: 'Body 7',
          imageUrl: 'assets/images/7.jpg',
          userId: '1'),
      Post(
          id: '8',
          date: '2023-06-30',
          headerText: 'Header 8',
          bodyText: 'Body 8',
          imageUrl: 'assets/images/8.jpg',
          userId: '1'),
      Post(
          id: '9',
          date: '2023-06-29',
          headerText: 'Header 9',
          bodyText: 'Body 9',
          imageUrl: 'assets/images/9.jpg',
          userId: '1'),
      Post(
          id: '10',
          date: '2023-06-28',
          headerText: 'Header 10',
          bodyText: 'Body 10',
          imageUrl: 'assets/images/10.jpg',
          userId: '1'),
    ];

    // Firebase'den gönderileri getirir ve listeye ekler.
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date', descending: true)
        .get();

    _posts.addAll(snapshot.docs
        .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList());

    // Gönderileri tarihe göre sıralar.
    _posts.sort((a, b) => b.date.compareTo(a.date));

    _isLoading = false;
    // notifyListeners() çağrısı, widget ağacının oluşturulmasını beklemek için kullanılır.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /// Yeni bir gönderi ekler ve ardından tüm gönderileri yeniden getirir.
  Future<void> addPost(Post post) async {
    await FirebaseFirestore.instance.collection('posts').add(post.toMap());
    fetchPosts();
  }

  /// Belirli bir kullanıcıya ait gönderileri getirir ve `_userPosts` listesine ekler.
  Future<void> fetchPostsByUserId(String userId) async {
    _isLoading = true;
    // notifyListeners() çağrısı, widget ağacının oluşturulmasını beklemek için kullanılır.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();

    _userPosts = snapshot.docs
        .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    _isLoading = false;
    // notifyListeners() çağrısı, widget ağacının oluşturulmasını beklemek için kullanılır.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /// Belirli bir gönderiyi siler ve ardından tüm gönderileri yeniden getirir.
  Future<void> deletePost(String postId) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    fetchPosts();
  }
}
