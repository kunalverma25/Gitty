//
//  ListVC.swift
//  Gitty
//
//  Created by upandrarai on 21/01/18.
//  Copyright © 2018 Kunal. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var listTableView: UITableView!
    
    var users: [User] = []
    var gists: [Gist] = []
    var repos: [Repo] = []
    var url: String?
    var page = 1
    var maxValues = 0
    var isUser = false
    var isGist = false
    var isRepo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.register(UINib(nibName: "SubtitledTableViewCell", bundle: nil), forCellReuseIdentifier: "SubtitledTableViewCell")
        listTableView.register(UINib(nibName: "RepoTableViewCell", bundle: nil), forCellReuseIdentifier: "RepoTableViewCell")
        if isRepo {
            listTableView.estimatedRowHeight = 100
            listTableView.rowHeight = UITableViewAutomaticDimension
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isUser {
            if users.count != maxValues {
                fetchUsers()
            }
        }
        else if isGist {
            if gists.count != maxValues {
                fetchGists()
            }
        }
        else if isRepo {
            if repos.count != maxValues {
                fetchRepos()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isUser {
            return users.count
        }
        else if isGist {
            return gists.count
        }
        else if isRepo {
            return repos.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isRepo {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepoTableViewCell") as! RepoTableViewCell
            cell.configureRepoCell(repos[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitledTableViewCell") as! SubtitledTableViewCell
            if isUser {
                cell.configureUserCell(users[indexPath.row])
            }
            else {
                cell.configureGistCell(gists[indexPath.row])
            }
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func fetchUsers() {
        guard let url = self.url else { return }
        SVProgressHUD.show()
        let userListURL = URL(string: url + "?" + urlQueryString + "&page=\(page)")!
        Server.callAPI(userListURL, method: .get, parameters: nil, headers: nil) { (json, error) in
            SVProgressHUD.dismiss()
            if json != nil {
                let jsonData = try! json!.rawData()
                do {
                    let results = try JSONDecoder().decode([User].self, from: jsonData)
                    self.users.append(contentsOf: results)
                    self.listTableView.delegate = self
                    self.listTableView.dataSource = self
                    self.listTableView.reloadData()
                }
                catch {
                    // error in parsing
                }
            }
            else {
                let alert = UIAlertController(title: "Error!", message: "Some error occurred.\nPlease try again.", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Okay", style: .default) { (action:UIAlertAction) in
                    self.fetchUsers()
                }
                let action2 = UIAlertAction(title: "Cancel", style: .default)
                alert.addAction(action1)
                alert.addAction(action2)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func fetchGists() {
        guard let url = self.url else { return }
        SVProgressHUD.show()
        let userListURL = URL(string: url + "?" + urlQueryString + "&page=\(page)")!
        Server.callAPI(userListURL, method: .get, parameters: nil, headers: nil) { (json, error) in
            SVProgressHUD.dismiss()
            if json != nil {
                let jsonData = try! json!.rawData()
                do {
                    let results = try JSONDecoder().decode([Gist].self, from: jsonData)
                    self.gists.append(contentsOf: results)
                    self.listTableView.delegate = self
                    self.listTableView.dataSource = self
                    self.listTableView.reloadData()
                }
                catch {
                    // error in parsing
                }
            }
            else {
                let alert = UIAlertController(title: "Error!", message: "Some error occurred.\nPlease try again.", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Okay", style: .default) { (action:UIAlertAction) in
                    self.fetchGists()
                }
                let action2 = UIAlertAction(title: "Cancel", style: .default)
                alert.addAction(action1)
                alert.addAction(action2)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func fetchRepos() {
        guard let url = self.url else { return }
        SVProgressHUD.show()
        let userListURL = URL(string: url + "?" + urlQueryString + "&page=\(page)")!
        Server.callAPI(userListURL, method: .get, parameters: nil, headers: nil) { (json, error) in
            SVProgressHUD.dismiss()
            if json != nil {
                let jsonData = try! json!.rawData()
                do {
                    let results = try JSONDecoder().decode([Repo].self, from: jsonData)
                    self.repos.append(contentsOf: results)
                    self.listTableView.delegate = self
                    self.listTableView.dataSource = self
                    self.listTableView.reloadData()
                }
                catch {
                    // error in parsing
                }
            }
            else {
                let alert = UIAlertController(title: "Error!", message: "Some error occurred.\nPlease try again.", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Okay", style: .default) { (action:UIAlertAction) in
                    self.fetchRepos()
                }
                let action2 = UIAlertAction(title: "Cancel", style: .default)
                alert.addAction(action1)
                alert.addAction(action2)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isUser {
            performSegue(withIdentifier: "profileSegue", sender: users[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isUser {
            if indexPath.row == users.count - 1 && users.count != maxValues {
                self.page += 1
                fetchUsers()
            }
        }
        else if isGist {
            if indexPath.row == gists.count - 1 && gists.count != maxValues {
                self.page += 1
                fetchGists()
            }
        }
        else if isRepo {
            if indexPath.row == repos.count - 1 && repos.count != maxValues {
                self.page += 1
                fetchRepos()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue" {
            let vc = segue.destination as! ProfileVC
            vc.user = sender as! User
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
    }
    
}

