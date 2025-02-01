import 'dart:convert';

AddBannerModal addBannerModalFromJson(String str) =>
    AddBannerModal.fromJson(json.decode(str));

String addBannerModalToJson(AddBannerModal data) => json.encode(data.toJson());

class AddBannerModal {
  final String itemTitle;
  final String? itemBanner;

  AddBannerModal({
    required this.itemTitle,
     this.itemBanner,
  });

  factory AddBannerModal.fromJson(Map<String, dynamic> json) => AddBannerModal(
        itemTitle: json["item_title"],
        itemBanner: json["jewellary_banner"],
      );

  Map<String, dynamic> toJson() => {
        "item_title": itemTitle,
        "jewellary_banner": itemBanner,
      };
}
