import 'package:revon/models.dart';

final bookList = [
  Book(
    title: 'The Great Gatsby',
    author: 'F. Scott',
    imageUrl:
        'https://i0.wp.com/americanwritersmuseum.org/wp-content/uploads/2018/02/CK-3.jpg?resize=267%2C400&ssl=1',
    reviews: [
      Review(
          time: DateTime.now().toUtc(),
          rating: 3.9,
          text: 'Best Book Ever',
          user: User(id: '1', name: 'John Doe')),
      Review(
          time: DateTime.now().toUtc(),
          rating: 3.9,
          text: 'Best Book Ever',
          user: User(id: '2', name: 'Jane Doe')),
      Review(
          time: DateTime.now().toUtc(),
          rating: 3.9,
          text: 'Best Book Ever',
          user: User(id: '3', name: 'Bob Smith')),
      Review(
          time: DateTime.now().toUtc(),
          rating: 3.9,
          text: 'Best Book Ever',
          user: User(id: '4', name: 'Sara Johnson')),
      Review(
          time: DateTime.now().toUtc(),
          rating: 3.9,
          text: 'Best Book Ever',
          user: User(id: '5', name: 'Mark Lee')),
      Review(
          time: DateTime.now().toUtc(),
          rating: 3.9,
          text: 'Best Book Ever',
          user: User(id: '6', name: 'Emily White')),
      Review(
          time: DateTime.now().toUtc(),
          rating: 3.9,
          text: 'Best Book Ever',
          user: User(id: '7', name: 'David Kim')),
      Review(
          time: DateTime.now().toUtc(),
          rating: 3.9,
          text: 'Best Book Ever',
          user: User(id: '8', name: 'Karen Brown')),
      Review(
          time: DateTime.now().toUtc(),
          rating: 3.9,
          text: 'Best Book Ever',
          user: User(id: '9', name: 'Mike Chen')),
    ],
    overview: 'This is a classic novel about the American Dream.',
    authorIntro:
        'F. Scott Fitzgerald was an American novelist and short-story writer.',
  ),
  Book(
    title: 'The Alchemist123',
    author: 'Paulo Coelho',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/71aFt4+OTOL.jpg',
    reviews: [
      Review(
          time: DateTime.now().toUtc(),
          rating: 4.5,
          text: 'This book is amazing! Highly recommended.',
          user: User(id: '1', name: 'John Doe')),
      Review(
          time: DateTime.now().toUtc(),
          rating: 3.0,
          text: 'It was an okay book, not my favorite.',
          user: User(id: '2', name: 'Jane Doe')),
    ],
    overview:
        'This is a novel about a shepherd boy on a journey to find his destiny.',
    authorIntro: 'Paulo Coelho is a Brazilian lyricist and novelist.',
  ),
  Book(
    title: 'To Kill a Mockingbird',
    author: 'Harper Lee',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/1/16/Mimus_polyglottos1.jpg/1024px-Mimus_polyglottos1.jpg',
    reviews: [
      Review(
        time: DateTime.now().toUtc(),
        rating: 5.0,
        text: 'A timeless classic. Must-read.',
        user: User(id: '1', name: 'John Doe'),
      ),
      Review(
          time: DateTime.now().toUtc(),
          rating: 4.0,
          text: 'A great book that everyone should read.',
          user: User(id: '2', name: 'Jane Doe')),
      Review(
          time: DateTime.now().toUtc(),
          rating: 2.5,
          text: 'I did not enjoy this book.',
          user: User(id: '3', name: 'Bob Smith')),
      Review(
          time: DateTime.now().toUtc(),
          rating: 2.5,
          text: 'I did not enjoy this book.',
          user: User(id: '4', name: '')),
    ],
    overview:
        'The Great Gatsby is a 1925 novel by F. Scott Fitzgerald. The story takes place in 1922, during the Roaring Twenties, a time of prosperity in the United States after World War I. The book is widely considered to be a literary classic and a contender for the title "Great American Novel".',
    authorIntro:
        'Francis Scott Fitzgerald was an American novelist, essayist, screenwriter, and short-story writer.',
  ),
  Book(
      title: 'The Alchemist',
      author: 'Paulo Coelho',
      imageUrl:
          'https://images-na.ssl-images-amazon.com/images/I/71aFt4+OTOL.jpg',
      reviews: [
        Review(
            time: DateTime.utc(2022),
            rating: 4.5,
            text: 'This book is amazing! Highly recommended.',
            user: User(id: '10', name: 'Ravi Singh')),
      ],
      overview:
          'The Alchemist is a novel by Brazilian author Paulo Coelho that was first published in 1988. Originally written in Portuguese, it has been translated into at least 80 languages as of September 2021. An allegorical novel, The Alchemist follows a young Andalusian shepherd in his journey to Egypt, after having a recurring dream of finding a treasure there.',
      authorIntro:
          'Paulo Coelho is a Brazilian lyricist and novelist. He is best known for his novel The Alchemist.')
];
