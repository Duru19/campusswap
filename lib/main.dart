import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const navy = Color(0xFF082F79);
const pale = Color(0xFFF1F4F9);

void main() => runApp(const CampusSwapApp());

class Listing {
  Listing({required this.id, required this.title, required this.price, required this.category, required this.condition, required this.description, required this.owner, this.imageUrl = '', this.sold = false, this.buyerEmail = ''});
  final int id;
  String title, category, condition, description, owner, imageUrl, buyerEmail;
  double price;
  bool sold;
}

class Review {
  Review(this.author, this.stars, this.comment);
  final String author, comment;
  final int stars;
}

class Store extends ChangeNotifier {
  String user = 'Orkun Güzel';
  String email = 'orkun.guzel@sabanciuniv.edu';
  int nextId = 10;
  final favorites = <int>{2, 4};
  final reviews = <Review>[Review('Mert A.', 5, 'Great communication!'), Review('Zeynep T.', 4, 'Item as described.'), Review('Can B.', 5, 'Easy campus pickup.')];
  final listings = <Listing>[
    Listing(id: 1, title: 'Calculus Book', price: 150, category: 'Books', condition: 'Good', description: 'Calculus textbook in good condition.', owner: 'Orkun Güzel'),
    Listing(id: 2, title: 'Casio fx-991EX', price: 250, category: 'Electronics', condition: 'Like new', description: 'Scientific calculator, works perfectly.', owner: 'Ayşe K.', imageUrl: 'https://images.unsplash.com/photo-1587145820266-a5951ee6f620?w=700'),
    Listing(id: 3, title: 'Desk Lamp', price: 0, category: 'Furniture', condition: 'Good', description: 'Free desk lamp for pickup.', owner: 'Orkun Güzel'),
    Listing(id: 4, title: 'Mini Fridge', price: 800, category: 'Furniture', condition: 'Good', description: 'Compact fridge for dorm room.', owner: 'Ayşe K.'),
    Listing(id: 5, title: 'Lab Coat', price: 100, category: 'Clothing', condition: 'Like new', description: 'Clean laboratory coat.', owner: 'Mert A.'),
    Listing(id: 6, title: 'Winter Jacket', price: 300, category: 'Clothing', condition: 'Good', description: 'Warm winter jacket.', owner: 'Zeynep T.'),
  ];
  void toggleFavorite(int id) { if (!favorites.add(id)) favorites.remove(id); notifyListeners(); }
  void remove(int id) { listings.removeWhere((e) => e.id == id); favorites.remove(id); notifyListeners(); }
  void save(Listing item) { if (!listings.any((e) => e.id == item.id)) listings.insert(0, item); notifyListeners(); }
  void markSold(Listing item, String buyer) { item.sold = true; item.buyerEmail = buyer; notifyListeners(); }
  void addReview(Review review) { reviews.insert(0, review); notifyListeners(); }
}

class CampusSwapApp extends StatefulWidget {
  const CampusSwapApp({super.key});
  @override State<CampusSwapApp> createState() => _CampusSwapAppState();
}
class _CampusSwapAppState extends State<CampusSwapApp> {
  final store = Store();
  bool loggedIn = false;
  @override Widget build(BuildContext context) => AnimatedBuilder(animation: store, builder: (context, _) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'CampusSwap',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: navy), scaffoldBackgroundColor: Colors.white, textTheme: GoogleFonts.nunitoSansTextTheme(), inputDecorationTheme: InputDecoration(filled: true, fillColor: pale, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)), appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: Color(0xFF15223C), surfaceTintColor: Colors.white)),
    home: loggedIn ? MainShell(store: store, logout: () => setState(() => loggedIn = false)) : AuthScreen(onLogin: (name, email) { store.user = name; store.email = email; setState(() => loggedIn = true); }),
  ));
}

