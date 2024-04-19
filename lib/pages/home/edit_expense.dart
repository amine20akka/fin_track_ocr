import 'package:fin_track_ocr/models/expense.dart';
import 'package:fin_track_ocr/models/product.dart';
import 'package:fin_track_ocr/services/database_service.dart';
import 'package:fin_track_ocr/shared/linear_gradient.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditExpense extends StatefulWidget {
  final String uid;
  final Expense expense;
  const EditExpense({super.key, required this.expense, required this.uid});

  @override
  State<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  late final DatabaseService _databaseService;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  late TextEditingController _sellerController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService(uid: widget.uid);
    _selectedDate = widget.expense.date!;
    _dateController = TextEditingController(
        text: widget.expense.date != null
            ? DateFormat('MMMM dd, yyyy')
                .format(widget.expense.date!)
                .toString()
            : '');
    _sellerController =
        TextEditingController(text: widget.expense.seller ?? '');
  }

  @override
  void dispose() {
    _dateController.dispose();
    _sellerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(249, 238, 232, 232),
        body: SingleChildScrollView(
          child: Column(children: [
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
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Update Expense',
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
                ]),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 40.0,
                        columns: const [
                          DataColumn(
                            label: Text('Product Name'),
                          ),
                          DataColumn(
                            // numeric: true,
                            label: Text('Price'),
                          ),
                          DataColumn(
                            // numeric: true,
                            label: Text('Quantity'),
                          ),
                        ],
                        rows: widget.expense.products.map<DataRow>((product) {
                          return DataRow(cells: [
                            DataCell(
                              TextFormField(
                                initialValue: product.name,
                                onChanged: (value) {
                                  setState(() {
                                    product.name = value;
                                  });
                                },
                              ),
                            ),
                            DataCell(
                              TextFormField(
                                initialValue: product.price.toStringAsFixed(2),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                onChanged: (value) {
                                  setState(() {
                                    product.price =
                                        double.tryParse(value) ?? 0.0;
                                  });
                                },
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (product.quantity > 1) {
                                          product.quantity--;
                                        }
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                    child: Center(
                                      child: Text(
                                        product.quantity.toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        product.quantity++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'Date of the expense (Optional)',
                        prefixIcon: Icon(Icons.date_range),
                      ),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2015, 8),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate = picked;
                            widget.expense.date = picked; // Update expense date
                            _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _sellerController,
                      decoration: const InputDecoration(
                        labelText: 'Seller (Optional)',
                        prefixIcon: Icon(Icons.sell_outlined),
                      ),
                    ),
                    const SizedBox(height: 100.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.grey[800],
                          ),
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
                            Expense updatedExpense = Expense(
                              id: widget.expense.id,
                              totalAmount:
                                  calculateTotalAmount(widget.expense.products),
                              products: widget.expense.products,
                              seller: _sellerController.text,
                              date: widget.expense.date,
                            );

                            _databaseService.updateExpense(updatedExpense);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Success'),
                                  content: const Text(
                                      'The expense has been updated successfully !'),
                                  actions: [
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
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
                            child: Text('Update'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}

// Méthode pour calculer le montant total de la dépense
double calculateTotalAmount(List<Product> products) {
  double totalAmount = 0.0;
  for (var product in products) {
    totalAmount += product.price * product.quantity;
  }
  return totalAmount;
}
