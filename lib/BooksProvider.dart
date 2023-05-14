import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'controller/firestore_controller.dart';
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
    List<Book> myBooks = await getBooksFromFireStore();
    books.clear();
    this.books.addAll(myBooks);
    print('all books updated');
    print(this.books);
  }

  @override
  bool updateShouldNotify(BooksProvider oldWidget) {
    return books != oldWidget.books;
  }
}
