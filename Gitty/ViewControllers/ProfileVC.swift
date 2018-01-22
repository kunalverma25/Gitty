//
//  ProfileVC.swift
//  Gitty
//
//  Created by upandrarai on 21/01/18.
//  Copyright © 2018 Kunal. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SVProgressHUD
import SwiftyJSON

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var profileTable: UITableView!
    @IBOutlet weak var followersView: UIView!
    @IBOutlet weak var followingView: UIView!
    
    var profileCellData: [ProfileCellData] = []
    var user: User?
    var savedUser: SavedUser?
    var fetchedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTable.register(UINib(nibName: "NumberedTableViewCell", bundle: nil), forCellReuseIdentifier: "NumberedTableViewCell")
        profileTable.register(UINib(nibName: "SubtitledTableViewCell", bundle: nil), forCellReuseIdentifier: "SubtitledTableViewCell")
        let followerGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapFollowers(_:)))
        followersView.addGestureRecognizer(followerGesture)
        let followingGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapFollowing(_:)))
        followingView.addGestureRecognizer(followingGesture)
        if savedUser != nil {
            self.fetchedUser = User(savedUser: savedUser!)
            setData(self.fetchedUser!)
        }
        else if user == nil {
            fetchProfile(isLoggedInUser: true)
        }
        else {
            fetchProfile(isLoggedInUser: false, userName: user!.login!)
        }
    }
    
    @objc func tapFollowers(_ sender: UITapGestureRecognizer) {
        guard let url = fetchedUser?.followers_url, URL(string: url) != nil else {
            return
        }
        performSegue(withIdentifier: "listSegue", sender: "Followers")
    }
    
    @objc func tapFollowing(_ sender: UITapGestureRecognizer) {
        print(fetchedUser?.followers_url)
        guard let url = fetchedUser?.following_url?.replacingOccurrences(of: "{/other_user}", with: ""), URL(string: url) != nil else {
            return
        }
        performSegue(withIdentifier: "listSegue", sender: "Following")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func fetchProfile(isLoggedInUser: Bool, userName: String? = nil) {
        var url : URL
        if isLoggedInUser {
            url = URL(string: APIServer.profileURL + "?" + urlQueryString)!
        }
        else {
            guard let userName = userName else {
                return
            }
            url = URL(string: APIServer.otherUserProfileURL + userName + "?" + urlQueryString)!
        }
        print(url)
        SVProgressHUD.show()
        Server.callAPI(url, method: .get, parameters: nil, headers: nil) { (json, error) in
            SVProgressHUD.dismiss()
            if json != nil {
                let jsonData = try! json!.rawData()
                do {
                    let userData = try JSONDecoder().decode(User.self, from: jsonData)
                    if isLoggedInUser {
                        let encodedUser = try! PropertyListEncoder().encode(userData)
                        UserDefaults.standard.set(encodedUser, forKey: "loggedInUser")
                    }
                    self.fetchedUser = userData
                    self.setData(userData)
                }
                catch {
                    // error in parsing
                }
            }
            else {
                if isLoggedInUser {
                    if let encodedUser = UserDefaults.standard.object(forKey: "loggedInUser") as? Data {
                        let storedUser = try! PropertyListDecoder().decode(User.self, from: encodedUser)
                        self.fetchedUser = storedUser
                        self.setData(storedUser)
                    }
                }
                else {
                    let alert = UIAlertController(title: "Error!", message: "Some error occurred.\nPlease try again.", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "Okay", style: .default) { (action:UIAlertAction) in
                        self.fetchProfile(isLoggedInUser: isLoggedInUser, userName: userName)
                    }
                    let action2 = UIAlertAction(title: "Cancel", style: .default)
                    alert.addAction(action1)
                    alert.addAction(action2)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func setData(_ userData: User) {
        if let imageURLString = userData.avatar_url, URL(string: imageURLString) != nil {
            profileImageView.kf.setImage(with: URL(string: imageURLString), placeholder: UIImage(named: "Octocat"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        self.navigationItem.title = userData.login
        profileNameLabel.text = userData.name
        followersLabel.text = userData.followers.stringValue
        followingLabel.text = userData.following.stringValue
        
        profileCellData.removeAll()
        profileCellData.append(ProfileCellData(title: "Repositories", number: userData.public_repos.stringValue, subtitle: nil, imageName: "repository"))
        profileCellData.append(ProfileCellData(title: "Gists", number: userData.public_gists.stringValue, subtitle: nil, imageName: "gists"))
        if let location = userData.location {
            profileCellData.append(ProfileCellData(title: "Location", number: nil, subtitle: location, imageName: "location"))
        }
        if let lastUpdated = userData.updated_at {
            profileCellData.append(ProfileCellData(title: "Last Update", number: nil, subtitle: lastUpdated.date, imageName: "clock"))
        }
        if let profileURL = userData.html_url {
            profileCellData.append(ProfileCellData(title: "Github Link", number: nil, subtitle: profileURL, imageName: "github"))
        }
        profileTable.delegate = self
        profileTable.dataSource = self
        profileTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if profileCellData[indexPath.row].subtitle == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NumberedTableViewCell") as! NumberedTableViewCell
            cell.configureCell(profileCellData[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitledTableViewCell") as! SubtitledTableViewCell
        cell.configureProfileCell(profileCellData[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch profileCellData[indexPath.row].title {
        case "Gists"?:
            guard let url = fetchedUser?.gists_url?.replacingOccurrences(of: "{/gist_id}", with: ""), URL(string: url) != nil else {
                return
            }
            performSegue(withIdentifier: "listSegue", sender: profileCellData[indexPath.row])
        case "Repositories"?:
            guard let url = fetchedUser?.repos_url, URL(string: url) != nil else {
                return
            }
            performSegue(withIdentifier: "listSegue", sender: profileCellData[indexPath.row])
        case "Github Link"?:
            guard let url = fetchedUser?.html_url, URL(string: url) != nil else {
                return
            }
            UIApplication.shared.openURL(URL(string: url)!)
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listSegue" {
            let vc = segue.destination as! ListVC
            if sender as? String == "Followers" {
                vc.isUser = true
                vc.navigationItem.title = "Followers"
                vc.url = fetchedUser!.followers_url!
                if Int(followersLabel.text!) != nil {
                    vc.maxValues = Int(followersLabel.text!)!
                }
            }
            else if sender as? String == "Following" {
                vc.isUser = true
                vc.navigationItem.title = "Following"
                vc.url = fetchedUser!.following_url!.replacingOccurrences(of: "{/other_user}", with: "")
                if Int(followingLabel.text!) != nil {
                    vc.maxValues = Int(followingLabel.text!)!
                }
            }
            else if let gistValue = sender as? ProfileCellData, gistValue.title == "Gists" {
                vc.navigationItem.title = "Gists"
                vc.url = fetchedUser!.gists_url!.replacingOccurrences(of: "{/gist_id}", with: "")
                vc.isGist = true
                if let maxValue = gistValue.number, Int(maxValue) != nil {
                    vc.maxValues = Int(maxValue)!
                }
            }
            else if let repoValue = sender as? ProfileCellData, repoValue.title == "Repositories" {
                vc.navigationItem.title = "Repositories"
                vc.url = fetchedUser!.repos_url!
                vc.isRepo = true
                if let maxValue = repoValue.number, Int(maxValue) != nil {
                    vc.maxValues = Int(maxValue)!
                }
            }
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
    }
    
}
