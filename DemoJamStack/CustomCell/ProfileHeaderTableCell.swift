// 
// ProfileHeaderTableCell.swift
// 
// Created on 6/21/20.
// 

import UIKit

class ProfileHeaderTableCell: UITableViewCell {

    static let cellId = "ProfileHeaderTableCell"
    
    @IBOutlet weak var imvView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
