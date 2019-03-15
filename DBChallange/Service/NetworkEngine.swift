//
// NetworkEngine.swift
// DBChallange
//
// Created by Sylvia-Kathrin Tanneberger on 2019-03-13.
// Copyright (c) 2019 ttx.WebService();. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Error handling
let networkEngineDomain: String = "NetworkEngineDomain"
let invalidResponse: Int = 100
let invalidJSON: Int = 101

// MARK: - URL and service definitions
let endPointURL: String = "https://jsonplaceholder.typicode.com"
let servicePostList: String = "/posts?userId=%d"
let servicePostDetail: String = "/comments?postId=%d"
let serviceValidateUserID: String = "/users?id=%d"

protocol NetworkEngineProtocol: class {
	func validateUserID(_ userID: Int, responseHandler: @escaping (ResponseHandler<Bool, ErrorResult>) -> Void)
	func requestPosts(for userID: Int, responseHandler: @escaping (ResponseHandler<[Post], ErrorResult>) -> Void)
	func requestComments(for postID: Int, responseHandler: @escaping (ResponseHandler<[Comment], ErrorResult>) -> Void)
}

class NetworkEngine: NetworkEngineProtocol {
	func validateUserID(_ userID: Int, responseHandler: @escaping (ResponseHandler<Bool, ErrorResult>) -> Void) {
		let requestURL = URL(string: endPointURL + String(format: serviceValidateUserID, userID))
		let restSession = URLSession.shared

		let restDataTask = restSession.dataTask(with: requestURL!, completionHandler: { (data, response, error) in
			if error == nil {
				let httpResponse = response as! HTTPURLResponse
				if httpResponse.statusCode == 200 {
					guard data != nil else {
						DispatchQueue.main.async {
							responseHandler(.fault(.data(code: invalidResponse, description: "Invalid or empty response data.")))
						}
						return
					}

					DispatchQueue.main.async {
						let jsonString = String(data: data!, encoding: .utf8)
						responseHandler(.success(jsonString != nil && jsonString!.count > 2))
					}
				}
			} else {
				DispatchQueue.main.async {
					let errorCode: Int = (error! as NSError).code
					let errorDescription: String = (error! as NSError).userInfo[NSLocalizedDescriptionKey] as! String
					responseHandler(.fault(.network(code: errorCode, description: errorDescription)))
				}
			}
		})
		restDataTask.resume()
	}

	func requestPosts(for userID: Int, responseHandler: @escaping (ResponseHandler<[Post], ErrorResult>) -> Void) {
		let requestURL = URL(string: endPointURL + String(format: servicePostList, userID))
		let restSession = URLSession.shared
		let restDataTask = restSession.dataTask(with: requestURL!, completionHandler: { (data, response, error) in
			if error == nil {
				let httpResponse = response as! HTTPURLResponse
				if httpResponse.statusCode == 200 {
					guard data != nil else {
						DispatchQueue.main.async {
							responseHandler(.fault(.data(code: invalidResponse, description: "Invalid or empty response data.")))
						}
						return
					}
					do {
						let postResponse = try JSONDecoder().decode([Post].self, from: data!)
						DispatchQueue.main.async {
							responseHandler(.success(postResponse))
						}
					} catch {
						DispatchQueue.main.async {
							responseHandler(.fault(.json(code: invalidJSON, description: "Invalid JSON data.")))
						}
					}
				}
			} else {
				DispatchQueue.main.async {
					let errorCode: Int = (error! as NSError).code
					let errorDescription: String = (error! as NSError).userInfo[NSLocalizedDescriptionKey] as! String
					responseHandler(.fault(.network(code: errorCode, description: errorDescription)))
				}
			}
		})
		restDataTask.resume()
	}

	func requestComments(for postID: Int, responseHandler: @escaping (ResponseHandler<[Comment], ErrorResult>) -> Void) {
		let requestURL = URL(string: endPointURL + String(format: servicePostDetail, postID))
		let restSession = URLSession.shared
		let restDataTask = restSession.dataTask(with: requestURL!, completionHandler: { (data, response, error) in
			if error == nil {
				let httpResponse = response as! HTTPURLResponse
				if httpResponse.statusCode == 200 {
					guard data != nil else {
						DispatchQueue.main.async {
							responseHandler(.fault(.data(code: invalidResponse, description: "Invalid or empty response data.")))
						}
						return
					}
					do {
						let commentResponse = try JSONDecoder().decode([Comment].self, from: data!)
						DispatchQueue.main.async {
							responseHandler(.success(commentResponse))
						}
					} catch {
						DispatchQueue.main.async {
							responseHandler(.fault(.json(code: invalidJSON, description: "Invalid JSON data.")))
						}
					}
				}
			} else {
				DispatchQueue.main.async {
					let errorCode: Int = (error! as NSError).code
					let errorDescription: String = (error! as NSError).userInfo[NSLocalizedDescriptionKey] as! String
					responseHandler(.fault(.network(code: errorCode, description: errorDescription)))
				}
			}
		})
		restDataTask.resume()
	}
}
