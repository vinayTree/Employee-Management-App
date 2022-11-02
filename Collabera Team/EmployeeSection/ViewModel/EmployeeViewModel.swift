//
//  EmployeeViewModel.swift
//  Collabera Team
//
//  Created by vinay kumar bg on 30/10/22.
//

import Foundation
import RxSwift
import CoreData

class EmployeeViewModel {
    
    var employees = PublishSubject<[Employee]>()
    
    func getEmployees() {
        
        let fetchRequest = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
        do {
            
            let employeesData = try managedContext.fetch(fetchRequest)
            
            let group = DispatchGroup()
            group.enter()
            
            var empArr = [Employee]()
            
            DispatchQueue.main.async {
                
                empArr = employeesData.map({ (employeeEntity) -> Employee in
                    
                    var employeeModel = Employee()
                    employeeModel.name = employeeEntity.value(forKey: "name") as? String ?? ""
                    employeeModel.emailId = employeeEntity.value(forKey: "emailId") as? String ?? ""
                    employeeModel.city = employeeEntity.value(forKey: "city") as? String ?? ""
                    employeeModel.isMarried = employeeEntity.value(forKey: "isMarried") as? Bool ?? false
                    employeeModel.anniversary = employeeEntity.value(forKey: "anniversary") as? String ?? ""
                    employeeModel.isResigned = employeeEntity.value(forKey: "isResigned") as? Bool ?? false
                    
                    return employeeModel
                })
                
                group.leave()
            }
            
            group.notify(queue: .main) {
                self.employees.onNext(empArr)
            }

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func addEmployee(employee: Employee) {
        
        let context = EmployeeEntity(context: managedContext)
        context.setValue(employee.name, forKey: "name")
        context.setValue(employee.emailId, forKey: "emailId")
        context.setValue(employee.city, forKey: "city")
        context.setValue(employee.isMarried, forKey: "isMarried")
        context.setValue(employee.anniversary, forKey: "anniversary")
        context.setValue(employee.isResigned, forKey: "isResigned")
        
        do {
            try managedContext.save()
            
            self.employees.onNext([employee])
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateEmployee(employee: Employee) {
        
        let fetchRequest = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
        do {
            let employeesData = try managedContext.fetch(fetchRequest)
            
            let requiredEmployee = employeesData.filter { (employeeEntity) -> Bool in
                return employee.emailId == (employeeEntity.value(forKey: "emailId") as? String ?? "")
            }
            if let employeeToUpdate = requiredEmployee.first {
                
                employeeToUpdate.setValue(employee.name, forKey: "name")
                employeeToUpdate.setValue(employee.emailId, forKey: "emailId")
                employeeToUpdate.setValue(employee.city, forKey: "city")
                employeeToUpdate.setValue(employee.isMarried, forKey: "isMarried")
                employeeToUpdate.setValue(employee.anniversary, forKey: "anniversary")
                employeeToUpdate.setValue(employee.isResigned, forKey: "isResigned")

            }
            do {
                try managedContext.save()
                RxBus.shared.empUpdated.onNext(employee)
            } catch  let error as NSError {
                print("Could not update. \(error), \(error.userInfo)")
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func resignEmployee(employee: Employee) {
        
        let fetchRequest = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
        do {
            let employeesData = try managedContext.fetch(fetchRequest)
            
            let requiredEmployee = employeesData.filter { (employeeEntity) -> Bool in
                return employee.emailId == (employeeEntity.value(forKey: "emailId") as? String ?? "")
            }
            if let employeeResigned = requiredEmployee.first {
                
                employeeResigned.setValue(employee.name, forKey: "name")
                employeeResigned.setValue(employee.emailId, forKey: "emailId")
                employeeResigned.setValue(employee.city, forKey: "city")
                employeeResigned.setValue(employee.isMarried, forKey: "isMarried")
                employeeResigned.setValue(employee.anniversary, forKey: "anniversary")
                employeeResigned.setValue(employee.isResigned, forKey: "isResigned")
            }
            do {
                try managedContext.save()
                RxBus.shared.empResignCompleted.onNext(employee)
            } catch  let error as NSError {
                print("Could not update. \(error), \(error.userInfo)")
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteEmployeeOf(index: Int) {
        
        let fetchRequest = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
        do {
            let employeesData = try managedContext.fetch(fetchRequest)
            
            let employeeToDelete = employeesData[index]
            managedContext.delete(employeeToDelete)
            
            do {
                try managedContext.save()
                RxBus.shared.empDeletedIndex.onNext(index)
            } catch  let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
