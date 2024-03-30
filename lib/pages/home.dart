import 'package:fin_track_ocr/models/expense.dart';
import 'package:fin_track_ocr/pages/splash_screen.dart';
import 'package:fin_track_ocr/services/auth_service.dart';
import 'package:fin_track_ocr/pages/add_expense_form.dart';
import 'package:fin_track_ocr/services/database_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String uid;
  const Home({super.key, required this.uid});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final DatabaseService _databaseService;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService(uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(249, 238, 232, 232),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 174, 9, 31),
        elevation: 0.0,
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width, // Largeur maximale
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/fintrack-ocr-favicon-black.png',
                  width: 100,
                  height: 50,
                ),
                const Text(
                  'FinTrack OCR',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  icon: const Icon(Icons.person),
                  label: const Text('Logout'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: StreamBuilder<List<Expense>>(
                stream: _databaseService
                    .userExpenses, // Utilisez le flux pour récupérer les dépenses de l'utilisateur
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Affichez un indicateur de chargement tant que les données sont en cours de récupération
                    return const SplashScreen();
                  } else {
                    if (snapshot.hasError) {
                      // Affichez un message d'erreur s'il y a eu une erreur lors de la récupération des données
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      // Affichez les dépenses en temps réel
                      final expenses = snapshot.data ?? [];
                      return ListView.builder(
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final expense = expenses[index];
                          return ListTile(
                            title: Text('Expense ${index + 1}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Total Amount: \$${expense.totalAmount.toStringAsFixed(2)}'),
                                Text('Seller: ${expense.seller ?? 'N/A'}'),
                                Text(
                                    'Date: ${expense.date != null ? expense.date!.toString() : 'N/A'}'),
                                const Text('Products:'),
                                for (var product in expense.products)
                                  Text(
                                      '- ${product.name}, Quantity: ${product.quantity}, Price: \$${product.price.toStringAsFixed(2)}'),
                              ],
                            ),
                            // Affichez d'autres détails de la dépense selon vos besoins
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Afficher le formulaire d'ajout de dépense manuellement dans une boîte de dialogue contextuelle (popup)
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Center(child: Text('Add an Expense')),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 20), // Ajoutez un padding personnalisé
                        content: SizedBox(
                          // Utilisez SizedBox pour définir une largeur maximale
                          width: MediaQuery.of(context).size.width *
                              0.95, // Vous pouvez ajuster le facteur 0.9 selon vos besoins
                          child: SingleChildScrollView(
                            child: AddExpenseForm(
                                uid: widget
                                    .uid), // Utilisez le formulaire d'ajout de dépense ici
                          ),
                        ),
                        actions: [
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add \nmanually'),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Action pour capturer un reçu d'une dépense
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Scan \na receipt'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
