import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const RetailProApp());
}

class RetailProApp extends StatelessWidget {
  const RetailProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retail AI Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F19), // Deep Midnight
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF), // Neon Teal
          secondary: Color(0xFF00E676), // Neon Green
          surface: Color(0xFF151C2C), // Slightly lighter panel color
          background: Color(0xFF0B0F19),
        ),
        fontFamily: 'Roboto', // Default clean font
        cardTheme: CardThemeData(
          elevation: 8,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF2A3441), width: 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF0F1522),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.grey),
        ),
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AiDashboardTab(),
    const PosTerminalTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_currentIndex]),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF0F1522),
        indicatorColor: const Color(0xFF00E5FF).withOpacity(0.2),
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.auto_graph_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.auto_graph, color: Color(0xFF00E5FF)),
            label: 'AI Forecast',
          ),
          NavigationDestination(
            icon: Icon(Icons.point_of_sale_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.point_of_sale, color: Color(0xFF00E5FF)),
            label: 'Register',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 🧠 TAB 1: The AI Dashboard (FastAPI)
// ==========================================
class AiDashboardTab extends StatefulWidget {
  const AiDashboardTab({super.key});

  @override
  State<AiDashboardTab> createState() => _AiDashboardTabState();
}

class _AiDashboardTabState extends State<AiDashboardTab> {
  bool _isLoading = false;
  String _predictionResult = "--";

  final String _fastApiUrl = "http://localhost:8000/predict";

  Future<void> fetchPrediction() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse(_fastApiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "store": 1,
          "item": 15,
          "year": 2026,
          "month": 7,
          "day_of_week": 5
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _predictionResult = data['predicted_sales'].toString();
        });
      } else {
        setState(() => _predictionResult = "ERR");
      }
    } catch (e) {
      setState(() => _predictionResult = "OFF");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.memory, color: Color(0xFF00E5FF), size: 32),
              const SizedBox(width: 12),
              Text("Neural Forecast", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          const Text("XGBoost Predictive Engine  //  Port 8000", style: TextStyle(color: Color(0xFF00E5FF), fontFamily: 'Courier', fontSize: 12)),
          const SizedBox(height: 40),
          
          // Result Card with Gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF152336), Color(0xFF0B121C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3), width: 1),
              boxShadow: [
                BoxShadow(color: const Color(0xFF00E5FF).withOpacity(0.1), blurRadius: 20, spreadRadius: 2),
              ]
            ),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  const Text("PROJECTED DEMAND (ITEM 15)", style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 2)),
                  const SizedBox(height: 16),
                  _isLoading 
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: CircularProgressIndicator(color: Color(0xFF00E5FF)),
                      )
                    : Text(
                        _predictionResult, 
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 84, 
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                          shadows: [Shadow(color: Color(0xFF00E5FF), blurRadius: 20)]
                        )
                      ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_upward, color: Color(0xFF00E676), size: 16),
                      SizedBox(width: 4),
                      Text("High Confidence", style: TextStyle(color: Color(0xFF00E676), fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
          ),
          
          const Spacer(),
          
          // Action Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 10,
                shadowColor: const Color(0xFF00E5FF).withOpacity(0.5),
              ),
              onPressed: fetchPrediction,
              child: const Text("INITIALIZE SCAN", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ==========================================
// 🛒 TAB 2: The POS Register (Node.js)
// ==========================================
class PosTerminalTab extends StatefulWidget {
  const PosTerminalTab({super.key});

  @override
  State<PosTerminalTab> createState() => _PosTerminalTabState();
}

class _PosTerminalTabState extends State<PosTerminalTab> {
  final TextEditingController _storeController = TextEditingController(text: "STORE_001");
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(); // NEW: Price Controller
  int _quantity = 1;
  bool _isSubmitting = false;

  final String _nodeApiUrl = "http://localhost:5000/api/sales"; 

  Future<void> submitSale() async {
    if (_storeController.text.isEmpty || _itemController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Store, Item, and Price are required.', style: TextStyle(fontFamily: 'Courier')), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final response = await http.post(
        Uri.parse(_nodeApiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "store_id": _storeController.text,
          "item_id": _itemController.text,
          "price": double.tryParse(_priceController.text) ?? 0.0, // NEW: Added Price
          "quantity_sold": _quantity, // FIXED: Renamed to match your MongoDB schema
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SUCCESS: Data written to MongoDB.', style: TextStyle(fontFamily: 'Courier', fontWeight: FontWeight.bold)), backgroundColor: Color(0xFF00E676)),
        );
        setState(() {
          _itemController.clear();
          _priceController.clear(); // Clear price after success
          _quantity = 1;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('FAULT: ${response.body}'), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('LINK DEAD: Check Node.js port 5000.'), backgroundColor: Colors.redAccent),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.qr_code_scanner, color: Color(0xFF00E676), size: 32),
              const SizedBox(width: 12),
              Text("POS Terminal", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          const Text("Secure Uplink // MongoDB Active", style: TextStyle(color: Color(0xFF00E676), fontFamily: 'Courier', fontSize: 12)),
          const SizedBox(height: 32),
          
          Expanded( // Added Expanded so it scrolls nicely on smaller screens
            child: SingleChildScrollView(
              child: Card(
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _storeController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          labelText: "Origin Store ID",
                          prefixIcon: Icon(Icons.store, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _itemController,
                        style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
                        decoration: const InputDecoration(
                          labelText: "Product SKU / Item ID",
                          prefixIcon: Icon(Icons.tag, color: Color(0xFF00E5FF)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          labelText: "Unit Price (\$)",
                          prefixIcon: Icon(Icons.attach_money, color: Color(0xFF00E676)),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B0F19),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF2A3441)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("QUANTITY", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                            Row(
                              children: [
                                IconButton(
                                  style: IconButton.styleFrom(backgroundColor: const Color(0xFF151C2C)),
                                  onPressed: () {
                                    if (_quantity > 1) setState(() => _quantity--);
                                  }, 
                                  icon: const Icon(Icons.remove, color: Colors.white)
                                ),
                                const SizedBox(width: 24),
                                Text("$_quantity", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
                                const SizedBox(width: 24),
                                IconButton(
                                  style: IconButton.styleFrom(backgroundColor: const Color(0xFF151C2C)),
                                  onPressed: () => setState(() => _quantity++), 
                                  icon: const Icon(Icons.add, color: Color(0xFF00E676))
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E676),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 10,
                shadowColor: const Color(0xFF00E676).withOpacity(0.5),
              ),
              onPressed: _isSubmitting ? null : submitSale,
              icon: _isSubmitting 
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3))
                  : const Icon(Icons.check_circle_outline, size: 28),
              label: Text(
                _isSubmitting ? "TRANSMITTING..." : "AUTHORIZE TRANSACTION", 
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.5)
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}