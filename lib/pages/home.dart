import 'dart:io';

import 'package:fin_track_ocr/models/expense.dart';
import 'package:fin_track_ocr/models/user.dart';
import 'package:fin_track_ocr/pages/budget_progress.dart';
import 'package:fin_track_ocr/pages/profile_pop_up_menu.dart';
import 'package:fin_track_ocr/pages/add_expense_form.dart';
import 'package:fin_track_ocr/services/database_service.dart';
import 'package:fin_track_ocr/shared/linear_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  final String uid;
  const Home({super.key, required this.uid});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<UserData>(
                stream: DatabaseService(uid: widget.uid).userData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }

                  if (snapshot.hasData) {
                    String? imageUrl = snapshot.data!.profileImageUrl;
                    double totalAmountAllExpenses = 0;
                    List<Expense> expenses = snapshot.data!.expenses;
                    if (expenses.isNotEmpty) {
                      for (Expense exp in expenses) {
                        totalAmountAllExpenses += exp.totalAmount;
                      } 
                    }

                    return Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                        gradient: myLinearGradient,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.menu_outlined),
                                color: Colors.white,
                                iconSize: 30.0,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/fintrack-ocr-favicon-white.png',
                                    width: 50,
                                    height: 35,
                                  ),
                                  Text(
                                    'FinTrack',
                                    style: GoogleFonts.gabriela(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      letterSpacing: 2.5,
                                    ),
                                  ),
                                ],
                              ),
                              ProfilePopupMenu(
                                profileImage: CircleAvatar(
                                  radius: 16,
                                  backgroundImage: imageUrl != null
                                      ? FileImage(File(imageUrl))
                                      : const AssetImage(
                                          'assets/default_profile_image.png',
                                        ) as ImageProvider,
                                ),
                                uid: widget.uid,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'You have spent',
                            style: GoogleFonts.gabriela(
                              color: Colors.grey[300],
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            '${totalAmountAllExpenses.toStringAsFixed(2)} TND',
                            style: GoogleFonts.gabriela(
                              color: Colors.grey[300],
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0,
                            ),
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            'Out of your budget ${snapshot.data!.budget.toStringAsFixed(2)} TND',
                            style: GoogleFonts.gabriela(
                              color: Colors.grey[300],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: BudgetProgress(
                                budget: snapshot.data!.budget,
                                totalExpenses: totalAmountAllExpenses
                              ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${daysLeftInMonth()} days left',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<List<Expense>>(
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
                      return const Placeholder();
                    } else {
                      final expenses = snapshot.data ?? [];
                      if (expenses.isEmpty) {
                        // Afficher un message lorsque la liste des dépenses est vide
                        return const Center(
                            child: Text('No Transactions yet !'));
                      } else {
                        // Renvoyer une colonne contenant chaque dépense
                        return Column(
                          children: expenses.map((expense) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: 5.0,
                                horizontal: 10.0,
                              ),
                              elevation: 2.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Amount: ${expense.totalAmount.toStringAsFixed(3)} TND',
                                    ),
                                    Text('Seller: ${expense.seller ?? 'Unknown'}'),
                                    Text(
                                      'Date: ${expense.date != null ? DateFormat('yyyy-MM-dd').format(expense.date!) : 'Unknown'}',
                                    ),
                                    const SizedBox(height: 5.0),
                                    const Text(
                                      'Products:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: expense.products.map((product) {
                                        return Text(
                                          '- ${product.name}, Quantity: ${product.quantity}, Price: ${product.price.toStringAsFixed(2)} TND',
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Naviguer vers un autre widget
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpenseForm(
                uid: widget.uid,
              ),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 4, 103, 136),
        elevation: 5.0,
        tooltip: 'Add an expense',
        // label: const Text(
        //   'Add',
        //   style: TextStyle(color: Colors.white),
        // ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

int daysLeftInMonth() {
  // Get the current date
  DateTime now = DateTime.now();

  // Get the first day of the next month
  DateTime nextMonth = DateTime(now.year, now.month + 1, 1);

  // Calculate the difference in days between now and the first day of next month
  Duration difference = nextMonth.difference(now);

  // Return the number of days left in the current month
  return difference.inDays;
}
