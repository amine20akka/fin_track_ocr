import 'package:fin_track_ocr/models/expense.dart';
import 'package:fin_track_ocr/models/product.dart';
import 'package:fin_track_ocr/services/database_service.dart';
import 'package:fin_track_ocr/shared/linear_gradient.dart';
import 'package:flutter/material.dart';
import 'package:fin_track_ocr/shared/input_decoration_expense.dart';
import 'package:google_fonts/google_fonts.dart';
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
                expenseInputDecoration.copyWith(labelText: 'Name of product')
                                      .copyWith(prefixIcon: const Icon(Icons.production_quantity_limits)),
          ),
          TextFormField(
            validator: (value) =>
                value!.isEmpty ? 'Please enter the price of the product' : null,
            controller: widget.priceController,
            decoration: expenseInputDecoration.copyWith(
              labelText: 'Price',
              suffixText: 'TND',
            ).copyWith(prefixIcon: const Icon(Icons.attach_money)),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 1.5,),
          Center(
            child: Container(
              width: 230.0,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Color.fromARGB(255, 196, 208, 225),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Quantity :   '),
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
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.remove_circle_outline),
        onPressed: widget.onRemove,
        color: const Color.fromARGB(255, 169, 7, 7),
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
    _addProductField();
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(249, 238, 232, 232),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                gradient: myLinearGradient,
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add Expense',
                            style: GoogleFonts.poly(
                              color: Colors.grey[200],
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Icon(
                            color: Colors.grey[200],
                            Icons.receipt_long_outlined,
                          ),
                        ]
                      ),
                  ),
            ),
            const SizedBox(height: 40.0,),
            Center(
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < _productControllers.length; i++)
                      ProductListTile(
                        key: Key('$i'),
                        productController: _productControllers[i],
                        priceController: _priceControllers[i],
                        quantityController: _quantityControllers[i],
                        onRemove: () => _removeProductField(i),
                      ),
                    Center(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          color: Color.fromARGB(255, 196, 208, 225),
                        ),
                        child: IconButton(
                          iconSize: 30.0,
                          onPressed: _addProductField,
                          icon: const Icon(Icons.add),
                          color: Colors.grey[800],
                        ),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Center(
                        child: Text(
                          'Add a product',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80.0,
                    ),
                    const Divider(
                      indent: 50.0,
                      endIndent: 50.0,
                      thickness: 1.5,
                      color: Color.fromARGB(31, 36, 36, 36),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ListTile(
                      title: TextFormField(
                        controller: _dateController,
                        decoration: const InputDecoration(
                            labelText: 'Date of the expense (Optional)',
                            prefixIcon: Icon(Icons.date_range), 
                            ),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              _dateController.text =
                                  DateFormat('yyyy-MM-dd').format(picked);
                            });
                          }
                        },
                      ),
                    ),
                    ListTile(
                      title: TextFormField(
                        controller: _sellerController,
                        decoration: const InputDecoration(
                          labelText: 'Seller (Optional)',
                          prefixIcon: Icon(Icons.sell_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.grey[800],),
                            label: Text(
                              'Back Home',
                              style: TextStyle(
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Color.fromARGB(255, 4, 103, 136),
                              ),
                              foregroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.white),
                            ),
                            onPressed: () {
                              // Submit form data
                              List<Map<String, dynamic>> productsData = [];
                              for (int i = 0;
                                  i < _productControllers.length;
                                  i++) {
                                String productName =
                                    _productControllers[i].text;
                                double price = double.tryParse(
                                        _priceControllers[i].text) ??
                                    0.0;
                                int quantity = int.tryParse(
                                        _quantityControllers[i].text) ??
                                    0;
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
                                    title: const Text('Success'),
                                    content: const Text(
                                        'The expense has been added successfully !'),
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
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text('Add'),
                            ),
                          ),
                        ]
                      ),
                      const SizedBox(height: 30.0,),
                  ],
                ),
              ),
            ),
          ],
        ),
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
    _addProductField();
  }
}
