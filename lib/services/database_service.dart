import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_track_ocr/models/expense.dart';
import 'package:fin_track_ocr/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String firstName, String lastName) async {
    return await userCollection.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    List<dynamic>? expensesData = data?['expenses'];

    List<Expense> expenses = [];
    if (expensesData != null) {
      expenses = expensesData
          .map((expenseMap) => Expense.fromMap(expenseMap))
          .toList();
    }

    return UserData(
      uid: uid,
      firstName: data!['firstName'],
      lastName: data['lastName'],
      expenses: expenses,
    );
  }

  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // Méthode pour ajouter une dépense à l'utilisateur
  Future<void> addExpense(Expense expense) async {
    await userCollection.doc(uid).update({
      'expenses': FieldValue.arrayUnion([expense.toMap()]),
    });
  }


  List<Expense> _expensesFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    List<dynamic>? expensesData = data?['expenses'];

    List<Expense> expenses = [];
    if (expensesData != null) {
      expenses = expensesData
          .map((expenseMap) => Expense.fromMap(expenseMap))
          .toList();
    }
    return expenses;
  }

  Stream<List<Expense>> get userExpenses {
    return userCollection.doc(uid).snapshots().map(_expensesFromSnapshot);
  }
}
