
import 'package:flutter/material.dart';

const primary = Color(0xFF123C83);
const light = Color(0xFFF1F5FB);

void main() {
  runApp(const CampusSwapApp());
}

class Listing {
  Listing({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.condition,
    required this.description,
    required this.owner,
    this.imageUrl = '',
    this.sold = false,
    this.buyerEmail = '',
  });

  final int id;
  String title;
  double price;
  String category;
  String condition;
  String description;
  String owner;
  String imageUrl;
  bool sold;
  String buyerEmail;
}

class Review {
  Review(this.author, this.rating, this.comment);
  final String author;
  final int rating;
  final String comment;
}

class Store extends ChangeNotifier {
  String user = 'Orkun Güzel';
  String email = 'orkun.guzel@sabanciuniv.edu';
  int nextId = 10;

  final Set<int> favorites = {2, 4};

  final List<Review> reviews = [
    Review('Mert A.', 5, 'Great communication!'),
    Review('Zeynep T.', 4, 'Item as described.'),
    Review('Can B.', 5, 'Easy campus pickup.'),
  ];

  final List<Listing> listings = [
    Listing(
      id: 1,
      title: 'Calculus Book',
      price: 150,
      category: 'Books',
      condition: 'Good',
      description: 'Calculus textbook in good condition.',
      owner: 'Orkun Güzel',
    ),
    Listing(
      id: 2,
      title: 'Casio fx-991EX',
      price: 250,
      category: 'Electronics',
      condition: 'Like new',
      description: 'Scientific calculator, works perfectly.',
      owner: 'Ayşe K.',
      imageUrl:
          'https://images.unsplash.com/photo-1587145820266-a5951ee6f620?w=700',
    ),
    Listing(
      id: 3,
      title: 'Desk Lamp',
      price: 0,
      category: 'Furniture',
      condition: 'Good',
      description: 'Free desk lamp for pickup.',
      owner: 'Orkun Güzel',
    ),
    Listing(
      id: 4,
      title: 'Mini Fridge',
      price: 800,
      category: 'Furniture',
      condition: 'Good',
      description: 'Compact fridge for dorm room.',
      owner: 'Ayşe K.',
    ),
    Listing(
      id: 5,
      title: 'Lab Coat',
      price: 100,
      category: 'Clothing',
      condition: 'Like new',
      description: 'Clean laboratory coat.',
      owner: 'Mert A.',
    ),
    Listing(
      id: 6,
      title: 'Winter Jacket',
      price: 300,
      category: 'Clothing',
      condition: 'Good',
      description: 'Warm winter jacket.',
      owner: 'Zeynep T.',
    ),
  ];

  void toggleFavorite(int id) {
    if (!favorites.add(id)) {
      favorites.remove(id);
    }
    notifyListeners();
  }

  void save(Listing item) {
    if (!listings.any((e) => e.id == item.id)) {
      listings.insert(0, item);
    }
    notifyListeners();
  }

  void remove(int id) {
    listings.removeWhere((e) => e.id == id);
    favorites.remove(id);
    notifyListeners();
  }

  void markSold(Listing item, String buyer) {
    item.sold = true;
    item.buyerEmail = buyer;
    notifyListeners();
  }

  void addReview(Review review) {
    reviews.insert(0, review);
    notifyListeners();
  }
}

String priceText(double price) {
  if (price == 0) return 'Free';
  return '${price.toStringAsFixed(0)} TL';
}

bool validEmail(String value) {
  return RegExp(
    r'^[^@\s]+@sabanciuniv\.edu$',
  ).hasMatch(value.trim().toLowerCase());
}

Widget listingImage(Listing item, {double height = 140}) {
  Widget placeholder() {
    return Image.asset(
      'assets/placeholder.png',
      fit: BoxFit.cover,
      width: double.infinity,
      height: height,
    );
  }

  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: SizedBox(
      height: height,
      width: double.infinity,
      child: item.imageUrl.isEmpty
          ? placeholder()
          : Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, error, stack) => placeholder(),
            ),
    ),
  );
}

Future<void> showNotice(
  BuildContext context,
  String title,
  String message,
) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

class CampusSwapApp extends StatefulWidget {
  const CampusSwapApp({super.key});

