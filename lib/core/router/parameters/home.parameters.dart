// ignore_for_file: public_member_api_docs

/// Query parameters for home.
class HomeParameters {
  HomeParameters({this.categoryName});

  final String? categoryName;

  Map<String, String?> toMap() {
    return {'categoryName': categoryName};
  }
}
