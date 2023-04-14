import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:revon/blurred_background.dart';
import 'package:share/share.dart';

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
          SizedBox(
            height: 100,
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

class Book {
  final String title;
  final String author;
  final String imageUrl;
  final List<Review> reviews;

  Book(this.title, this.author, this.imageUrl, this.reviews);

  double get averageRating {
    if (reviews.isEmpty) {
      return 0;
    }
    double totalRating =
        reviews.map((review) => review.rating).reduce((a, b) => a + b);
    return totalRating / reviews.length;
  }
}

class Review {
  final double rating;
  final String text;

  Review(this.rating, this.text);
}

class BookDetail extends StatefulWidget {
  final Book book;
  BookDetail({required this.book});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  final _scrollController = ScrollController();

  final double _appBarMaxOpacity = 0.8;

  final double _appBarMinOpacity = 0.0;

  double _appBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _appBarOpacity = (_scrollController.offset / 100)
          .clamp(_appBarMinOpacity, _appBarMaxOpacity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          '${widget.book.title}',
        ),
        elevation: 0.0,
        backgroundColor: Colors.black.withOpacity(_appBarOpacity),
        actions: [
          IconButton(
              onPressed: () {
                Share.share('${widget.book.title} by ${widget.book.author}');
              },
              icon: Icon(Icons.share))
        ],
      ),
      body: BlurredBackground(
        img: widget.book.imageUrl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 100),
                height: 300,
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  child: CachedNetworkImage(
                    imageUrl: widget.book.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        widget.book.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 0),
                    Center(
                      child: Text(
                        '${widget.book.author}',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.only(top: 0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.book.reviews.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('${widget.book.reviews[index].rating} stars'),
                    subtitle: Text(widget.book.reviews[index].text),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
