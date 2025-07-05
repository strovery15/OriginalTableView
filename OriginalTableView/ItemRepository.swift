

import Foundation


class ItemRepository {
    
    var items: [Item]
    var itemIDs: [Item.ID] { items.map(\.id) }
    
    func getItem(id: Item.ID) -> Item? {
        items.first(where: {$0.id == id})
    }
    
    init(items: [String]) {
        self.items = items.map { i in Item(id: UUID(), title: "#\(i)") }
    }
}

struct Item: Identifiable {
    var id: UUID
    var title: String
}
