import 'package:damilk_app/src/bloc/base_bloc.dart';
import 'package:damilk_app/src/repository/remote/api/models/alone/city_model.dart';
import 'package:damilk_app/src/repository/remote/api/models/base_response.dart';
import 'package:damilk_app/src/repository/sim23_repository.dart';

class RegistrationBloc extends BaseBloc {
  final _repository = Sim23Repository();
  BaseResponse<List<CityModel>> citiesResponse;

  Future<BaseResponse<List<CityModel>>> loadCitiesIfEmpty() async {
    if (citiesResponse != null &&
        citiesResponse.isSuccessful() &&
        citiesResponse.data.isNotEmpty) {
      return Future.value(citiesResponse);
    } else {
      showProgress();
      citiesResponse = await _repository.loadCities();
      hideProgress();

      return citiesResponse;
    }
  }

  Future<BaseResponse> register(String name, CityModel city) async {
    showProgress();
    final response = await _repository.register(name, city);
    hideProgress();
    return response;
  }

  CityModel getCity(int position) {
    return citiesResponse.data[position];
  }
}
