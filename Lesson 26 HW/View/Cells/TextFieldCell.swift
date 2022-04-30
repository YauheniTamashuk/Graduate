import UIKit

protocol TextFieldCellOutput: AnyObject {
    func textFieldCell(_ textFieldCell: TextFieldCell, didChangeText text: String, cellType: TextFieldType )
}

class TextFieldCell: UITableViewCell, ReuseIdentifying {
    
    static var reuseIdentifier: String { NSStringFromClass(self) }
    private var type = TextFieldType.email
    weak var output: TextFieldCellOutput?
    
    private let textField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupElements()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(text: String?, placeholder: String?, type: TextFieldType) {
        textField.text = text
        textField.placeholder = placeholder
        self.type = type
    }
    
    private func setupElements() {
        textField.autocorrectionType = .no
        selectionStyle = .none
        textField.addTarget(self, action: #selector(didValueChanged), for: .editingChanged)
        contentView.addSubview(textField)
    }
    
    @objc private func didValueChanged(_ textField: UITextField) {
        output?.textFieldCell(self, didChangeText: textField.text ?? "", cellType: type)
    }
    
    private func setupConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
        ])
    }
}
