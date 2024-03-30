import 'package:fin_track_ocr/models/expense.dart';

// class CustomUser {
//   final String uid;

//   CustomUser({required this.uid});
// }


class UserData {
  final String uid;
  final String firstName;
  final String lastName;
  final List<Expense> expenses;

  UserData({
    required this.uid,
    required this.firstName,
    required this.lastName,
    List<Expense>? expenses, // La liste des dépenses peut être nulle au début
  }) : expenses = expenses ?? []; // Si expenses est nulle, initialisez-le avec une liste vide

}