  @override
  State<CampusSwapApp> createState() => _CampusSwapAppState();
}

class _CampusSwapAppState extends State<CampusSwapApp> {
  final Store store = Store();
  bool loggedIn = false;

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusSwap',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: light,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: loggedIn
          ? MainShell(
              store: store,
              logout: () => setState(() => loggedIn = false),
            )
          : AuthScreen(
              onLogin: (name, email) {
                store.user = name;
                store.email = email;
                setState(() => loggedIn = true);
              },
            ),
    );
  }
}

// SCREEN 1: LOGIN
// SCREEN 2: SIGN UP

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.onLogin});

  final void Function(String, String) onLogin;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool signUp = false;
  final formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    phone.dispose();
    super.dispose();
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;

    final userEmail = email.text.trim().toLowerCase();
    final userName = signUp
        ? name.text.trim()
        : userEmail == 'orkun.guzel@sabanciuniv.edu'
            ? 'Orkun Güzel'
            : userEmail.split('@').first;

    widget.onLogin(userName, userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CircleAvatar(
                      radius: 38,
                      backgroundColor: primary,
                      child: Text(
                        'CS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      signUp ? 'Create Account' : 'CampusSwap',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (!signUp)
                      const Text(
                        'Swap on campus',
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 30),
                    if (signUp) ...[
                      TextFormField(
                        controller: name,
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                        ),
                        validator: (v) =>
                            (v ?? '').trim().isEmpty
                                ? 'Name is required'
                                : null,
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'University email',
                        hintText: 'name@sabanciuniv.edu',
                      ),
                      validator: (v) =>
                          validEmail(v ?? '')
                              ? null
                              : 'Enter a valid university email',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: password,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      validator: (v) =>
                          (v ?? '').length < 6
                              ? 'Use at least 6 characters'
                              : null,
                    ),
                    if (signUp) ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: phone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone (optional)',
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: submit,
                      child: Text(signUp ? 'Sign Up' : 'Log In'),
                    ),
                    TextButton(
                      onPressed: () {
                        formKey.currentState?.reset();
                        setState(() => signUp = !signUp);
                      },
                      child: Text(
                        signUp
                            ? 'Already have an account? Log In'
                            : 'New here? Sign Up',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// MAIN NAVIGATION

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.store,
    required this.logout,
  });

  final Store store;
  final VoidCallback logout;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;

  void openDetails(Listing item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(
          store: widget.store,
          listing: item,
        ),
      ),
    );
  }

  void editListing(Listing item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListingFormScreen(
          store: widget.store,
          existing: item,
          onComplete: () {
            Navigator.pop(context);
            setState(() => tab = 4);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        store: widget.store,
        onTap: openDetails,
        onSearch: () => setState(() => tab = 1),
      ),
      SearchScreen(
        store: widget.store,
        onTap: openDetails,
      ),
      ListingFormScreen(
        store: widget.store,
        embedded: true,
        onComplete: () => setState(() => tab = 0),
      ),
      FavoritesScreen(
        store: widget.store,
        onTap: openDetails,
      ),
      ProfileScreen(
        store: widget.store,
        onTap: openDetails,
        onEdit: editListing,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          const [
            'CampusSwap',
            'Search',
            'New Listing',
            'Favorites',
            'Profile',
          ][tab],
        ),
        actions: tab == 4
            ? [
                TextButton(
                  onPressed: widget.logout,
                  child: const Text('Log out'),
                ),
              ]
            : null,
      ),
      body: IndexedStack(
        index: tab,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (value) {
          setState(() => tab = value);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            label: 'Sell',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// REUSABLE LISTING CARD

class ListingTile extends StatelessWidget {
  const ListingTile({
    super.key,
    required this.item,
    required this.store,
    required this.onTap,
    this.compact = false,
  });

  final Listing item;
  final Store store;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(5),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: compact
              ? Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: listingImage(item, height: 82),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(priceText(item.price)),
                          Text(item.category),
                          if (item.sold)
                            const Text('SOLD'),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          store.toggleFavorite(item.id),
                      icon: Icon(
                        store.favorites.contains(item.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: primary,
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    listingImage(item),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              store.toggleFavorite(item.id),
                          icon: Icon(
                            store.favorites.contains(item.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: primary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      priceText(item.price),
                      style: const TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (item.sold)
                      const Text('SOLD'),
                  ],
                ),
        ),
      ),
    );
  }
}

// SCREEN 3: HOME

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.store,
    required this.onTap,
    required this.onSearch,
  });

  final Store store;
  final void Function(Listing) onTap;
  final VoidCallback onSearch;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String category = 'All';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final items = widget.store.listings.where((item) {
          return !item.sold &&
              (category == 'All' ||
                  item.category == category);
        }).toList();

        return ListView(
          padding: const EdgeInsets.all(14),
          children: [
            TextField(
              readOnly: true,
              onTap: widget.onSearch,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search items...',
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  'All',
                  'Books',
                  'Electronics',
                  'Furniture',
                  'Clothing',
                ].map((value) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(value),
                      selected: category == value,
                      onSelected: (_) {
                        setState(() => category = value);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Newest listings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        constraints.maxWidth > 550 ? 3 : 2,
                    mainAxisExtent: 255,
                  ),
                  itemBuilder: (context, index) {
                    return ListingTile(
                      item: items[index],
                      store: widget.store,
                      onTap: () => widget.onTap(items[index]),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}

// SCREEN 4: SEARCH

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.store,
    required this.onTap,
  });

  final Store store;
  final void Function(Listing) onTap;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final query = TextEditingController();
  final minPrice = TextEditingController();
  final maxPrice = TextEditingController();

  String category = 'All';
  bool filtered = false;

  @override
  void dispose() {
    query.dispose();
    minPrice.dispose();
    maxPrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final items = widget.store.listings.where((item) {
          if (item.sold) return false;

          if (!item.title.toLowerCase().contains(
                query.text.toLowerCase(),
              )) {
            return false;
          }

          if (!filtered) return true;

          final minimum =
              double.tryParse(minPrice.text) ?? 0;
          final maximum =
              double.tryParse(maxPrice.text) ??
                  double.infinity;

          return (category == 'All' ||
                  item.category == category) &&
              item.price >= minimum &&
              item.price <= maximum;
        }).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: query,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search items...',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
              items: [
                'All',
                'Books',
                'Electronics',
                'Furniture',
                'Clothing',
              ].map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => category = value ?? 'All');
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minPrice,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Min price',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: maxPrice,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Max price',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                setState(() => filtered = true);
              },
              child: const Text('Apply Filters'),
            ),
            const SizedBox(height: 12),
            Text('${items.length} results'),
            ...items.map(
              (item) => ListingTile(
                item: item,
                store: widget.store,
                compact: true,
                onTap: () => widget.onTap(item),
              ),
            ),
          ],
        );
      },
    );
  }
}

