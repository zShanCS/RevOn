import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'models/models.dart';

class BooksProvider extends InheritedWidget {
  final List<Book> books;

  const BooksProvider({
    Key? key,
    required Widget child,
    required this.books,
  }) : super(key: key, child: child);

  static BooksProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BooksProvider>();
  }

  Future<void> fetchBooks() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('books').get();

    final List<Book> books = snapshot.docs
        .map((QueryDocumentSnapshot document) => Book.fromFirestore(document))
        .toList();

    this.books.addAll(books);
  }

  @override
  bool updateShouldNotify(BooksProvider oldWidget) {
    return true;
  }
}
