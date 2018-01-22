

import Foundation
struct License : Codable {
	let key : String?
	let name : String?
	let spdx_id : String?
	let url : String?

	enum CodingKeys: String, CodingKey {

		case key = "key"
		case name = "name"
		case spdx_id = "spdx_id"
		case url = "url"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		key = try values.decodeIfPresent(String.self, forKey: .key)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		spdx_id = try values.decodeIfPresent(String.self, forKey: .spdx_id)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}

}
