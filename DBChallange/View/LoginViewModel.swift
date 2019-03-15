//
// LoginViewModel.swift
// DBChallange
//
// Created by Sylvia-Kathrin Tanneberger on 2019-03-13.
// Copyright (c) 2019 ttx.WebService();. All rights reserved.
//

import Foundation

protocol LoginViewModelProtocol: class {
	var networkEngine: NetworkEngineProtocol? { get set }
	var localDataModel: LocalDataModelProtocol? { get set }
	var onErrorHandling: ((ErrorResult?) -> Void)? { get set }
	var userIsValid: ObservableValue<Bool>? { get set }

	func validateUserID(_ userID: Int)
}

class LoginViewModel: LoginViewModelProtocol {
	var networkEngine: NetworkEngineProtocol? = nil
	var localDataModel: LocalDataModelProtocol? = nil
	var onErrorHandling: ((ErrorResult?) -> Void)? = nil
	var userIsValid: ObservableValue<Bool>? = ObservableValue<Bool>(false)

	func validateUserID(_ userID: Int) {
		networkEngine?.validateUserID(userID, responseHandler: { handler in
			switch handler {
				case .success(let isValid):
					if isValid {
						self.localDataModel?.currentUserID = userID
					}
					self.userIsValid?.value = isValid
					break
				case .fault(let faultResponse):
					self.onErrorHandling?(faultResponse)
					break
			}
		})
	}
}
