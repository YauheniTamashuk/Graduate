import UIKit

class ListCell: UITableViewCell, ReuseIdentifying {
    
    static var reuseIdentifier: String { NSStringFromClass(self) }
    var object: ListObject = User()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with listObject: ListObject) {
        object = listObject
        textLabel?.text = listObject.text
        detailTextLabel?.text = listObject.secondaryText
    }
}
