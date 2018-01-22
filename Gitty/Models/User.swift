

import Foundation
class User : Codable {
	let login : String?
	let id : Int?
	let avatar_url : String?
	let html_url : String?
	let followers_url : String?
	let following_url : String?
	let gists_url : String?
	let repos_url : String?
    let type : String?
	let name : String?
	let company : String?
	let location : String?
	let email : String?
	let bio : String?
	let public_repos : Int?
	let public_gists : Int?
	let followers : Int?
	let following : Int?
	let created_at : String?
	let updated_at : String?

	enum CodingKeys: String, CodingKey {

		case login = "login"
		case id = "id"
		case avatar_url = "avatar_url"
		case html_url = "html_url"
		case followers_url = "followers_url"
		case following_url = "following_url"
		case gists_url = "gists_url"
		case repos_url = "repos_url"
        case type = "type"
		case name = "name"
		case company = "company"
		case location = "location"
		case email = "email"
        case bio = "bio"
		case public_repos = "public_repos"
		case public_gists = "public_gists"
		case followers = "followers"
		case following = "following"
		case created_at = "created_at"
		case updated_at = "updated_at"
	}

    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		login = try values.decodeIfPresent(String.self, forKey: .login)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		avatar_url = try values.decodeIfPresent(String.self, forKey: .avatar_url)
		html_url = try values.decodeIfPresent(String.self, forKey: .html_url)
		followers_url = try values.decodeIfPresent(String.self, forKey: .followers_url)
		following_url = try values.decodeIfPresent(String.self, forKey: .following_url)
		gists_url = try values.decodeIfPresent(String.self, forKey: .gists_url)
		repos_url = try values.decodeIfPresent(String.self, forKey: .repos_url)
        type = try values.decodeIfPresent(String.self, forKey: .type)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		company = try values.decodeIfPresent(String.self, forKey: .company)
		location = try values.decodeIfPresent(String.self, forKey: .location)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		bio = try values.decodeIfPresent(String.self, forKey: .bio)
		public_repos = try values.decodeIfPresent(Int.self, forKey: .public_repos)
		public_gists = try values.decodeIfPresent(Int.self, forKey: .public_gists)
		followers = try values.decodeIfPresent(Int.self, forKey: .followers)
		following = try values.decodeIfPresent(Int.self, forKey: .following)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
	}
    
    init(savedUser: SavedUser) {
        login = savedUser.login
        avatar_url = savedUser.avatar_url
        id = Int(exactly: savedUser.id)
        html_url = savedUser.html_url
        followers_url = savedUser.followers_url
        following_url = savedUser.following_url
        gists_url = savedUser.gists_url
        repos_url = savedUser.repos_url
        type = savedUser.type
        name = savedUser.name
        company = savedUser.company
        location = savedUser.location
        bio = savedUser.bio
        public_repos = Int(exactly: savedUser.public_repos)
        public_gists = Int(exactly: savedUser.public_gists)
        followers = Int(exactly: savedUser.followers)
        following = Int(exactly: savedUser.following)
        created_at = savedUser.created_at
        updated_at = savedUser.updated_at
        email = nil
    }

}
