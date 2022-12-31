import "parser.dart";
import "part1.dart";

// Returns the decoder key
int part2(List<Pair> pairs) {
  List<ArrValue> packets = [];
  for (var pair in pairs) {
    packets.add(pair.one);
    packets.add(pair.two);
  }

  var arr2 = new ArrValue();
  arr2.value.add(new ArrValue());
  (arr2.value[0] as ArrValue).value.add(new IntValue(2));
  packets.add(arr2);
  var arr6 = new ArrValue();
  arr6.value.add(new ArrValue());
  (arr6.value[0] as ArrValue).value.add(new IntValue(6));
  packets.add(arr6);

  bool all_in_order = true;

  do {
    all_in_order = true;
    for (int i = 0; i < packets.length - 1; i += 1) {
      var ro = is_right_order(new Pair(packets[i], packets[i + 1]));
      // print("$i - $ro");
      if (ro == RightOrder.False) {
        all_in_order = false;
        // Swap
        var tmp = packets[i];
        packets[i] = packets[i + 1];
        packets[i+1] = tmp;
      } else if (ro == RightOrder.Continue) {
        print("ERROR");
      }
    }
  } while(!all_in_order);
  
  var divider_indices = find_divider_packet_indices(packets);
  if (divider_indices.length != 2) {
    print("ERROR");
  }

  return divider_indices.reduce((a, b) => a * b);
}

List<int> find_divider_packet_indices(List<ArrValue> packets) {
  List<int> indices = [];
  int index = 0;
  for (var packet in packets) {
    index += 1;
    if (
      packet.value.length == 1
      && packet.value[0] is ArrValue
      && (packet.value[0] as ArrValue).value.length == 1
      && (packet.value[0] as ArrValue).value[0] is IntValue
    ) {
      if (((packet.value[0] as ArrValue).value[0] as IntValue).value == 2) {
        indices.add(index);
      } else if (((packet.value[0] as ArrValue).value[0] as IntValue).value == 6) {
        indices.add(index);
      }
    }
  }
  return indices;
}
