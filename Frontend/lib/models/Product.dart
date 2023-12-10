class Product {
  final int id;
  final int current;
  final String name;
  final String image;
  final int bidding;
  final String description;
  final int maximumPrice;
  final DateTime date;
  final int timer;
  final bool isSold;

  Product({
    required this.id,
    required this.current,
    required this.name,
    required this.image,
    required this.bidding,
    required this.description,
    required this.maximumPrice,
    required this.date,
    required this.timer,
    required this.isSold,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      current: json['current'],
      name: json['name'],
      image: json['image'],
      bidding: json['bidding'],
      description: json['description'],
      maximumPrice: json['maximum_price'],
      date: DateTime.parse(json['date']),
      timer: json['timer'],
      isSold: json['is_sold'],
    );
  }
}