// SCREEN 5: LISTING DETAILS

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.store,
    required this.listing,
  });

  final Store store;
  final Listing listing;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final isOwner = listing.owner == store.user;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Listing Details'),
            actions: [
              IconButton(
                onPressed: () =>
                    store.toggleFavorite(listing.id),
                icon: Icon(
                  store.favorites.contains(listing.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              listingImage(listing, height: 230),
              const SizedBox(height: 16),
              Text(
                listing.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                priceText(listing.price),
                style: const TextStyle(
                  fontSize: 21,
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  Chip(label: Text(listing.category)),
                  Chip(label: Text(listing.condition)),
                  if (listing.sold)
                    const Chip(label: Text('Sold')),
                ],
              ),
              const SizedBox(height: 12),
              Text(listing.description),
              const SizedBox(height: 20),
              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(listing.owner),
                  subtitle:
                      const Text('Seller profile and reviews'),
                  trailing:
                      const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SellerScreen(
                          store: store,
                          seller: listing.owner,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              if (isOwner) ...[
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListingFormScreen(
                          store: store,
                          existing: listing,
                          onComplete: () =>
                              Navigator.pop(context),
                        ),
                      ),
                    );
                  },
                  child: const Text('Edit'),
                ),
                FilledButton(
                  onPressed: listing.sold
                      ? null
                      : () {
                          showDialog<void>(
                            context: context,
                            builder: (_) => SoldDialog(
                              store: store,
                              item: listing,
                            ),
                          );
                        },
                  child: const Text('Mark as Sold'),
                ),
              ] else if (listing.sold &&
                  listing.buyerEmail.toLowerCase() ==
                      store.email.toLowerCase())
                FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReviewScreen(
                          store: store,
                          listing: listing,
                        ),
                      ),
                    );
                  },
                  child: const Text('Leave a Review'),
                )
              else if (!listing.sold)
                const Text(
                  'Contact the seller using their university email.',
                ),
            ],
          ),
        );
      },
    );
  }
}

