import 'dart:convert';

UserModel userModelFromJson(String str) =>
    UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) =>
    json.encode(data.toJson());

class UserModel {
  bool status;
  int code;
  String message;
  Data data;

  UserModel({
    this.status = false,
    this.code = 0,
    this.message = "",
    Data? data,
  }) : data = data ?? Data();

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        status: json["status"] ?? false,
        code: json["code"] ?? 0,
        message: json["message"] ?? "",
        data: json["data"] != null
            ? Data.fromJson(json["data"])
            : Data(),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int id;
  String name;
  String email;
  String number;
  String profileUrl;
  int redeemed;
  String gender;
  String dob;
  String city;
  String role;
  int? cityId;
  int districtId;
  String district;
  String address;
  Bank bank;
  Vendor? vendor;
  List<AddedVendor> addedVendors;

  Data({
    this.id = 0,
    this.name = "",
    this.email = "",
    this.number = "",
    this.profileUrl =
        "https://images.squarespace-cdn.com/content/v1/56c346b607eaa09d9189a870/1551408857522-4ZFG11B2M7UPFYBFBRO0/FLAUNT-MAGAZINE-JOJI-2.jpg",
    this.redeemed = 0,
    this.gender = "",
    this.dob = "",
    this.district = "",
    this.districtId = 0,
    this.cityId,
    this.city = "",
    this.address = "",
    this.role = "",
    this.vendor,
    List<AddedVendor>? addedVendors,
    Bank? bank,
  })  : bank = bank ?? Bank(),
        addedVendors = addedVendors ?? [];

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        email: json["email"]?.toString() ?? "",
        number: json["number"] ?? "",
        profileUrl: json["profile_url"] ??
            "https://images.squarespace-cdn.com/content/v1/56c346b607eaa09d9189a870/1551408857522-4ZFG11B2M7UPFYBFBRO0/FLAUNT-MAGAZINE-JOJI-2.jpg",
        redeemed: json["reedemed"] ?? 0,
        city: json["city"] ?? "",
        district: json["district"] ?? "",
        dob: json["dob"] ?? "",
        gender: json["gender"] ?? "",
        districtId: json["district_id"] ?? 0,
        cityId: json["city_id"],
        address: json["address"] ?? "",
        bank: json["bank"] != null
            ? Bank.fromJson(json["bank"])
            : Bank(),
        vendor: json["vendor"] == null
            ? Vendor()
            : Vendor.fromJson(json["vendor"]),
        role: json["role"] ?? "",
        addedVendors: json["added_vendors"] == null
            ? []
            : List<AddedVendor>.from(
                json["added_vendors"]
                    .map((x) => AddedVendor.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "number": number,
        "profile_url": profileUrl,
        "reedemed": redeemed,
        "gender": gender,
        "dob": dob,
        "district": district,
        "city": city,
        "address": address,
        "bank": bank.toJson(),
        "city_id": cityId,
        "district_id": districtId,
        "role": role,
        "vendor": vendor?.toJson(),
        "added_vendors":
            addedVendors.map((e) => e.toJson()).toList(),
      };
}

class Bank {
  String name;
  String accountNumber;
  String branch;
  String holderName;
  String esewa;
  String khalti;

  Bank({
    this.name = "",
    this.accountNumber = "",
    this.branch = "",
    this.holderName = "",
    this.esewa = "",
    this.khalti = "",
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        name: json["name"]?.toString() ?? "",
        accountNumber: json["account_number"]?.toString() ?? "",
        branch: json["branch"]?.toString() ?? "",
        holderName: json["holder_name"]?.toString() ?? "",
        esewa: json["esewa"]?.toString() ?? "",
        khalti: json["khalti"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "account_number": accountNumber,
        "branch": branch,
        "holder_name": holderName,
        "esewa": esewa,
        "khalti": khalti,
      };
}

class Vendor {
  int id;
  String vendorName;
  String vendorPan;
  String vendorEmail;
  bool displayPrice;
  int isVerifiedAccount;

  Vendor({
    this.id = 0,
    this.vendorName = "",
    this.vendorPan = "",
    this.vendorEmail = "",
    this.displayPrice = false,
    this.isVerifiedAccount = 0,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json["id"] ?? 0,
        vendorName: json["name"] ?? "",
        vendorPan: json["email"] ?? "",
        vendorEmail: json["number"] ?? "",
        displayPrice: json["display_price"] ?? false,
        isVerifiedAccount: json["is_verified_account"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": vendorName,
        "email": vendorPan,
        "number": vendorEmail,
        "display_price": displayPrice,
        "is_verified_account": isVerifiedAccount,
      };
}

class AddedVendor {
  int id;
  int userId;
  String shopName;
  String panNumber;
  String ownerName;
  int displayPrice;
  int isVerifiedAccount;
  String createdAt;
  String updatedAt;

  AddedVendor({
    this.id = 0,
    this.userId = 0,
    this.shopName = "",
    this.panNumber = "",
    this.ownerName = "",
    this.displayPrice = 0,
    this.isVerifiedAccount = 0,
    this.createdAt = "",
    this.updatedAt = "",
  });

  factory AddedVendor.fromJson(Map<String, dynamic> json) =>
      AddedVendor(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        shopName: json["shop_name"] ?? "",
        panNumber: json["pan_number"] ?? "",
        ownerName: json["owner_name"] ?? "",
        displayPrice: json["display_price"] ?? 0,
        isVerifiedAccount:
            json["is_verified_account"] ?? 0,
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "shop_name": shopName,
        "pan_number": panNumber,
        "owner_name": ownerName,
        "display_price": displayPrice,
        "is_verified_account": isVerifiedAccount,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}