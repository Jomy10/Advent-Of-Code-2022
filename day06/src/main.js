// const fs = require('fs');
import fs from 'fs';

/** Returns the position of the first start-of-packet marker
 * @param input {string}
 * @returns {number} the amount of characters to be read before the first marker
 */
export function findFirstPacketMarker(input) {
  return findFirstMarker(input, 4);
}

/** Returns the position of the first start-of-message marker
 * @param input {string}
 * @returns {number}
 */
export function findFirstMessageMarker(input) {
  return findFirstMarker(input, 14);
}

/** Find the first position of a series of unique `distinctLength` amount of character
 * @param input {string}
 * @param distinctLength {number}
 * @returns {number}
 */
function findFirstMarker(input, distinctLength) {
  for (let i = 0; i < input.length - distinctLength; i++) {
    let possibleMarker = input.substring(i, i + distinctLength);

    // Check if unique
    let found = true;
    unique_loop: for (let c = 0; c < distinctLength; c++) {
      for (let c2 = 0; c2 < distinctLength; c2++) {
        if (c == c2) continue;
        if (possibleMarker[c] == possibleMarker[c2]) {
          found = false;
          break unique_loop;
        }
      }
    }

    if (found) return i + distinctLength;
  }
}

fs.readFile("./input.txt", 'utf8', (err, data) => {
  if (err) {
    console.log(err);
    return;
  }
  console.log("Part 1:", findFirstPacketMarker(data));
  console.log("Part 2:", findFirstMessageMarker(data));
});
