// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

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
        data: json["data"] != null ? Data.fromJson(json["data"]) : Data(),
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

    Data({
        this.id = 0,
        this.name = "",
        this.email = "",
        this.number = "",
        this.profileUrl = "https://images.squarespace-cdn.com/content/v1/56c346b607eaa09d9189a870/1551408857522-4ZFG11B2M7UPFYBFBRO0/FLAUNT-MAGAZINE-JOJI-2.jpg",
        this.redeemed = 0,
        this.gender = "",
        this.dob = "",
        this.district = "",
        this.districtId = 0,
        this.cityId,
        this.city = "",
        this.address ="",
        this.role = "",
        Bank? bank,
    }) : bank = bank ?? Bank();

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        number: json["number"] ?? "",
        profileUrl: json["profile_url"] ?? "https://images.squarespace-cdn.com/content/v1/56c346b607eaa09d9189a870/1551408857522-4ZFG11B2M7UPFYBFBRO0/FLAUNT-MAGAZINE-JOJI-2.jpg",
        redeemed: json["reedemed"] ?? 0,
        city: json["city"] ?? "",
        district: json["district"] ?? "",
        dob: json["dob"] ?? "",
        gender: json["gender"] ?? "",
        districtId: json["district_id"] ?? 0,
        cityId: json                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ["city_id"], 
        address: json["address"] ?? "",
        bank: json["bank"] != null ? Bank.fromJson(json["bank"]) : Bank(),
        role: json["role"] ?? ""
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "number": number,
        "profile_url": profileUrl,
        "reedemed": redeemed,
        "gender" : gender,
        "dob": dob,
        "district" : district,
        "city" : city,
        "address" : address,
        "bank": bank.toJson(),
        "city_id" : cityId,
        "district_id": districtId,
        "role" : role
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
        name: json["name"] ?? "",
        accountNumber: json["account_number"] ?? "",
        branch: json["branch"] ?? "",
        holderName: json["holder_name"] ?? "",
        esewa: json["esewa"] ?? "",
        khalti: json["khalti"] ?? "",
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
