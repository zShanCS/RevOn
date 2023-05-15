import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revon/LoginScreen.dart';
import 'package:revon/utils.dart';

import 'BooksProvider.dart';
import 'BookDetail.dart';
import 'data.dart';
import 'models/models.dart' hide User;
import 'LoginScreen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({
    super.key,
  });

  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Book> filteredBooks = [];
  bool searchVisible = false;
  bool firstTimeRun = true;
  final FocusNode _searchFocusNode = FocusNode();

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _focusOnSearch() {
    _searchFocusNode.requestFocus();
  }

  @override
  void initState() {
    super.initState();
    filteredBooks = [];
    print(filteredBooks);
  }

  @override
  Widget build(BuildContext context) {
    List<Book> books = BooksProvider.of(context)!.books;
    setState(() {
      if (firstTimeRun) filteredBooks = books;
      firstTimeRun = false;
    });
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (searchVisible) {
                    //search was visible before => means we are closing search now => reset filter.
                    searchController.clear();
                    filteredBooks = books;
                  } else {
                    //search was not visible => means we openend the search => bring search box into focus
                    _focusOnSearch();
                  }
                  searchVisible = !searchVisible;
                });
              },
              icon: searchVisible ? Icon(Icons.clear) : Icon(Icons.search)),
          IconButton(
              onPressed: () async {
                final FirebaseAuth _auth = FirebaseAuth.instance;
                _auth.signOut();
                Navigator.of(context).pushReplacement(
                  createPageRoute(LoginScreen(), changeBehavior: false),
                );
              },
              icon: Icon(Icons.logout))
        ],
        title: Row(
          children: [
            Text('RevOn'),
            SizedBox(
              width: 10,
            ),
            Visibility(
              visible: searchVisible,
              child: Expanded(
                child: TextField(
                  focusNode: _searchFocusNode,
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by book or author',
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: (text) {
                    text = text.toLowerCase();
                    setState(() {
                      filteredBooks = books.where((book) {
                        var title = book.title.toLowerCase();
                        var author = book.author.toLowerCase();
                        return title.contains(text) || author.contains(text);
                      }).toList();
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/Background.png',
              fit: BoxFit.cover,
            ),
          ),
          GridView.builder(
            padding: EdgeInsets.fromLTRB(16, 100, 16, 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: filteredBooks.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    createPageRoute(
                      BookDetail(bookId: filteredBooks[index].id),
                      changeBehavior: true,
                    ),
                  );
                },
                child: Hero(
                  transitionOnUserGestures: true,
                  tag: 'bigImg${filteredBooks[index].id}',
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    child: Image.network(
                      filteredBooks[index].imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
