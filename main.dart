// lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MultiRestaurantApp());
}

class MultiRestaurantApp extends StatelessWidget {
  const MultiRestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Restaurant Food Ordering App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepOrange,
        useMaterial3: true,
        fontFamily: 'Poppins', // optional: include in pubspec if desired
      ),
      home: const SplashScreen(),
    );
  }
}

// ---------------- SPLASH ----------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: const [
          Icon(Icons.restaurant_menu, size: 110, color: Colors.deepOrange),
          SizedBox(height: 20),
          Text(
            "Multi Restaurant\nFood Ordering App",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepOrange,
            ),
          ),
        ]),
      ),
    );
  }
}

// ---------------- LOGIN ----------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      final userName = _email.text.contains('@') ? _email.text.split('@')[0] : _email.text;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardPage(userName: userName)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(children: [
              const Icon(Icons.fastfood, size: 80, color: Colors.deepOrange),
              const SizedBox(height: 12),
              const Text("Multi Restaurant Food Ordering App",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
              const SizedBox(height: 24),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email, color: Colors.deepOrange)),
                validator: (v) => v == null || v.isEmpty ? "Enter email" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock, color: Colors.deepOrange)),
                validator: (v) => v == null || v.isEmpty ? "Enter password" : null,
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12)),
                child: const Text("Login"),
              ),
              const SizedBox(height: 10),
              TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpPage())), child: const Text("Create an account"))
            ]),
          ),
        ),
      ),
    );
  }
}

// ---------------- SIGNUP ----------------
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}
class _SignUpPageState extends State<SignUpPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _signup() {
    if (_formKey.currentState!.validate()) {
      final userName = _name.text.isNotEmpty ? _name.text : (_email.text.contains('@') ? _email.text.split('@')[0] : _email.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardPage(userName: userName)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up"), backgroundColor: Colors.deepOrange),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(controller: _name, decoration: const InputDecoration(labelText: "Name", prefixIcon: Icon(Icons.person, color: Colors.deepOrange))),
              const SizedBox(height: 12),
              TextFormField(controller: _email, decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email, color: Colors.deepOrange)), validator: (v) => v==null||v.isEmpty? "Enter email":null),
              const SizedBox(height: 12),
              TextFormField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock, color: Colors.deepOrange)), validator: (v)=> v==null||v.isEmpty? "Enter password":null),
              const SizedBox(height: 18),
              ElevatedButton(onPressed: _signup, style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange), child: const Text("Sign Up")),
            ]),
          ),
        ),
      ),
    );
  }
}

// ---------------- DASHBOARD (holds cart and restaurants) ----------------
class DashboardPage extends StatefulWidget {
  final String userName;
  const DashboardPage({super.key, required this.userName});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  // Cart stored here so it can be cleared on payment success
  final List<CartItem> _cart = [];

