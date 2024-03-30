class Product {
  String name; // Nom du produit
  double price; // Prix du produit
  int quantity; // Quantité du produit

  Product({
    required this.name,
    required this.price,
    required this.quantity,
  });

  // Constructeur nommé pour créer une instance à partir d'une carte de données Firebase
  Product.fromMap(Map<String, dynamic>? map)
      : name = map?['name'] ?? '',
        price = (map?['price'] ?? 0.0)
            .toDouble(), // Assurez-vous que le prix est converti en double
        quantity =
            map?['quantity'] ?? 1; // Valeur par défaut de la quantité est 1

  // Méthode pour convertir l'objet Product en carte de données Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}
