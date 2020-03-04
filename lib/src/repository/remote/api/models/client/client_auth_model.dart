import 'package:sim23/src/repository/remote/api/models/client/client_model.dart';
import 'package:sim23/src/repository/remote/api/models/client/token_model.dart';

class ClientAuthModel {
  final ClientModel clientModel;
  final TokenModel tokenModel;

  ClientAuthModel(this.clientModel, this.tokenModel);

  factory ClientAuthModel.fromJson(Map<String, dynamic> json) {
    return ClientAuthModel(
        ClientModel.fromJson(json['client'] as Map<String, dynamic>),
        TokenModel.fromJson(json['token'] as Map<String, dynamic>));
  }
}
