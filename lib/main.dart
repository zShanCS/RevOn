import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:revon/blurred_background.dart';
import 'package:revon/data.dart';
import 'package:revon/utils.dart';
import 'package:share/share.dart';
import 'package:revon/blurred_background.dart';
import 'package:revon/book_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'BookListScreen.dart';
import 'BooksProvider.dart';
import 'models/models.dart';

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
    return BooksProvider(
      books: [],
      child: RevOnApp(),
    );
  }
}

class RevOnApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: BooksProvider.of(context)!.fetchBooks(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Book Reviews',
            theme: ThemeData(
              // Define the default brightness and colors.
              brightness: Brightness.dark,
              primaryColor: Colors.lightBlue[800],
              fontFamily: 'Poppins',
              textTheme: const TextTheme(
                bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
              ),
            ),
            home: BookListScreen(
              books: BooksProvider.of(context)!.books,
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