  // 5 restaurants each with 5 items
  final List<Map<String, dynamic>> restaurants = [
    {
      "name": "HYDERABAD DUM BIRYANI",
      "image": "assets/images/DumBiryani.jpeg",
      "type": "Indian • Veg & Non-Veg",
      "menu": [
        {"name": "chicken dum biryani", "price": "250", "image": "assets/images/Spicy dum biryani.jpg"},
        {"name": "Paneer Butter Masala", "price": "200", "image": "assets/images/buttermasala.jpg"},
        {"name": "Garlic Naan", "price": "50", "image": "assets/images/naan.jpg"},
        {"name": "chicken fry biryani", "price": "180", "image": "assets/images/chicken fry biryani.jpg"},
        {"name": "Mutton dum biryani", "price": "300", "image": "assets/images/mutton dum biryani.jpg"},
      ],
    },
    {
      "name": "Pizza Planet",
      "image": "assets/images/pizzaplanet.jpg",
      "type": "Italian • Pizza",
      "menu": [
        {"name": "corn pizza", "price": "280", "image": "assets/images/cornpizza.jpg"},
        {"name": "Pepperoni Pizza", "price": "350", "image": "assets/images/pepperpizza.jpg"},
        {"name": "Cheese Burst Pizza", "price": "400", "image": "assets/images/cheesebrustpizza.jpg"},
        {"name": "chicken pizza", "price": "250", "image": "assets/images/chickenpizza.jpg"},
        {"name": "Garlic Bread", "price": "120", "image": "assets/images/garlicbread.jpg"},
      ],
    },
    {
      "name": "Burger Hub",
      "image": "assets/images/burgerhub.jpg",
      "type": "Fast Food • Burgers",
      "menu": [
        {"name": "Cheese Burger", "price": "180", "image": "assets/images/cheeseburger.jpg"},
        {"name": "Chicken Burger", "price": "200", "image": "assets/images/chickenburger.jpg"},
        {"name": "Veg Burger", "price": "150", "image": "assets/images/vegburger.jpg"},
        {"name": "French Fries", "price": "80", "image": "assets/images/french.jpg"},
        {"name": "Onion Rings", "price": "90", "image": "assets/images/onionrings.jpg"},
      ],
    },
    {
      "name": "Dessert Haven",
      "image": "assets/images/desserts.jpg",
      "type": "Desserts • Bakery",
      "menu": [
        {"name": "Chocolate Cake", "price": "200", "image": "assets/images/chocolatecake.jpg"},
        {"name": "Ice Cream", "price": "150", "image": "assets/images/ice cream.jpg"},
        {"name": "Cupcake", "price": "100", "image": "assets/images/cupcake.jpg"},
        {"name": "Brownie", "price": "120", "image": "assets/images/brownie.jpg"},
        {"name": "Cheesecake", "price": "250", "image": "assets/images/cheesecake.jpg"},
      ],
    },
    {
      "name": "vegetarian restarunt",
      "image": "assets/images/veg.jpg",
      "type": "Indian • Grill",
      "menu": [
        {"name": "veg biryani", "price": "280", "image": "assets/images/vegbiryani.jpg"},
        {"name": "vada pav", "price": "220", "image": "assets/images/vadapav.jpg"},
        {"name": "ghobi manchurian", "price": "240", "image": "assets/images/ghobi.jpg"},
        {"name": "mushroom curry", "price": "300", "image": "assets/images/mushroomcurry.jpg"},
        {"name": "rajma", "price": "200", "image": "assets/images/rajma.jpg"},
      ],
    },
  ];

  // Search state (for Explore)
  String _searchQuery = "";
  // ignore: prefer_final_fields
  List<Map<String, String>> _allItems = [];

  @override
  void initState() {
    super.initState();
    // Flatten menu items for search
    for (var r in restaurants) {
      for (var m in r['menu']) {
        _allItems.add({
          "name": m['name'],
          "price": m['price'].toString(),
          "image": m['image'],
          "restaurant": r['name'],
        });
      }
    }
  }

