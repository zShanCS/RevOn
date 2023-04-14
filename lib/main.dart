import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:revon/blurred_background.dart';

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
    Book('Pride and Prejudice', 'Jane Austen',
        'https://images-na.ssl-images-amazon.com/images/I/71aFt4+OTOL.jpg', [
      Review(4.0, 'A classic romance novel.'),
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
      appBar: AppBar(
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
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: filteredBooks.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              print('clicked');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return BookDetail(book: filteredBooks[index]);
                }),
              );
            },
            child: Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: filteredBooks[index].imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) {
                        print('error widget called');
                        return Image.asset('assets/images/error_image.png');
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    filteredBooks[index].title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    filteredBooks[index].author,
                    style: TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  RatingBarIndicator(
                    rating: filteredBooks[index].averageRating,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BookDetailScreen extends StatelessWidget {
  final Book book;

  BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: key,
      appBar: AppBar(
        title: Text(book.title),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: BlurredBackground(
          img: book.imageUrl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              Center(
                child: CachedNetworkImage(
                  imageUrl: book.imageUrl,
                  fit: BoxFit.cover,
                  height: 300,
                  width: 200,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) {
                    return Image.asset('assets/images/error_image.png');
                  },
                ),
              ),
              SizedBox(height: 16),
              Text(
                book.title,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                'by ${book.author}',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Reviews:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: book.reviews.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('${book.reviews[index].rating} stars'),
                    subtitle: Text(book.reviews[index].text),
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

class BookDetail extends StatelessWidget {
  final Book book;
  BookDetail({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          '${book.title}',
        ),
        elevation: 0.0,
      ),
      body: BlurredBackground(
        img: book.imageUrl,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        book.imageUrl,
                        errorListener: () {
                          print('image failed to load');
                        },
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'by ${book.author}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: book.reviews.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('${book.reviews[index].rating} stars'),
                    subtitle: Text(book.reviews[index].text),
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
