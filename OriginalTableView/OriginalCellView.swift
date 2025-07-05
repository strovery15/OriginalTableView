

import UIKit


class OriginalCellView: UIView, UIContentView {
    
    @IBOutlet var view: UIView!
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var menuButton: UIButton!
    
    var originalConfiguration: OriginalCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            originalConfiguration
        }
        set {
            guard let newConfi = newValue as? OriginalCellConfiguration else {
                return
            }
            originalConfiguration = newConfi
        }
    }
    
    init(configuration: OriginalCellConfiguration) {
        super.init(frame: .zero)
        self.configuration = configuration
        loadView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadView() {
        Bundle.main.loadNibNamed("\(OriginalCellView.self)", owner: self)
       addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0)
        ])
    }
    
    func configureLayout() {
        itemLabel.text = originalConfiguration.item
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .regular, scale: .small)
        let systemImage = UIImage(systemName: "ellipsis", withConfiguration: symbolConfiguration)
        menuButton.setTitle("", for: .normal)
        menuButton.setImage(systemImage, for: .normal)
        menuButton.menu = createMenu()
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.tintColor = UIColor.systemGray4
    }
    
    func createMenu() -> UIMenu {
        var menus = [UIMenuElement]()
        menus.append(UIAction(title: "移動", image: UIImage(systemName: "arrow.right"), handler: {_ in
            print("移動")
        }))
        menus.append(UIAction(title: "削除",image: UIImage(systemName: "trash"), attributes: .destructive, handler: {_ in
            print("削除")
            
        }))
        
        return UIMenu(title: "", options: .singleSelection, children: menus)
    }
    
}

struct OriginalCellConfiguration: UIContentConfiguration {
    
    var item: String?
    
    func makeContentView() -> UIView & UIContentView {
        return OriginalCellView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> OriginalCellConfiguration {
        return self
    }
    
}
