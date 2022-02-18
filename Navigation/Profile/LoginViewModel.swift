//
//  LoginViewModel.swift
//  Navigation
//
//  Created by GiN Eugene on 16/2/2022.
//

import Foundation
import UIKit
import FirebaseAuth

protocol LoginViewOutput {
    func signInUser(userLogin: String, userPassword: String)
}

final class LoginViewModel: LoginViewOutput {
    
    let loginVC: UIViewController = LogInViewController()
    
    func signInUser(userLogin: String, userPassword: String) {
        
        let authGroup = DispatchGroup()

        var vc: ProfileViewController
    #if DEBUG
        vc = ProfileViewController(userService: TestUserService(), userName: "testUser")
    #else
        var status: Bool?
        var errorCode: Int?
        authGroup.enter()
        Auth.auth().signIn(withEmail: userLogin, password: userPassword) { authResult, error in

            if let result = authResult {
                print("Result: \(result)")
                print("Sign in result: \(String(describing: result.user.email))")
                status = true
            } else if let error = error as NSError? {
                print("Error: \(error)")
                errorCode = error.code
                if errorCode != 17011 {
                    status = false
                } else {

                    Auth.auth().createUser(withEmail: userLogin, password: userPassword) { authResult, error in
                        if let result = authResult {
                            print("Result: \(result)")
                            print("Sign in result: \(String(describing: result.user.email))")
                            status = true
                        } else if let error = error as NSError? {
                            print("Error: \(error.code)")
                            errorCode = error.code
                            status = false
                        }
                        if let status = status {
                            print("Status: \(String(describing: status))")
                            guard status else {
                                print("Try again")
                                return
                            }
                        }
                    }
                }
            }
            if let status = status {
                print("Status: \(String(describing: status))")
                guard status else {
                    print("Try again")
                    return
                }
            }
            authGroup.leave()
        }

        vc = ProfileViewController(userService: CurrentUserService(), userName: userLogin )
    #endif
        authGroup.notify(queue: DispatchQueue.main) { [self] in
            self.loginVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

