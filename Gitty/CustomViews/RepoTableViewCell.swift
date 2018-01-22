//
//  RepoTableViewCell.swift
//  Gitty
//
//  Created by upandrarai on 22/01/18.
//  Copyright © 2018 Kunal. All rights reserved.
//

import UIKit
import Kingfisher

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var forkLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    func configureRepoCell(_ repo: Repo) {
        titleLabel.text = repo.name
        starLabel.text = repo.stargazers_count.stringValue
        forkLabel.text = repo.forks_count.stringValue
        ownerLabel.text = repo.owner?.login
        if let imageURLString = repo.owner?.avatar_url, URL(string: imageURLString) != nil {
            cellImageView.kf.setImage(with: URL(string: imageURLString), placeholder: UIImage(named: "Octocat"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        if let description = repo.description {
            subTitleLabel.text = description + "\nUpdated - \(repo.updated_at!.date)"
        }
        else {
            subTitleLabel.text = "Updated - \(repo.updated_at!.date)"
        }
        
    }
    
}
