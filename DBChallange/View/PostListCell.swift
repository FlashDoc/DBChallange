//
//  PostListCell.swift
//  DBChallange
//
//  Created by Sylvia-Kathrin Tanneberger on 14.03.19.
//  Copyright © 2019 ttx.WebService();. All rights reserved.
//

import UIKit

protocol PostListCellDelegate: class {
	func listCell(_ cell: PostListCell, updateFavoriteState stateFlag: Bool)
}

class PostListCell: UITableViewCell {
	static let cellID: String = "PostListCell"
	static let cellHeight: CGFloat = 82.0
	
	@IBOutlet var labelTitle: UILabel!
	@IBOutlet var labelBody: UILabel!
	@IBOutlet var btnFavorite: UIButton!

	var delegate: PostListCellDelegate?

	override func awakeFromNib() {
		super.awakeFromNib()
		btnFavorite.setImage(UIImage(named: "favorite_off"), for: .normal)
		btnFavorite.setImage(UIImage(named: "favorite_on"), for: .selected)
	}
	
	@IBAction func actionToggleFavorite(_ sender: Any) {
		btnFavorite.isSelected = !btnFavorite.isSelected
		if delegate != nil {
			delegate?.listCell(self, updateFavoriteState: btnFavorite.isSelected)
		}
	}
	
}
