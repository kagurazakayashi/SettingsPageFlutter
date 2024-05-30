bool weSetVal(List data, String id, dynamic val) {
  for (var eMain in data) {
    String eid = eMain.containsKey("Key") ? eMain["Key"] : "";
    List? echilds = eMain.containsKey("Childs") ? eMain["Childs"] : null;
    if (eid == id) {
      String type = eMain.containsKey("Type") ? eMain["Type"] : "";
      if (val == null) {
        if (type == "PSMultiValueSpecifier") {
          return false;
        }
      }
      if (type == "PSToggleSwitchSpecifier") {
        Object valtrue = eMain.containsKey("True") ? eMain["True"] : true;
        Object valfalse = eMain.containsKey("False") ? eMain["False"] : false;
        if (val.toString() == valtrue.toString()) {
          eMain["Value"] = true;
        } else if (val.toString() == valfalse.toString()) {
          eMain["Value"] = false;
        } else {
          eMain["Value"] = val;
          return true;
        }
        return true;
      }
      eMain["Value"] = val;
      return true;
    }
    if (echilds == null) {
      continue;
    }
    bool isSet = weSetVal(echilds, id, val);
    if (isSet) {
      return true;
    }
  }
  return false;
}
