import 'dart:convert';

AddProductDetailModal addProductDetailModalFromJson(String str) =>
    AddProductDetailModal.fromJson(json.decode(str));

String addProductDetailModalToJson(AddProductDetailModal data) => json.encode(data.toJson());

class AddProductDetailModal {

 final  String  itemTitle;
  final String itemName;
  final String itemPrice; // Change to String type
  final String itemSize; // Change to String type
  final String itemDes; // Change to String type
   String? itemImg; // Change to String type


  AddProductDetailModal({
    required  this.itemTitle,
    required this.itemName,
    required this.itemPrice,
    required this.itemSize,
    required this.itemDes,
     this.itemImg,

  });

  factory AddProductDetailModal.fromJson(Map<String, dynamic> json) => AddProductDetailModal(
    itemTitle: json["item_title"],
    itemName: json["item_name"],
    itemPrice: json["item_price"],
    itemSize: json["item_size"],
    itemDes: json["item_desc"],
    itemImg: json["item_img"],

  );

  Map<String, dynamic> toJson() => {
    "item_title": itemTitle,
    "item_name": itemName,
    "item_price": itemPrice,
    "item_size": itemSize,
    "item_desc": itemDes,
    "item_img": itemImg,

  };
}
