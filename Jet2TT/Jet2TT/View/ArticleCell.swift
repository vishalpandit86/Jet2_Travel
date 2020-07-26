//
//  ArticleCell.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    let userAvatarImageView = UIImageView()
    let userNameLabel = UILabel()
    let designationLabel = UILabel()
    let createAtLabel = UILabel()
    let mediaImageView = UIImageView()

    let contentLabel = UILabel()
    let likeLabel = UILabel()
    let commentsLabel = UILabel()

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
        [userAvatarImageView, userNameLabel, designationLabel, createAtLabel, mediaImageView, contentLabel, likeLabel, commentsLabel].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})

        contentLabel.numberOfLines = 0
        userNameLabel.font = .systemFont(ofSize: 16.0)
        designationLabel.font = .systemFont(ofSize: 13.0)
        createAtLabel.font = .systemFont(ofSize: 12.0)
        contentLabel.font = .systemFont(ofSize: 14.0)
        likeLabel.font = .boldSystemFont(ofSize: 12.0)
        commentsLabel.font = .boldSystemFont(ofSize: 12.0)

        createAtLabel.textAlignment = .right
        commentsLabel.textAlignment = .right

        userAvatarImageView.contentMode = .scaleAspectFit
        userAvatarImageView.image = UIImage()
        userAvatarImageView.backgroundColor = .lightGray
        userAvatarImageView.layer.cornerRadius = 22.0

        mediaImageView.contentMode = .scaleAspectFit

    }

    private func setupHierarchy() {
        [userAvatarImageView, userNameLabel, designationLabel, createAtLabel, contentLabel, likeLabel, commentsLabel, mediaImageView].forEach({self.contentView.addSubview($0)})

    }

    private func setupLayouts() {
        let marginGuide = contentView.layoutMarginsGuide

        NSLayoutConstraint.activate([
            userAvatarImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 0.0),
            userAvatarImageView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 5.0),
            userAvatarImageView.widthAnchor.constraint(equalToConstant: 44.0),
            userAvatarImageView.heightAnchor.constraint(equalToConstant: 44.0)
            ])

        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 0.0),
            userNameLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 55.0),
            userNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 40.0),
            userNameLabel.heightAnchor.constraint(equalToConstant: 25.0)
        ])

        NSLayoutConstraint.activate([
            designationLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 0.0),
            designationLabel.leftAnchor.constraint(equalTo: userNameLabel.leftAnchor, constant: 0.0),
            designationLabel.widthAnchor.constraint(equalTo: userNameLabel.widthAnchor),
            designationLabel.heightAnchor.constraint(equalToConstant: 15.0)
        ])

        NSLayoutConstraint.activate([
            createAtLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 0.0),
            createAtLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 0.0),
            createAtLabel.heightAnchor.constraint(equalToConstant: 20.0),
            createAtLabel.widthAnchor.constraint(equalToConstant: 80.0)
        ])

        NSLayoutConstraint.activate([
            self.mediaImageView.topAnchor.constraint(equalTo: self.userAvatarImageView.bottomAnchor, constant: 5.0),
            self.mediaImageView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 5.0),
            self.mediaImageView.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 5.0),
            self.mediaImageView.heightAnchor.constraint(equalToConstant: 160.0)
        ])

        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: mediaImageView.bottomAnchor, constant: 5.0),
            contentLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 0.0),
            contentLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 0.0),
            contentLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -20.0)
        ])

        NSLayoutConstraint.activate([
            likeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0),
            likeLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 5.0),
            likeLabel.heightAnchor.constraint(equalToConstant: 20.0),
            likeLabel.widthAnchor.constraint(equalToConstant: 120.0)
        ])

        NSLayoutConstraint.activate([
            commentsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0),
            commentsLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 0.0),
            commentsLabel.heightAnchor.constraint(equalToConstant: 20.0),
            commentsLabel.widthAnchor.constraint(equalToConstant: 120.0)
        ])

    }

    func update(with viewModel: ArticleCellViewModel) {
        userNameLabel.text = viewModel.userName
        designationLabel.text = viewModel.designation
        createAtLabel.text = viewModel.createAtString

        contentLabel.text = viewModel.content
        likeLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments

        viewModel.loadImage(cacheKey: .avatar) { image in
            guard image != nil else { return }

            self.userAvatarImageView.image = image
            self.userAvatarImageView.backgroundColor = .clear
            self.userAvatarImageView.layer.cornerRadius = 22.0
            self.userAvatarImageView.clipsToBounds = true

            self.userAvatarImageView.layer.shadowColor = UIColor.darkGray.cgColor
            self.userAvatarImageView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
            self.userAvatarImageView.layer.shadowRadius = 22.0
            self.userAvatarImageView.layer.shadowOpacity = 0.9
        }

        if viewModel.isMediaAvailable {
            viewModel.loadImage(cacheKey: .media) { (image) in
                guard image != nil else { return }
                self.mediaImageView.image = image
            }
        } else {
            NSLayoutConstraint.activate([
                self.mediaImageView.heightAnchor.constraint(equalToConstant: 0.0)
            ])
        }

    }
}
