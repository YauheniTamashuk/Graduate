import UIKit

class ProfileController: UIViewController {

    private var object: ListObject
    private let profileView: ProfileView
    private let sectionManager: SectionManager
    private let type: DataType
    private let isEditable: Bool

    var completionHandler: ((ListObject) -> Void)?

    init(type: DataType, object: ListObject? = nil, isEditable: Bool = true) {

        if let object = object {
            self.object = object
        } else {
            switch type {
            case .users, .teachers:
                self.object = User()
            case .courses:
                self.object = Course()
            }
        }

        profileView = ProfileView(type: type)
        sectionManager = SectionManager(type: type, object: self.object)
        self.type = type
        self.isEditable = isEditable
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    @objc private func saveButtonPressed(_ button: UIBarButtonItem) {
        completionHandler?(object)
        navigationController?.popViewController(animated: true)
    }


// MARK: - PrivateMethods

    private func configure() {
        view.addSubview(profileView)
        profileView.output = self
        profileView.setup(with: sectionManager.sections)
        profileView.reloadData()
        guard isEditable else { return }
        configureNavigationBar()
    }

    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = .init(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveButtonPressed)
        )
    }

    private func showSelectionController(
        type: DataType,
        selectedObjects: [ListObject],
        allowsMultipleSelection: Bool = false,
        completionHandler: @escaping ([ListObject]) -> Void
    ) {
        let selectionController = SelectionController(type: .users)
        selectionController.selectedObjects = selectedObjects
        selectionController.allowsMultipleSelection = allowsMultipleSelection
        selectionController.completionHandler = {
            completionHandler($0)
        }
        navigationController?.pushViewController(selectionController, animated: true)
    }

    private func updateSections() {
        sectionManager.updateSections(with: object)
        profileView.setup(with: sectionManager.sections)
    }

    private func setupUser(with text: String, cellType: TextFieldType) {
        guard let user = object as? User else { return }
        switch cellType {
        case .name:
            user.name = text
        case .surname:
            user.surname = text
        case .email:
            user.email = text
        case .subject, .department:
            break
        }
    }

    private func setupCourse(with text: String, cellType: TextFieldType) {
        guard let course = object as? Course else { return }
        switch cellType {
        case .name:
            course.name = text
        case .subject:
            course.subject = text
        case .department:
            course.department = text
        case .surname, .email:
            break
        }
    }
}

// MARK: - ProfileViewOutput

extension ProfileController: ProfileViewOutput {
    func profileView(_ profileView: ProfileView, shouldShowDeleteActionFor row: Row) -> Bool {
        guard type == .courses else { return false }
        switch row {
        case .textFieldCell, .selectionCell:
            return false
        case .listCell:
            return true
        }
    }

    func profileView(_ profileView: ProfileView, deleteActionFor object: ListObject, at indexPath: IndexPath) {
        guard let course = self.object as? Course else { return }
        course.subscribers = course.subscribers.filter { $0.id != object.id }
        updateSections()
        profileView.deleteRow(at: indexPath)
    }

    func profileView(_ profileView: ProfileView, didSelectListCellWith object: ListObject) {
        guard type == .courses else { return }
        let profileController = ProfileController(type: .users, object: object, isEditable: false)
        navigationController?.pushViewController(profileController, animated: true)
    }

    func profileView(_ profileView: ProfileView, didSelectSelectionCell cellType: SelectionCellType) {
        guard
            type == .courses,
            let course = object as? Course
        else { return }
        switch cellType {
        case .singleSelection:
            showSelectionController(type: .users, selectedObjects: [course.teacher ?? User()]) {
                guard let teacher = $0.first as? User else { return }
                course.teacher = teacher
                self.object = course
                self.updateSections()
                self.profileView.reloadData()
            }
        case .multipleSelection:
            showSelectionController(type: .users, selectedObjects: course.subscribers, allowsMultipleSelection: true) {
                guard let subscribers = $0 as? [User] else { return }
                course.subscribers = subscribers
                self.object = course
                self.updateSections()
                self.profileView.reloadData()
            }
        }
    }

    func profileView(_ profileView: ProfileView, didChangeField text: String, cellType: TextFieldType) {
        switch self.type {
        case .users, .teachers:
            setupUser(with: text, cellType: cellType)
        case .courses:
            setupCourse(with: text, cellType: cellType)
        }
    }
}
