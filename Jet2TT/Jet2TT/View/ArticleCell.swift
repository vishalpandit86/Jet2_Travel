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

    var userTapGestureRecognizer: UITapGestureRecognizer!
    var cellViewModel: ArticleCellViewModel?

    var mediaHeightConstraint: NSLayoutConstraint!

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
        userNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        designationLabel.font = .systemFont(ofSize: 14, weight: .medium)
        createAtLabel.font = .systemFont(ofSize: 12, weight: .light)
        contentLabel.font = .systemFont(ofSize: 14, weight: .medium)
        likeLabel.font = .systemFont(ofSize: 14, weight: .bold)
        commentsLabel.font = .systemFont(ofSize: 14, weight: .bold)

        createAtLabel.textAlignment = .right
        commentsLabel.textAlignment = .right

        userAvatarImageView.contentMode = .scaleAspectFit
        userAvatarImageView.image = UIImage()
        userAvatarImageView.backgroundColor = .lightGray
        userAvatarImageView.layer.cornerRadius = 22.0

        mediaImageView.contentMode = .scaleAspectFit

        userTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userViewTapped))

        [userNameLabel, designationLabel, userAvatarImageView].forEach({ view in
            let tapGesture  = UITapGestureRecognizer(target: self, action: #selector(userViewTapped))
            view.addGestureRecognizer(tapGesture)
            view.isUserInteractionEnabled = true
        })
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
            self.mediaImageView.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 5.0)
        ])
        mediaHeightConstraint = self.mediaImageView.heightAnchor.constraint(equalToConstant: 160.0)
        mediaHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: mediaImageView.bottomAnchor, constant: 5.0),
            contentLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 0.0),
            contentLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 0.0),
            contentLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -20.0)
        ])

        NSLayoutConstraint.activate([
            likeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3.0),
            likeLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 5.0),
            likeLabel.heightAnchor.constraint(equalToConstant: 20.0),
            likeLabel.widthAnchor.constraint(equalToConstant: 140.0)
        ])

        NSLayoutConstraint.activate([
            commentsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3.0),
            commentsLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 0.0),
            commentsLabel.heightAnchor.constraint(equalToConstant: 20.0),
            commentsLabel.widthAnchor.constraint(equalToConstant: 140.0)
        ])

    }

    func update(with viewModel: ArticleCellViewModel) {
        self.cellViewModel = viewModel
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

            self.userAvatarImageView.addGestureRecognizer(self.userTapGestureRecognizer)
            self.userAvatarImageView.isUserInteractionEnabled = true

        }

        if viewModel.isMediaAvailable {
            viewModel.loadImage(cacheKey: .media) { (image) in
                guard image != nil else { return }
                self.mediaImageView.image = image
                self.mediaHeightConstraint.constant = 120.0

                self.contentView.setNeedsLayout()
                self.contentView.layoutIfNeeded()
            }
        } else {
            self.mediaHeightConstraint.constant = 0.0
            self.contentView.setNeedsLayout()
            self.contentView.layoutIfNeeded()
        }

        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellViewModel = nil
        self.userAvatarImageView.image = nil
        self.mediaImageView.image = nil
    }

    @objc
    func userViewTapped(_ sender: UITapGestureRecognizer) {
        if let user = self.cellViewModel?.user {
            self.cellViewModel?.onUserSelect(user)
        }
    }
}
