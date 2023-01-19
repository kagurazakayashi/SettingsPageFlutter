bool weSetVal(List data, String id, dynamic val) {
  for (var eMain in data) {
    String eid = eMain.containsKey("Key") ? eMain["Key"] : "";
    List? echilds = eMain.containsKey("Childs") ? eMain["Childs"] : null;
    if (eid == id) {
      eMain["val"] = val;
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
