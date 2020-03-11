import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:damilk_app/src/bloc/provider/block_provider.dart';
import 'package:damilk_app/src/repository/remote/api/models/alone/city_model.dart';
import 'package:damilk_app/src/resources/colors.dart';
import 'package:damilk_app/src/resources/const.dart';
import 'package:damilk_app/src/resources/drawables.dart';
import 'package:damilk_app/src/resources/strings.dart';
import 'package:damilk_app/src/router/app_routing_names.dart';
import 'package:damilk_app/src/ui/screens/auth/registration/registration_bloc.dart';
import 'package:damilk_app/src/ui/screens/auth/registration/registration_screen.dart';
import 'package:damilk_app/src/extensions/parser.dart';
import 'package:damilk_app/src/extensions/widgets.dart';
//import 'package:damilk_app/src/ui/widgets/city_picker_dialog.dart';

class RegistrationWidget extends State<RegistrationScreen> {
  RegistrationBloc _bloc;
  TextEditingController _nameInputController;
  FocusNode _nameFocusNode;
  var _showBackgroundRectangle = true;
  CityModel _pickedCity;
  bool _continueEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameInputController = TextEditingController(text: "");
    _nameFocusNode = FocusNode();
    _bloc = RegistrationBloc();

//    KeyboardVisibilityNotification().addNewListener(
//      onChange: (bool visible) {
//        setState(() {
//          _showBackgroundRectangle = !visible;
//        });
//      },
//    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    _nameFocusNode.dispose();
    _nameInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brand_grey,
      body: StreamBuilder(
        stream: _bloc.progressStream,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return ModalProgressHUD(
            child: _buildScreenContent(),
            inAsyncCall: snapshot.data,
          );
        },
      ),
    );
  }

  Widget _buildScreenContent() {
    return BlocProvider<RegistrationBloc>(
      block: _bloc,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 88.dp()),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.dp()),
                  bottomRight: Radius.circular(16.dp())),
              child: Container(
                color: AppColors.white,
              ),
            ),
          ),
          _showBackgroundRectangle
              ? Drawables.getImage(Drawables.REGISTRATION_TRIANGLE_BACKGROUND)
              : null,
          Align(alignment: Alignment.bottomCenter, child: _buildInput()),
          Align(alignment: Alignment.bottomCenter, child: _buildBottomButton())
        ].where((element) => element != null).toList(),
      ),
    );
  }

  Widget _buildInput() {
    return Padding(
      padding: EdgeInsets.only(bottom: 110.dp(), left: 24.dp(), right: 24.dp()),
      child: Wrap(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 40.dp()),
            child: Text(
              Strings.get(context, Strings.REGISTRATION_SCREEN_TITLE),
              style: TextStyle(
                  color: AppColors.solid_black,
                  fontSize: 24.sp(),
                  fontFamily: Const.FONT_FAMILY_NUNITO,
                  fontWeight: FontWeight.w700),
            ),
          ),
          TextField(
            controller: _nameInputController,
            cursorColor: AppColors.solid_black,
            onChanged: (String enteredText) {
              _checkContinueButtonEnabled();
            },
            style: TextStyle(
                color: AppColors.solid_black,
                fontSize: 16.sp(),
                fontWeight: FontWeight.w600,
                fontFamily: Const.FONT_FAMILY_NUNITO),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                  left: 16.dp(), right: 16.dp(), top: 16.dp(), bottom: 20.dp()),
              hintText: Strings.get(context, Strings.NAME),
              hintStyle: TextStyle(
                  color: AppColors.solid_black_60,
                  fontSize: 16.sp(),
                  fontWeight: FontWeight.w600,
                  fontFamily: Const.FONT_FAMILY_NUNITO),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.focused_border, width: 2.dp()),
                  borderRadius: BorderRadius.all(Radius.circular(8.dp()))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.focused_border, width: 2.dp()),
                  borderRadius: BorderRadius.all(Radius.circular(8.dp()))),
            ),
          ),
          GestureDetector(
            onTap: _openCityPicker,
            child: Container(
              margin: EdgeInsets.only(top: 16.dp()),
              padding: EdgeInsets.only(
                  left: 16.dp(), top: 16.dp(), bottom: 16.dp(), right: 20.dp()),
              decoration: BoxDecoration(
                  color: AppColors.transparent,
                  borderRadius: BorderRadius.circular(8.dp()),
                  border: Border.all(
                      color: AppColors.focused_border, width: 2.dp())),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _pickedCity == null
                          ? Strings.get(context, Strings.CITY)
                          : _pickedCity.title,
                      style: TextStyle(
                          color: AppColors.solid_black,
                          fontSize: 16.sp(),
                          fontFamily: Const.FONT_FAMILY_NUNITO,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Drawables.getImage(Drawables.ARROW_DOWN)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _openCityPicker() async {
    final citiesResponse = await _bloc.loadCitiesIfEmpty();
    if (citiesResponse.isSuccessful()) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
//            return CityPickerDialog(citiesResponse.data, _onCityPicked);
          });
    } else {
      handleFailure(citiesResponse);
    }
  }

  void _onCityPicked(int cityPosition) {
    setState(() {
      _pickedCity = _bloc.getCity(cityPosition);
    });
    _checkContinueButtonEnabled();
  }

  void _checkContinueButtonEnabled() {
    final isEnabled =
        _pickedCity != null && _nameInputController.text.trim().isNotEmpty;
    if (_continueEnabled != isEnabled) {
      setState(() {
        _continueEnabled = isEnabled;
      });
    }
  }

  Widget _buildBottomButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          onTap: () => {
            if (_continueEnabled) {_registerUser()}
          },
          child: Container(
            height: 88.dp(),
            padding: EdgeInsets.only(top: 24.dp(), bottom: 24.dp()),
            color: AppColors.transparent,
            child: Center(
              child: Text(
                Strings.get(context, Strings.SIGN_IN),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color:
                        _continueEnabled ? AppColors.white : AppColors.white_60,
                    fontSize: 14.sp(),
                    fontFamily: Const.FONT_FAMILY_NUNITO,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: 8.dp(), right: 24.dp(), top: 24.dp(), bottom: 24.dp()),
          child: Drawables.getImage(Drawables.ARROW_RIGHT,
              tint: _continueEnabled ? AppColors.white : AppColors.white_60),
        )
      ],
    );
  }

  void _registerUser() async {
    final response =
        await _bloc.register(_nameInputController.text.trim(), _pickedCity);

    if (response.isSuccessful()) {
//      Navigator.of(context).pushNamedAndRemoveUntil(
//          AppRoutes.CONGRATULATION_SCREEN, (Route route) => false,
//          arguments: CongratulationArguments(_nameInputController.text, true));
    } else {
      handleFailure(response);
    }
  }
}
