class ClientModel {
  final String phone, firstName, lastName, birthday, street, email;
  final bool gender;

  ClientModel(this.phone, this.firstName, this.lastName, this.gender,
      this.birthday, this.street, this.email);

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('card')) {
      final cardJson = json['card'] as Map<String, dynamic>;
    }
    if (json.containsKey('points_barcodes')) {
      final pointsBarcodesJson = json['points_barcodes'] as List<dynamic>;
    }
    if (json.containsKey('free_cards_barcodes')) {
      final freeCardsBarcodesJson =
          json['free_cards_barcodes'] as List<dynamic>;
    }

    if (json.containsKey('free_cards_counters')) {
      final freeCardsCounterJson = json['free_cards_counters'] as List<dynamic>;
    }

    return ClientModel(
        json['phone'] as String,
        json['first_name'] as String,
        json['last_name'] as String,
        json['gender'] as bool,
        json['birthday'] as String,
        json['street'] as String,
        json['email'] as String);
  }
}
