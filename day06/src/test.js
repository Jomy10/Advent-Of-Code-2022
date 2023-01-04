import { findFirstPacketMarker, findFirstMessageMarker } from './main.js';

let id = 1;
function test(input, expected) {
  if (findFirstPacketMarker(input) != expected)
    console.log(`[${id}] Failed`);
  else
    console.log(`[${id}] success`);

  id += 1;
}

function test2(input, expected) {
  if (findFirstMessageMarker(input) != expected)
    console.log(`[${id}] Failed`);
  else
    console.log(`[${id}] success`);

  id += 1;
}

console.log("== Part 1 ==");
test("mjqjpqmgbljsphdztnvjfqwrcgsmlb", 7);
test("bvwbjplbgvbhsrlpgdmjqwftvncz", 5);
test("nppdvjthqldpwncqszvftbrmjlhg", 6);
test("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 10);
test("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 11);

console.log("== Part 1 ==");
test2("mjqjpqmgbljsphdztnvjfqwrcgsmlb", 19);
test2("bvwbjplbgvbhsrlpgdmjqwftvncz", 23);
test2("nppdvjthqldpwncqszvftbrmjlhg", 23);
test2("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 29);
test2("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 26);
