//
//  MessageTableViewCell.swift
//  PruebaChat
//
//  Created by Brayam Alberto Mora Arias on 13/05/20.
//  Copyright © 2020 Brayam Alberto Mora Arias. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var messageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCustom(text:Any, type:Bool)->CGFloat{
        let label =  UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.text = text as? String
        
        let constraintRect = CGSize(width: 0.66 * messageView.frame.width,height: .greatestFiniteMagnitude)
        let boundingBox = (text as AnyObject).boundingRect(with: constraintRect,
                                                           options: .usesLineFragmentOrigin,
                                                           attributes: [.font: label.font!],
                                                           context: nil)
        label.frame.size = CGSize(width: ceil(boundingBox.width),height: ceil(boundingBox.height))
        
        var bubbleSize = CGSize()
        if text as? String == "image" {
            bubbleSize = CGSize(width: 200,height: 200 )
        }else{
            bubbleSize = CGSize(width: label.frame.width + 50, height: label.frame.height + 30 )
        }
        
        let bubbleView = BubbleChatView()
        bubbleView.isIncoming = type
        bubbleView.frame.size = bubbleSize
        bubbleView.backgroundColor = .clear
        if !type{
            bubbleView.frame.origin.x = self.messageView.frame.width -  bubbleSize.width - 20
            messageView.addSubview(bubbleView)
            if text as? String == "image" {
                showImageMessage(myview: bubbleView,type: type)
            }else{
                label.frame.origin.x = bubbleView.frame.origin.x + 10
                label.frame.origin.y = bubbleView.frame.origin.y + 10
                messageView.addSubview(label)
            }
            let imageIndicatorView = UIImageView(image: UIImage(named: "readconfirm_icon"))
            imageIndicatorView.frame.size = CGSize(width: 15, height: 15)
            if bubbleView.frame.width > 70{
                imageIndicatorView.frame.origin.x = boundingBox.width + 15// bubbleView.frame.width //- 220
            }else{
                imageIndicatorView.frame.origin.x = boundingBox.width + 30
            }
            imageIndicatorView.frame.origin.y = 0
            
            imageIndicatorView.contentMode = .scaleAspectFit
            imageIndicatorView.clipsToBounds = true
            imageIndicatorView.backgroundColor = Colors.clear
            imageIndicatorView.layer.cornerRadius = 10
            
            bubbleView.addSubview(imageIndicatorView)
        }else{
            //entrante
            bubbleView.lastIn = true
            bubbleView.frame.origin.x = self.messageView.frame.origin.x + 10
            messageView.addSubview(bubbleView)
            if text as? String == "image" {
                showImageMessage(myview: bubbleView,type: type)
            }else{
                label.frame.origin.x = bubbleView.frame.origin.x + 25
                label.frame.origin.y = bubbleView.frame.origin.y + 10
                messageView.addSubview(label)
            }
            
        }
        
        let time = "10:03 am"
        let date =  UILabel()
        date.numberOfLines = 0
        date.font = UIFont.systemFont(ofSize: 10)
        date.textColor = Colors.white
        date.text = time
        let boundingBoxDate = (time as AnyObject).boundingRect(with: constraintRect,
                                                               options: .usesLineFragmentOrigin,
                                                               attributes: [.font: label.font!],
                                                               context: nil)
        date.frame.size = CGSize(width: ceil(boundingBoxDate.width),height: 10)
        //date.frame.size = CGSize(width: 100, height: 10)
        
        
        if type {
            
            date.frame.origin.y = bubbleView.frame.height - 15
            date.textAlignment = .left
            if bubbleView.frame.width > 70{
                date.frame.origin.x = bubbleView.frame.origin.x + 25
            }else{
                date.frame.origin.x = bubbleView.frame.origin.x + 11
                date.frame.origin.y = bubbleView.frame.height - 10
            }
        }else{
            date.frame.origin.y = bubbleView.frame.height - 15
            date.textAlignment = .right
            if bubbleView.frame.width > 70{
                date.frame.origin.x = bubbleView.frame.origin.x + bubbleView.frame.width - 100
            }else{
                date.frame.origin.x = bubbleView.frame.origin.x - 28
                date.frame.origin.y = bubbleView.frame.height - 10
            }
        }
        
        messageView.addSubview(date)
        bubbleView.layer.cornerRadius = bubbleView.frame.height / 2
        
        return bubbleSize.height
    }
    
    func showImageMessage(myview:UIView, type:Bool) {
        messageView.addSubview(myview)
        let width: CGFloat = 200 - 20// * 0.66//0.66 * messageView.frame.width
        let height: CGFloat =  200 - 20/// 0.75// width / 0.75
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.frame.size = CGSize(width: width, height: height)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = Colors.clear
        imageView.layer.cornerRadius = 10
        if type{
            imageView.center.x = (myview.frame.width / 2) + 15//- (width / 2)
        }else{
            imageView.center.x = myview.frame.origin.x + (myview.frame.width / 2) - 7.5//- (width / 2)
        }
        
        messageView.addSubview(imageView)
        
    }
    
    
    
}
