//
//  SavedUser.swift
//  Gitty
//
//  Created by upandrarai on 22/01/18.
//  Copyright © 2018 Kunal. All rights reserved.
//

import CoreData
import Foundation

class SavedUser: NSManagedObject {
    @NSManaged var login: String?
    @NSManaged var avatar_url: String?
    @NSManaged var id: Int64
    @NSManaged var html_url: String?
    @NSManaged var followers_url : String?
    @NSManaged var following_url : String?
    @NSManaged var gists_url : String?
    @NSManaged var repos_url : String?
    @NSManaged var type : String?
    @NSManaged var name : String?
    @NSManaged var company : String?
    @NSManaged var location : String?
    @NSManaged var bio : String?
    @NSManaged var public_repos : Int64
    @NSManaged var public_gists : Int64
    @NSManaged var followers : Int64
    @NSManaged var following : Int64
    @NSManaged var created_at : String?
    @NSManaged var updated_at : String?
    
    convenience init(_ user: User, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "SavedUser", in: context)!
        self.init(entity: entity, insertInto: context)
        self.login = user.login
        self.avatar_url = user.avatar_url
        self.id = user.id.nsNumber
        self.html_url = user.html_url
        self.followers_url = user.followers_url
        self.following_url = user.following_url
        self.gists_url = user.gists_url
        self.repos_url = user.repos_url
        self.type = user.type
        self.name = user.name
        self.company = user.company
        self.location = user.location
        self.bio = user.bio
        self.public_repos = user.public_repos.nsNumber
        self.public_gists = user.public_gists.nsNumber
        self.followers = user.followers.nsNumber
        self.following = user.following.nsNumber
        self.created_at = user.created_at
        self.updated_at = user.updated_at
    }
}
