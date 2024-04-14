import 'package:fin_track_ocr/models/expense.dart';

class UserData {
  final String uid;
  final String firstName;
  final String lastName;
  String? profileImageUrl;
  final List<Expense> expenses;
  final double budget;

  UserData({
    required this.uid,
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
    List<Expense>? expenses,
    required this.budget,
  }) : expenses = expenses ?? [];
}
