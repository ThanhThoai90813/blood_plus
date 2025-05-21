class UserModel {
  final String id;
  final String? userImage;
  final String name;
  final String email;
  final String? bloodType;
  final String? job;
  final DateTime? dateOfBirth;
  final int donationCount;
  final String? address;
  final String? passportNumber;
  final double? latitude;
  final double? longitude;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    String? userImage,
    this.bloodType,
    this.job,
    this.dateOfBirth,
    required this.donationCount,
    this.address,
    this.passportNumber,
    this.latitude,
    this.longitude,
  }) : userImage = _validateImage(userImage);

  // Hàm kiểm tra và gán ảnh mặc định nếu userImage không hợp lệ
  static String? _validateImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty || !imageUrl.startsWith('http')) {
      print('Invalid or missing userImage, using default: assets/images/profile.jpg');
      return 'assets/images/profile.jpg';
    }
    return imageUrl;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['message'] ?? json;
    return UserModel(
      id: data['id']?.toString() ?? '',
      userImage: data['userImage']?.toString(),
      name: data['name']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      bloodType: data['bloodType']?.toString(),
      job: data['job']?.toString(),
      dateOfBirth: data['dateOfBirth'] != null
          ? DateTime.tryParse(data['dateOfBirth'].toString())
          : null,
      donationCount: (data['donationCount'] as num?)?.toInt() ?? 0,
      address: data['address']?.toString(),
      passportNumber: data['passportNumber']?.toString(),
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userImage': userImage,
      'name': name,
      'email': email,
      'bloodType': bloodType,
      'job': job,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'donationCount': donationCount,
      'address': address,
      'passportNumber': passportNumber,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}