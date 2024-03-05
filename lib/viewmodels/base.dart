import 'package:flutter/cupertino.dart';
import '../constants/viewState.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  set state(ViewState newState) {
    _state = newState;
  }

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  void setErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }
}
