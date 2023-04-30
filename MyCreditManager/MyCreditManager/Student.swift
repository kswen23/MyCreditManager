//
//  Student.swift
//  MyCreditManager
//
//  Created by 김성원 on 2023/04/30.
//

typealias Subject = (String, Grade)

struct Student {
    
    let name: String
    var subjects: [Subject]
}

enum Grade: Double {
    
    case Aplus = 4.5
    case A = 4
    case Bplus = 3.5
    case B = 3
    case Cplus = 2.5
    case C = 2
    case Dplus = 1.5
    case D = 1
    case F = 0
    
    static func convertStringToGrade(input: String) -> Self? {
        switch input {
        case "A+" : return Aplus
        case "A": return A
        case "B+": return Bplus
        case "B": return B
        case "C+": return Cplus
        case "C": return C
        case "D+": return Dplus
        case "D": return D
        case "F": return F
            
        default:
            print("잘못된 성적을 입력하셨습니다.")
            return nil
        }
    }
    
    static func convertGradeToString(input: Self) -> String {
        switch input {
            
        case .Aplus: return "A+"
        case .A: return "A"
        case .Bplus: return "B+"
        case .B: return "B"
        case .Cplus: return "C+"
        case .C: return "C"
        case .Dplus: return "D+"
        case .D: return "D"
        case .F: return "F"
        }
    }
}
