import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_track_ocr/models/expense.dart';
import 'package:fin_track_ocr/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future createUser(String firstName, String lastName, String? profileImageUrl,
      double budget) async {
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

  Stream<List<Expense>> getExpensesForCurrentMonth() {
    // Obtenez le premier jour du mois actuel
    DateTime firstDayOfMonth =
        DateTime(DateTime.now().year, DateTime.now().month, 1);

    // Obtenez le premier jour du mois suivant
    DateTime firstDayOfNextMonth =
        DateTime(DateTime.now().year, DateTime.now().month + 1, 1);

    return userCollection.doc(uid).snapshots().map((userSnapshot) {
      if (userSnapshot.exists) {
        // Récupérer les données utilisateur
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        // Récupérer les dépenses de l'utilisateur
        List<dynamic>? expensesData = userData['expenses'];

        // Si les données des dépenses existent, les filtrer pour le mois en cours
        if (expensesData != null) {
          List<Expense> expenses = expensesData
              .map((expenseMap) {
                Expense expense = Expense.fromMap(expenseMap);
                // Vérifier si la date de la dépense est dans le mois en cours
                if (expense.date != null &&
                    expense.date!.isAfter(firstDayOfMonth.subtract(const Duration(days: 1))) &&
                    expense.date!.isBefore(firstDayOfNextMonth)) {
                  return expense;
                } else {
                  return null;
                }
              })
              .where((expense) => expense != null)
              .toList()
              .cast<
                  Expense>(); // Supprimer les éléments null et caster la liste à Expense
          return expenses;
        }
      }
      return <Expense>[]; // Retourner une liste vide si aucune dépense n'est trouvée
    });
  }


  Stream<List<Expense>> get userExpenses {
    return userCollection.doc(uid).snapshots().map(_expensesFromSnapshot);
  }

  Future<void> updateProfileImageUrl(String? profileImageUrl) async {
    await userCollection.doc(uid).update({
      'profileImageUrl': profileImageUrl,
    });
  }

  Future<void> updateUserData(
      String firstName, String lastName, double budget) async {
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
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      List<dynamic> expenses = userData?['expenses'] ?? [];
      // Filtrer la liste pour exclure l'élément avec l'ID spécifié
      expenses.removeWhere((expense) => expense['id'] == expenseId);
      // Mettre à jour les données utilisateur avec la nouvelle liste de dépenses
      await userCollection.doc(uid).update({'expenses': expenses});
    }
  }

  Future<void> updateExpense(Expense updatedExpense) async {
  // Récupérer les données utilisateur actuelles
  DocumentSnapshot userSnapshot = await userCollection.doc(uid).get();
  if (userSnapshot.exists) {
    // Récupérer la liste des dépenses
    Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
    List<dynamic> expenses = userData?['expenses'] ?? [];

    // Trouver l'index de la dépense à mettre à jour
    int index = expenses.indexWhere((expense) => expense['id'] == updatedExpense.id);
    
    if (index != -1) {
      // Remplacer l'ancienne dépense par la nouvelle dépense
      expenses[index] = updatedExpense.toMap();

      // Mettre à jour les données utilisateur avec la nouvelle liste de dépenses
      await userCollection.doc(uid).update({'expenses': expenses});
    }
  }
}

  List<Expense> getExpensesByProductNameOrSeller(
      List<Expense> expenses, String query) {
    final lowerCaseQuery = query.toLowerCase();
    List<Expense> filteredExpenses = expenses.where((expense) {
      // Check if any product name contains the query
      final productNameLowerCase = expense.products
          .map((product) => product.name.toLowerCase())
          .toList();
      if (productNameLowerCase
          .any((productName) => productName.contains(lowerCaseQuery))) {
        return true;
      }
      // Check if the seller name contains the query
      final sellerNameLowerCase =
          expense.seller?.toLowerCase() ?? ''; // Handle null seller
      if (sellerNameLowerCase.contains(lowerCaseQuery)) {
        return true;
      }
      return false;
    }).toList();
    return filteredExpenses;
  }


}
