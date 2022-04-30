import UIKit

class ListController: UIViewController {

    private let model: Model
    private let listView: ListView
    private let type: DataType

    init(type: DataType) {
        model = Model(type: type)
        listView = ListView(type: type)
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }

   

// MARK: - PrivateMethods

    private func configure() {
        view.addSubview(listView)
        listView.output = self
        listView.setup(with: model.data)
        guard type != .teachers else { return }
        configureNavigationBar()
    }
    
    private func update() {
        model.update()
        listView.setup(with: model.data)
        listView.reloadData()
    }

    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = .init(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
    }
    
    @objc private func addButtonPressed(_ button: UIBarButtonItem) {
        let profileController = ProfileController(type: type)
        profileController.completionHandler = { [weak self] in
            guard let self = self else { return }
            self.model.addObject($0)
        }
        navigationController?.pushViewController(profileController, animated: true)
    }
}

// MARK: - ListViewOutput

extension ListController: ListViewOutput {
    func listView(_ listView: ListView, shouldShowActionsAt indexPath: IndexPath) -> Bool {
        type != .teachers
    }

    func listView(_ listView: ListView, selectActionFor object: ListObject, at indexPath: IndexPath) {
        guard type == .teachers else { return }
        let profileController = ProfileController(type: type, object: object, isEditable: false)
        navigationController?.pushViewController(profileController, animated: true)
    }

    func listView(_ listView: ListView, editActionFor object: ListObject, at indexPath: IndexPath) {
        let profileController = ProfileController(type: type, object: object)
        profileController.completionHandler = { [weak self] in
            guard let self = self else { return }
            self.model.updateObject($0)
        }
        navigationController?.pushViewController(profileController, animated: true)
    }

    func listView(_ listView: ListView, deleteActionFor object: ListObject, at indexPath: IndexPath) {
        model.deleteObject(object)
        listView.setup(with: model.data)
        listView.deleteRow(at: indexPath)
    }
}
