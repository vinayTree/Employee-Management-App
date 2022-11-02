//
//  Authentication.swift
//  Collabera Team
//
//  Created by vinay kumar bg on 30/10/22.
//

import RxSwift

protocol Authentication {
    func signIn() -> Single<SignInResponse>
}
