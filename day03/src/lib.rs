/// Returns an iterator over the rucksacks represented as a tuple of its compartments
pub fn parse_input_compartments<'a>(input: &'a str) -> impl std::iter::Iterator<Item = (&'a str, &'a str)> + 'a {
    input.lines()
        .map(|line| {
            line.split_at(line.len() / 2)
        })
}

/// Get the item that is shared between two compartments of a rucksack
pub fn get_shared_item_type(rucksack: (&str, &str)) -> char {
    let mut val: char = '\0';
    let mut iter =rucksack.0.chars()
        .fuse()
        .map(|c| {
            if rucksack.1.contains(c) {
                val = c;
                None
            } else {
                Some(())
            }
        });
    while iter.next().is_some() {}
    return val;
}

/// Get the item that is shared between groups of 3 rucksacks
pub fn get_shared_item_type_group<'a>(mut rucksacks: impl std::iter::Iterator<Item = &'a str>) -> Vec<char> {
    let mut shared_items = Vec::new();
    loop {
        if let Some(rucksack1) = rucksacks.next() {
            let rucksack2 = rucksacks.next().unwrap();
            let rucksack3 = rucksacks.next().unwrap();

            for c in rucksack1.chars() {
                if rucksack2.contains(c) && rucksack3.contains(c) {
                    shared_items.push(c);
                    break;
                }
            }
        } else {
            break;
        }
    }
    return shared_items;
}

pub fn get_priority(item: char) -> u8 {
    if item >= 'a' {
        (item as u8) - ('a' as u8) + 1
    } else {
        (item as u8) - ('A' as u8) + 27
    }
}
