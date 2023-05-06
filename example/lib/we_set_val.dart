bool weSetVal(List data, String id, dynamic val) {
  for (var eMain in data) {
    String eid = eMain.containsKey("Key") ? eMain["Key"] : "";
    List? echilds = eMain.containsKey("Childs") ? eMain["Childs"] : null;
    if (eid == id) {
      if (val == null) {
        String type = eMain.containsKey("Type") ? eMain["Type"] : "";
        if (type == "PSMultiValueSpecifier") {
          return false;
        }
      }
      eMain["Value"] = val;
      return true;
    }
    if (echilds == null) {
      continue;
    }
    // print('>> eid: $eid, id: $id, val: $val >> eChilds: $echilds');
    bool isSet = weSetVal(echilds, id, val);
    if (isSet) {
      return true;
    }
  }
  return false;
}
