class User {
  final String uid;
  final String? firstName, lastName, phone, title, shopName, shopLocation, color;
  final int? dateJoined;

  const User({
    required this.uid,
    this.firstName,
    this.lastName,
    this.phone,
    this.title,
    this.shopName,
    this.shopLocation,
    this.dateJoined,
    this.color,
  });

  factory User.fromMap(Map<String, dynamic> mapData) {
    return User(
      uid: mapData["uid"],
      firstName: mapData["firstName"],
      lastName: mapData["lastName"],
      phone: mapData["phone"],
      title: mapData["title"],
      shopName: mapData["shopName"],
      shopLocation: mapData["shopLocation"],
      dateJoined: mapData["dateJoined"],
      color: mapData["color"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "firstName": firstName,
      "lastName": lastName,
      "phone": phone,
      "title": title,
      "shopName": shopName,
      "shopLocation": shopLocation,
      "color": color,
      "dateJoined": dateJoined,
    };
  }

}
