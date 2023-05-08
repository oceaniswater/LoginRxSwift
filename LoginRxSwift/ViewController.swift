//
//  ViewController.swift
//  LoginRxSwift
//
//  Created by Mark Golubev on 08/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    private let viewModel = LoginViewModel()
    private let bag = DisposeBag()

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.becomeFirstResponder()
        
        usernameTextField.rx.text
            .map { $0 ?? ""}
            .bind(to: viewModel.username)
            .disposed(by: bag)
        
        passwordTextField.rx.text
            .map { $0 ?? ""}
            .bind(to: viewModel.password)
            .disposed(by: bag)
        
        viewModel.isValid()
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: bag)
        
        viewModel.isValid()
            .map {$0 ? 1 : 0.6}
            .bind(to: loginButton.rx.alpha)
            .disposed(by: bag)
    }
    
    @IBAction func tappedLoginButton(_ sender: UIButton) {
        print(#function)
    }
    


}

class LoginViewModel {
    let username = PublishSubject<String>()
    let password = PublishSubject<String>()
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(username.asObservable().startWith(""), password.asObservable().startWith("")).map { username, password in
            return username.count > 3 && password.count > 3
        }.startWith(false)
    }
}

