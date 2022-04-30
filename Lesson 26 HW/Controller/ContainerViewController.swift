import UIKit

private struct Constants {
    static let usersTitle = "Users"
    static let coursesTitle = "Courses"
    static let teachersTitle = "Teachers"

    static let usersImage = UIImage(systemName: "person.3")
    static let coursesImage = UIImage(systemName: "books.vertical")
    static let teachersImage = UIImage(systemName: "person.2")
}

class ContainerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        view.backgroundColor = .white
        viewControllers = [
            generateNavigationController(
                rootViewController: ListController(type: .users),
                title: Constants.usersTitle,
                image: Constants.usersImage
            ),
            generateNavigationController(
                rootViewController: ListController(type: .courses),
                title: Constants.coursesTitle,
                image: Constants.coursesImage
            ),
            generateNavigationController(
                rootViewController: ListController(type: .teachers),
                title: Constants.teachersTitle,
                image: Constants.teachersImage
            )
        ]
    }

    private func generateNavigationController(
        rootViewController: UIViewController,
        title: String,
        image: UIImage?
    ) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        rootViewController.title = title
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        return navigationController
    }

}
