import 'package:fin_track_ocr/models/expense.dart';
import 'package:fin_track_ocr/models/product.dart';
import 'package:fin_track_ocr/pages/add_expense/add_expense_form.dart';
import 'package:fin_track_ocr/pages/edit_expense/edit_expense.dart';
import 'package:fin_track_ocr/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransactionsList extends StatefulWidget {
  final String uid;

  const TransactionsList({super.key, required this.uid});

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  late final DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService(uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Expense>>(
        stream: _databaseService.getExpensesForCurrentMonth(),
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
              final expenses = snapshot.data ?? [];
              if (expenses.isEmpty) {
                // Afficher un message lorsque la liste des dépenses est vide
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                                  transitionDuration:
                                      const Duration(milliseconds: 500),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.ease;
                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    var offsetAnimation =
                                        animation.drive(tween);
                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
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
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(expenses.length, (index) {
                      final expense = expenses[expenses.length - 1 - index];
                      final List<Product> productsToShow =
                          expense.products.take(3).toList();

                      return Card(
                        margin: const EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                            ? DateFormat('MMMM dd, yyyy')
                                                .format(expense.date!)
                                            : DateFormat('MMMM dd, yyyy')
                                                .format(DateTime.now()),
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
                                      else if (productsToShow.length == 2)
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('${productsToShow[0].name}, '),
                                            Text(productsToShow[1].name),
                                          ],
                                        )
                                      else
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('${productsToShow[0].name}, '),
                                            Text('${productsToShow[1].name}, '),
                                            const Text('...'),
                                          ],
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                    tooltip: 'Edit',
                                    color:
                                        const Color.fromARGB(255, 90, 116, 116),
                                    iconSize: 26.0,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(milliseconds: 500),
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
                                        const Color.fromARGB(255, 191, 10, 10),
                                    iconSize: 26.0,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              "Confirm Delete",
                                              style:
                                                  TextStyle(color: Color.fromARGB(255, 215, 49, 37)),
                                            ),
                                            content: const Text(
                                              "Are you sure you want to delete this transaction?",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    249, 238, 232, 232),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.blue[900]),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 215, 49, 37)),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _databaseService
                                                        .deleteExpense(
                                                            expense.id);
                                                    Navigator.of(context).pop();
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
                                    color:
                                        const Color.fromARGB(255, 90, 116, 116),
                                    iconSize: 26.0,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    249, 238, 232, 232),
                                            title: const Center(
                                                child: Text(
                                              'Expense Details',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 15.0,
                                                  ),
                                                  DataTable(
                                                    columnSpacing: 20.0,
                                                    columns: const [
                                                      DataColumn(
                                                          numeric: false,
                                                          label: Text(
                                                            'Product',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                      DataColumn(
                                                          numeric: true,
                                                          label: Text(
                                                            'Price (TND)',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                      DataColumn(
                                                          numeric: true,
                                                          label: Text(
                                                            'Quantity',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                    ],
                                                    rows: expense.products
                                                        .map<DataRow>(
                                                            (product) {
                                                      return DataRow(cells: [
                                                        DataCell(
                                                            Text(product.name)),
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
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16.0,
                                                              ),
                                                            ),
                                                            Text(
                                                              expense.date !=
                                                                      null
                                                                  ? DateFormat(
                                                                          'MMMM dd, yyyy')
                                                                      .format(expense
                                                                          .date!)
                                                                  : 'Unknown',
                                                              style: GoogleFonts
                                                                  .poly(
                                                                fontSize: 16.0,
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
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16.0,
                                                              ),
                                                            ),
                                                            Text(
                                                              expense.seller ??
                                                                  'Unknown',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16.0,
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
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                      Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          transitionDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      500),
                                                          transitionsBuilder:
                                                              (context,
                                                                  animation,
                                                                  secondaryAnimation,
                                                                  child) {
                                                            const begin =
                                                                Offset(
                                                                    1.0, 0.0);
                                                            const end =
                                                                Offset.zero;
                                                            const curve =
                                                                Curves.ease;
                                                            var tween = Tween(
                                                                    begin:
                                                                        begin,
                                                                    end: end)
                                                                .chain(CurveTween(
                                                                    curve:
                                                                        curve));
                                                            var offsetAnimation =
                                                                animation.drive(
                                                                    tween);
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
                                                    child: Text(
                                                      'Update',
                                                      style: TextStyle(
                                                        color: Colors.blue[900],
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      'Close',
                                                      style: TextStyle(
                                                        color: Colors.blue[900],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.arrow_forward),
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
        },
      ),
    );
  }
}
