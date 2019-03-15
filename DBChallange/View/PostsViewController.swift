//
//  PostsViewController.swift
//  DBChallange
//
//  Created by Sylvia-Kathrin Tanneberger on 13.03.19.
//  Copyright © 2019 ttx.WebService();. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {
	@IBOutlet var postsList: UITableView!
	@IBOutlet var favoriteBarButton: UIBarButtonItem!

	private lazy var appDelegate: AppDelegate = {
		return UIApplication.shared.delegate as! AppDelegate
	}()

	private lazy var postsViewModel: PostsViewModelProtocol? = {
		let viewModel: (PostsViewModelProtocol & PostListCellDelegate)? = PostsViewModel()
		viewModel?.networkEngine = NetworkEngine()
		viewModel?.localDataModel = self.appDelegate.localDataModel
		viewModel?.onErrorHandling = { [weak self] error in
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
		return viewModel
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.hidesBackButton = true
		postsList.rowHeight = UITableView.automaticDimension
		postsList.estimatedRowHeight = PostListCell.cellHeight

		postsViewModel?.dataSource?.data.addAndNotify(observer: self, notificationHandler: { [weak self] _ in
			self?.postsList.reloadData()
		})

		self.postsViewModel?.getIndexPathFor = { (cell) -> IndexPath? in
			return self.postsList.indexPath(for: cell) ?? nil
		}

		postsList.dataSource = postsViewModel?.dataSource
		postsList.delegate = self
	}

	override func viewWillAppear(_ animated: Bool) {
		postsViewModel?.requestPosts()
		super.viewWillAppear(animated)
	}

	@IBAction func actionShowAll(_ sender: Any) {
		postsViewModel?.showAll()
	}
	
	@IBAction func actionShowFavoriteOnly(_ sender: Any) {
		postsViewModel?.showFavoritesOnly()
	}
}

extension PostsViewController: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
	}
}
