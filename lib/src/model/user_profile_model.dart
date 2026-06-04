import 'dart:convert';

UserModel userModelFromJson(String str) =>
    UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) =>
    json.encode(data.toJson());

class UserModel {
  bool status;
  int code;
  String message;
  UserData data;

  UserModel({
    this.status = false,
    this.code = 0,
    this.message = '',
    UserData? data,
  }) : data = data ?? UserData();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: UserData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'code': code,
        'message': message,
        'data': data.toJson(),
      };
}

class UserData {
  User user;

  UserData({User? user}) : user = user ?? User();

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
      };
}

class User {
  int id;
  String name;
  String email;
  int status;
  String number;
  String profileUrl;
  int redeemed;
  String gender;
  String dob;
  String city;
  String district;
  int cityId;
  int districtId;
  String address;
  String role;
  Bank bank;
  Vendor vendor;

  // ✅ FIXED: dynamic list
  List<Map<String, dynamic>> vendors;

  User({
    this.id = 0,
    this.name = '',
    this.email = '',
    this.status = 0,
    this.number = '',
    this.profileUrl = '',
    this.redeemed = 0,
    this.gender = '',
    this.dob = '',
    this.city = '',
    this.district = '',
    this.cityId = 0,
    this.districtId = 0,
    this.address = '',
    this.role = '',
    Bank? bank,
    Vendor? vendor,
    List<Map<String, dynamic>>? vendors,
  })  : bank = bank ?? Bank(),
        vendor = vendor ?? Vendor(),
        vendors = vendors ?? [];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email']?.toString() ?? '',
      status: json['status'] ?? 0,
      number: json['number']?.toString() ?? '',
      profileUrl: json['profile_url']?.toString() ?? '',
      redeemed: json['reedemed'] ?? 0,
      gender: json['gender']?.toString() ?? '',
      dob: json['dob']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      cityId: json['city_id'] ?? 0,
      districtId: json['district_id'] ?? 0,
      address: json['address']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      bank: Bank.fromJson(json['bank'] ?? {}),
      vendor: Vendor.fromJson(json['vendor'] ?? {}),

      // ✅ SAFE dynamic mapping
      vendors: (json['vendors'] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'status': status,
      'number': number,
      'profile_url': profileUrl,
      'reedemed': redeemed,
      'gender': gender,
      'dob': dob,
      'city': city,
      'district': district,
      'city_id': cityId,
      'district_id': districtId,
      'address': address,
      'role': role,
      'bank': bank.toJson(),
      'vendor': vendor.toJson(),

      // ✅ dynamic list output
      'vendors': vendors,
    };
  }
}

class Bank {
  String name;
  String accountNumber;
  String branch;
  String holderName;
  String esewa;
  String khalti;

  Bank({
    this.name = '',
    this.accountNumber = '',
    this.branch = '',
    this.holderName = '',
    this.esewa = '',
    this.khalti = '',
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      name: json['name']?.toString() ?? '',
      accountNumber: json['account_number']?.toString() ?? '',
      branch: json['branch']?.toString() ?? '',
      holderName: json['holder_name']?.toString() ?? '',
      esewa: json['esewa']?.toString() ?? '',
      khalti: json['khalti']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'account_number': accountNumber,
        'branch': branch,
        'holder_name': holderName,
        'esewa': esewa,
        'khalti': khalti,
      };
}

class Vendor {
  dynamic id;
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
        id: json["id"] == "" ? 0 : json["id"] ?? 0,
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