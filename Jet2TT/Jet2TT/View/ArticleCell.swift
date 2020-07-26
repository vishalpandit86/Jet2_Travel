//
//  ArticleCell.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    let titleLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        self.titleLabel = UILabel()//ViewFactory.createUILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }

    private func setUpViews() {

        contentView.addSubview(titleLabel)
        let marginGuide = contentView.layoutMarginsGuide
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 5).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 5).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: -5).isActive = true
    }
}
