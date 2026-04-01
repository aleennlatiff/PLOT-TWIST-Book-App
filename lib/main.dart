import 'package:flutter/material.dart';

const Color primaryPink = Color(0xFFEC4899);
const Color babyBlueLight = Color(0xFFBFDBFE);

void main() {
  runApp(const BookMatchApp());
}

class BookMatchApp extends StatelessWidget {
  const BookMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PLOT-TWIST Book App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryPink,
          primary: primaryPink,
          secondary: babyBlueLight,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAF5F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Color(0xFF1F2937),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
            color: primaryPink,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// --- DATA MODEL ---
class Book {
  final String id;
  final String title;
  final String author;
  final String image;
  final String description;
  final String category;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.image,
    required this.description,
    required this.category,
  });
}

// --- GLOBAL DATA ---
// All available books
List<Book> allBooks = [
  Book(
    id: '1',
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    image: "https://m.media-amazon.com/images/I/81QuEGw8VPL._AC_UF1000,1000_QL80_.jpg",
    description: "A story of ambition and love in the 1920s.",
    category: "Fiction",
  ),
  Book(
    id: '2',
    title: "1984",
    author: "George Orwell",
    image: "https://m.media-amazon.com/images/I/71kxa1-0mfL._AC_UF1000,1000_QL80_.jpg",
    description: "A dystopian social science fiction novel.",
    category: "Sci-Fi",
  ),
  Book(
    id: '3',
    title: "The Hobbit",
    author: "J.R.R. Tolkien",
    image: "https://m.media-amazon.com/images/I/710+HcoP38L._AC_UF1000,1000_QL80_.jpg",
    description: "A fantasy adventure about Bilbo Baggins.",
    category: "Fantasy",
  ),
  Book(
    id: '4',
    title: "Dune",
    author: "Frank Herbert",
    image: "https://m.media-amazon.com/images/I/81ym3QUd3KL._AC_UF1000,1000_QL80_.jpg",
    description: "A sweeping sci-fi epic set on the desert planet Arrakis.",
    category: "Sci-Fi",
  ),
  Book(
    id: '5',
    title: "The Silent Patient",
    author: "Alex Michaelides",
    image: "https://m.media-amazon.com/images/I/81jj-cKcwzL._AC_UF1000,1000_QL80_.jpg",
    description: "A shocking psychological thriller.",
    category: "Mystery",
  ),
];

// The list that will hold the user's saved books
List<Book> mySavedLibrary = [];

// --- HOME PAGE ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";
  String selectedCategory = "All";
  final List<String> categories = ["All", "Fiction", "Sci-Fi", "Fantasy", "Mystery"];

  List<Book> get filteredBooks {
    return allBooks.where((book) {
      final matchesCategory = selectedCategory == "All" || book.category == selectedCategory;
      final matchesSearch = book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu_book_rounded, color: primaryPink, size: 30),
        title: const Text("PLOT-TWIST"),
        actions: [
          // NEW: Library Button in Navbar
          IconButton(
            icon: const Icon(Icons.favorite_rounded, color: primaryPink, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LibraryPage()),
              ).then((_) {
                // Refresh the home page when coming back in case books were removed
                setState(() {}); 
              });
            },
          ),
          // The "Pink Circle" Profile Picture
          const Padding(
            padding: EdgeInsets.only(right: 16.0, left: 8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Search books or authors...",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: primaryPink),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),

          // --- CATEGORY FILTERS ---
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : primaryPink,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: primaryPink,
                    backgroundColor: babyBlueLight.withOpacity(0.3),
                    side: isSelected ? BorderSide.none : const BorderSide(color: babyBlueLight),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              "Discover",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
            ),
          ),

          // --- FILTERED RESULTS  ---
          Expanded(
            child: filteredBooks.isEmpty
                ? const Center(
                    child: Text(
                      "No books found.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailsPage(book: book)),
                          ).then((_) {
                            // Refresh home page when returning from details
                            setState(() {}); 
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Hero(
                                tag: 'book-image-${book.id}-home',
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      book.image,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              book.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              book.author,
                              style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// --- DETAILS PAGE (Now Stateful to handle the Save Button) ---
class DetailsPage extends StatefulWidget {
  final Book book;
  const DetailsPage({super.key, required this.book});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    // Check if the current book is inside the saved library list
    bool isSaved = mySavedLibrary.contains(widget.book);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Overview"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryPink),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'book-image-${widget.book.id}-home',
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10)),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(widget.book.image, height: 320, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: babyBlueLight.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.book.category,
                      style: const TextStyle(color: primaryPink, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.book.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1F2937)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "by ${widget.book.author}",
                    style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Synopsis", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.book.description,
                    style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  if (isSaved) {
                    mySavedLibrary.remove(widget.book);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Removed from Library", style: TextStyle(fontWeight: FontWeight.bold)),
                        backgroundColor: Colors.grey[600],
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  } else {
                    mySavedLibrary.add(widget.book);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Added to My Library! 💖", style: TextStyle(fontWeight: FontWeight.bold)),
                        backgroundColor: primaryPink,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  }
                });
              },
              icon: Icon(
                isSaved ? Icons.favorite : Icons.favorite_border_rounded, 
                color: isSaved ? primaryPink : Colors.white
              ),
              label: Text(
                isSaved ? "Saved in Library" : "Save to Library", 
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: isSaved ? primaryPink : Colors.white
                )
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSaved ? babyBlueLight.withOpacity(0.5) : primaryPink,
                elevation: isSaved ? 0 : 2,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- NEW: MY LIBRARY PAGE ---
class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Library"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryPink),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: mySavedLibrary.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.heart_broken_rounded, size: 80, color: babyBlueLight),
                  const SizedBox(height: 16),
                  const Text(
                    "Your library is empty!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text("Go discover some great books.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mySavedLibrary.length,
              itemBuilder: (context, index) {
                final book = mySavedLibrary[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(book.image, width: 50, height: 80, fit: BoxFit.cover),
                    ),
                    title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(book.author),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          mySavedLibrary.remove(book); // Allow user to delete from list
                        });
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailsPage(book: book)),
                      ).then((_) => setState(() {}));
                    },
                  ),
                );
              },
            ),
    );
  }
}