import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:revon/controller/local_storage_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> fetchBooks({bool refreshFromFirestore = false}) async {
    List<Book> myBooks = [];

    if (refreshFromFirestore) {
      myBooks = await getBooksFromFireStore();
      print('Books  ${myBooks.length}  loaded from firestore directly.');
    } else {
      myBooks = await getBooksFromSharedPreferences();
      print('Books  ${myBooks.length}  searched in SharedPrefs.');
      if (myBooks.length == 0) {
        print('No books  ${myBooks.length}  found in SharedPref');
        //shared pref doesnt have any books in it... load from firestore
        myBooks = await getBooksFromFireStore();
        print(
            'Books  ${myBooks.length}  loaded from firestore directly after checking SHaredPrefs.');
      } else {
        print('Books ${myBooks.length} found and loaded from Shared Prefs..');
      }
    }
    books.clear();
    books.addAll(myBooks);
    print('all books updated  ${myBooks.length} ');
    print(books);
    saveBooksInSharedPreferences(books);
  }

  @override
  bool updateShouldNotify(BooksProvider oldWidget) {
    return books != oldWidget.books;
  }
}
