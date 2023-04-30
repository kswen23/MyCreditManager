//
//  main.swift
//  MyCreditManager
//
//  Created by 김성원 on 2023/04/30.
//

import Foundation

var input: String?
var currentState: CreditManagerFunction!
var currentStudentArray: [Student] = []

repeat {
    startCreditManager()
    
    currentState = CreditManagerFunction.convertToCreditManagerFunction(input: input)
    
    switch currentState {
    case .addStudent:
        addStudent()
    case .deleteStudent:
        deleteStudent()
    case .addGrade:
        addGrade()
    case .deleteGrade:
        deleteGrade()
    case .showAverage:
        showAverage()
    case .end:
        endCreditManager()
    case .other:
        wrongInput()
    case .none:
        break
    }
    
} while currentState != .end

func startCreditManager() {
    print("원하는 기능을 입력해주세요")
    print("1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료")
    input = readLine()
}

func addStudent() {
    print("추가할 학생의 이름을 입력해주세요")
    guard let name = readLine() else { return }
    if studentNameIsValid(name: name) {
        appendStudent(name: name)
    } else {
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
    }
    
}

func appendStudent(name: String) {
    if studentNameIsDuplicated(name: name) {
        print("\(name)은 이미 존재하는 학생입니다. 추가하지 않습니다.")
    } else {
        currentStudentArray.append(Student(name: name, subjects: []))
        print("\(name) 학생을 추가했습니다.")
    }
}

func studentNameIsDuplicated(name: String) -> Bool {
    let nameArray = currentStudentArray.map { $0.name }
    if nameArray.contains(name) {
        return true
    } else {
        return false
    }
}

func studentNameIsValid(name: String) -> Bool {
    let stringArr = name.map { String($0) }
    let checkingResult = stringArr
        .map { Character($0).isLetter }
    guard checkingResult.isEmpty == false else { return false }
    
    if checkingResult.contains(false) {
        return false
    } else {
        return true
    }
}

func deleteStudent() {
    print("삭제할 학생의 이름을 입력해주세요")
    guard let name = readLine() else { return }
    if studentNameIsValid(name: name) {
        removeStudent(name: name)
    } else {
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
    }
}

func removeStudent(name: String) {
    if studentNameIsDuplicated(name: name) {
        let nameArray = currentStudentArray.map { $0.name }
        if let index = nameArray.firstIndex(of: name) {
            currentStudentArray.remove(at: index)
            print("\(name) 학생을 삭제했습니다.")
        }
    } else {
        print("\(name) 학생을 찾지 못했습니다.")
    }
}

func addGrade() {
    print("성적을 추가할 학생의 이름, 과목, 성적(A+, A, F등)을 띄어쓰기로 구분하여 차례로 작성해주세요.")
    print("입력예) Mickey Swift A+")
    print("만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.")
    guard let gradeInput = readLine() else { return }
    if gradeInputIsValid(input: gradeInput) {
        let gradeInput = gradeInput.components(separatedBy: " ")
        let name = gradeInput[0]
        if studentNameIsDuplicated(name: name) {
            updateStudentGrade(input: gradeInput)
        } else {
            print("\(name) 학생을 찾지 못했습니다.")
        }
    } else {
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
    }
}

func gradeInputIsValid(input: String) -> Bool {
    let separatedInput = input.components(separatedBy: " ")
    if separatedInput.count == 3 {
        return true
    } else {
        return false
    }
}

func updateStudentGrade(input: [String]) {
    let name = input[0]
    let subject = input[1]
    if let index = currentStudentArray.map({ $0.name }).firstIndex(of: name),
       let grade = Grade.convertStringToGrade(input: input[2]) {
        let subjects = currentStudentArray[index].subjects.map { $0.0 }
        if subjects.contains(subject) {
            let subjectIndex = subjects.firstIndex(of: subject)!
            currentStudentArray[index].subjects[subjectIndex] = (input[1], grade)
            print("\(name) 학생의 \(subject) 과목이 \(input[2])로 추가(변경)되었습니다.")
        } else {
            currentStudentArray[index].subjects.append((input[1], grade))
            print("\(name) 학생의 \(subject) 과목이 \(input[2])로 추가(변경)되었습니다.")
        }
    }
}

func deleteGrade() {
    print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.")
    print("입력예) Mickey Swift")
    guard let deleteInput = readLine() else { return }
    if deleteInputIsValid(input: deleteInput) {
        removeStudentSubject(input: deleteInput)
    } else {
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
    }
}

func removeStudentSubject(input: String) {
    let separatedInput = input.components(separatedBy: " ")
    let name = separatedInput[0]
    let subject = separatedInput[1]
    let nameArr = currentStudentArray.map{ $0.name }
    if let nameIndex = nameArr.firstIndex(of: name) {
        if let subjectIndex = currentStudentArray[nameIndex].subjects.map({ $0.0 }).firstIndex(of: subject) {
            currentStudentArray[nameIndex].subjects.remove(at: subjectIndex)
            print("\(name) 학생의 \(subject) 과목의 성적이 삭제되었습니다.")
        } else {
            print("\(name) 학생의 \(subject) 과목이 존재하지 않습니다.")
        }
    } else {
        print("\(name) 학생을 찾지 못했습니다.")
    }
    
}

func deleteInputIsValid(input: String) -> Bool {
    let separatedInput = input.components(separatedBy: " ")
    if separatedInput.count == 2 {
        return true
    } else {
        return false
    }
}

func showAverage() {
    print("평점을 알고싶은 학생의 이름을 입력해주세요")
    guard let studentName = readLine() else { return }
    guard !studentName.isEmpty else {
        return print("입력이 잘못되었습니다. 다시 확인해주세요.")
    }
    if let studentIndex = currentStudentArray.map({ $0.name }).firstIndex(of: studentName) {
        let student = currentStudentArray[studentIndex]
        student.subjects.forEach { subject, grade in
            print("\(subject): \(Grade.convertGradeToString(input: grade))")
        }
        print("평점: \(calculateAverage(subjects: student.subjects))")
    } else {
        print("\(studentName) 학생을 찾지 못했습니다.")
    }
}

func calculateAverage(subjects: [Subject]) -> String {
    let average = subjects
        .map{ $0.1.rawValue }
        .reduce(0, { $0 + $1 }) / Double(subjects.count)
    return String(format: "%.2f", average).trimmingCharacters(in: ["0", "."])
}

func endCreditManager() {
    print("프로그램을 종료합니다...")
}

func wrongInput() {
    print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
}


enum CreditManagerFunction {
    
    case addStudent
    case deleteStudent
    case addGrade
    case deleteGrade
    case showAverage
    case end
    case other
    
    static func convertToCreditManagerFunction(input: String?) -> Self {
        guard let input = input else { return .other }
        
        switch input {
        case "1": return .addStudent
        case "2": return .deleteStudent
        case "3": return .addGrade
        case "4": return .deleteGrade
        case "5": return .showAverage
        case "X": return .end
        default: return .other
        }
    }
    
}
