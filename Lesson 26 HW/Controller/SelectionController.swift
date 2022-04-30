import UIKit

class SelectionController: UIViewController {

    //- MARK: - PrivateProperties
    
    private let model: Model
    private let selectionView: SelectionView
    
    //- MARK: - PublicProperties
    
    var selectedObjects = [ListObject]()
    var allowsMultipleSelection = false
    var completionHandler: (([ListObject]) -> Void)?

    //- MARK: - Init
    
    init(type: DataType) {
        model = Model(type: type)
        selectionView = SelectionView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - PrivateMethods

private extension SelectionController {
    func configure() {
        view.addSubview(selectionView)
        selectionView.output = self
        selectionView.setup(
            with: model.data,
            selectedObjects: selectedObjects,
            allowsMultipleSelection: allowsMultipleSelection
        )
        configureNavigationBar()
    }

    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = .init(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonPressed)
        )
    }
    
    @objc func doneButtonPressed(_ button: UIBarButtonItem) {
        completionHandler?(selectedObjects)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - SelectionViewOutput

extension SelectionController: SelectionViewOutput {
    func selectionView(_ selectionView: SelectionView, selectionChangedWith objects: [ListObject]) {
        selectedObjects = objects
    }
}
