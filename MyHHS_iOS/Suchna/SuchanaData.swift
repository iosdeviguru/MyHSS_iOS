
import Foundation
struct SuchanaData : Codable {
	let suchana_title : String?
	let suchana_text : String?
	let id : String?
	let created_date : String?
	let is_read : String?

	enum CodingKeys: String, CodingKey {

		case suchana_title = "suchana_title"
		case suchana_text = "suchana_text"
		case id = "id"
		case created_date = "created_date"
		case is_read = "is_read"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		suchana_title = try values.decodeIfPresent(String.self, forKey: .suchana_title)
		suchana_text = try values.decodeIfPresent(String.self, forKey: .suchana_text)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		created_date = try values.decodeIfPresent(String.self, forKey: .created_date)
		is_read = try values.decodeIfPresent(String.self, forKey: .is_read)
	}

}
