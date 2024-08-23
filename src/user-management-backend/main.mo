import Option "mo:base/Option";
import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";

actor Inventory {

  // The type of an item identifier.
  public type ItemId = Nat32;

  // The type of an item.
  public type Item = {
    name : Text;
    quantity : Nat32;
  };

  // The next available item identifier.
  private stable var next : ItemId = 0;

  // The item data store.
  private stable var items : Trie.Trie<ItemId, Item> = Trie.empty();

  // Add a new item to the inventory.
  public func addItem(item : Item) : async ItemId {
    let itemId = next;
    next += 1;
    items := Trie.replace(
      items,
      key(itemId),
      Nat32.equal,
      ?item,
    ).0;
    return itemId;
  };

  // Read an item from the inventory.
  public query func readItem(itemId : ItemId) : async ?Item {
    let result = Trie.find(items, key(itemId), Nat32.equal);
    return result;
  };

  // Update an item in the inventory.
  public func updateItem(itemId : ItemId, item : Item) : async Bool {
    let result = Trie.find(items, key(itemId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      items := Trie.replace(
        items,
        key(itemId),
        Nat32.equal,
        ?item,
      ).0;
    };
    return exists;
  };

  // Delete an item from the inventory.
  public func deleteItem(itemId : ItemId) : async Bool {
    let result = Trie.find(items, key(itemId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      items := Trie.replace(
        items,
        key(itemId),
        Nat32.equal,
        null,
      ).0;
    };
    return exists;
  };

  // Create a trie key from an item identifier.
  private func key(x : ItemId) : Trie.Key<ItemId> {
    return { hash = x; key = x };
  };
};
