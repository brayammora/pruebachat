//
//  ChatsTableViewCell.swift
//  PruebaChat
//
//  Created by Brayam Alberto Mora Arias on 12/05/20.
//  Copyright © 2020 Brayam Alberto Mora Arias. All rights reserved.
//


import UIKit

class ChatsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var descriptionMessage: UILabel!
    @IBOutlet weak var timeMessage: UILabel!
    @IBOutlet weak var counterMessages: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.timeLabel.textColor = Theme.current.colorTitleTable4
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
