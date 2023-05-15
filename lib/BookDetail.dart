import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:revon/BooksProvider.dart';
import 'package:revon/blurred_background.dart';
import 'package:revon/utils.dart';
import 'package:share/share.dart';
import 'package:revon/blurred_background.dart';

import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:revon/WriteReview.dart';

import 'models/models.dart';

class BookDetail extends StatefulWidget {
  final String bookId;
  BookDetail({required this.bookId});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  _calcPositiveReviewsPercentage(List<double> reviews) {
    if (reviews.isEmpty) {
      return 0;
    }
    final pos = reviews.where((element) => element > 3.0);
    return ((pos.length / reviews.length) * 100).ceil();
  }

  late Book mybook;
  @override
  Widget build(BuildContext context) {
    Book mybook = BooksProvider.of(context)
            ?.books
            .firstWhere((element) => element.id == widget.bookId) ??
        Book(
            title: '',
            author: 'author',
            imageUrl: 'imageUrl',
            reviews: [],
            overview: 'overview',
            authorIntro: 'authorIntro');
    print(mybook.reviews);
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black.withOpacity(0),
        actions: [
          IconButton(
              onPressed: () {
                Share.share('${mybook.title} by ${mybook.author}');
              },
              icon: Icon(Icons.share))
        ],
      ),
      body: BlurredBackground(
        img: mybook.imageUrl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 100),
                height: 300,
                width: 200,
                child: Hero(
                  transitionOnUserGestures: true,
                  tag: 'bigImg${mybook.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    child: Image.network(
                      mybook.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
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
                    Center(
                      child: Text(
                        mybook.title,
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
                        '${mybook.author}',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Overview',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${mybook.overview}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'About the author',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${mybook.authorIntro}',
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Reviews',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            numberBullet(mybook.reviews.length)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              '${_calcPositiveReviewsPercentage(mybook.reviews.map((e) => e.rating).toList())}% Positive',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white.withOpacity(0.3),
                          ),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                            createPageRoute(WriteReview(bookId: mybook.id),
                                changeBehavior: false),
                          )
                              .whenComplete(() {
                            print('book details screen on top again');
                            setState(() {
                              mybook = BooksProvider.of(context)
                                      ?.books
                                      .firstWhere((element) =>
                                          element.id == widget.bookId) ??
                                  Book(
                                      title: '',
                                      author: 'author',
                                      imageUrl: 'imageUrl',
                                      reviews: [],
                                      overview: 'overview',
                                      authorIntro: 'authorIntro');
                            });
                            print('changed reviews: ${mybook.reviews}');
                          });
                        },
                        icon: Icon(Icons.edit_square, size: 15),
                        label: Text(
                          'Write Review',
                          style: TextStyle(fontSize: 12),
                        ))
                  ],
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.only(top: 0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: mybook.reviews.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Text(
                          mybook.reviews[index].user.name.isNotEmpty
                              ? mybook.reviews[index].user.name
                              : 'User',
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        starBullet(mybook.reviews[index].rating),
                        Spacer(),
                        Text(
                          formatTime(mybook.reviews[index].time),
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                    // title: Text('${mybook.reviews[index].rating} stars'),
                    subtitle: Text(
                      mybook.reviews[index].text,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container numberBullet(int len) {
    return Container(
      width: 25.0,
      height: 25.0,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getReviewCountText(len),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }

  Container starBullet(double rating) {
    return Container(
      width: 40.0,
      height: 15.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.grey.withOpacity(0.1),
        shape: BoxShape.rectangle,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              rating.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 9.0,
              ),
            ),
            SizedBox(
              width: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Icon(
                Icons.star,
                size: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _getReviewCountText(int len) {
  int reviewCount = len;
  if (reviewCount < 10) {
    return reviewCount.toString();
  } else if (reviewCount >= 10 && reviewCount <= 99) {
    return reviewCount.toString();
  } else {
    return '99+';
  }
}

String formatTime(DateTime time) {
  final now = DateTime.now();
  final diff = now.difference(time);

  if (diff.inSeconds < 60) {
    return '${diff.inSeconds} seconds ago';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
  } else if (diff.inHours < 24) {
    return '${diff.inHours} hours ago';
  } else if (diff.inDays < 30) {
    return '${diff.inDays} days ago';
  } else {
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(time);
  }
}
