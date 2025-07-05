

import UIKit


class OriginalCell: UICollectionViewListCell {
    
    var item: String?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfiguration = OriginalCellConfiguration().updated(for: state)
        newConfiguration.item = item
        contentConfiguration = newConfiguration
    }
}
