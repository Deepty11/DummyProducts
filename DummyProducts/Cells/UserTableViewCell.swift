//
//  UserTableViewCell.swift
//  DummyProducts
//
//  Created by Rehnuma Reza on 11/3/23.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    static let identifier = "UserTableViewCell"
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
