import 'package:fin_track_ocr/models/product.dart';
import 'package:uuid/uuid.dart';

class Expense {
  String id; // Identifiant unique de la dépense
  double totalAmount; // Montant total de la dépense
  List<Product> products; // Liste des produits achetés
  String? seller; // Vendeur (facultatif)
  DateTime? date; // Date de la dépense (facultatif)

  Expense({
    required this.id,
    required this.totalAmount,
    required this.products,
    this.seller,
    this.date,
  });

  // Constructeur nommé pour créer une instance à partir d'une carte de données Firebase
  Expense.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        totalAmount = map['totalAmount'],
        products = (map['products'] as List<dynamic>)
            .map((productMap) => Product.fromMap(productMap))
            .toList(),
        seller = map['seller'],
        date = map['date']
            ?.toDate(); // Convertir le timestamp Firestore en objet DateTime si la date est présente

  // Méthode pour convertir l'objet Expense en carte de données Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalAmount': totalAmount,
      'products': products.map((product) => product.toMap()).toList(),
      'seller': seller,
      'date': date,
    };
  }

  // Méthode pour générer un identifiant unique basé sur la date et l'heure actuelles
  static String generateUniqueId() {
    var uuid = const Uuid();
    return uuid.v4();
  }
}
