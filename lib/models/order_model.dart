class Order {
  int id;
  int productId;
  int qty;
  double subTotal;
  int proccessBy;
  Order({
    required this.id,
    required this.productId,
    required this.qty,
    required this.subTotal,
    required this.proccessBy,
  });
}
