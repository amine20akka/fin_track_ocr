// ignore_for_file: use_build_context_synchronously
import 'package:fin_track_ocr/models/expense.dart';
import 'package:fin_track_ocr/models/product.dart';
import 'package:fin_track_ocr/pages/add_expense/add_expense_form.dart';
import 'package:fin_track_ocr/pages/edit_expense/edit_expense.dart';
import 'package:fin_track_ocr/services/database_service.dart';
import 'package:fin_track_ocr/shared/linear_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransactionsHistory extends StatefulWidget {
  final String uid;

  const TransactionsHistory({super.key, required this.uid});

  @override
  State<TransactionsHistory> createState() => _TransactionsHistoryState();
}

class _TransactionsHistoryState extends State<TransactionsHistory> {
  late final DatabaseService _databaseService;
  List<Expense>? expenses;
  List<Expense>? filteredExpenses = [];
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService(uid: widget.uid);
    // Initialize filteredExpenses with expenses when the widget is first loaded
    _databaseService.userExpenses.listen((List<Expense> data) {
      setState(() {
        expenses = data;
        filteredExpenses =
            expenses; // Initialize filteredExpenses with expenses
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(249, 238, 232, 232),
      body: Column(
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
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 6.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                IconButton(
                  color: Colors.grey[200],
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  width: 24.0,
                ),
                Row(
                  children: [
                    Icon(
                      color: Colors.grey[200],
                      Icons.history,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Transactions history',
                      style: GoogleFonts.poly(
                        color: Colors.grey[200],
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 202, 202, 202),
                      filled: true,
                      hintText: 'Search (product, seller)',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 215, 215, 215),
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 215, 215, 215),
                          width: 1.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                    ),
                    onChanged: (value) {
                      // Trigger search operation here
                      String productNameOrSeller =
                          value.trim(); // Get the entered product name
                      // Call the method to filter expenses by product name
                      setState(() {
                        filteredExpenses =
                            _databaseService.getExpensesByProductNameOrSeller(
                                expenses!, productNameOrSeller);
                      });
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Center(
                              child: Text(
                            'Filter Options',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.date_range),
                                title: const Text('Date'),
                                onTap: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now(),
                                  );
                                  if (pickedDate != null) {
                                    // Filter expenses by date
                                    setState(() {
                                      selectedDate = pickedDate;
                                      if (filteredExpenses!.isEmpty) {
                                        filteredExpenses = expenses!
                                            .where((expense) =>
                                                expense.date != null &&
                                                expense.date!.year ==
                                                    selectedDate!.year &&
                                                expense.date!.month ==
                                                    selectedDate!.month &&
                                                expense.date!.day ==
                                                    selectedDate!.day)
                                            .toList();
                                      } else {
                                        filteredExpenses = filteredExpenses!
                                            .where((expense) =>
                                                expense.date != null &&
                                                expense.date!.year ==
                                                    selectedDate!.year &&
                                                expense.date!.month ==
                                                    selectedDate!.month &&
                                                expense.date!.day ==
                                                    selectedDate!.day)
                                            .toList();
                                      }
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.monetization_on),
                                title: const Text('Total amount'),
                                onTap: () {
                                  GlobalKey<FormState> formKey =
                                      GlobalKey<FormState>();
                                  TextEditingController minAmountController =
                                      TextEditingController();
                                  TextEditingController maxAmountController =
                                      TextEditingController();

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Filter by Total Amount'),
                                        content: Form(
                                          key: formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                controller: minAmountController,
                                                decoration:
                                                    const InputDecoration(
                                                  suffixText: 'TND',
                                                  prefixIcon: Icon(
                                                      Icons.monetization_on),
                                                  labelText: 'Minimum Amount',
                                                ),
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                  decimal: true,
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter a minimum amount';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                              TextFormField(
                                                controller: maxAmountController,
                                                decoration:
                                                    const InputDecoration(
                                                  suffixText: 'TND',
                                                  prefixIcon: Icon(
                                                      Icons.monetization_on),
                                                  labelText: 'Maximum Amount',
                                                ),
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                  decimal: true,
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter a maximum amount';
                                                  }
                                                  if (double.tryParse(value)! <
                                                      double.tryParse(
                                                          minAmountController
                                                              .text)!) {
                                                    return 'Max amount must be >= min amount';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                final List<Expense>
                                                    filteredExpensesList;
                                                if (filteredExpenses!.isEmpty) {
                                                  filteredExpensesList =
                                                      expenses!
                                                          .where((expense) {
                                                    double minAmount =
                                                        double.tryParse(
                                                            minAmountController
                                                                .text)!;
                                                    double maxAmount =
                                                        double.tryParse(
                                                            maxAmountController
                                                                .text)!;
                                                    return expense
                                                                .totalAmount >=
                                                            minAmount &&
                                                        expense.totalAmount <=
                                                            maxAmount;
                                                  }).toList();
                                                } else {
                                                  filteredExpensesList =
                                                      filteredExpenses!
                                                          .where((expense) {
                                                    double minAmount =
                                                        double.tryParse(
                                                            minAmountController
                                                                .text)!;
                                                    double maxAmount =
                                                        double.tryParse(
                                                            maxAmountController
                                                                .text)!;
                                                    return expense
                                                                .totalAmount >=
                                                            minAmount &&
                                                        expense.totalAmount <=
                                                            maxAmount;
                                                  }).toList();
                                                }

                                                setState(() {
                                                  filteredExpenses =
                                                      filteredExpensesList;
                                                });

                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: const Text('Apply'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Clear the text field values
                                              minAmountController.clear();
                                              maxAmountController.clear();

                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              const Divider(
                                thickness: 0.8,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Center(
                                    child: Text(
                                  'Sort Options',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0),
                                )),
                              ),
                              ListTile(
                                leading: const Icon(Icons.date_range),
                                title: const Text('Sort by Date'),
                                onTap: () {
                                  setState(() {
                                    filteredExpenses!.sort(
                                        (a, b) => a.date!.compareTo(b.date!));
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.monetization_on),
                                title: const Text('Sort by Total Amount'),
                                onTap: () {
                                  setState(() {
                                    filteredExpenses!.sort((a, b) => a.totalAmount.compareTo(b.totalAmount));
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(height: 15.0,),
                              const Divider(
                                thickness: 0.8,
                              ),
                              ListTile(
                                leading: const Icon(Icons.clear),
                                title: const Text('Clear Filter and Sort'),
                                onTap: () {
                                  setState(() {
                                    filteredExpenses = expenses;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.filter_list),
                ),
              ],
            ),
          ),
          Text(
            'Total: ${filteredExpenses!.length} Transactions',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder<List<Expense>>(
                  stream: _databaseService.userExpenses,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SpinKitFoldingCube(
                          color: Color.fromARGB(255, 15, 64, 129),
                          size: 35.0,
                        ),
                      );
                    } else {
                      if (snapshot.hasError) {
                        return Container();
                      } else {
                        expenses = snapshot.data ?? [];
                        if (expenses!.isEmpty) {
                          // Afficher un message lorsque la liste des dépenses est vide
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 80.0,),
                                Text(
                                  'No Transactions yet !',
                                  style: GoogleFonts.poly(
                                    fontSize: 24.0,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: const Duration(
                                                milliseconds: 500),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              const begin = Offset(1.0, 0.0);
                                              const end = Offset.zero;
                                              const curve = Curves.ease;
                                              var tween = Tween(
                                                      begin: begin, end: end)
                                                  .chain(
                                                      CurveTween(curve: curve));
                                              var offsetAnimation =
                                                  animation.drive(tween);
                                              return SlideTransition(
                                                position: offsetAnimation,
                                                child: child,
                                              );
                                            },
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) {
                                              return AddExpenseForm(
                                                uid: widget.uid,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Add one here ...',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.blue[900],
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Icon(Icons.receipt_long_outlined,
                                        color: Colors.blue[900]),
                                  ],
                                )
                              ]);
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: Column(
                              children: List.generate(filteredExpenses!.length,
                                  (index) {
                                final expense = filteredExpenses![
                                    filteredExpenses!.length - 1 - index];
                                final List<Product> productsToShow =
                                    expense.products.take(4).toList();

                                return Card(
                                  elevation: 4.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.monetization_on,
                                              size: 20.0,
                                            ),
                                            Text(
                                              '  ${expense.totalAmount.toStringAsFixed(2)} TND',
                                              style: GoogleFonts.gabriela(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '•  Date: ',
                                                  style: GoogleFonts.poly(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                Text(
                                                  expense.date != null
                                                      ? DateFormat(
                                                              'MMMM dd, yyyy')
                                                          .format(expense.date!)
                                                      : 'Unknown',
                                                  style: GoogleFonts.poly(
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 6.0,
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  '•  Seller: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                Text(
                                                  expense.seller ?? 'Unknown',
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 6.0,
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  '•  Products: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                if (productsToShow.length == 1)
                                                  Text(productsToShow[0].name)
                                                else if (productsToShow
                                                        .length ==
                                                    2)
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          '${productsToShow[0].name}, '),
                                                      Text(productsToShow[1]
                                                          .name),
                                                    ],
                                                  )
                                                else if (productsToShow
                                                        .length ==
                                                    3)
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          '${productsToShow[0].name}, '),
                                                      Text(
                                                          '${productsToShow[1].name}, '),
                                                      Text(productsToShow[2]
                                                          .name),
                                                    ],
                                                  )
                                                else
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          '${productsToShow[0].name}, '),
                                                      Text(
                                                          '${productsToShow[1].name}, '),
                                                      Text(
                                                          '${productsToShow[2].name}, '),
                                                      const Text('...'),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              tooltip: 'Edit',
                                              color: const Color.fromARGB(
                                                  255, 90, 116, 116),
                                              iconSize: 26.0,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    transitionDuration:
                                                        const Duration(
                                                            milliseconds: 500),
                                                    transitionsBuilder:
                                                        (context,
                                                            animation,
                                                            secondaryAnimation,
                                                            child) {
                                                      const begin =
                                                          Offset(1.0, 0.0);
                                                      const end = Offset.zero;
                                                      const curve = Curves.ease;
                                                      var tween = Tween(
                                                              begin: begin,
                                                              end: end)
                                                          .chain(CurveTween(
                                                              curve: curve));
                                                      var offsetAnimation =
                                                          animation
                                                              .drive(tween);
                                                      return SlideTransition(
                                                        position:
                                                            offsetAnimation,
                                                        child: child,
                                                      );
                                                    },
                                                    pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) {
                                                      return EditExpense(
                                                        expense: expense,
                                                        uid: widget.uid,
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                              ),
                                            ),
                                            IconButton(
                                              tooltip: 'Remove',
                                              highlightColor:
                                                  const Color.fromARGB(
                                                      255, 191, 10, 10),
                                              iconSize: 26.0,
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        "Confirm Delete",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    215,
                                                                    49,
                                                                    37)),
                                                      ),
                                                      content: const Text(
                                                        "Are you sure you want to delete this transaction?",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              249,
                                                              238,
                                                              232,
                                                              232),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue[900]),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: const Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        215,
                                                                        49,
                                                                        37)),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              _databaseService
                                                                  .deleteExpense(
                                                                      expense
                                                                          .id);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                              ),
                                            ),
                                            IconButton(
                                              tooltip: 'More details',
                                              color: const Color.fromARGB(
                                                  255, 90, 116, 116),
                                              iconSize: 26.0,
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              249,
                                                              238,
                                                              232,
                                                              232),
                                                      title: const Center(
                                                          child: Text(
                                                        'Expense Details',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 15.0,
                                                            ),
                                                            DataTable(
                                                              columnSpacing:
                                                                  20.0,
                                                              columns: const [
                                                                DataColumn(
                                                                    numeric:
                                                                        false,
                                                                    label: Text(
                                                                      'Product',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    )),
                                                                DataColumn(
                                                                    numeric:
                                                                        true,
                                                                    label: Text(
                                                                      'Price (TND)',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    )),
                                                                DataColumn(
                                                                    numeric:
                                                                        true,
                                                                    label: Text(
                                                                      'Quantity',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    )),
                                                              ],
                                                              rows: expense
                                                                  .products
                                                                  .map<DataRow>(
                                                                      (product) {
                                                                return DataRow(
                                                                    cells: [
                                                                      DataCell(Text(
                                                                          product
                                                                              .name)),
                                                                      DataCell(Text(product
                                                                          .price
                                                                          .toStringAsFixed(
                                                                              2))),
                                                                      DataCell(Text(product
                                                                          .quantity
                                                                          .toString())),
                                                                    ]);
                                                              }).toList(),
                                                            ),
                                                            const SizedBox(
                                                              height: 40.0,
                                                            ),
                                                            Column(
                                                              children: [
                                                                Center(
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        'Date: ',
                                                                        style: GoogleFonts
                                                                            .poly(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              16.0,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        expense.date !=
                                                                                null
                                                                            ? DateFormat('MMMM dd, yyyy').format(expense.date!)
                                                                            : 'Unknown',
                                                                        style: GoogleFonts
                                                                            .poly(
                                                                          fontSize:
                                                                              16.0,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 20.0,
                                                                ),
                                                                Center(
                                                                  child: Row(
                                                                    children: [
                                                                      const Text(
                                                                        'Seller: ',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              16.0,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        expense.seller ??
                                                                            'Unknown',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16.0,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Close',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .blue[900],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: const Icon(
                                                  Icons.arrow_forward),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        }
                      }
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
