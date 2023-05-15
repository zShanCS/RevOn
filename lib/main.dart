import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'BookListScreen.dart';
import 'BooksProvider.dart';
import 'LoginScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // for (var book in bookList) {
  //   firestore.collection('books').doc(book.id).set({
  //     'title': book.title,
  //     'author': book.author,
  //     'image': book.imageUrl,
  //     'overview': book.overview,
  //     'authorIntro': book.authorIntro,
  //     'reviews': book.reviews
  //         .map((review) => {
  //               'time': review.time.toUtc(),
  //               'rating': review.rating,
  //               'text': review.text,
  //               'user': {
  //                 'id': review.user.id,
  //                 'name': review.user.name,
  //               },
  //             })
  //         .toList(),
  //   }).then((value) {
  //     print('Added ${book.title} to Firestore');
  //   }).catchError((error) => print('Error adding ${book.title}: $error'));
  // }

  runApp(MyApp());
}

// void addReviewForBook(String bookId, Review review) {
//   CollectionReference reviewsCollectionRef =
//       FirebaseFirestore.instance.collection('books/$bookId/reviews');
//   DocumentReference newReviewDocRef = reviewsCollectionRef.doc();

//   Map<String, dynamic> reviewData = {
//     'rating': review.rating,
//     'text': review.text,
//     'user': {
//       'id': review.user.id,
//       'name': review.user.name,
//       'imageUrl': review.user.imageUrl,
//     },
//     'time': review.time.toUtc(),
//   };

//   newReviewDocRef
//       .set(reviewData)
//       .then((value) => print('Added review for book $bookId to Firestore'))
//       .catchError(
//           (error) => print('Error adding review for book $bookId: $error'));
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('My App build function called');
    final BooksProvider booksProvider = BooksProvider(
      books: [],
      child: RevOnApp(),
    );
    return booksProvider;
  }
}

class RevOnApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(
        'RevOn build called: the state of books before future builder: ${BooksProvider.of(context)!.books.length}');
    return FutureBuilder(
      future: BooksProvider.of(context)!.fetchBooks(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Book Reviews',
            theme: ThemeData(
              // Define the default brightness and colors.
              brightness: Brightness.dark,
              primaryColor: Colors.white12,
              fontFamily: 'Poppins',
              textTheme: const TextTheme(
                bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
              ),
            ),
            home: FirstScreen(),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class FirstScreen extends StatelessWidget {
  Future<bool> isLoggedIn() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = await _auth.currentUser;
    // prefs.setBool('isLoggedIn', false);
    return user != null ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedIn(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          bool isLoggedIn = snapshot.data!;
          print('user Loggedd In: $isLoggedIn');
          return isLoggedIn ? BookListScreen() : LoginScreen();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
