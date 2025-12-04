class EmployeeRecap {
  final int id;
  final String name;
  final String? departement;
  final String? position;
  final String? gender;
  final String? address;
  final String? email;
  final String? createdAt;
  final List<Map<String, dynamic>>? letters;

  EmployeeRecap({
    required this.id,
    required this.name,
    this.departement,
    this.position,
    this.gender,
    this.address,
    this.email,
    this.createdAt,
    this.letters,
  });

  factory EmployeeRecap.fromJson(Map<String, dynamic> json) {
    return EmployeeRecap(
      id: json['id'],
      name: json['name'],
      departement: json['department'],
      position: json['position'],
      gender: json['gender'],
      address: json['address'],
      email: json['email'],
      createdAt: json['created_at'],
      letters: List<Map<String, dynamic>>.from(json['letters'] ?? []),
    );
  }
}
