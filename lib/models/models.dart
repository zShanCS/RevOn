import 'package:cloud_firestore/cloud_firestore.dart';
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
      {id,
      required this.title,
      required this.author,
      required this.imageUrl,
      required this.reviews,
      required this.overview,
      required this.authorIntro})
      : id = id ?? uuid.v4();

  factory Book.fromFirestore(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    // print('\n\n\n Data loaded from firestore');
    // print(data);
    List<dynamic> reviewsData = data['reviews'] ?? [];
    List<Review> reviews =
        reviewsData.map((reviewData) => Review.fromMap(reviewData)).toList();
    return Book(
      id: snapshot.id,
      title: data['title'],
      author: data['author'],
      imageUrl: data['image'],
      reviews: reviews,
      overview: data['overview'],
      authorIntro: data['authorIntro'],
    );
  }

  double get averageRating {
    if (reviews.isEmpty) {
      return 0;
    }
    double totalRating =
        reviews.map((review) => review.rating).reduce((a, b) => a + b);
    return totalRating / reviews.length;
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    List<dynamic> reviewsData = map['reviews'] ?? [];
    List<Review> reviews =
        reviewsData.map((reviewData) => Review.fromMap(reviewData)).toList();

    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      imageUrl: map['imageUrl'],
      reviews: reviews,
      overview: map['overview'],
      authorIntro: map['authorIntro'],
    );
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> reviewsData =
        reviews.map((review) => review.toMap()).toList();

    return {
      'id': id,
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
      'reviews': reviewsData,
      'overview': overview,
      'authorIntro': authorIntro,
    };
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

  Review.fromMap(Map<String, dynamic> map)
      : rating = map['rating'],
        text = map['text'],
        user = User.fromMap(map['user']),
        time = (map['time'] is Timestamp)
            ? (map['time'] as Timestamp).toDate()
            : DateTime.parse(map['time']);

  Review(
      {required this.rating,
      required this.text,
      required this.user,
      DateTime? time})
      : time = time ?? DateTime.now().toUtc(),
        assert(time == null || time.isUtc);

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'text': text,
      'user': user.toMap(),
      'time': time.toIso8601String(),
    };
  }

  @override
  String toString() {
    return '$rating: $text';
  }
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
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}
