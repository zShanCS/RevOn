import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:revon/blurred_background.dart';
import 'package:share/share.dart';
import 'package:revon/models.dart';
import 'package:revon/blurred_background.dart';
import 'package:revon/book_detail.dart';

void main() {
  runApp(BookReviewsApp());
}

class BookReviewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Reviews',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],

        // Define the default font family.
        fontFamily: 'Poppins',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
        ),
      ),
      home: BookListScreen(),
    );
  }
}

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final List<Book> books = [
    Book(
      'The Great Gatsby',
      'F. Scott',
      'https://i0.wp.com/americanwritersmuseum.org/wp-content/uploads/2018/02/CK-3.jpg?resize=267%2C400&ssl=1',
      [
        Review(3.9, 'Best Book Ever'),
        Review(3.9, 'Best Book Ever'),
        Review(3.9, 'Best Book Ever'),
        Review(3.9, 'Best Book Ever'),
        Review(3.9, 'Best Book Ever'),
        Review(3.9, 'Best Book Ever'),
        Review(3.9, 'Best Book Ever'),
        Review(3.9, 'Best Book Ever'),
        Review(3.9, 'Best Book Ever'),
      ],
    ),
    Book('The Alchemist', 'Paulo Coelho',
        'https://images-na.ssl-images-amazon.com/images/I/71aFt4+OTOL.jpg', [
      Review(4.5, 'This book is amazing! Highly recommended.'),
      Review(3.0, 'It was an okay book, not my favorite.'),
    ]),
    Book(
        'To Kill a Mockingbird',
        'Harper Lee',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/1/16/Mimus_polyglottos1.jpg/1024px-Mimus_polyglottos1.jpg',
        [
          Review(5.0, 'A timeless classic. Must-read.'),
          Review(4.0, 'A great book that everyone should read.'),
          Review(2.5, 'I did not enjoy this book.'),
          Review(2.5, 'I did not enjoy this book.'),
          Review(2.5, 'I did not enjoy this book.'),
          Review(4.0, 'A great book that everyone should read.'),
          Review(2.5, 'I did not enjoy this book.'),
          Review(4.0, 'A great book that everyone should read.'),
          Review(2.5, 'I did not enjoy this book.'),
          Review(4.0, 'A great book that everyone should read.'),
          Review(2.5, 'I did not enjoy this book.'),
          Review(2.5, 'I did not enjoy this book.'),
          Review(4.0, 'A great book that everyone should read.'),
          Review(2.5, 'I did not enjoy this book.'),
        ]),
    Book('1984', 'George Orwell',
        'https://images-na.ssl-images-amazon.com/images/I/71aFt4+OTOL.jpg', [
      Review(4.0, 'A chilling and thought-provoking book.'),
      Review(5.0, 'One of the best books I have ever read.'),
      Review(5.0, 'One of the best books I have ever read.'),
      Review(5.0, 'One of the best books I have ever read.'),
      Review(5.0, 'One of the best books I have ever read.'),
      Review(5.0, 'One of the best books I have ever read.'),
      Review(5.0, 'One of the best books I have ever read.'),
      Review(5.0, 'One of the best books I have ever read.'),
      Review(5.0, 'One of the best books I have ever read.'),
      Review(5.0, 'One of the best books I have ever read.'),
      Review(5.0, 'One of the best books I have ever read.'),
      Review(5.0, 'One of the best books I have ever read.'),
      Review(5.0, 'One of the best books I have ever read.'),
    ]),
    Book('The Prophecy', 'George Orwell',
        'https://m.media-amazon.com/images/I/51XXwdv2twL.jpg', [
      Review(4.0, 'A chilling and thought-provoking book.'),
      Review(5.0, 'One of the best books I have ever read.'),
      Review(5.0, 'One of the best books I have ever read.'),
      Review(5.0, 'One of the best books I have ever read.'),
      Review(5.0, 'One of the best books I have ever read.'),
      Review(5.0, 'One of the best books I have ever read.'),
      Review(5.0, 'One of the best books I have ever read.'),
      Review(5.0,
          'One of the best books I have ever read.One of the best books I have ever read.One of the best books I have ever read.One of the best books I have ever read.One of the best books I have ever read.One of the best books I have ever read.'),
      Review(5.0, 'One of the best books I have ever read.'),
    ]),
    Book(
        'Pride and Prejudice',
        'Jane Austen',
        'https://img.freepik.com/free-vector/digital-technology-background-with-abstract-wave-border_53876-117508.jpg',
        [
          Review(4.0, 'A classic romance novel.'),
          Review(3.5, 'An enjoyable read, but not my favorite.'),
          Review(3.5, 'An enjoyable read, but not my favorite.'),
          Review(3.5, 'An enjoyable read, but not my favorite.'),
          Review(3.5, 'An enjoyable read, but not my favorite.'),
          Review(3.5, 'An enjoyable read, but not my favorite.'),
          Review(3.5, 'An enjoyable read, but not my favorite.'),
          Review(3.5, 'An enjoyable read, but not my favorite.'),
          Review(3.5, 'An enjoyable read, but not my favorite.'),
          Review(3.5, 'An enjoyable read, but not my favorite.'),
          Review(3.5, 'An enjoyable read, but not my favorite.'),
          Review(3.5, 'An enjoyable read, but not my favorite.'),
        ]),
  ];

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
    filteredBooks = books;
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
                    filteredBooks = books;
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return BookDetail(book: filteredBooks[index]);
                    }),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  child: CachedNetworkImage(
                    imageUrl: filteredBooks[index].imageUrl,
                    fit: BoxFit.cover,
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
