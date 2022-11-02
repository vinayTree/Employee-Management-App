//
//  SignInViewModel.swift
//  Collabera Team
//
//  Created by vinay kumar bg on 30/10/22.
//

import RxSwift

class SignInViewModel {
    
    private let disposeBag = DisposeBag()
    private let authentication: Authentication
    
    let emailAddress = BehaviorSubject(value: "")
    let password = BehaviorSubject(value: "")
    let isSignInActive: Observable<Bool>
    
    // events
    let didSignIn = PublishSubject<Void>()
    let didFailSignIn = PublishSubject<Error>()
    
    init(authentication: Authentication) {
        self.authentication = authentication
        self.isSignInActive = Observable.combineLatest(self.emailAddress, self.password).map { $0.0 != "" && $0.1 != "" }
    }
    

}
