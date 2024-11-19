//
//import SwiftUI
//
//
//struct Employee: Identifiable {
//    let id = UUID()
//    let name: String
//    let role: String
//   let bubble: StateProgress.Bubbles
//}
//
//struct EmployeeView: View {
//    let employees = [
//      Employee(name: "Jake", role: "Software Engineer", bubble: .done),
//        Employee(name: "Jared", role: "Product Manager", bubble: .done),
//        Employee(name: "Michael", role: "UX Designer", bubble: .done)
//    ]
//    
//    var body: some View {
//        ForEach(employees) { employee in
//            HStack() {
//                Text(employee.name)
//                    .font(.headline)
//                Text(employee.role)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//        }
//    }
//}
