//
//  ViewController.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 26/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import UIKit

class UserProfileController: UIViewController {
    var viewModel: UserProfileViewModel!

    let userImageView = UIImageView()
    let userNameLabel = UILabel()
    let designationLabel = UILabel()
    let cityLabel = UILabel()
    let aboutLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupHierarchy()
        setupLayouts()
        updateUI()
    }

    private func setupViews() {
        navigationItem.title = viewModel.title

        [userImageView, userNameLabel, designationLabel, cityLabel, aboutLabel].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})

        userNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        designationLabel.font = .systemFont(ofSize: 16, weight: .medium)
        cityLabel.font = .systemFont(ofSize: 16, weight: .medium)
        aboutLabel.font = .systemFont(ofSize: 16, weight: .medium)
        aboutLabel.numberOfLines = 0

        userNameLabel.textAlignment = .center
        designationLabel.textAlignment = .center
        cityLabel.textAlignment = .center
        userImageView.image = UIImage()
        userImageView.backgroundColor = .darkGray
        userImageView.contentMode = .scaleAspectFit
    }

    private func setupHierarchy() {
        [userImageView, userNameLabel, designationLabel, cityLabel, aboutLabel].forEach({ view.addSubview($0)})

    }

    private func setupLayouts() {

        let marginGuide = self.view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 10.0),
            userImageView.centerXAnchor.constraint(equalTo: marginGuide.centerXAnchor, constant: 0.0),
            userImageView.heightAnchor.constraint(equalToConstant: 200.0),
            userImageView.widthAnchor.constraint(equalToConstant: 200.0)
        ])

        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 5.0),
            userNameLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 5.0),
            userNameLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 5.0),
            userNameLabel.heightAnchor.constraint(equalToConstant: 40.0)
        ])

        NSLayoutConstraint.activate([
            designationLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            designationLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 5.0),
            designationLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 5.0),
            designationLabel.heightAnchor.constraint(equalToConstant: 30.0)
        ])

        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: designationLabel.bottomAnchor, constant: 10.0),
            cityLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 5.0),
            cityLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 5.0),
            cityLabel.heightAnchor.constraint(equalToConstant: 30.0)
        ])

        NSLayoutConstraint.activate([
            aboutLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10.0),
            aboutLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 5.0),
            aboutLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 5.0)
        ])
    }

    private func updateUI() {
        userNameLabel.text = viewModel.userFullName
        designationLabel.text = viewModel.designation
        cityLabel.text = viewModel.city
        aboutLabel.text = viewModel.about
        viewModel.loadImage(urlString: viewModel.imageUrl) { (image) in
            guard image != nil else { return }

            self.userImageView.image = image
            self.userImageView.layer.cornerRadius = 100.0
            self.userImageView.clipsToBounds = true
            self.userImageView.layer.borderColor = UIColor.darkGray.cgColor
            self.userImageView.layer.borderWidth = 2.0
            self.userImageView.contentMode = .scaleAspectFit
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }

}

