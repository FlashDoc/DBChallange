//
// PostsViewModel.swift
// DBChallange
//
// Created by Sylvia-Kathrin Tanneberger on 2019-03-14.
// Copyright (c) 2019 ttx.WebService();. All rights reserved.
//

import Foundation
import UIKit

protocol PostsViewModelProtocol: class {
	var networkEngine: NetworkEngineProtocol? { get set }
	var localDataModel: LocalDataModelProtocol? { get set }
	var onErrorHandling: ((ErrorResult?) -> Void)? { get set }
	var getIndexPathFor: ((UITableViewCell) -> IndexPath?)? { get set }
	var dataSource: PostsViewDataSource? { get set }

	func requestPosts()
	func showAll()
	func showFavoritesOnly()
}

class PostsViewModel: PostsViewModelProtocol {
	var networkEngine: NetworkEngineProtocol? = nil
	var localDataModel: LocalDataModelProtocol? = nil
	var onErrorHandling: ((ErrorResult?) -> Void)? = nil
	var getIndexPathFor: ((UITableViewCell) -> IndexPath?)? = nil

	lazy var dataSource: PostsViewDataSource? = {
		let theDataSource = PostsViewDataSource()
		theDataSource.cellDelegate = self
		return theDataSource
	}()

	private var postsDD: [PostDD] = []

	func requestPosts() {
		networkEngine?.requestPosts(for: localDataModel?.currentUserID ?? 0, responseHandler: { handler in
			switch handler {
				case .success(let posts):
					self.postsDD = self.createPostsDD(with: posts)
					self.dataSource?.data.value = self.postsDD
					break
				case .fault(let error):
					self.onErrorHandling?(error)
					break
			}
		})
	}

	func showAll() {
		self.dataSource?.data.value = self.postsDD
	}

	func showFavoritesOnly() {
		let favoritePosts = postsDD.filter({($0 as PostDD).isFavorite! })
		self.dataSource?.data.value = favoritePosts
	}

	private func createPostsDD(with posts: [Post]) -> [PostDD] {
		var postsDD: [PostDD] = self.dataSource?.data.value ?? []

		for post in posts {
			if !postsDD.contains(where: { $0.post?.userID == post.userID && $0.post?.id == post.id	}) {
				let postDDItem = PostDD(post: post, isFavorite: false)
				postsDD.append(postDDItem)
			}
		}

		if postsDD.count > 0 {
			postsDD.sort(by: { $0.post!.id < $1.post!.id })
		}

		return postsDD
	}
}

extension PostsViewModel: PostListCellDelegate {
	func listCell(_ cell: PostListCell, updateFavoriteState stateFlag: Bool) {
		if let indexPath = getIndexPathFor?(cell) {
			let row = indexPath.row
			var postDDItem = postsDD[row]
			postDDItem.isFavorite = stateFlag
			postsDD[row] = postDDItem
			dataSource?.data.value = postsDD
		}
	}
}
