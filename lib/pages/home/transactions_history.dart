import 'package:fin_track_ocr/models/expense.dart';
import 'package:fin_track_ocr/models/product.dart';
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

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService(uid: widget.uid);
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
              child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start, 
                    children: [
                      IconButton(
                        color: Colors.grey[200],
                        icon: const Icon(Icons.arrow_back), 
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 24.0,),
                      Row(
                        children: [
                          Icon(
                            color: Colors.grey[200],
                            Icons.history,
                          ),
                          const SizedBox(width: 10.0,),
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
                    ]
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 202, 202, 202),
                      filled: true,
                      hintText: 'Search',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(30.0)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 215, 215, 215),
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(30.0)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 215, 215, 215),
                          width: 1.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Action lorsque l'icône est cliquée
                  },
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Select Filter Option'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text('Filter Option 1'),
                                onTap: () {
                                  // Handle filter option 1
                                  Navigator.pop(context); // Close the dialog
                                },
                              ),
                              ListTile(
                                title: const Text('Filter Option 2'),
                                onTap: () {
                                  // Handle filter option 2
                                  Navigator.pop(context); // Close the dialog
                                },
                              ),
                              // Add more ListTile widgets for additional filter options
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
                                ]);
                          } else {
                            return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                child: Column(
                                    children: List.generate(expenses.length, (index) {
                                      final expense =
                                          expenses[expenses.length - 1 - index];
                                      final List<Product> productsToShow =
                                          expense.products.take(4).toList();
                                  
                                      return Card(
                                        elevation: 4.0,
                                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0, vertical: 10.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
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
                                              const SizedBox(height: 20.0,),
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
                                              const SizedBox(height: 15.0,),
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
                                                      _databaseService
                                                          .deleteExpense(expense.id);
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
