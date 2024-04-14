import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BudgetProgress extends StatelessWidget {
  final double budget;
  final double totalExpenses;

  const BudgetProgress(
      {super.key, required this.budget, required this.totalExpenses});

  @override
  Widget build(BuildContext context) {
    // Calculate the percentage of the budget spent
    double percentageSpent = (totalExpenses / budget) * 100;

    Color progressColor;

    if (percentageSpent >= 90) {
      progressColor = const Color.fromARGB(255, 191, 10, 10);
    } else if (percentageSpent >= 70) {
      progressColor = const Color.fromARGB(255, 177, 118, 8);
    } else {
      progressColor = const Color.fromARGB(255, 4, 136, 180);
    }


    return CircularPercentIndicator(
      animation: true,
      animationDuration: 800,
      radius: 110,
      percent: percentageSpent >= 100 ? 1.0 : percentageSpent / 100,
      progressColor: progressColor,
      lineWidth: 20.0,
      center: Text(
        '${budget - totalExpenses} TND',
        style: GoogleFonts.gabriela(
          letterSpacing: 1.5,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}
