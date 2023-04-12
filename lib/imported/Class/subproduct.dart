class Subproduct {
  String name;
  double cost, price;
  int quantity,index;

  Subproduct({
    required this.index,
    required this.name,
    required this.cost,
    required this.price,
    required this.quantity,
  });
  @override
  String toString() {
    return 'Subproduct(index:$index ,name: $name, cost: $cost, price: $price, quantity: $quantity)';
  }
}
