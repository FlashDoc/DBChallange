//
//  LoginViewController.swift
//  DBChallange
//
//  Created by Sylvia-Kathrin Tanneberger on 13.03.19.
//  Copyright © 2019 ttx.WebService();. All rights reserved.
//

import UIKit

let segueShowPosts: String = "showPosts"

class LoginViewController: UIViewController {
	@IBOutlet var fieldUserID: UITextField!

	private lazy var appDelegate: AppDelegate = {
		return UIApplication.shared.delegate as! AppDelegate
	}()

	private lazy var loginViewModel: LoginViewModelProtocol? = {
		let theViewModel: LoginViewModelProtocol? = LoginViewModel()

		theViewModel?.networkEngine = NetworkEngine()
		theViewModel?.localDataModel = self.appDelegate.localDataModel
		theViewModel?.onErrorHandling = { [weak self] error in
			var faultDescription: String = ""

			switch error! {

				case .network(let code, let description), .data(let code, let description), .json(let code, let description):
					faultDescription = description
					break
			}

			if !faultDescription.isEmpty {
				self?.appDelegate.showFaultAlert(with: faultDescription)
			}
		}
		return theViewModel
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		loginViewModel?.userIsValid?.addAndNotify(observer: self, notificationHandler: { [weak self] _ in
			if self?.loginViewModel?.userIsValid?.value ?? false {
				let postsController = self!.storyboard?.instantiateViewController(withIdentifier: "PostsViewController") as! PostsViewController
				self?.navigationController?.pushViewController(postsController, animated: true)
			}
		})
	}

	@IBAction func actionLogin(_ sender: Any) {
		guard let userIDString = fieldUserID.text else {
			return
		}

		if !userIDString.isEmpty {
			let userID: Int = Int(userIDString)!
			loginViewModel?.validateUserID(userID)
		}
	}
}

