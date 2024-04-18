import 'dart:io';

import 'package:fin_track_ocr/models/expense.dart';
import 'package:fin_track_ocr/models/user.dart';
import 'package:fin_track_ocr/pages/budget_progress.dart';
import 'package:fin_track_ocr/pages/drawer.dart';
import 'package:fin_track_ocr/pages/profile_pop_up_menu.dart';
import 'package:fin_track_ocr/pages/add_expense_form.dart';
import 'package:fin_track_ocr/services/database_service.dart';
import 'package:fin_track_ocr/shared/linear_gradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
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
                                totalExpenses: totalAmountAllExpenses),
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
              const SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      indent: 20.0,
                      thickness: 0.3,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 10.0,),
                  const Icon(Icons.access_time_filled),
                  const SizedBox(width: 5.0,),
                  Text(
                    'Recent Transactions',
                    style: GoogleFonts.poly(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(width: 10.0,),
                  Expanded(
                    child: Divider(
                      endIndent: 20.0,
                      thickness: 0.3,
                      color: Colors.grey[700],
                    ),
                  ),
                  // const Expanded(
                  //   child: TextField(
                  //     decoration: InputDecoration(
                  //       fillColor: Color.fromARGB(255, 202, 202, 202),
                  //       filled: true,
                  //       hintText: 'Search',
                  //       enabledBorder: OutlineInputBorder(
                  //         borderRadius:
                  //             BorderRadius.all(Radius.elliptical(30.0, 30.0)),
                  //         borderSide: BorderSide(
                  //             color: Color.fromARGB(255, 215, 215, 215),
                  //             width: 1.0),
                  //       ),
                  //     contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  //     ),
                  //   ),
                  // ),
                  // IconButton(
                  //   onPressed: () {
                  //     // Action lorsque l'icône est cliquée
                  //   },
                  //   icon: const Icon(Icons.search),
                  // ),
                ],
              ),
              const SizedBox(height: 15.0,),
              Expanded(
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
                                            transitionDuration: const Duration(milliseconds: 500),
                                            transitionsBuilder:
                                                (context, animation, secondaryAnimation, child) {
                                              const begin = Offset(1.0, 0.0);
                                              const end = Offset.zero;
                                              const curve = Curves.ease;
                                              var tween = Tween(begin: begin, end: end)
                                                  .chain(CurveTween(curve: curve));
                                              var offsetAnimation = animation.drive(tween);
                                              return SlideTransition(
                                                position: offsetAnimation,
                                                child: child,
                                              );
                                            },
                                            pageBuilder: (context, animation, secondaryAnimation) {
                                              return AddExpenseForm(
                                                uid: widget.uid,
                                              );
                                            },
                                          ),
                                        );
                                      }, 
                                      child: Text('Add one here ...', style: TextStyle(fontSize: 20.0, color: Colors.blue[900], fontWeight: FontWeight.w400),),
                                    ),
                                    Icon(Icons.receipt_long_outlined, color: Colors.blue[900]),
                                  ],
                                )
                              ]
                            );
                        } else {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(expenses.length, (index) {
                                final expense = expenses[expenses.length - 1 - index];
                                return Card(
                                  margin: const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                                  elevation: 4.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.monetization_on),
                                            Text(
                                              '  ${expense.totalAmount.toStringAsFixed(2)} TND',
                                              style: GoogleFonts.gabriela(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              expense.products.map((product) {
                                            return Text(
                                              '- ${product.name} x${product.quantity}\n  Unit: ${product.price.toStringAsFixed(2)} TND',
                                            );
                                          }).toList(),
                                        ),
                                        Text(
                                          'SELLER: ${expense.seller ?? 'Unknown'}',
                                        ),
                                        Text(
                                          'DATE: ${expense.date != null ? DateFormat('yyyy-MM-dd').format(expense.date!) : 'Unknown'}',
                                        ),
                                        IconButton(
                                          highlightColor: const Color.fromARGB(255, 191, 10, 10),
                                          color: const Color.fromARGB(255, 191, 10, 10),
                                          iconSize: 30.0,
                                          onPressed: () {
                                            _databaseService.deleteExpense(expense.id);
                                          }, 
                                          icon: const Icon(Icons.cancel_outlined),
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
              ),
              const SizedBox(height: 80.0,),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              pageBuilder: (context, animation, secondaryAnimation) {
                return AddExpenseForm(
                  uid: widget.uid,
                );
              },
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 4, 108, 142),
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
      drawer: MyDrawer(uid: widget.uid),
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
