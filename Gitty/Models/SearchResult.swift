

import Foundation
struct SearchResult : Codable {
	let total_count : Int?
	let incomplete_results : Bool?
	let users : [User]?

	enum CodingKeys: String, CodingKey {
		case total_count = "total_count"
		case incomplete_results = "incomplete_results"
		case users = "items"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		total_count = try values.decodeIfPresent(Int.self, forKey: .total_count)
		incomplete_results = try values.decodeIfPresent(Bool.self, forKey: .incomplete_results)
		users = try values.decodeIfPresent([User].self, forKey: .users)
	}

}
