

import Foundation
struct Plan : Codable {
	let name : String?
	let space : Int?
	let collaborators : Int?
	let private_repos : Int?

	enum CodingKeys: String, CodingKey {

		case name = "name"
		case space = "space"
		case collaborators = "collaborators"
		case private_repos = "private_repos"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		space = try values.decodeIfPresent(Int.self, forKey: .space)
		collaborators = try values.decodeIfPresent(Int.self, forKey: .collaborators)
		private_repos = try values.decodeIfPresent(Int.self, forKey: .private_repos)
	}

}
