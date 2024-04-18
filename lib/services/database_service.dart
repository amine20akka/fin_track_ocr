import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_track_ocr/models/expense.dart';
import 'package:fin_track_ocr/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future createUser(String firstName, String lastName, String? profileImageUrl, double budget) async {
    return await userCollection.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'profileImageUrl': profileImageUrl,
      'budget': budget,
      'expenses': [],
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
      profileImageUrl: data['profileImageUrl'],
      budget: data['budget'] ?? 0,
    );
  }

  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

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

  Future<void> updateProfileImageUrl(String? profileImageUrl) async {
    await userCollection.doc(uid).update({
      'profileImageUrl': profileImageUrl,
    });
  }

  Future<void> updateUserData(String firstName, String lastName, double budget) async {
    await userCollection.doc(uid).update({
      'firstName': firstName,
      'lastName': lastName,
      'budget': budget, 
    });
  }

  Future<void> deleteExpense(String expenseId) async {
    // Récupérer les données utilisateur actuelles
    DocumentSnapshot userSnapshot = await userCollection.doc(uid).get();
    if (userSnapshot.exists) {
      // Récupérer la liste des dépenses
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
      List<dynamic> expenses = userData?['expenses'] ?? [];
      // Filtrer la liste pour exclure l'élément avec l'ID spécifié
      expenses.removeWhere((expense) => expense['id'] == expenseId);
      // Mettre à jour les données utilisateur avec la nouvelle liste de dépenses
      await userCollection.doc(uid).update({'expenses': expenses});
    }
  }



}
