import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:revon/blurred_background.dart';
import 'package:share/share.dart';
import 'package:revon/models.dart';
import 'package:revon/blurred_background.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      print('appbar opacity updated');
      _appBarOpacity = (_scrollController.offset / 100)
          .clamp(_appBarMinOpacity, _appBarMaxOpacity);
    });
  }

  _calcPositiveReviewsPercentage(List<double> reviews) {
    final pos = reviews.where((element) => element > 3.0);
    return ((pos.length / reviews.length) * 100).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // title: Text(
        //   '${widget.book.title}',
        // ),
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            numberBullet(widget.book.reviews.length)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              '${_calcPositiveReviewsPercentage(widget.book.reviews.map((e) => e.rating).toList())}% Positive',
                              style: TextStyle(
                                fontSize: 8,
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
                        onPressed: () {},
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
                itemCount: widget.book.reviews.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('${widget.book.reviews[index].rating} stars'),
                    subtitle: Text(
                      widget.book.reviews[index].text,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
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
