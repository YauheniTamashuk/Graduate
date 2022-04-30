import UIKit

// MARK: - Protocols

protocol ProfileViewInput {
    func setup(with sections: [Section])
}

protocol ProfileViewOutput: AnyObject {
    func profileView(_ profileView: ProfileView, shouldShowDeleteActionFor row: Row) -> Bool
    func profileView(_ profileView: ProfileView, deleteActionFor object: ListObject, at indexPath: IndexPath)
    func profileView(_ profileView: ProfileView, didChangeField text: String, cellType: TextFieldType)
    func profileView(_ profileView: ProfileView, didSelectSelectionCell celltype: SelectionCellType)
    func profileView(_ profileView: ProfileView, didSelectListCellWith object: ListObject)
}

// MARK: - Constants

private struct Constants {
    static let deleteActionTitle = "Delete"
    static let deleteImage = UIImage(systemName: "trash")
}

class ProfileView: UIView {

    weak var output: ProfileViewOutput?

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var sections = [Section]()
    private let type: DataType
    private let isEditable: Bool

    init(type: DataType, isEditable: Bool = true) {
        self.type = type
        self.isEditable = isEditable
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupConstraints()
    }
}

// MARK: - ProfileViewInput

extension ProfileView: ProfileViewInput {
    func setup(with sections: [Section]) {
        self.sections = sections
    }

    func reloadData() {
        tableView.reloadData()
    }

    func deleteRow(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - PrivateMethods

private extension ProfileView {
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
        tableView.register(SelectionCell.self, forCellReuseIdentifier: SelectionCell.reuseIdentifier)
        addSubview(tableView)
    }

    func setupConstraints() {
        attachToSuperview()
        tableView.attachToSuperview()
    }
}

// MARK: - UITableViewDataSource

extension ProfileView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell

        let row = sections[indexPath.section].rows[indexPath.row]

        switch row {
        case .textFieldCell(text: let text, placeholder: let placeholder, type: let type):
            cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier, for: indexPath)
            guard let textFieldCell = cell as? TextFieldCell else { break }
            textFieldCell.setup(text: text, placeholder: placeholder, type: type)
            textFieldCell.output = self
        case .selectionCell(text: let text, type: let type):
            cell = tableView.dequeueReusableCell(withIdentifier: SelectionCell.reuseIdentifier, for: indexPath)
            guard let selectionCell = cell as? SelectionCell else { break }
            selectionCell.setup(text: text, type: type)
        case .listCell(listObject: let object):
            cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier, for: indexPath)
            guard let listCell = cell as? ListCell else { break }
            listCell.setup(with: object)
        }

        cell.isUserInteractionEnabled = isEditable
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProfileView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        switch cell {
        case let selectionCell as SelectionCell:
            output?.profileView(self, didSelectSelectionCell: selectionCell.type ?? .singleSelection)
        case let listCell as ListCell:
            output?.profileView(self, didSelectListCellWith: listCell.object)
        default:
            break
        }
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let row = sections[indexPath.section].rows[indexPath.row]
        guard
            let shouldShowAction = output?.profileView(self, shouldShowDeleteActionFor: row),
            shouldShowAction
        else { return nil }
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: Constants.deleteActionTitle
        ) { _, _, completion in
            let cell = tableView.cellForRow(at: indexPath)
            guard let listCell = cell as? ListCell else { return }
            self.output?.profileView(self, deleteActionFor: listCell.object, at: indexPath)
            completion(true)
        }
        deleteAction.image = Constants.deleteImage
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - TextFieldCellOutput

extension ProfileView: TextFieldCellOutput {
    func textFieldCell(_ textFieldCell: TextFieldCell, didChangeText text: String, cellType: TextFieldType) {
        output?.profileView(self, didChangeField: text, cellType: cellType)
    }
}
