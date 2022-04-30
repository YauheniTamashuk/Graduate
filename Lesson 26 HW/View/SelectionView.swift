import UIKit

// MARK: - Protocols

protocol SelectionViewInput {
    func setup(with objects: [ListObject], selectedObjects: [ListObject], allowsMultipleSelection: Bool)
}

protocol SelectionViewOutput: AnyObject {
    func selectionView(_ selectionView: SelectionView, selectionChangedWith objects: [ListObject])
}

class SelectionView: UIView {

    weak var output: SelectionViewOutput?

    private let tableView = UITableView()
    private var objects = [ListObject]()
    private var selectedObjects = [ListObject]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupConstraints()
    }

}

// MARK: - ListViewInput

extension SelectionView: SelectionViewInput {
    func setup(with objects: [ListObject], selectedObjects: [ListObject], allowsMultipleSelection: Bool) {
        self.objects = objects
        self.selectedObjects = selectedObjects
        tableView.allowsMultipleSelection = allowsMultipleSelection
    }
}

// MARK: - PrivateMethods

private extension SelectionView {
    func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
        addSubview(tableView)
    }

    func setupConstraints() {
        attachToSuperview()
        tableView.attachToSuperview()
    }

    func getContentForCell(at indexPath: IndexPath) -> UIListContentConfiguration {
        var content = UIListContentConfiguration.cell()
        let object = objects[indexPath.row]
        content.text = object.text
        content.secondaryText = object.secondaryText
        return content
    }

    func getSelectedObjects() -> [ListObject] {
        var selectedObjects = [ListObject]()
        tableView.indexPathsForSelectedRows?.forEach {
            selectedObjects.append(objects[$0.row])
        }
        return selectedObjects
    }
}

// MARK: - UITableViewDataSource

extension SelectionView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier, for: indexPath)
        guard let listCell = cell as? ListCell else { return .init() }
        listCell.setup(with: objects[indexPath.row])

        selectedObjects.forEach {
            if $0.id == objects[indexPath.row].id {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                cell.accessoryType = .checkmark
            }
        }
        return listCell
    }
}

// MARK: - UITableViewDelegate

extension SelectionView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .checkmark
        output?.selectionView(self, selectionChangedWith: getSelectedObjects())
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .none
        output?.selectionView(self, selectionChangedWith: getSelectedObjects())
    }
}