String priceText(double price) => price == 0 ? 'Free' : '${price.toStringAsFixed(price % 1 == 0 ? 0 : 2)} TL';
Widget imageOf(Listing listing, {double height = 140}) => ClipRRect(borderRadius: BorderRadius.circular(12), child: SizedBox(height: height, width: double.infinity, child: listing.imageUrl.isEmpty ? Image.asset('assets/images/placeholder.png', fit: BoxFit.cover) : Image.network(listing.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Image.asset('assets/images/placeholder.png', fit: BoxFit.cover))));
Future<void> notice(BuildContext context, String title, String message) async => showDialog<void>(context: context, builder: (ctx) => AlertDialog(title: Text(title), content: Text(message), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))]));

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.onLogin});
  final void Function(String, String) onLogin;
  @override State<AuthScreen> createState() => _AuthScreenState();
}
class _AuthScreenState extends State<AuthScreen> {
  bool signUp = false;
  final form = GlobalKey<FormState>();
  final name = TextEditingController(), email = TextEditingController(), password = TextEditingController(), phone = TextEditingController();
  @override void dispose() { name.dispose(); email.dispose(); password.dispose(); phone.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 440), child: Form(key: form, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    const CircleAvatar(radius: 36, backgroundColor: navy, child: Text('CS', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold))),
    const SizedBox(height: 16), Text(signUp ? 'Create Account' : 'CampusSwap', textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: navy)),
    const SizedBox(height: 5), if (!signUp) const Text('Swap on campus', textAlign: TextAlign.center), const SizedBox(height: 30),
    if (signUp) ...[TextFormField(controller: name, decoration: const InputDecoration(labelText: 'Full name'), validator: (v) => (v ?? '').trim().isEmpty ? 'Name is required' : null), const SizedBox(height: 12)],
    TextFormField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'University email', hintText: 'name@sabanciuniv.edu'), validator: (v) => RegExp(r'^[^@\s]+@sabanciuniv\.edu$').hasMatch((v ?? '').trim().toLowerCase()) ? null : 'Enter a valid Sabancı University email'),
    const SizedBox(height: 12), TextFormField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password'), validator: (v) => (v ?? '').length < 6 ? 'Use at least 6 characters' : null),
    if (signUp) ...[const SizedBox(height: 12), TextFormField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone (optional)'))],
    const SizedBox(height: 20), FilledButton(onPressed: () { if (form.currentState!.validate()) widget.onLogin(signUp ? name.text.trim() : (email.text.trim().toLowerCase() == 'orkun.guzel@sabanciuniv.edu' ? 'Orkun Güzel' : email.text.trim().split('@').first), email.text.trim()); }, child: Text(signUp ? 'Sign Up' : 'Log In')),
    TextButton(onPressed: () { form.currentState?.reset(); setState(() => signUp = !signUp); }, child: Text(signUp ? 'Already have an account? Log In' : 'New here? Sign Up')),
  ]))))));
}

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.store, required this.logout});
  final Store store;
  final VoidCallback logout;
  @override State<MainShell> createState() => _MainShellState();
}
class _MainShellState extends State<MainShell> {
  int tab = 0;
  void details(Listing item) => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(store: widget.store, listing: item)));
  void edit([Listing? item]) => Navigator.push(context, MaterialPageRoute(builder: (_) => ListingFormScreen(store: widget.store, existing: item, onComplete: () { Navigator.pop(context); setState(() => tab = 0); })));
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(['CampusSwap', 'Search', 'New Listing', 'Favorites', 'Profile'][tab], style: const TextStyle(fontWeight: FontWeight.bold)), actions: tab == 4 ? [TextButton(onPressed: widget.logout, child: const Text('Log out'))] : null),
    body: IndexedStack(index: tab, children: [HomeScreen(store: widget.store, onTap: details, onSearch: () => setState(() => tab = 1)), SearchScreen(store: widget.store, onTap: details), Center(child: ListingFormScreen(store: widget.store, embedded: true, onComplete: () => setState(() => tab = 0))), FavoritesScreen(store: widget.store, onTap: details), ProfileScreen(store: widget.store, onTap: details, onEdit: edit)]),
    bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (v) => setState(() => tab = v), destinations: const [NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'), NavigationDestination(icon: Icon(Icons.search), label: 'Search'), NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'Sell'), NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Saved'), NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile')]),
  );
}

