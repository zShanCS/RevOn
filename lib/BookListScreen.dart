import 'package:flutter/material.dart';
import 'package:revon/utils.dart';

import 'BooksProvider.dart';
import 'book_detail.dart';
import 'data.dart';
import 'models/models.dart';

class BookListScreen extends StatefulWidget {
  final List<Book> books;
  const BookListScreen({super.key, required this.books});

  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Book> filteredBooks = [];
  bool searchVisible = false;
  final FocusNode _searchFocusNode = FocusNode();

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _focusOnSearch() {
    FocusScope.of(context).requestFocus(_searchFocusNode);
  }

  @override
  void initState() {
    super.initState();
    filteredBooks = widget.books;
    print(filteredBooks);
  }

  @override
  Widget build(BuildContext context) {
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
                    filteredBooks = widget.books;
                  } else {
                    //search was not visible => means we openend the search => bring search box into focus
                    _focusOnSearch();
                  }
                  searchVisible = !searchVisible;
                });
              },
              icon: searchVisible ? Icon(Icons.clear) : Icon(Icons.search))
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
                      filteredBooks = widget.books.where((book) {
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
                      BookDetail(book: filteredBooks[index]),
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
                      child: _generateImage(filteredBooks[index].imageUrl)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

dynamic _generateImage(link) {
  try {
    dynamic c = Image.network(
      link,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
    );
    return c;
  } catch (e) {
    return Text('Image Not loading');
  }
}