// SCREEN 6: CREATE / EDIT LISTING

class ListingFormScreen extends StatefulWidget {
  const ListingFormScreen({
    super.key,
    required this.store,
    required this.onComplete,
    this.existing,
    this.embedded = false,
  });

  final Store store;
  final VoidCallback onComplete;
  final Listing? existing;
  final bool embedded;

  @override
  State<ListingFormScreen> createState() =>
      _ListingFormScreenState();
}

class _ListingFormScreenState
    extends State<ListingFormScreen> {
  final formKey = GlobalKey<FormState>();

  late final title = TextEditingController(
    text: widget.existing?.title ?? '',
  );

  late final description = TextEditingController(
    text: widget.existing?.description ?? '',
  );

  late final price = TextEditingController(
    text: widget.existing?.price.toStringAsFixed(0) ?? '',
  );

  late final image = TextEditingController(
    text: widget.existing?.imageUrl ?? '',
  );

  late String category =
      widget.existing?.category ?? 'Books';

  late String condition =
      widget.existing?.condition ?? 'Good';

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    price.dispose();
    image.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    final item = widget.existing ??
        Listing(
          id: widget.store.nextId++,
          title: '',
          price: 0,
          category: category,
          condition: condition,
          description: '',
          owner: widget.store.user,
        );

    item.title = title.text.trim();
    item.description = description.text.trim();
    item.price =
        double.parse(price.text.replaceAll(',', '.'));
    item.category = category;
    item.condition = condition;
    item.imageUrl = image.text.trim();

    widget.store.save(item);

    if (!mounted) return;

    await showNotice(
      context,
      'Success',
      widget.existing == null
          ? 'Listing posted successfully.'
          : 'Listing updated successfully.',
    );

    if (!mounted) return;

    if (widget.embedded) {
      title.clear();
      description.clear();
      price.clear();
      image.clear();
      formKey.currentState?.reset();

      setState(() {
        category = 'Books';
        condition = 'Good';
      });
    }

    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.embedded
          ? null
          : AppBar(
              title: Text(
                widget.existing == null
                    ? 'New Listing'
                    : 'Edit Listing',
              ),
            ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Image.asset(
                'assets/placeholder.png',
                height: 130,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: image,
                decoration: const InputDecoration(
                  labelText: 'Photo URL (optional)',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (v) =>
                    (v ?? '').trim().isEmpty
                        ? 'Title is required'
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: description,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (v) =>
                    (v ?? '').trim().isEmpty
                        ? 'Description is required'
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: price,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Price (0 for free)',
                ),
                validator: (v) {
                  final number = double.tryParse(
                    (v ?? '').replaceAll(',', '.'),
                  );

                  if (number == null ||
                      !number.isFinite ||
                      number < 0) {
                    return 'Enter a valid price';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
                items: [
                  'Books',
                  'Electronics',
                  'Furniture',
                  'Clothing',
                ].map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  category = value ?? 'Books';
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: condition,
                decoration: const InputDecoration(
                  labelText: 'Condition',
                ),
                items: [
                  'New',
                  'Like new',
                  'Good',
                  'Fair',
                ].map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  condition = value ?? 'Good';
                },
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: submit,
                child: Text(
                  widget.existing == null
                      ? 'Post Listing'
                      : 'Save Changes',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SCREEN 7: MARK AS SOLD

class SoldDialog extends StatefulWidget {
  const SoldDialog({
    super.key,
    required this.store,
    required this.item,
  });

  final Store store;
  final Listing item;

  @override
  State<SoldDialog> createState() => _SoldDialogState();
}

class _SoldDialogState extends State<SoldDialog> {
  final formKey = GlobalKey<FormState>();
  final buyer = TextEditingController();

  @override
  void dispose() {
    buyer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Who bought it?'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Only this buyer can review you.',
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: buyer,
              decoration: const InputDecoration(
                labelText: 'Buyer university email',
              ),
              validator: (v) =>
                  validEmail(v ?? '')
                      ? null
                      : 'Enter a valid university email',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) {
              return;
            }

            widget.store.markSold(
              widget.item,
              buyer.text.trim(),
            );

            Navigator.pop(context);
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

// SCREEN 8: MY PROFILE

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.store,
    required this.onTap,
    required this.onEdit,
  });

  final Store store;
  final void Function(Listing) onTap;
  final void Function(Listing) onEdit;

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool sold = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final items = widget.store.listings.where((item) {
          return item.owner == widget.store.user &&
              item.sold == sold;
        }).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const CircleAvatar(
              radius: 38,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 12),
            Text(
              widget.store.user,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.store.email,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  label: Text('Active'),
                ),
                ButtonSegment(
                  value: true,
                  label: Text('Sold'),
                ),
              ],
              selected: {sold},
              onSelectionChanged: (value) {
                setState(() => sold = value.first);
              },
            ),
            const SizedBox(height: 12),
            ...items.map((item) {
              return Card(
                child: ListTile(
                  leading: SizedBox(
                    width: 55,
                    child: listingImage(
                      item,
                      height: 55,
                    ),
                  ),
                  title: Text(item.title),
                  subtitle: Text(priceText(item.price)),
                  onTap: () => widget.onTap(item),
                  trailing: PopupMenuButton<String>(
                    onSelected: (action) async {
                      if (action == 'Edit') {
                        widget.onEdit(item);
                        return;
                      }

                      final confirmed =
                          await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title:
                              const Text('Delete listing?'),
                          content: Text(
                            'Remove ${item.title}?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(ctx, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        widget.store.remove(item.id);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'Edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

// SCREEN 9: SELLER PROFILE

class SellerScreen extends StatelessWidget {
  const SellerScreen({
    super.key,
    required this.store,
    required this.seller,
  });

  final Store store;
  final String seller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final average = store.reviews.isEmpty
            ? 0.0
            : store.reviews
                    .map((r) => r.rating)
                    .reduce((a, b) => a + b) /
                store.reviews.length;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Seller Profile'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const CircleAvatar(
                radius: 36,
                child: Icon(Icons.person),
              ),
              const SizedBox(height: 12),
              Text(
                seller,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${average.toStringAsFixed(1)} ★  ·  ${store.reviews.length} reviews',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Buyer reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...store.reviews.map(
                (review) => Card(
                  child: ListTile(
                    title: Text(review.author),
                    subtitle: Text(review.comment),
                    trailing:
                        Text('${review.rating} ★'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// SCREEN 10: FAVORITES

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({
    super.key,
    required this.store,
    required this.onTap,
  });

  final Store store;
  final void Function(Listing) onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final items = store.listings.where((item) {
          return store.favorites.contains(item.id);
        }).toList();

        if (items.isEmpty) {
          return const Center(
            child: Text(
              'No favorites yet. Tap a heart to save an item.',
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(12),
          children: items.map((item) {
            return ListingTile(
              item: item,
              store: store,
              compact: true,
              onTap: () => onTap(item),
            );
          }).toList(),
        );
      },
    );
  }
}

// SCREEN 11: LEAVE A REVIEW

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({
    super.key,
    required this.store,
    required this.listing,
  });

  final Store store;
  final Listing listing;

  @override
  State<ReviewScreen> createState() =>
      _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final formKey = GlobalKey<FormState>();
  final comment = TextEditingController();
  int rating = 5;

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    widget.store.addReview(
      Review(
        widget.store.user,
        rating,
        comment.text.trim(),
      ),
    );

    await showNotice(
      context,
      'Success',
      'Your review was submitted.',
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave a Review'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text(
              widget.listing.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Seller: ${widget.listing.owner}',
            ),
            const SizedBox(height: 20),
            const Text('How was the seller?'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() => rating = index + 1);
                  },
                  icon: Icon(
                    index < rating
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.orange,
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: comment,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Comment',
              ),
              validator: (v) =>
                  (v ?? '').trim().isEmpty
                      ? 'Please write a comment'
                      : null,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: submit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
