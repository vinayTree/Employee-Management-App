//
//  EmployeesListVC.swift
//  Collabera Team
//
//  Created by vinay kumar bg on 30/10/22.
//

import UIKit
import RxSwift

class EmployeesListVC: UIViewController {
    
    @IBOutlet weak var employeeListTableView: UITableView!
    
    weak var coordinator: EmployeesCoordinator?
    
    static func instantiate() -> EmployeesListVC {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateInitialViewController() as! EmployeesListVC
        return viewController
    }
    
    let disposeBag = DisposeBag()
    var employeeVM = EmployeeViewModel()
    var employeeList = [Employee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
}

extension EmployeesListVC {
    
    fileprivate func initialSetup() {
        
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = NSLocalizedString("Collabera Emlpoyees", comment: "")
        
        self.observeViewModelChanges()
        
        self.title = "Employee List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEmployee))
        
        self.employeeListTableView.register(UINib(nibName: "EmployeeTableCell", bundle: nil), forCellReuseIdentifier: "EmployeeTableCell")
        self.employeeListTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.employeeListTableView.tableFooterView = UIView()
        self.employeeListTableView.dataSource = self
        self.employeeListTableView.delegate = self
        
        self.employeeVM.getEmployees()
    }
    
    fileprivate func observeViewModelChanges() {
        
        self.employeeVM.employees
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (employees) in
                
                print("on next")
                
                self.employeeList.append(contentsOf: employees)
                self.employeeListTableView.reloadData()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        RxBus.shared.empAdded
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (employee) in
                self.employeeVM.addEmployee(employee: employee)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        RxBus.shared.empUpdateClicked
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (employeeToUpdate) in
                self.employeeVM.updateEmployee(employee: employeeToUpdate)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        RxBus.shared.empUpdated
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (updatedEmployee) in
                self.employeeList = self.employeeList.map({ (employee) -> Employee in
                    if updatedEmployee.emailId == employee.emailId {
                        return updatedEmployee
                    } else {
                        return employee
                    }
                })
                self.employeeListTableView.reloadData()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        RxBus.shared.empResignClicked
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (employeeToUpdate) in
                self.employeeVM.resignEmployee(employee: employeeToUpdate)

            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        RxBus.shared.empResignCompleted
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (employeeResigned) in
                
                self.employeeList = self.employeeList.map({ (employee) -> Employee in
                    if employeeResigned.emailId == employee.emailId {
                        return employeeResigned
                    } else {
                        return employee
                    }
                })
                self.employeeListTableView.reloadData()

            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        RxBus.shared.empDeletedIndex.subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (index) in
                self.employeeList.remove(at: index)
                self.employeeListTableView.reloadData()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
    }
    
    @objc fileprivate func addEmployee(_ sender: UIBarButtonItem) {
        
//        coordinator?.parentCoordinator?.navigateToEmployeesDetailsViewController(viewModel: employeeList.first ?? Employee())

        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEmployeeVC") as! AddEmployeeVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
}

extension EmployeesListVC {
    
    fileprivate func employeeTableCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableCell", for: indexPath) as? EmployeeTableCell else {
            fatalError("EmployeeTableCell not found!")
        }
        
        cell.nameLabel.text = self.employeeList[indexPath.row].name
        cell.emailLabel.text = self.employeeList[indexPath.row].emailId
        
        if self.employeeList[indexPath.row].isResigned {
            cell.backgroundColor = .lightGray
        }
        else{
            cell.backgroundColor = .white
        }
        return cell
    }
}

extension EmployeesListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.employeeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.employeeTableCell(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEmployeeVC") as! AddEmployeeVC
        obj.currentEmployee = self.employeeList[indexPath.row]
        obj.isEditing = true
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if self.employeeList[indexPath.row].isResigned {
            let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
                            
                self.employeeVM.deleteEmployeeOf(index: indexPath.row)
//                let currentEmployee = self.employeeList[indexPath.row]
//
//                self.employeeVM.resignEmployee(employee: currentEmployee)
            }
            deleteAction.backgroundColor = UIColor.red
            return [deleteAction]

        }
        else{
            
            let deleteAction = UITableViewRowAction(style: .default, title: "Resigned") { (action, indexPath) in
    //            self.employeeVM.deleteEmployeeOf(index: indexPath.row)
                let currentEmployee = self.employeeList[indexPath.row]

//                self.employeeVM.resignEmployee(employee: currentEmployee)
                            
                var employeeModel = Employee()
                employeeModel.name = currentEmployee.name
                employeeModel.emailId = currentEmployee.emailId
                employeeModel.city = currentEmployee.city
                employeeModel.isMarried = currentEmployee.isMarried
                employeeModel.anniversary = currentEmployee.anniversary
                employeeModel.isResigned = true
                
                RxBus.shared.empResignClicked.onNext(employeeModel)

            }
            deleteAction.backgroundColor = UIColor.red
            return [deleteAction]

        }
       
        
    }
}
