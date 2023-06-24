class Organization {
  String imageUrl;
  String organizationName;
  String description;
  String website;
  String facebook;
  String email;
  String address;
  String phone;
  String fax;
  String foundingYear;
  String guidestar;
  List<dynamic> services;

  Organization({
    required this.imageUrl,
    required this.organizationName,
    required this.description,
    required this.website,
    required this.facebook,
    required this.email,
    required this.address,
    required this.phone,
    required this.fax,
    required this.foundingYear,
    required this.guidestar,
    required this.services,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    List<String> services = [];
    final dynamic jsonServices = json['services'];
    if (jsonServices != null) {
      if (jsonServices is String) {
        // If 'services' is a string, add it to the list as a single item
        services.add(jsonServices);
      } else if (jsonServices is List<dynamic>) {
        // If 'services' is a list, convert each item to a string and add to the list
        services = jsonServices.map((item) => item.toString()).toList();
      }
    }

    return Organization(
      imageUrl: json['imageUrl'] ?? '',
      organizationName: json['organization_name'] ?? '',
      description: json['description'] ?? '',
      website: json['website'] ?? '',
      facebook: json['facebook'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      fax: json['fax'] ?? '',
      foundingYear: json['foundingYear'] ?? '',
      guidestar: json['guidestar'] ?? '',
      services: services,
    );
  }
}
