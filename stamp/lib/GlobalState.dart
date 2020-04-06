class GlobalState {
  static final GlobalState ourInstance = new GlobalState();

  static GlobalState getInstance() {
    return ourInstance;
  }
  Map <dynamic , dynamic > data = new Map();

  void setValue (dynamic key ,dynamic value ) {
    data [key] = value;
  }

  dynamic getValue (dynamic key ){
    return data[key];
  }

}
