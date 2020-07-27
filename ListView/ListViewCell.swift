//
//  ListViewCell.swift
//  ListView
//
//  Created by Piyush Kachariya on 7/27/20.
//  Copyright © 2020 Kachariya. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {

    var label: UILabel!
    var imgview: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialSetup() {
        label = UILabel(frame: contentView.frame)
        contentView.addSubview(label)
        label.textAlignment = .left
        label.font = UIFont(name: label.font.fontName, size: 17)
        self.contentView.backgroundColor = .white
        
        imgview = UIImageView(frame: contentView.frame)
        imgview.clipsToBounds = true
        imgview.contentMode = .scaleToFill
        contentView.addSubview(imgview)
    }

}