  void _addToCartFromMap(Map<String, String> item) {
    setState(() {
      _cart.add(CartItem(name: item['name']!, price: item['price']!, image: item['image']!));
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added to cart")));
  }

  void _addToCart(CartItem item) {
    setState(() {
      _cart.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added to cart")));
  }

  void _clearCart() {
    setState(() {
      _cart.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    final pages = [
      _homeTab(),
      _exploreTab(),
      _profileTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.userName}!"),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: Stack(children: [
              const Icon(Icons.shopping_cart, color: Colors.white),
              if (_cart.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(radius: 8, backgroundColor: Colors.white, child: Text(_cart.length.toString(), style: const TextStyle(fontSize: 10, color: Colors.deepOrange))),
                ),
            ]),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage(cart: _cart, onProceedToPay: (total) {
                // open payment page; pass callback to clear cart on success
                Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentPage(total: total, onPaymentSuccess: () {
                  _clearCart();
                  // navigate to order tracking
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrderTrackingPage(userName: widget.userName)));
                })));
              })));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.orange.shade300,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // ---------------- HOME TAB ----------------
  Widget _homeTab() {
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text("Top Restaurants", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      ...restaurants.map((r) => GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantDetailPage(restaurant: r, onAdd: _addToCart))),
        child: Card(
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(12)), child: Image.asset(r['image'], height: 160, width: double.infinity, fit: BoxFit.cover)),
            ListTile(title: Text(r['name'], style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(r['type']), trailing: const Icon(Icons.arrow_forward_ios, color: Colors.deepOrange)),
          ]),
        ),
      // ignore: unnecessary_to_list_in_spreads
      )).toList(),
      const SizedBox(height: 18),
      Center(child: ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderTrackingPage(userName: widget.userName))), icon: const Icon(Icons.delivery_dining), label: const Text("Track Order"), style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange))),
      const SizedBox(height: 18),
    ]);
  }

  // ---------------- EXPLORE TAB (SEARCH) ----------------
  Widget _exploreTab() {
    final results = _searchQuery.trim().isEmpty ? _allItems : _allItems.where((it) => it['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) || it['restaurant']!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    return Column(children: [
      Padding(padding: const EdgeInsets.all(12.0), child: TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search, color: Colors.deepOrange), hintText: "Search items or restaurants", border: OutlineInputBorder()), onChanged: (v) => setState(() => _searchQuery = v))),
      Expanded(child: results.isEmpty ? const Center(child: Text("No items found")) : ListView.builder(padding: const EdgeInsets.all(12), itemCount: results.length, itemBuilder: (context, i) {
        final it = results[i];
        return Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(
          leading: Image.asset(it['image']!, width: 56, height: 56, fit: BoxFit.cover),
          title: Text(it['name']!),
          subtitle: Text("${it['restaurant']} • ₹${it['price']}"),
          trailing: ElevatedButton(onPressed: () => _addToCartFromMap(it), style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange), child: const Text("Add")),
        ));
      })),
    ]);
  }

  // ---------------- PROFILE TAB ----------------
  Widget _profileTab() {
    return ListView(padding: const EdgeInsets.all(16), children: [
      ListTile(leading: CircleAvatar(backgroundColor: Colors.deepOrange.shade100, child: const Icon(Icons.person, color: Colors.deepOrange)), title: Text(widget.userName)),
      const Divider(),
      ListTile(leading: const Icon(Icons.help_outline, color: Colors.deepOrange), title: const Text("Help & FAQ"), subtitle: const Text("Email: chandinitulluru54@gmail.com"), onTap: () {
        showDialog(context: context, builder: (_) => AlertDialog(title: const Text("Help & FAQ"), content: const Text("Contact: chandinitulluru54@gmail.com\n\nQ: How to order?\nA: Select items and pay via UPI or COD."), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))]));
      }),
      ListTile(leading: const Icon(Icons.logout, color: Colors.deepOrange), title: const Text("Logout"), onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()))),
    ]);
  }
}

// ---------------- CART ----------------
class CartItem {
  final String name, price, image;
  CartItem({required this.name, required this.price, required this.image});
}

// CartPage shows cart and lets user proceed to payment by calling onProceedToPay(total)
class CartPage extends StatelessWidget {
  final List<CartItem> cart;
  final Function(double) onProceedToPay;
  const CartPage({super.key, required this.cart, required this.onProceedToPay});

  double _total() {
    double t = 0;
    for (var c in cart) {
      t += double.tryParse(c.price) ?? 0;
    }
    return t;
  }

  @override
  Widget build(BuildContext context) {
    final total = _total();
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart"), backgroundColor: Colors.deepOrange),
      body: cart.isEmpty ? const Center(child: Text("Your cart is empty")) : Column(children: [
        Expanded(child: ListView(padding: const EdgeInsets.all(12), children: cart.map((c) => Card(child: ListTile(leading: Image.asset(c.image, width: 56, height: 56, fit: BoxFit.cover), title: Text(c.name), subtitle: Text("₹${c.price}")))).toList())),
        Padding(padding: const EdgeInsets.all(12), child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Total:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text("₹${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: () => onProceedToPay(total), style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange), child: const Text("Proceed to Payment")),
        ])),
      ]),
    );
  }
}

// ---------------- PAYMENT ----------------
class PaymentPage extends StatefulWidget {
  final double total;
  final VoidCallback onPaymentSuccess;
  const PaymentPage({super.key, required this.total, required this.onPaymentSuccess});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}
class _PaymentPageState extends State<PaymentPage> {
  String _method = "UPI";
  final _upiField = TextEditingController();
  final _phoneField = TextEditingController();

