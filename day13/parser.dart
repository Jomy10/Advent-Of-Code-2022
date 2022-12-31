class Pair {
  // The packets in the pair
  ArrValue one;
  ArrValue two;

  Pair(this.one, this.two);

  @override
  String toString() {
    return "Pair{$one, $two}";
  }
}

class Value<T> {
  T value;

  Value(T this.value);

  @override
  String toString() {
    return "Val{$value}";
  }
}

class ArrValue implements Value<List<Value>> {
  late List<Value> value;

  ArrValue() {
    this.value = [];
  }

  @override
  String toString() {
    return "Arr{$value}";
  }
}

class IntValue implements Value<int> {
  int value;

  IntValue(int this.value);
  @override
  String toString() {
    return "Int{$value}";
  }
}

List<Pair> parse(String input) {
  List<Pair> output = [];

  input.split("\n\n").forEach((pairstr) {
    var pair = pairstr.split("\n");
    var one = pair[0];
    var two = pair[1];

    output.add(parse_pair(one, two));
  });
  
  return output;
}

Pair parse_pair(String one, String two) {
  return new Pair(parse_message(one), parse_message(two));
}

ArrValue parse_message(String msg) {
  var level = 0;
  ArrValue top_arr = new ArrValue();
  List<ArrValue> current_arr_path = [];

  List<String> collected_int = [];
  
  msg.runes.forEach((int rune) {
    var char = new String.fromCharCode(rune);

    if (char == '[') {
      if (level == 0) {
        top_arr = new ArrValue();
        current_arr_path.add(top_arr);
      } else {
        var new_val = new ArrValue();
        current_arr_path.last.value.add(new_val);
        current_arr_path.add(new_val);
      }

      level += 1;
    } else if (char == ']') {
      // Add int value
      if (collected_int.length != 0) {
        var int_str = collected_int.join("");
        int val = int.parse(int_str);
        collected_int.clear();
        current_arr_path.last.value.add(new IntValue(val));
      }

      current_arr_path.removeLast();
      level -= 1;
    } else if (char == ',') {
      // Add int value
      if (collected_int.length != 0) {
        var int_str = collected_int.join("");
        int val = int.parse(int_str);
        collected_int.clear();
        current_arr_path.last.value.add(new IntValue(val));
      }
    } else {
      // Add part of int to collected
      collected_int.add(char);
    }
  });

  return top_arr;
}
