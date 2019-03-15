//
// LocalDataModel.swift
// DBChallange
//
// Created by Sylvia-Kathrin Tanneberger on 2019-03-13.
// Copyright (c) 2019 ttx.WebService();. All rights reserved.
//

import Foundation

protocol LocalDataModelProtocol: class {
	var currentUserID: Int? { get set }
	var posts: ObservableValue<[Post]> { get set }
}

// MARK: - JSON response structs
struct Post: Codable {
	enum PostKeys: String, CodingKey {
		case userID = "userId"
		case id
		case title
		case body
	}

	let userID: Int
	let id: Int
	let title: String
	let body: String
}

extension Post {
	init(from decoder: Decoder) throws {
		let postContainer = try decoder.container(keyedBy: Post.PostKeys.self)
		let userID = try postContainer.decode(Int.self, forKey: .userID)
		let id = try postContainer.decode(Int.self, forKey: .id)
		let title = try postContainer.decode(String.self, forKey: .title)
		let body = try postContainer.decode(String.self, forKey: .body)

		self.init(userID: userID, id: id, title: title, body: body)
	}
}

struct Comment: Codable {
	enum CommentKeys: String, CodingKey {
		case postID = "postId"
		case id
		case name
		case email
		case body
	}

	let postId: Int
	let id: Int
	let name: String
	let email: String
	let body: String
}

class LocalDataModel: LocalDataModelProtocol {
	var currentUserID: Int? = nil
	var posts: ObservableValue<[Post]> = ObservableValue([])
}
