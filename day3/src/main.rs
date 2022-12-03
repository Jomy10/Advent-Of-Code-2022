use day3::*;

fn main() {
    let input = std::fs::read_to_string("input.txt").unwrap();
    let rucksacks = parse_input_compartments(&input);
    let shared_items = rucksacks.map(|rucksack| get_shared_item_type(rucksack));
    let priorities = shared_items.map(|shared_item| get_priority(shared_item));
    let sum: u32 = priorities.map(|v| v as u32).sum();
    println!("Part 1: {}", sum);

    let rucksacks = input.lines();
    let shared_items = get_shared_item_type_group(rucksacks);
    let priorities = shared_items.iter().map(|shared_item| get_priority(*shared_item));
    let sum: u32 = priorities.map(|v| v as u32).sum();
    println!("Part 2: {}", sum);
}
