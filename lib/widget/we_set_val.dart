bool weSetVal(List data, String id, String val) {
  for (var eMain in data) {
    String eid = eMain.containsKey("Key") ? eMain["Key"] : "";
    List? echilds = eMain.containsKey("childs") ? eMain["childs"] : null;
    print('eid: $eid, id: $id, val: $val');
    if (eid == id) {
      eMain["val"] = val;
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