class ListingTile extends StatelessWidget {
  const ListingTile({super.key, required this.item, required this.store, required this.onTap, this.compact = false});
  final Listing item;
  final Store store;
  final VoidCallback onTap;
  final bool compact;
  @override Widget build(BuildContext context) => Card(clipBehavior: Clip.antiAlias, margin: const EdgeInsets.all(5), child: InkWell(onTap: onTap, child: Padding(padding: const EdgeInsets.all(10), child: compact ? Row(children: [SizedBox(width: 95, child: imageOf(item, height: 82)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(priceText(item.price), style: const TextStyle(color: navy, fontWeight: FontWeight.bold)), Text(item.category), if (item.sold) const Text('SOLD', style: TextStyle(color: Colors.red))])), IconButton(onPressed: () => store.toggleFavorite(item.id), icon: Icon(store.favorites.contains(item.id) ? Icons.favorite : Icons.favorite_border, color: navy))]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [imageOf(item), const SizedBox(height: 8), Row(children: [Expanded(child: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold))), IconButton(onPressed: () => store.toggleFavorite(item.id), icon: Icon(store.favorites.contains(item.id) ? Icons.favorite : Icons.favorite_border, color: navy))]), Text(priceText(item.price), style: const TextStyle(color: navy, fontWeight: FontWeight.bold)), if (item.sold) const Text('SOLD', style: TextStyle(color: Colors.red))]))));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.store, required this.onTap, required this.onSearch});
  final Store store; final void Function(Listing) onTap; final VoidCallback onSearch;
  @override State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  String category = 'All';
  @override Widget build(BuildContext context) { final items = widget.store.listings.where((e) => !e.sold && (category == 'All' || e.category == category)).toList(); return ListView(padding: const EdgeInsets.all(14), children: [TextField(readOnly: true, onTap: widget.onSearch, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search items...')), const SizedBox(height: 12), SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: ['All', 'Books', 'Electronics', 'Furniture', 'Clothing'].map((c) => Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(c), selected: category == c, onSelected: (_) => setState(() => category = c)))).toList())), const SizedBox(height: 16), const Text('Newest listings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 8), LayoutBuilder(builder: (context, constraints) => GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: items.length, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: constraints.maxWidth > 550 ? 3 : 2, mainAxisExtent: 255), itemBuilder: (ctx, i) => ListingTile(item: items[i], store: widget.store, onTap: () => widget.onTap(items[i]))))]); }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.store, required this.onTap});
  final Store store; final void Function(Listing) onTap;
  @override State<SearchScreen> createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  final query = TextEditingController(), min = TextEditingController(), max = TextEditingController();
  String category = 'All'; bool filtered = false;
  @override void dispose() { query.dispose(); min.dispose(); max.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) { final items = widget.store.listings.where((e) { if (e.sold || !e.title.toLowerCase().contains(query.text.toLowerCase())) return false; if (!filtered) return true; final lo = double.tryParse(min.text) ?? 0, hi = double.tryParse(max.text) ?? double.infinity; return (category == 'All' || e.category == category) && e.price >= lo && e.price <= hi; }).toList(); return ListView(padding: const EdgeInsets.all(16), children: [TextField(controller: query, onChanged: (_) => setState(() {}), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search items...')), const SizedBox(height: 12), DropdownButtonFormField<String>(initialValue: category, decoration: const InputDecoration(labelText: 'Category'), items: ['All', 'Books', 'Electronics', 'Furniture', 'Clothing'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (v) => setState(() => category = v!)), const SizedBox(height: 12), Row(children: [Expanded(child: TextField(controller: min, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Min price'))), const SizedBox(width: 12), Expanded(child: TextField(controller: max, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Max price')))]), const SizedBox(height: 12), FilledButton(onPressed: () => setState(() => filtered = true), child: const Text('Apply Filters')), const SizedBox(height: 12), Text('${items.length} results'), ...items.map((e) => ListingTile(item: e, store: widget.store, compact: true, onTap: () => widget.onTap(e)))]); }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key, required this.store, required this.onTap});
  final Store store; final void Function(Listing) onTap;
  @override Widget build(BuildContext context) { final items = store.listings.where((e) => store.favorites.contains(e.id)).toList(); return items.isEmpty ? const Center(child: Text('No favorites yet. Tap a heart to save an item.')) : ListView(padding: const EdgeInsets.all(12), children: items.map((e) => ListingTile(item: e, store: store, compact: true, onTap: () => onTap(e))).toList()); }
}

class ListingFormScreen extends StatefulWidget {
  const ListingFormScreen({super.key, required this.store, required this.onComplete, this.existing, this.embedded = false});
  final Store store; final Listing? existing; final VoidCallback onComplete; final bool embedded;
  @override State<ListingFormScreen> createState() => _ListingFormScreenState();
}
class _ListingFormScreenState extends State<ListingFormScreen> {
  final keyForm = GlobalKey<FormState>();
  late final title = TextEditingController(text: widget.existing?.title ?? '');
  late final description = TextEditingController(text: widget.existing?.description ?? '');
  late final price = TextEditingController(text: widget.existing?.price.toStringAsFixed(0) ?? '');
  late final image = TextEditingController(text: widget.existing?.imageUrl ?? '');
  late String category = widget.existing?.category ?? 'Books', condition = widget.existing?.condition ?? 'Good';
  @override void dispose() { title.dispose(); description.dispose(); price.dispose(); image.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(appBar: widget.embedded ? null : AppBar(title: Text(widget.existing == null ? 'New Listing' : 'Edit Listing')), body: SafeArea(child: Form(key: keyForm, child: ListView(padding: const EdgeInsets.all(18), children: [
    Image.asset('assets/images/placeholder.png', height: 130), const SizedBox(height: 10),
    TextFormField(controller: image, decoration: const InputDecoration(labelText: 'Photo URL (optional)', prefixIcon: Icon(Icons.image_outlined))), const SizedBox(height: 12),
    TextFormField(controller: title, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => (v ?? '').trim().isEmpty ? 'Title is required' : null), const SizedBox(height: 12),
    TextFormField(controller: description, minLines: 2, maxLines: 4, decoration: const InputDecoration(labelText: 'Description'), validator: (v) => (v ?? '').trim().isEmpty ? 'Description is required' : null), const SizedBox(height: 12),
    TextFormField(controller: price, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Price (0 for free)'), validator: (v) { final n = double.tryParse((v ?? '').replaceAll(',', '.')); return n == null || n < 0 ? 'Enter a valid non-negative price' : null; }), const SizedBox(height: 12),
    DropdownButtonFormField<String>(initialValue: category, decoration: const InputDecoration(labelText: 'Category'), items: ['Books', 'Electronics', 'Furniture', 'Clothing'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) => category = v!), const SizedBox(height: 12),
    DropdownButtonFormField<String>(initialValue: condition, decoration: const InputDecoration(labelText: 'Condition'), items: ['New', 'Like new', 'Good', 'Fair'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) => condition = v!), const SizedBox(height: 20),
    FilledButton(onPressed: () async { if (!keyForm.currentState!.validate()) return; final item = widget.existing ?? Listing(id: widget.store.nextId++, title: '', price: 0, category: category, condition: condition, description: '', owner: widget.store.user); item.title = title.text.trim(); item.description = description.text.trim(); item.price = double.parse(price.text.replaceAll(',', '.')); item.category = category; item.condition = condition; item.imageUrl = image.text.trim(); widget.store.save(item); if (!mounted) return; await notice(context, 'Success', widget.existing == null ? 'Listing posted successfully.' : 'Listing updated successfully.'); if (mounted) { if (widget.embedded) { keyForm.currentState!.reset(); title.clear(); description.clear(); price.clear(); image.clear(); setState(() { category = 'Books'; condition = 'Good'; }); } widget.onComplete(); } }, child: Text(widget.existing == null ? 'Post Listing' : 'Save Changes')),
  ]))));
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.store, required this.listing});
  final Store store; final Listing listing;
  @override Widget build(BuildContext context) { final owner = listing.owner == store.user; return AnimatedBuilder(animation: store, builder: (context, _) => Scaffold(appBar: AppBar(title: const Text('Listing Details'), actions: [IconButton(onPressed: () => store.toggleFavorite(listing.id), icon: Icon(store.favorites.contains(listing.id) ? Icons.favorite : Icons.favorite_border))]), body: ListView(padding: const EdgeInsets.all(18), children: [imageOf(listing, height: 230), const SizedBox(height: 16), Row(children: [Expanded(child: Text(listing.title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold))), Text(priceText(listing.price), style: const TextStyle(fontSize: 20, color: navy, fontWeight: FontWeight.bold))]), const SizedBox(height: 8), Wrap(spacing: 8, children: [Chip(label: Text(listing.category)), Chip(label: Text(listing.condition)), if (listing.sold) const Chip(label: Text('Sold'))]), const SizedBox(height: 12), Text(listing.description), const SizedBox(height: 20), Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: Text(listing.owner), subtitle: const Text('Seller profile and reviews'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SellerScreen(store: store, seller: listing.owner))))), const SizedBox(height: 10), Text(listing.owner == 'Ayşe K.' ? 'ayse.k@sabanciuniv.edu' : store.email), const SizedBox(height: 18), if (owner) ...[OutlinedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ListingFormScreen(store: store, existing: listing, onComplete: () => Navigator.pop(context)))), child: const Text('Edit')), FilledButton(onPressed: listing.sold ? null : () => showDialog<void>(context: context, builder: (_) => SoldDialog(store: store, item: listing)), child: const Text('Mark as Sold'))] else if (listing.sold && listing.buyerEmail.toLowerCase() == store.email.toLowerCase()) FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewScreen(store: store, listing: listing))), child: const Text('Leave a Review')) else if (!listing.sold) const Text('Contact the seller using their university email to arrange a purchase.'),
  ]))); }
}

