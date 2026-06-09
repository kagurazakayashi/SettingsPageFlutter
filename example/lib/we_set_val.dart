bool weSetVal(List data, String id, dynamic val) {
  for (var eMain in data) {
    String eid = eMain.containsKey("Key") ? eMain["Key"] : "";
    List? echilds = eMain.containsKey("Childs") ? eMain["Childs"] : null;
    if (eid=="rang test") {
      print(">>>>[$eid] $eMain");
    }
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

      if (eid == "net_mtu") {
        print(">>>> 000 $val ${val.runtimeType}");
        double valnum = 0;

        switch (val.runtimeType.toString()) {
          case "int":
            valnum = (val as int).toDouble();
            break;
          case "double":
            valnum = val as double;
            break;
          case "String":
            try {
              valnum = double.parse(val as String);
            } catch (_) {}
            break;
          default:
        }
        print(">>>> 001 $val $eMain");
        double minval = 10;
        print(">>>> 002 $val $eMain");
        Object temp =
            eMain.containsKey("MinimumValue") ? eMain["MinimumValue"] : 10;
        print(">>>> 111 $val $eMain");
        switch (temp.runtimeType.toString()) {
          case "int":
            minval = (temp as int).toDouble();
            break;
          case "double":
            minval = temp as double;
            break;
          case "String":
            try {
              minval = double.parse(temp as String);
            } catch (_) {
              minval = 10;
            }
            break;
          default:
        }
        print(">>>> 222 $val $eMain");
        if (valnum < minval) {
          print(">>>> 222 - 00 $val $eMain");
          val = minval.toString();
        } else {
          print(">>>> 222 - 11 $val $eMain");
          val = valnum.toString();
        }
      }
      print(">>> $val");
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
