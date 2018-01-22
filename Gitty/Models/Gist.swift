

import Foundation
struct Gist : Codable {
	let url : String?
	let forks_url : String?
	let commits_url : String?
	let id : String?
	let git_pull_url : String?
	let git_push_url : String?
	let html_url : String?
	let isPublic : Bool?
	let created_at : String?
	let updated_at : String?
	let description : String?
	let comments : Int?
	let comments_url : String?
	let owner : User?
	let truncated : Bool?

	enum CodingKeys: String, CodingKey {

		case url = "url"
		case forks_url = "forks_url"
		case commits_url = "commits_url"
		case id = "id"
		case git_pull_url = "git_pull_url"
		case git_push_url = "git_push_url"
		case html_url = "html_url"
		case isPublic = "public"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case description = "description"
		case comments = "comments"
		case comments_url = "comments_url"
		case owner = "owner"
		case truncated = "truncated"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		forks_url = try values.decodeIfPresent(String.self, forKey: .forks_url)
		commits_url = try values.decodeIfPresent(String.self, forKey: .commits_url)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		git_pull_url = try values.decodeIfPresent(String.self, forKey: .git_pull_url)
		git_push_url = try values.decodeIfPresent(String.self, forKey: .git_push_url)
		html_url = try values.decodeIfPresent(String.self, forKey: .html_url)
		isPublic = try values.decodeIfPresent(Bool.self, forKey: .isPublic)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		comments = try values.decodeIfPresent(Int.self, forKey: .comments)
		comments_url = try values.decodeIfPresent(String.self, forKey: .comments_url)
		owner = try values.decodeIfPresent(User.self, forKey: .owner)
		truncated = try values.decodeIfPresent(Bool.self, forKey: .truncated)
	}

}
