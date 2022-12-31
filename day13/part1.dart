import "parser.dart";

List<int> get_equal_pair_indices(List<Pair> pairs) {
  List<int> indices = [];
  int pair_number = 0;

  for (var pair in pairs) {
    pair_number += 1;
    var ro = is_right_order(pair);
    if (ro == RightOrder.True) {
      indices.add(pair_number);
    } else if (ro == RightOrder.Continue) {
      print("ERROR");
    }
  }

  return indices;
}

enum RightOrder {
  True,
  False,
  Continue,
}

// Check if a list is in the right order
RightOrder is_right_order(Pair pair) {
  int i = 0;
  while (true) {
    // TODO: add index check
    if (pair.one.value.length == i) {
      if (pair.two.value.length == i) {
        return RightOrder.Continue;
      }
      return RightOrder.True;
    } else if (pair.two.value.length == i) {
      return RightOrder.False;
    }
    var val_l = pair.one.value[i];
    var val_r = pair.two.value[i];
    if (val_l is IntValue && val_r is IntValue) {
      if (val_l.value < val_r.value) {
        return RightOrder.True;
      } else if (val_l.value > val_r.value) {
        return RightOrder.False;
      } else { // equal
        i += 1;
        continue;
      }
    } else if (val_l is ArrValue && val_r is ArrValue) {
      var ro = is_right_order(new Pair(val_l, val_r));
      if (ro == RightOrder.True) {
        return RightOrder.True;
      } else if (ro == RightOrder.False) {
        return RightOrder.False;
      } else if (ro == RightOrder.Continue) {
        i += 1;
        continue;
      }
    } else {
      Pair pair;
      if (val_l is IntValue) {
        var val_l_a = new ArrValue();
        val_l_a.value.add(new IntValue(val_l.value));
        pair = new Pair(val_l_a, val_r as ArrValue);
      } else {
        var val_r_a = new ArrValue();
        val_r_a.value.add(new IntValue(val_r.value));
        pair = new Pair(val_l as ArrValue, val_r_a);
      }
      var ro = is_right_order(pair);
      if (ro == RightOrder.True) {
        return RightOrder.True;
      } else if (ro == RightOrder.False) {
        return RightOrder.False;
      } else if (ro == RightOrder.Continue) {
        i += 1;
        continue;
      }
    }

    print("ERROR: unreachable");
  }
}
