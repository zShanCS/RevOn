import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:revon/models/models.dart';

Future<List<Book>> getBooksFromFireStore() async {
  final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('books').get();

  final List<Book> books = snapshot.docs
      .map((QueryDocumentSnapshot document) => Book.fromFirestore(document))
      .toList();
  return books;
}

Future<void> saveReview(String bookId, Review review) async {
  try {
    final firestore = FirebaseFirestore.instance;
    final bookRef = firestore.collection('books').doc(bookId);

    await firestore.runTransaction((transaction) async {
      final bookDoc = await transaction.get(bookRef);

      if (!bookDoc.exists) {
        throw Exception('Book not found');
      }
      dynamic revList = bookDoc.data();
      Book myBook = Book.fromFirestore(bookDoc);
      final List<Review> reviews = myBook.reviews;
      reviews.add(review);
      await transaction.update(bookRef, {
        'reviews': reviews.map((review) {
          return {
            'time': review.time.toUtc(),
            'rating': review.rating,
            'text': review.text,
            'user': {
              'id': review.user.id,
              'name': review.user.name,
            },
          };
        }).toList()
      });
      print('review saved ${review.text}');
    });
  } catch (e) {
    print('Error saving review: $e');
    // rethrow;
  }
}
