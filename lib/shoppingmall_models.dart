import 'dart:io';

class Product {
  String productCode;
  String gender;
  String name;
  int price;
  String size;
  String get fullName => '$gender $name $size';
  Product(this.productCode, this.gender, this.name, this.price, this.size);
}

class CartItem {
  String key;
  int quantity;
  int price;
  String productCode;
  CartItem(this.key, this.quantity, this.price, this.productCode);
}

class User {
  String id;
  String password;
  User(this.id, this.password);
}
