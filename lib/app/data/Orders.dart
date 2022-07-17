class Orders {
  final String id;
  final List<OrderList> data;
  final String nama;
  final String hp;
  final String status;
  final double total;
  Orders(
      {required this.id,
      required this.data,
      required this.nama,
      required this.hp,
      required this.status,
      required this.total});
  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      id: json['id'],
      data:
          List<OrderList>.from(json['data'].map((x) => OrderList.fromJson(x))),
      nama: json['nama'],
      hp: json['hp'],
      status: json['status'],
      total: json['total'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
      'nama': nama,
      'hp': hp,
      'status': status,
      'total': total,
    };
  }
}

class OrderList {
  final String id;
  final String title;
  final String image;
  final int price;
  final int quantity;
  final String type;

  OrderList({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
    required this.type,
  });

  factory OrderList.fromJson(Map<String, dynamic> json) {
    return OrderList(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      price: json['price'],
      quantity: json['quantity'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'price': price,
      'quantity': quantity,
      'type': type,
    };
  }
}
