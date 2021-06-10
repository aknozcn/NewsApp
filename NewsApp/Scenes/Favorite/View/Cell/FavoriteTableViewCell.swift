//
//  FavoriteTableViewCell.swift
//  NewsApp
//
//  Created by Akin O. on 4.06.2021.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewAuthor: UIImageView!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var tableViewCellCard: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableViewCellCard.addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
