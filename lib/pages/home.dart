import 'dart:io';

import 'package:fin_track_ocr/models/expense.dart';
import 'package:fin_track_ocr/models/user.dart';
import 'package:fin_track_ocr/pages/profile_pop_up_menu.dart';
import 'package:fin_track_ocr/pages/add_expense_form.dart';
import 'package:fin_track_ocr/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  color: Color.fromARGB(255, 2, 71, 95),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/fintrack-ocr-favicon-white.png',
                      width: 70,
                      height: 40,
                    ),
                    const Text(
                      'FinTrack',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    StreamBuilder<UserData>(
                      stream: DatabaseService(uid: widget.uid).userData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }
                        if (snapshot.hasData) {
                          // Extract the imageUrl from UserData
                          String? imageUrl = snapshot.data!.profileImageUrl;
                          return ProfilePopupMenu(
                            profileImage: CircleAvatar(
                              radius: 16,
                              backgroundImage: imageUrl != null
                                  ? FileImage(File(imageUrl))
                                  : const AssetImage(
                                      'assets/default_profile_image.png',
                                    ) as ImageProvider,
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 20.0),
                  child: StreamBuilder(
                    stream: DatabaseService(uid: widget.uid).userData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      if (snapshot.hasData) {
                        return Center (child: Text('My Budget : ${snapshot.data!.budget}'));
                      }
                      return Container();
                    },
                  )),
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
                                      'Total Amount: ${expense.totalAmount.toStringAsFixed(2)} TND',
                                    ),
                                    Text('Seller: ${expense.seller ?? 'N/A'}'),
                                    Text(
                                      'Date: ${expense.date != null ? DateFormat('yyyy-MM-dd').format(expense.date!) : 'N/A'}',
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
      floatingActionButton: FloatingActionButton.extended(
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
        backgroundColor: const Color.fromARGB(255, 2, 71, 95),
        tooltip: 'Add an Expense',
        label: const Text(
          'Add an Expense',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
