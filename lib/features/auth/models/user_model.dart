class DeliveryStaff {
  final int id;
  final int? branchId;
  final String username;
  final String email;
  final String fullName;
  final String phone;
  final String? profileImage;
  final int roleId;
  final String employeeId;
  final String? dateOfJoining;
  final String? dateOfBirth;
  final String? address;
  final String status;
  final String userType;
  final DeliveryDetails? deliveryDetails;

  DeliveryStaff({
    required this.id,
    this.branchId,
    required this.username,
    required this.email,
    required this.fullName,
    required this.phone,
    this.profileImage,
    required this.roleId,
    required this.employeeId,
    this.dateOfJoining,
    this.dateOfBirth,
    this.address,
    required this.status,
    required this.userType,
    this.deliveryDetails,
  });

  factory DeliveryStaff.fromJson(Map<String, dynamic> json) {
    return DeliveryStaff(
      id: json['id'],
      branchId: json['branch_id'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profile_image'],
      roleId: json['role_id'] ?? 0,
      employeeId: json['employee_id'] ?? '',
      dateOfJoining: json['date_of_joining'],
      dateOfBirth: json['date_of_birth'],
      address: json['address'],
      status: json['status'] ?? 'active',
      userType: json['user_type'] ?? 'delivery_staff',
      deliveryDetails: json['delivery_details'] != null
          ? DeliveryDetails.fromJson(json['delivery_details'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branchId,
      'username': username,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'profile_image': profileImage,
      'role_id': roleId,
      'employee_id': employeeId,
      'date_of_joining': dateOfJoining,
      'date_of_birth': dateOfBirth,
      'address': address,
      'status': status,
      'user_type': userType,
      'delivery_details': deliveryDetails?.toJson(),
    };
  }
}

class DeliveryDetails {
  final int id;
  final int staffId;
  final String vehicleType;
  final String vehicleNumber;
  final bool isAvailable;

  DeliveryDetails({
    required this.id,
    required this.staffId,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.isAvailable,
  });

  factory DeliveryDetails.fromJson(Map<String, dynamic> json) {
    return DeliveryDetails(
      id: json['id'],
      staffId: json['staff_id'],
      vehicleType: json['vehicle_type'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      isAvailable: json['is_available'] == 1 || json['is_available'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff_id': staffId,
      'vehicle_type': vehicleType,
      'vehicle_number': vehicleNumber,
      'is_available': isAvailable ? 1 : 0,
    };
  }
}
