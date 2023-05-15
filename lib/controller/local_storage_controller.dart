import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

Future<void> saveBooksInSharedPreferences(List<Book> books) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> booksJsonList =
      books.map((book) => jsonEncode(book.toMap())).toList();
  await prefs.setStringList('books', booksJsonList);
  print('Books  ${books.length}  saved to SharedPreferences');
}

Future<List<Book>> getBooksFromSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String>? booksJsonList = prefs.getStringList('books');
  if (booksJsonList != null) {
    final List<Book> books = booksJsonList
        .map((jsonString) => Book.fromMap(jsonDecode(jsonString)))
        .toList();
    return books;
  }
  return [];
}
