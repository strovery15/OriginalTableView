//
//  ViewController.swift
//  OriginalTableView
//
//  Created by 川前優太 on 2025/07/01.
//

import UIKit


class ViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var repository: ItemRepository!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item.ID>!
    
    enum Section: Hashable {
        case main
    }
    
    var items = ["Apple🍎", "Banana🍌", "Lemon🍋", "Melon🍈", "Grape🍇","Strawbery🍓", "PineApple🍍", "Orange🍊", "Cherry🍒", "Peach🍑", "Blueberry🫐", "Watermelon🍉"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repository = ItemRepository(items: items)
        configureLayout()
        configureCollectionViewLayout()
        configureDataSource()
        applySnapshot()
    }
    
    func configureLayout() {
        navigationItem.title = "OriginalTableView"
        view.backgroundColor = .systemGray6
        let Gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognizer))
        collectionView.addGestureRecognizer(Gesture)
        collectionView.allowsSelection = false
        
    }
    
    func configureCollectionViewLayout() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.separatorConfiguration.bottomSeparatorInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
                configuration.leadingSwipeActionsConfigurationProvider = { indexPath -> UISwipeActionsConfiguration in
                    let action = UIContextualAction(style: .destructive, title: "削除") {
                        [weak self] _, _, completionHandler in
                        let itemID = self?.dataSource.itemIdentifier(for: indexPath)!
                        self?.deleteItem(id: itemID!)
                        completionHandler(true)
                    }
                    action.backgroundColor = UIColor.systemRed
                    let swipeActionConfi = UISwipeActionsConfiguration(actions: [action])
                    swipeActionConfi.performsFirstActionWithFullSwipe = false
                    return swipeActionConfi
                }
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.collectionViewLayout = layout
        
    }
    
}

extension ViewController {
    
    func configureDataSource() {
        let itemCellRegistration =
        UICollectionView.CellRegistration<OriginalCell, Item> {
            cell, indexpath, item in
            
            cell.item = item.title
        }
        
        self.dataSource = UICollectionViewDiffableDataSource(
            collectionView: self.collectionView,
            cellProvider: { [weak self] collectionView, indexpath, itemID in
                let item = self?.repository.getItem(id: itemID)
                return collectionView.dequeueConfiguredReusableCell(using: itemCellRegistration, for: indexpath, item: item)
            })
        
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(repository.itemIDs, toSection: .main)
        
        dataSource.reorderingHandlers.canReorderItem = { _ in true }
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    
}

extension ViewController {
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = repository.items.remove(at: sourceIndexPath.item)
        repository.items.insert(item, at: destinationIndexPath.item)
    }
    
    func deleteItem(id: Item.ID) {
        var snapshot = self.dataSource.snapshot()
        snapshot.deleteItems([id])
        self.dataSource.apply(snapshot, animatingDifferences: true)
        self.repository.items.removeAll { $0.id == id}
    }
    
    @objc func longPressRecognizer(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {return}
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
}
