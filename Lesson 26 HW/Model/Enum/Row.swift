import Foundation

enum Row {
    case textFieldCell(text: String?, placeholder: String?, type: TextFieldType)
    case selectionCell(text: String?, type: SelectionCellType)
    case listCell(listObject: ListObject)
}
