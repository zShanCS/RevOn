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
