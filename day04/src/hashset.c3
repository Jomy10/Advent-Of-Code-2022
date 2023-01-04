// Wrote this HashSet implementation, but I didn't actually need it because
// I got the objective of part2 wrong. I'll leave it here though in case I
// need it later, because it's not too bad.
module hashset <Key>;

define Hasher = fn int(Key);
define KeyEqual = fn bool(Key, Key);

struct Entry {
    Key key;
    Entry* next;
}

struct HashSet {
    bool* used;
    Entry* entries;
    int cap;
    Hasher hasher;
    KeyEqual keyEq;
}

fn HashSet* init(Hasher hasher, KeyEqual keyEq, int cap = 128) {
    HashSet* set = malloc(HashSet.sizeof);
    set.entries = malloc(Entry.sizeof * cap);
    set.used = malloc(bool.sizeof * cap);
    for (int i = 0; i < cap; i++) {
        set.used[i] = false;
    }
    set.cap = cap;
    set.hasher = hasher;
    set.keyEq = keyEq;
    return set;
}

fn void HashSet.dealloc(HashSet* set) {
    for (int i = 0; i < set.cap; i++) {
        if (!set.used[i]) continue;
        while (set.entries[i].next != null) {
            // TODO
        }
    }
    free(set.used);
    free(set.entries);
    free(set);
}

fn void HashSet.add(HashSet* set, Key key) {
    int idx = set.hasher(key) % set.cap;
    if (!set.used[idx]) {
        set.used[idx] = true;
        set.entries[idx].key = key;
        set.entries[idx].next = null;
    } else if (set.keyEq(set.entries[idx].key, key)) {
        return;
    } else {
        Entry* next = &set.entries[idx];
        while (next.next != null) {
            next = next.next;
        }
        next.next = malloc(Entry.sizeof);
        next.next.key = key;
        next.next.next = null;
    }
}

fn bool HashSet.has(HashSet* set, Key key) {
    int idx = set.hasher(key) % set.cap;
    if (!set.used[idx]) {
        return false;
    } else {
        Entry* entry = &set.entries[idx];
        while (entry != null) {
            if (set.keyEq(entry.key, key)) {
                return true;
            }
        }
        return false;
    }
}

struct HashSetIterator {
    HashSet* set;
    int entryPtr;
    Entry* subEntryPtr;
}

fn HashSetIterator HashSet.iter(HashSet* set) {
    return HashSetIterator {
        set,
        0,
        null
    };
}

fault IteratorError {
    END
}

fn Key! HashSetIterator.next(HashSetIterator* iter) {
    if (iter.entryPtr == iter.set.cap) {
        return IteratorError.END!;
    }
    if (iter.subEntryPtr == null) {
        while (!iter.set.used[iter.entryPtr]) {
            iter.entryPtr++;
            if (iter.entryPtr == iter.set.cap) {
                return IteratorError.END!;
            }
        }
        if (iter.set.entries[iter.entryPtr].next == null) {
            Key key = iter.set.entries[iter.entryPtr++].key;
            return key;
        } else {
            iter.subEntryPtr = iter.set.entries[iter.entryPtr].next;
            return iter.set.entries[iter.entryPtr].key;
            Key key = iter.set.entries[iter.entryPtr++].key;
            return key;
        }
    } else {
        if (iter.subEntryPtr.next == null) {
            Entry* cpy = iter.subEntryPtr;
            iter.subEntryPtr = null;
            iter.entryPtr++;
            return cpy.key;
        } else {
            Entry* cpy = iter.subEntryPtr;
            iter.subEntryPtr = cpy.next;
            return cpy.key;
        }
    }
}
