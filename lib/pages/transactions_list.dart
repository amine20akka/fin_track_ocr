import 'package:fin_track_ocr/models/expense.dart';
import 'package:fin_track_ocr/models/product.dart';
import 'package:fin_track_ocr/pages/add_expense_form.dart';
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
                        margin: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 10.0),
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
                                  Text(
                                    '•  ${expense.date != null ? DateFormat('MMMM dd, yyyy').format(expense.date!) : 'Unknown'}',
                                    style: GoogleFonts.poly(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6.0,
                                  ),
                                  Text(
                                    '•  From: ${expense.seller ?? 'Unknown'}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  const SizedBox(height: 6.0,),
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
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    tooltip: 'Edit',
                                    color:
                                        const Color.fromARGB(255, 90, 116, 116),
                                    iconSize: 26.0,
                                    onPressed: () {

                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Remove',
                                    highlightColor:
                                        const Color.fromARGB(255, 191, 10, 10),
                                    color:
                                        const Color.fromARGB(255, 191, 10, 10),
                                    iconSize: 26.0,
                                    onPressed: () {
                                      _databaseService
                                          .deleteExpense(expense.id);
                                    },
                                    icon: const Icon(
                                      Icons.cancel_outlined,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'More details',
                                    color:
                                        const Color.fromARGB(255, 90, 116, 116),
                                    iconSize: 26.0,
                                    onPressed: () {

                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                    ),
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
