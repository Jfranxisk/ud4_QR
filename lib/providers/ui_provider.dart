import 'package:flutter/foundation.dart';

class UIProvider extends ChangeNotifier {
  int _selectedMenuOption = 1;

  int get selectedMenuOption { return this._selectedMenuOption; }
  
  set selectedMenuOption (int index) { 
    this._selectedMenuOption = index;
    notifyListeners();
  }
}