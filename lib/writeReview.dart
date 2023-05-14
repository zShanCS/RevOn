import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:revon/BookDetail.dart';
import 'package:revon/BooksProvider.dart';
import 'package:revon/blurred_background.dart';
import 'package:revon/controller/firestore_controller.dart';
import 'package:revon/utils.dart';

import 'dart:ui' as ui;

import 'models/models.dart';

class WriteReview extends StatefulWidget {
  final String bookId;
  const WriteReview({
    super.key,
    required this.bookId,
  });

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  double rating = 3.5;
  String reviewText = '';
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    Book book = BooksProvider.of(context)!
        .books
        .firstWhere((element) => element.id == widget.bookId);

    print(book.reviews);
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        elevation: 0.0,
        backgroundColor: Colors.black.withOpacity(0),
      ),
      body: BlurredBackground(
        img: book.imageUrl,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 150,
                      width: 100,
                      child: Hero(
                        transitionOnUserGestures: true,
                        tag: 'bigImg${book.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Image.network(
                            book.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 0),
                          Text(
                            '${book.author}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${book.overview}',
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                loading
                    ? Container(
                        padding: EdgeInsets.fromLTRB(0, 80, 0, 30),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container(
                        child: Column(children: [
                          Center(
                            child: Text(
                              "Share your thoughts about this book",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 11.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Center(
                            child: RatingBar.builder(
                              initialRating: rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              onRatingUpdate: (myrating) {
                                print(myrating);
                                setState(() {
                                  rating = myrating;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                reviewText = value;
                              });
                            },
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: 'Write your review here...',
                              border: OutlineInputBorder(),
                              focusColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () async {
                                // Submit review logic here
                                if (reviewText.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          Color.fromARGB(20, 0, 0, 0),
                                      content: Center(
                                        child: Text(
                                          'Please add a rating and text',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      duration: Duration(
                                          seconds:
                                              2), // set the duration for the message
                                    ),
                                  );
                                  return;
                                }
                                setState(() {
                                  loading = true;
                                });
                                await saveReview(
                                    book.id,
                                    Review(
                                        rating: rating,
                                        text: reviewText,
                                        user: User(
                                            id: DateTime.now().toString(),
                                            name: 'John Doe')));
                                print(BooksProvider.of(context)?.books);

                                await BooksProvider.of(context)?.fetchBooks();

                                Navigator.of(context).pushReplacement(
                                  createPageRoute(BookDetail(bookId: book.id),
                                      changeBehavior: false),
                                );
                              },
                              child: Text(
                                'Submit Review',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white.withOpacity(0.3)),
                              ),
                            ),
                          ),
                        ]),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