class SoldDialog extends StatefulWidget {
  const SoldDialog({super.key, required this.store, required this.item});
  final Store store; final Listing item;
  @override State<SoldDialog> createState() => _SoldDialogState();
}
class _SoldDialogState extends State<SoldDialog> {
  final form = GlobalKey<FormState>(), buyer = TextEditingController();
  @override void dispose() { buyer.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AlertDialog(title: const Text('Who bought it?'), content: Form(key: form, child: Column(mainAxisSize: MainAxisSize.min, children: [const Text('Only this buyer can review you.'), const SizedBox(height: 12), TextFormField(controller: buyer, decoration: const InputDecoration(labelText: "Buyer's university email"), validator: (v) => RegExp(r'^[^@\s]+@sabanciuniv\.edu$').hasMatch((v ?? '').trim().toLowerCase()) ? null : 'Enter a university email')])), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () { if (!form.currentState!.validate()) return; widget.store.markSold(widget.item, buyer.text.trim()); Navigator.pop(context); }, child: const Text('Confirm'))]);
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.store, required this.onTap, required this.onEdit});
  final Store store; final void Function(Listing) onTap; final void Function(Listing) onEdit;
  @override State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  bool sold = false;
  @override Widget build(BuildContext context) { final items = widget.store.listings.where((e) => e.owner == widget.store.user && e.sold == sold).toList(); return ListView(padding: const EdgeInsets.all(16), children: [const CircleAvatar(radius: 38, child: Icon(Icons.person, size: 40)), const SizedBox(height: 10), Text(widget.store.user, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), Text(widget.store.email, textAlign: TextAlign.center), const SizedBox(height: 6), const Text('★★★★★', textAlign: TextAlign.center, style: TextStyle(color: Colors.orange)), const SizedBox(height: 14), SegmentedButton<bool>(segments: const [ButtonSegment(value: false, label: Text('Active')), ButtonSegment(value: true, label: Text('Sold'))], selected: {sold}, onSelectionChanged: (v) => setState(() => sold = v.first)), const SizedBox(height: 10), ...items.map((item) => Card(child: ListTile(leading: SizedBox(width: 60, child: imageOf(item, height: 55)), title: Text(item.title), subtitle: Text(priceText(item.price)), onTap: () => widget.onTap(item), trailing: PopupMenuButton<String>(onSelected: (v) async { if (v == 'Edit') widget.onEdit(item); else { final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: const Text('Delete listing?'), content: Text('Remove ${item.title}?'), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete'))])); if (ok == true) widget.store.remove(item); } }, itemBuilder: (_) => const [PopupMenuItem(value: 'Edit', child: Text('Edit')), PopupMenuItem(value: 'Delete', child: Text('Delete'))]))))]); }
}

class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key, required this.store, required this.seller});
  final Store store; final String seller;
  @override Widget build(BuildContext context) { final avg = store.reviews.isEmpty ? 0.0 : store.reviews.map((r) => r.stars).reduce((a, b) => a + b) / store.reviews.length; return Scaffold(appBar: AppBar(title: const Text('Seller Profile')), body: ListView(padding: const EdgeInsets.all(16), children: [const CircleAvatar(radius: 36, child: Icon(Icons.person)), const SizedBox(height: 12), Text(seller, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)), Text('${avg.toStringAsFixed(1)} ★  ·  ${store.reviews.length} reviews', textAlign: TextAlign.center), const SizedBox(height: 20), const Text('Buyer reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), ...store.reviews.map((r) => Card(child: ListTile(title: Text(r.author), subtitle: Text(r.comment), trailing: Text('${r.stars} ★'))))])); }
}

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key, required this.store, required this.listing});
  final Store store; final Listing listing;
  @override State<ReviewScreen> createState() => _ReviewScreenState();
}
class _ReviewScreenState extends State<ReviewScreen> {
  final form = GlobalKey<FormState>(), comment = TextEditingController();
  int rating = 5;
  @override void dispose() { comment.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Leave a Review')), body: Form(key: form, child: ListView(padding: const EdgeInsets.all(18), children: [Text(widget.listing.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), Text('Seller: ${widget.listing.owner}'), const SizedBox(height: 20), const Text('How was the seller?'), Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => IconButton(onPressed: () => setState(() => rating = i + 1), icon: Icon(i < rating ? Icons.star : Icons.star_border, color: Colors.orange)))), TextFormField(controller: comment, maxLines: 4, decoration: const InputDecoration(labelText: 'Comment'), validator: (v) => (v ?? '').trim().isEmpty ? 'Please write a comment' : null), const SizedBox(height: 20), FilledButton(onPressed: () async { if (!form.currentState!.validate()) return; widget.store.addReview(Review(widget.store.user, rating, comment.text.trim())); await notice(context, 'Success', 'Your review was submitted.'); if (context.mounted) Navigator.pop(context); }, child: const Text('Submit'))])));
}
