//
//  UserCell.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 27/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    let userAvatarImageView = UIImageView()
    let userNameLabel = UILabel()
    let designationLabel = UILabel()
    let cityLabel = UILabel()

    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setupHierarchy()
        setupLayouts()
    }

    private func setUpViews() {
        [userAvatarImageView, userNameLabel, designationLabel, cityLabel].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        userNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        designationLabel.font = .systemFont(ofSize: 14, weight: .medium)
        cityLabel.font = .systemFont(ofSize: 12, weight: .light)

        cityLabel.textAlignment = .right

        userAvatarImageView.contentMode = .scaleAspectFit
        userAvatarImageView.image = UIImage()
        userAvatarImageView.backgroundColor = .lightGray
        userAvatarImageView.layer.cornerRadius = 22.0

    }

    private func setupHierarchy() {
        [userAvatarImageView, userNameLabel, designationLabel, cityLabel].forEach({self.contentView.addSubview($0)})
    }

    private func setupLayouts() {
        let marginGuide = contentView.layoutMarginsGuide

        NSLayoutConstraint.activate([
            userAvatarImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 0.0),
            userAvatarImageView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 0.0),
            userAvatarImageView.widthAnchor.constraint(equalToConstant: 44.0),
            userAvatarImageView.heightAnchor.constraint(equalToConstant: 44.0)
        ])

        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 0.0),
            userNameLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 55.0),
            userNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 160.0),
            userNameLabel.heightAnchor.constraint(equalToConstant: 25.0)
        ])

        NSLayoutConstraint.activate([
            designationLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 0.0),
            designationLabel.leftAnchor.constraint(equalTo: userNameLabel.leftAnchor, constant: 0.0),
            designationLabel.widthAnchor.constraint(equalTo: userNameLabel.widthAnchor),
            designationLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 0.0)
        ])

        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 0.0),
            cityLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 10.0),
            cityLabel.heightAnchor.constraint(equalToConstant: 25.0),
            cityLabel.widthAnchor.constraint(equalToConstant: 160.0)
        ])
    }

    func update(with viewModel: UserCellViewModel) {
        userNameLabel.text = viewModel.userFullname
        designationLabel.text = viewModel.designation
        cityLabel.text = viewModel.city

        guard let imageUrl = viewModel.imageUrl else { return }
        viewModel.loadImage(urlString: imageUrl) { image in
            guard image != nil else { return }

            self.userAvatarImageView.image = image
            self.userAvatarImageView.backgroundColor = .clear
            self.userAvatarImageView.layer.cornerRadius = 22.0
            self.userAvatarImageView.clipsToBounds = true
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.userAvatarImageView.image = nil
    }
}

