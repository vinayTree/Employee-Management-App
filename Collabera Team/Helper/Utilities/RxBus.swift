//
//  RxBus.swift
//  Collabera Team
//
//  Created by vinay kumar bg on 30/10/22.
//

import Foundation
import RxSwift

class RxBus: NSObject {
    
    static let shared = RxBus()
    
    private override init() { }

    var empAdded = PublishSubject<Employee>()
    var empUpdateClicked = PublishSubject<Employee>()
    var empResignClicked = PublishSubject<Employee>()
    var empResignCompleted = PublishSubject<Employee>()
    var empUpdated = PublishSubject<Employee>()
    var empDeletedIndex = PublishSubject<Int>()
    var selectedCity = PublishSubject<String>()
}
