import 'dart:convert';

AddProductHomePageModal addProductHomePageModalFromJson(String str) =>
    AddProductHomePageModal.fromJson(json.decode(str));

String addProductHomePageModalToJson(AddProductHomePageModal data) => json.encode(data.toJson());

class AddProductHomePageModal {

  final  String  itemTitle;

  String? itemImg; // Change to String type


  AddProductHomePageModal({
    required  this.itemTitle,

    this.itemImg,

  });

  factory AddProductHomePageModal.fromJson(Map<String, dynamic> json) => AddProductHomePageModal(
    itemTitle: json["item_title"],

    itemImg: json["item_img"],

  );

  Map<String, dynamic> toJson() => {
    "item_title": itemTitle,

    "item_img": itemImg,

  };
}
