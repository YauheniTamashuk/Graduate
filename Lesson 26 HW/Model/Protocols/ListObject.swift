import Foundation

protocol ListObject {
    var id: UUID { get }
    var text: String { get }
    var secondaryText: String { get }
}
