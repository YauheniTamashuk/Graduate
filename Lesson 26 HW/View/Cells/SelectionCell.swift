import UIKit

private enum Constants {
    static let multipleSelectionImage = UIImage(systemName: "plus.circle")
}

class SelectionCell: UITableViewCell, ReuseIdentifying {
    
    static var reuseIdentifier: String { NSStringFromClass(self) }
    var type: SelectionCellType?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        textLabel?.textColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }
    
    func setup(text: String?, type: SelectionCellType) {
        textLabel?.text = text
        self.type = type
        guard type == .multipleSelection else { return }
        imageView?.image = Constants.multipleSelectionImage
    }
}
