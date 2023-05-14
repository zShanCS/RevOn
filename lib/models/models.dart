import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Book {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final List<Review> reviews;
  final String overview;
  final String authorIntro;

  Book(
      {required this.title,
      required this.author,
      required this.imageUrl,
      required this.reviews,
      required this.overview,
      required this.authorIntro})
      : id = uuid.v4();

  double get averageRating {
    if (reviews.isEmpty) {
      return 0;
    }
    double totalRating =
        reviews.map((review) => review.rating).reduce((a, b) => a + b);
    return totalRating / reviews.length;
  }

  @override
  String toString() {
    return id;
  }
}

class Review {
  final double rating;
  final String text;
  final User user;
  DateTime time = DateTime.now().toUtc();

  Review(
      {required this.rating,
      required this.text,
      required this.user,
      DateTime? time})
      : time = time ?? DateTime.now().toUtc(),
        assert(time == null || time.isUtc);
}

class User {
  final String id;
  final String name;
  final String? imageUrl; // optional parameter

  User({
    required this.id,
    required this.name,
    this.imageUrl,
  });
}
