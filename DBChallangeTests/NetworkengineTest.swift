//
//  NetworkengineTest.swift
//  DBChallangeTests
//
//  Created by Sylvia-Kathrin Tanneberger on 13.03.19.
//  Copyright © 2019 ttx.WebService();. All rights reserved.
//

import XCTest
import Foundation

class NetworkengineTest: XCTestCase {
	var networkEngine: NetworkEngineProtocol!

	override func setUp() {
		networkEngine = NetworkEngine()
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testInstanceNetworkEngine() {
		XCTAssertNotNil(networkEngine)
	}

	func testValidateUserIDWithValidUserID() {
		let expactationResponse = self.expectation(description: "UserID")
		var responseIsValid: Bool?
		var responseFault: ErrorResult?

		networkEngine.validateUserID(1, responseHandler: { handler in
			switch handler {
				case .success(let isValid):
					responseIsValid = isValid
					expactationResponse.fulfill()
					break
				case .fault(let errorHandle):
					responseFault = errorHandle
					expactationResponse.fulfill()
					break
			}
		})

		wait(for: [expactationResponse], timeout: 1)
		XCTAssertTrue(responseIsValid ?? false)
		if responseFault != nil {
			switch responseFault! {
				case .network(let code, let description), .data(let code, let description), .json(let code, let description):
					print("faultCode: \(code) description: \(description)")
			}
		}
	}

	func testValidateUserIDWithInvalidUserID() {
		let expactationResponse = self.expectation(description: "UserID")
		var responseIsValid: Bool?
		var responseFault: ErrorResult?

		networkEngine.validateUserID(99, responseHandler: { handler in
			switch handler {
				case .success(let isValid):
					responseIsValid = isValid
					expactationResponse.fulfill()
					break
				case .fault(let errorHandle):
					responseFault = errorHandle
					expactationResponse.fulfill()
					break
			}
		})

		wait(for: [expactationResponse], timeout: 1)
		XCTAssertFalse(responseIsValid ?? false)
		if responseFault != nil {
			switch responseFault! {
				case .network(let code, let description), .data(let code, let description), .json(let code, let description):
					print("faultCode: \(code) description: \(description)")
			}
		}
	}

	func testRequestPostsWithValidUserID() {
		let expactationResponse = self.expectation(description: "RequestPost")
		var response: [Post]?
		var responseFault: ErrorResult?

		networkEngine.requestPosts(for: 1, responseHandler: { handler in
			switch handler {
				case .success(let postResponse):
					response = postResponse
					expactationResponse.fulfill()
					break
				case .fault(let errorHandle):
					responseFault = errorHandle
					expactationResponse.fulfill()
					break
			}
		})

		wait(for: [expactationResponse], timeout: 1)
		XCTAssertNotNil(response)
		XCTAssertTrue(response!.count > 0)
		if responseFault != nil {
			switch responseFault! {
				case .network(let code, let description), .data(let code, let description), .json(let code, let description):
					print("faultCode: \(code) description: \(description)")
			}
		}
	}

	func testReqestPostsWithInvalidUserID() {
		let expactationResponse = self.expectation(description: "RequestPost")
		var response: [Post]?
		var responseFault: ErrorResult?

		networkEngine.requestPosts(for: 99, responseHandler: { handler in
			switch handler {
				case .success(let postResponse):
					response = postResponse
					expactationResponse.fulfill()
					break
				case .fault(let errorHandle):
					responseFault = errorHandle
					expactationResponse.fulfill()
					break
			}
		})

		wait(for: [expactationResponse], timeout: 1)
		XCTAssertNotNil(response)
		XCTAssertTrue(response!.count == 0)
		if responseFault != nil {
			switch responseFault! {
				case .network(let code, let description), .data(let code, let description), .json(let code, let description):
					print("faultCode: \(code) description: \(description)")
			}
		}
	}
}
