//
//  LoadingCell.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 27/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {
    let spinner = UIActivityIndicatorView()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setupHierarchy()
        setupLayouts()
    }

    private func setUpViews() {
        spinner.style = .medium
        spinner.hidesWhenStopped = true
        spinner.color = .darkGray
    }

    private func setupHierarchy() {
        contentView.addSubview(spinner)
    }

    private func setupLayouts() {
        let marginGuide = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: marginGuide.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 44.0),
            spinner.heightAnchor.constraint(equalToConstant: 44.0)
        ])
    }
}
