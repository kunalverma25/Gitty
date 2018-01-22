//
//  UserSearchVC.swift
//  Gitty
//
//  Created by upandrarai on 21/01/18.
//  Copyright © 2018 Kunal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import CoreData

class UserSearchVC: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var usersTableView: UITableView!
    
    var users: [User] = []
    var offlineUsers: [SavedUser] = []
    var filteredOfflineUsers: [SavedUser] = []
    var searchResult: SearchResult? = nil
    var searchTerm = ""
    var searchPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        usersTableView.register(UINib(nibName: "SubtitledTableViewCell", bundle: nil), forCellReuseIdentifier: "SubtitledTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        guard let searchTerm = searchBar.text, searchTerm != "" else { return }
        self.searchTerm = searchTerm
        if isInternetAvailable() {
            self.searchResult = nil
            self.users.removeAll()
            self.searchPage = 1
            fetchUsers(searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
        }
        else {
            offlineUsers = getOfflineUsers()
            print(offlineUsers)
            filteredOfflineUsers = offlineUsers.filter {
                $0.login?.lowercased().containsIgnoringCase(searchTerm) == true ||
                $0.name?.lowercased().containsIgnoringCase(searchTerm) == true ||
                $0.company?.lowercased().containsIgnoringCase(searchTerm) == true ||
                $0.location?.lowercased().containsIgnoringCase(searchTerm) == true
            }
            usersTableView.delegate = self
            usersTableView.dataSource = self
            usersTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInternetAvailable() {
            return users.count
        }
        else {
            return filteredOfflineUsers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitledTableViewCell") as! SubtitledTableViewCell
        if isInternetAvailable() {
            cell.configureUserCell(users[indexPath.row])
        }
        else {
            cell.configureOfflineUserCell(filteredOfflineUsers[indexPath.row])
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func fetchUsers(_ searchTerm: String) {
        let url = URL(string: APIServer.searchURL + searchTerm + "&" + urlQueryString + "&page=\(searchPage)")!
        print(url)
        SVProgressHUD.show()
        Server.callAPI(url, method: .get, parameters: nil, headers: nil) { (json, error) in
            SVProgressHUD.dismiss()
            if json != nil {
                let jsonData = try! json!.rawData()
                do {
                    let searchResult = try JSONDecoder().decode(SearchResult.self, from: jsonData)
                    self.searchResult = searchResult
                    guard let users = self.searchResult?.users else {
                        return
                    }
                    
                    self.users.append(contentsOf: users)
                    self.usersTableView.delegate = self
                    self.usersTableView.dataSource = self
                    self.usersTableView.reloadData()
                    _ = self.users.map { self.saveUsers($0) }
                }
                catch {
                    // error in parsing
                }
            }
            else {
                let alert = UIAlertController(title: "Error!", message: "Some error occurred.\nPlease try again.", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Okay", style: .default) { (action:UIAlertAction) in
                    self.fetchUsers(searchTerm)
                }
                let action2 = UIAlertAction(title: "Cancel", style: .default)
                alert.addAction(action1)
                alert.addAction(action2)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func saveUsers(_ user: User) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "SavedUser")
        let entity = NSEntityDescription.entity(forEntityName: "SavedUser", in: managedContext)
        fetchRequest.entity = entity
        fetchRequest.predicate = NSPredicate(format: "id = %d", user.id!)
        
        var objs: [SavedUser]? = []
        do {
            objs = try managedContext.fetch(fetchRequest) as? [SavedUser]
        }
        catch {
        }
        
        guard let objects = objs else { return }
        print(objects)
        if objects.count > 0 {
        }
        else {
            let savedUser = SavedUser(user, context: appDelegate.persistentContainer.viewContext)
            appDelegate.saveContext()
        }
    }
    
    func getOfflineUsers() -> [SavedUser] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "SavedUser")
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "SavedUser", in: managedContext)
        var objs: [SavedUser]? = []
        do {
            objs = try managedContext.fetch(fetchRequest) as? [SavedUser]
        }
        catch {
        }
        
        guard let objects = objs else { return [] }
        return objects
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.animateCell()
        if isInternetAvailable() {
            if indexPath.row == users.count - 1 && users.count != searchResult?.total_count {
                self.searchPage += 1
                fetchUsers(self.searchTerm)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isInternetAvailable() && users.count > indexPath.row {
            performSegue(withIdentifier: "profileSegue", sender: users[indexPath.row])
        }
        else if !isInternetAvailable() && offlineUsers.count > indexPath.row {
            performSegue(withIdentifier: "profileSegue", sender: offlineUsers[indexPath.row])
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue" {
            let vc = segue.destination as! ProfileVC
            if let user = sender as? User {
                vc.user = user
            }
            else if let user = sender as? SavedUser {
                vc.savedUser = user
            }
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
    }
}
