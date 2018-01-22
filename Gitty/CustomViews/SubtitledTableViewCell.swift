//
//  SubtitledTableViewCell.swift
//  Gitty
//
//  Created by upandrarai on 21/01/18.
//  Copyright © 2018 Kunal. All rights reserved.
//

import UIKit
import Kingfisher

class SubtitledTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    func configureProfileCell(_ cellData: ProfileCellData) {
        titleLabel.text = cellData.title
        subtitleLabel.text = cellData.subtitle
        guard let imageName = cellData.imageName else { return }
        cellImageView.image = UIImage(named: imageName)
    }
    
    func configureUserCell(_ user: User) {
        titleLabel.text = user.login
        subtitleLabel.text = user.name
        cellImageView.layer.cornerRadius = 12.5
        cellImageView.layer.masksToBounds = true
        if let imageURLString = user.avatar_url, URL(string: imageURLString) != nil {
            cellImageView.kf.setImage(with: URL(string: imageURLString), placeholder: UIImage(named: "Octocat"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    func configureGistCell(_ gist: Gist) {
        titleLabel.text = gist.id
        subtitleLabel.text = gist.updated_at?.date
        cellImageView.layer.cornerRadius = 12.5
        cellImageView.layer.masksToBounds = true
        if let imageURLString = gist.owner?.avatar_url, URL(string: imageURLString) != nil {
            cellImageView.kf.setImage(with: URL(string: imageURLString), placeholder: UIImage(named: "Octocat"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    func configureOfflineUserCell(_ user: SavedUser) {
        titleLabel.text = user.login
        subtitleLabel.text = user.name
        cellImageView.layer.cornerRadius = 12.5
        cellImageView.layer.masksToBounds = true
        if let imageURLString = user.avatar_url, URL(string: imageURLString) != nil {
            cellImageView.kf.setImage(with: URL(string: imageURLString), placeholder: UIImage(named: "Octocat"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
}
