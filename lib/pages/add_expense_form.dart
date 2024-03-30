import 'package:fin_track_ocr/models/expense.dart';
import 'package:fin_track_ocr/models/product.dart';
import 'package:fin_track_ocr/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:fin_track_ocr/shared/input_decoration_expense.dart';
import 'package:intl/intl.dart';

class ProductListTile extends StatefulWidget {
  final TextEditingController productController;
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final void Function() onRemove;

  const ProductListTile({
    super.key,
    required this.productController,
    required this.priceController,
    required this.quantityController,
    required this.onRemove,
  });

  @override
  ProductListTileState createState() => ProductListTileState();
}

class ProductListTileState extends State<ProductListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            validator: (value) =>
                value!.isEmpty ? 'Please enter the name of the product' : null,
            controller: widget.productController,
            decoration:
                expenseInputDecoration.copyWith(labelText: 'Name of product'),
          ),
          TextFormField(
            validator: (value) =>
                value!.isEmpty ? 'Please enter the price of the product' : null,
            controller: widget.priceController,
            decoration: expenseInputDecoration.copyWith(labelText: 'Price'),
            keyboardType: TextInputType.number,
          ),
          Row(
            children: [
              // const Text('Quantité'),
              IconButton(
                onPressed: () => _decrementQuantity(),
                icon: const Icon(Icons.remove),
              ),
              Text(widget.quantityController.text),
              IconButton(
                onPressed: () => _incrementQuantity(),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.remove_circle_outline),
        onPressed: widget.onRemove,
        color: const Color.fromARGB(255, 143, 6, 6),
        highlightColor: const Color.fromARGB(255, 227, 7, 7),
      ),
    );
  }

  void _incrementQuantity() {
    setState(() {
      int currentValue = int.tryParse(widget.quantityController.text) ?? 0;
      widget.quantityController.text = (currentValue + 1).toString();
    });
  }

  void _decrementQuantity() {
    setState(() {
      int currentValue = int.tryParse(widget.quantityController.text) ?? 0;
      if (currentValue > 1) {
        widget.quantityController.text = (currentValue - 1).toString();
      }
    });
  }
}

class AddExpenseForm extends StatefulWidget {
  final String uid;
  const AddExpenseForm({super.key, required this.uid});

  @override
  AddExpenseFormState createState() => AddExpenseFormState();
}

class AddExpenseFormState extends State<AddExpenseForm> {
  late final DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService(uid: widget.uid);
    _addProductField(); // Ajoutez un champ de produit initial
  }

  // final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _productControllers = [];
  final List<TextEditingController> _priceControllers = [];
  final List<TextEditingController> _quantityControllers = [];
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _sellerController = TextEditingController();

  static get uid => null;

  @override
  void dispose() {
    for (var controller in _productControllers) {
      controller.dispose();
    }
    for (var controller in _priceControllers) {
      controller.dispose();
    }
    for (var controller in _quantityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addProductField() {
    _productControllers.add(TextEditingController());
    _priceControllers.add(TextEditingController());
    TextEditingController quantityController =
        TextEditingController(text: '1'); // Initialisation avec la valeur 1
    _quantityControllers.add(quantityController);
    setState(() {});
  }

  void _removeProductField(int index) {
    _productControllers.removeAt(index);
    _priceControllers.removeAt(index);
    _quantityControllers.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < _productControllers.length; i++)
            ProductListTile(
              key: Key('$i'), // Utilisation de l'index comme clé unique
              productController: _productControllers[i],
              priceController: _priceControllers[i],
              quantityController: _quantityControllers[i],
              onRemove: () => _removeProductField(i),
            ),
          Center(
            child: TextButton.icon(
              onPressed: _addProductField,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add a product'),
            ),
          ),
          ListTile(
            title: TextFormField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date'),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2015, 8),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    _dateController.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(picked);
                  });
                }
              },
            ),
          ),
          ListTile(
            title: TextFormField(
              controller: _sellerController,
              decoration: const InputDecoration(labelText: 'Seller'),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Center(
            child: ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
              ),
              onPressed: () {
                  // Submit form data
                  List<Map<String, dynamic>> productsData = [];
                  for (int i = 0; i < _productControllers.length; i++) {
                    String productName = _productControllers[i].text;
                    double price =
                        double.tryParse(_priceControllers[i].text) ?? 0.0;
                    int quantity =
                        int.tryParse(_quantityControllers[i].text) ?? 0;
                    productsData.add({
                      'productName': productName,
                      'price': price,
                      'quantity': quantity,
                    });
                  }

                  String date = _dateController.text;
                  String seller = _sellerController.text;

                  // Création d'une instance de Expense
                  Expense newExpense = Expense(
                    id: Expense.generateUniqueId(),
                    totalAmount: calculateTotalAmount(productsData),
                    products: createProductList(productsData),
                    seller: seller.isNotEmpty ? seller : null,
                    date: DateTime.parse(
                        date), // Assurez-vous que la date est au bon format
                  );

                  // Mettre à jour les dépenses de l'utilisateur authentifié
                  _databaseService.addExpense(newExpense);

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Succès'),
                        content:
                            const Text('La dépense a été ajoutée avec succès.'),
                        actions: [
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Ferme la fenêtre contextuelle
                                _resetForm(); // Réinitialise le formulaire
                              },
                              child: const Text('OK'),
                            ),
                          ),
                        ],
                      );
                    },
                  );
              },
              child: const Text('Ajouter la dépense'),
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour calculer le montant total de la dépense
  double calculateTotalAmount(List<Map<String, dynamic>> productsData) {
    double totalAmount = 0.0;
    for (var productData in productsData) {
      double price = productData['price'];
      int quantity = productData['quantity'];
      totalAmount += price * quantity;
    }
    return totalAmount;
  }

  // Méthode pour créer une liste d'objets Product à partir des données du formulaire
  List<Product> createProductList(List<Map<String, dynamic>> productsData) {
    List<Product> productList = [];
    for (var productData in productsData) {
      String productName = productData['productName'];
      double price = productData['price'];
      int quantity = productData['quantity'];
      Product product = Product(
        name: productName,
        price: price,
        quantity: quantity,
      );
      productList.add(product);
    }
    return productList;
  }

  // Méthode pour réinitialiser le formulaire après l'ajout d'une dépense
  void _resetForm() {
    _productControllers.clear();
    _priceControllers.clear();
    _quantityControllers.clear();
    _dateController.clear();
    _sellerController.clear();
    _addProductField(); // Ajouter un nouveau champ de produit initial
  }
}
