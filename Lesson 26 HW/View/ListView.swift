import UIKit

protocol ListViewInput {
    func setup(with objects: [ListObject])
    func reloadData()
    func deleteRow(at indexPath: IndexPath)
}

protocol ListViewOutput: AnyObject {
    func listView(_ listView: ListView, shouldShowActionsAt indexPath: IndexPath) -> Bool
    func listView(_ listView: ListView, selectActionFor object: ListObject, at indexPath: IndexPath)
    func listView(_ listView: ListView, editActionFor object: ListObject, at indexPath: IndexPath)
    func listView(_ listView: ListView, deleteActionFor object: ListObject, at indexPath: IndexPath)
}

private enum Constants {
    static let editActionTitle = "Edit"
    static let editImage = UIImage(systemName: "pencil")
    static let deleteActionTitle = "Delete"
    static let deleteImage = UIImage(systemName: "trash")
}

class ListView: UIView {
    
    weak var output: ListViewOutput?
    
    private let tableView = UITableView()
    private let type: DataType
    private var objects = [ListObject]()
    
    init(type: DataType) {
        self.type = type
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
    
    private func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        attachToSuperview()
        tableView.attachToSuperview()
    }
}

extension ListView: ListViewInput {
    func setup(with objects: [ListObject]) {
        self.objects = objects
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func deleteRow(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - UITableViewDataSource

extension ListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier, for: indexPath)
        guard let listCell = cell as? ListCell else { return .init() }
        listCell.setup(with: objects[indexPath.row])
        return listCell
    }
}

// MARK: - UITableViewDelegate

extension ListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        output?.listView(self, selectActionFor: objects[indexPath.row], at: indexPath)
    }

    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard
            let shouldShowAction = output?.listView(self, shouldShowActionsAt: indexPath),
            shouldShowAction
        else { return nil }
        let editAction = UIContextualAction(
            style: .normal,
            title: Constants.editActionTitle
        ) { _, _, completion in
            self.output?.listView(
                self,
                editActionFor: self.objects[indexPath.row],
                at: indexPath
            )
            completion(true)
        }
        editAction.backgroundColor = .systemOrange
        editAction.image = Constants.editImage
        return UISwipeActionsConfiguration(actions: [editAction])
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard
            let shouldShowAction = output?.listView(self, shouldShowActionsAt: indexPath),
            shouldShowAction
        else { return nil }
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: Constants.deleteActionTitle
        ) { _, _, completion in
            self.output?.listView(
                self,
                deleteActionFor: self.objects[indexPath.row],
                at: indexPath
            )
            completion(true)
        }
        deleteAction.image = Constants.deleteImage
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
