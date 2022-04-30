import Foundation

private enum Constants {
    static let userNamePlaceholder = "Name"
    static let userSurnamePlaceholder = "Surname"
    static let userEmailPlaceholder = "Email"
    static let courseNamePlaceholder = "Name"
    static let courseSubjectPlaceholder = "Subject"
    static let courseDepartmentPlaceholder = "Department"
    static let courseTeacherCellText = "Select a teacher"
    static let courseSubscribersCellText = "Add subscribers"
    static let infoSectionTitle = "Info:"
    static let conductSectionTitle = "Conduct courses:"
    static let studyingSectionTitle = "Studying courses:"
    static let subscribersSectionTitle = "Subscribers"
}

struct Section {
    var title: String?
    var rows: [Row]
}

class SectionManager {
    var sections = [Section]()
    
    private let type: DataType
    private var object: ListObject
    
    init(type: DataType, object: ListObject) {
        self.type = type
        self.object = object
        updateSections(with: object)
    }
    
    func updateSections(with object: ListObject) {
        sections.removeAll()
        self.object = object
        switch type {
        case .users:
            createUserSections()
        case .courses:
            createCourseSections()
        case .teachers:
            createTeacherSections()
        }
    }
    
    private func createUserSections() {
        guard let user = object as? User else { return }
        let infoRows: [Row] = [
            .textFieldCell(text: user.name, placeholder: Constants.userNamePlaceholder, type: .name),
            .textFieldCell(text: user.surname, placeholder: Constants.userSurnamePlaceholder, type: .surname),
            .textFieldCell(text: user.email, placeholder: Constants.userEmailPlaceholder, type: .email)
        ]
        let infoSection = Section(title: Constants.infoSectionTitle, rows: infoRows)
        sections.append(infoSection)
        
        if !user.conductCourses.isEmpty {
            var conductСoursesRows = [Row]()
            user.conductCourses.forEach {
                conductСoursesRows.append(.listCell(listObject: $0))
            }
            let conductCoursesSection = Section(title: Constants.conductSectionTitle, rows: conductСoursesRows)
            sections.append(conductCoursesSection)
        }
        
        if !user.studyingСourses.isEmpty {
            var studyingСoursesRows = [Row]()
            user.studyingСourses.forEach {
                studyingСoursesRows.append(.listCell(listObject: $0))
            }
            let studyingСoursesSection = Section(title: Constants.studyingSectionTitle, rows: studyingСoursesRows)
            sections.append(studyingСoursesSection)
        }
    }
    
    private func createCourseSections() {
        guard let course = object as? Course else { return }
        let infoRows: [Row] = [
            .textFieldCell(text: course.name, placeholder: Constants.courseNamePlaceholder, type: .name),
            .textFieldCell(text: course.subject, placeholder: Constants.courseSubjectPlaceholder, type: .subject),
            .textFieldCell(text: course.department, placeholder: Constants.courseDepartmentPlaceholder, type: .department),
            .selectionCell(text: course.teacher?.text ?? Constants.courseTeacherCellText, type: .singleSelection)
        ]
        let infoSection = Section(title: Constants.infoSectionTitle, rows: infoRows)
        sections.append(infoSection)
        
        var subscribersRows: [Row] = [
            .selectionCell(text: Constants.courseSubscribersCellText, type: .multipleSelection)
        ]
        course.subscribers.forEach {
            subscribersRows.append(.listCell(listObject: $0))
        }
        let subscribersSection = Section(title: Constants.subscribersSectionTitle, rows: subscribersRows)
        sections.append(subscribersSection)
    }
    
    private func createTeacherSections() {
        guard let teacher = object as? Teacher else { return }
        let infoRows: [Row] = [
            .textFieldCell(text: teacher.name, placeholder: Constants.userNamePlaceholder, type: .name),
            .textFieldCell(text: teacher.surname, placeholder: Constants.userSurnamePlaceholder, type: .surname),
            .textFieldCell(text: teacher.email, placeholder: Constants.userEmailPlaceholder, type: .email)
        ]
        let infoSection = Section(title: Constants.infoSectionTitle, rows: infoRows)
        sections.append(infoSection)
        
        if !teacher.conductCourses.isEmpty {
            var conductCoursesRows = [Row]()
            teacher.conductCourses.forEach {
                conductCoursesRows.append(.listCell(listObject: $0))
            }
            let conductCoursesSection = Section(title: Constants.conductSectionTitle, rows: conductCoursesRows)
            sections.append(conductCoursesSection)
        }
        
        if !teacher.studyingСourses.isEmpty {
            var studyingCoursesRows = [Row]()
            teacher.studyingСourses.forEach {
                studyingCoursesRows.append(.listCell(listObject: $0))
            }
            let studyingCoursesSection = Section(title: Constants.studyingSectionTitle, rows: studyingCoursesRows)
            sections.append(studyingCoursesSection)
        }
    }
}
