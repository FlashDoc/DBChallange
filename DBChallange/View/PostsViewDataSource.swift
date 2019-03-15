//
// PostsViewDataSource.swift
// DBChallange
//
// Created by Sylvia-Kathrin Tanneberger on 2019-03-14.
// Copyright (c) 2019 ttx.WebService();. All rights reserved.
//

import Foundation
import UIKit

struct PostDD {
	var post: Post?
	var isFavorite: Bool?
}

class PostsViewDataSource: ObservableDataSource<PostDD>, UITableViewDataSource {
	var cellDelegate: PostListCellDelegate? = nil

	private lazy var titleAttributes: [NSAttributedString.Key: Any] = {
		let labelStyle = NSMutableParagraphStyle()
		labelStyle.alignment = .left
		let labelAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17.0), .foregroundColor: UIColor(white: 51.0/255.0, alpha: 1), .paragraphStyle: labelStyle]
		return labelAttributes
	}()

	private lazy var bodyAttributes: [NSAttributedString.Key: Any] = {
		let labelStyle = NSMutableParagraphStyle()
		labelStyle.alignment = .left
		let labelAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 15.0), .foregroundColor: UIColor(white: 153.0/255.0, alpha: 1), .paragraphStyle: labelStyle]
		return labelAttributes
	}()

	// MARK: - Table view data source
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.value.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: PostListCell.cellID) as! PostListCell
		let row = indexPath.row
		let postDDItem = data.value[row]

		cell.labelTitle.text = postDDItem.post?.title
		cell.labelBody.text = postDDItem.post?.body
		cell.btnFavorite.isSelected = postDDItem.isFavorite!
		cell.delegate = cellDelegate
		return cell
	}
}

