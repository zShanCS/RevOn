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
}