  void _pay() {
    if (_method == "UPI" && _upiField.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter UPI ID")));
      return;
    }
    if (_phoneField.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter contact number")));
      return;
    }
    // simulate payment processing
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
    Future.delayed(const Duration(seconds: 2), () {
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // close progress
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Payment successful")));
      // call success callback (which in Dashboard clears cart and navigates to OrderTracking)
      widget.onPaymentSuccess();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment"), backgroundColor: Colors.deepOrange),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Amount: ₹${widget.total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text("Select Payment Method:", style: TextStyle(fontWeight: FontWeight.bold)),
          // ignore: deprecated_member_use
          RadioListTile(value: "UPI", groupValue: _method, title: const Text("UPI"), activeColor: Colors.deepOrange, onChanged: (v) => setState(() => _method = v.toString())),
          if (_method == "UPI") TextField(controller: _upiField, decoration: const InputDecoration(labelText: "UPI ID (example: name@upi)")),
          const SizedBox(height: 8),
          TextField(controller: _phoneField, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "Contact Number")),
          const SizedBox(height: 20),
          Center(child: ElevatedButton(onPressed: _pay, style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange), child: const Text("Pay & Place Order"))),
        ]),
      ),
    );
  }
}

// ---------------- ORDER TRACKING (improved) ----------------
class OrderTrackingPage extends StatefulWidget {
  final String userName;
  const OrderTrackingPage({super.key, required this.userName});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}
class _OrderTrackingPageState extends State<OrderTrackingPage> with SingleTickerProviderStateMixin {
  int _step = 0;
  late Timer _timer;
  late AnimationController _animController;

  final List<_TrackStep> steps = [
    _TrackStep("Order Placed", Icons.check_circle_outline),
    _TrackStep("Preparing", Icons.kitchen),
    _TrackStep("Out for Delivery", Icons.delivery_dining),
    _TrackStep("Delivered", Icons.home),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _animController.forward();
    _timer = Timer.periodic(const Duration(seconds: 2), (t) {
      setState(() {
        if (_step < steps.length - 1) {
          _step++;
          _animController.forward(from: 0);
        } else {
          t.cancel();
          // After final step delay, navigate back to Dashboard (home)
          Future.delayed(const Duration(seconds: 1), () {
            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DashboardPage(userName: widget.userName)), (route) => false);
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animController.dispose();
    super.dispose();
  }

  Widget _buildStep(int i) {
    final done = i <= _step;
    return Column(children: [
      CircleAvatar(
        radius: 22,
        backgroundColor: done ? Colors.deepOrange : Colors.grey.shade300,
        child: Icon(steps[i].icon, color: done ? Colors.white : Colors.grey.shade700),
      ),
      const SizedBox(height: 6),
      SizedBox(width: 80, child: Text(steps[i].title, textAlign: TextAlign.center, style: TextStyle(color: done ? Colors.black : Colors.grey))),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Tracking"), backgroundColor: Colors.deepOrange),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const SizedBox(height: 18),
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: (_step + _animController.value) / (steps.length - 1),
                minHeight: 8,
                color: Colors.deepOrange,
                backgroundColor: Colors.orange.shade100,
              );
            },
          ),
          const SizedBox(height: 26),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(steps.length, (i) => _buildStep(i))),
          const SizedBox(height: 30),
          Expanded(child: Center(child: Text(
            _step < steps.length ? steps[_step].title : "Delivered",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ))),
          const SizedBox(height: 12),
          Text("Hi ${widget.userName}, your delivery progress is shown above.", textAlign: TextAlign.center),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}

class _TrackStep {
  final String title;
  final IconData icon;
  _TrackStep(this.title, this.icon);
}

// ---------------- RESTAURANT DETAIL ----------------
class RestaurantDetailPage extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final Function(CartItem) onAdd;
  const RestaurantDetailPage({super.key, required this.restaurant, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final menu = restaurant['menu'] as List<dynamic>;
    return Scaffold(
      appBar: AppBar(title: Text(restaurant['name']), backgroundColor: Colors.deepOrange),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: menu.length,
        itemBuilder: (context, i) {
          final item = menu[i] as Map<String, dynamic>;
          return Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(
            leading: Image.asset(item['image'], width: 60, height: 60, fit: BoxFit.cover),
            title: Text(item['name']),
            subtitle: Text("₹${item['price']}"),
            trailing: ElevatedButton(
              onPressed: () {
                onAdd(CartItem(name: item['name'], price: item['price'].toString(), image: item['image']));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added to cart")));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
              child: const Text("Add"),
            ),
          ));
        },
      ),
    );
  }
}
