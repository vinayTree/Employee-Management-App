//
//  SignInViewController.swift
//  Collabera Team
//
//  Created by vinay kumar bg on 30/10/22.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    weak var coordinator: SignInCoordinator?
    
    static func instantiate() -> SignInViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateInitialViewController() as! SignInViewController
        return viewController
    }
    
    private let disposeBag = DisposeBag()
    var viewModel: SignInViewModel?
    
    override func viewDidLoad() {
        
        signInButton.layer.cornerRadius = 5
        signInButton.layer.masksToBounds = true
        
        self.setUpBindings()
        super.viewDidLoad()
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if self.emailTextField.text == "" {
            self.showAlertWithOkBtn(msg: "Please enter Company ID!")
        } else if self.passwordTextField.text == "" {
            self.showAlertWithOkBtn(msg: "Please enter Password!")
        }else {
            let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmployeesListVC") as! EmployeesListVC
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
    func showAlertWithOkBtn(title : String = "", msg : String, okBtnTitle: String = "Ok", _ completion : (()->())? = nil){
        
        let alertViewController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: okBtnTitle, style: UIAlertAction.Style.default) { (action : UIAlertAction) -> Void in
            
            alertViewController.dismiss(animated: true, completion: nil)
            completion?()
        }
        
        alertViewController.addAction(okAction)
        alertViewController.preferredAction = okAction
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func setUpBindings() {
        guard let viewModel = viewModel else { return }
        
        self.emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailAddress)
            .disposed(by: self.disposeBag)
        
        self.passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: self.disposeBag)
        
    }
}
