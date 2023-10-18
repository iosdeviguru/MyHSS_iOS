/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ShakhaData : Codable {
    let org_chapter_id : String?
    let chapter_name : String?
    let contact_person_name : String?
    let building_name : String?
    let address_line_1 : String?
    let address_line_2 : String?
    let city : String?
    let county : String?
    let postal_code : String?
    let country : String?
    let latitude : String?
    let longitude : String?
    let phone : String?
    let email : String?
    let day : String?
    let start_time : String?
    let end_time : String?
    var distance : Double?

    enum CodingKeys: String, CodingKey {

        case org_chapter_id = "org_chapter_id"
        case chapter_name = "chapter_name"
        case contact_person_name = "contact_person_name"
        case building_name = "building_name"
        case address_line_1 = "address_line_1"
        case address_line_2 = "address_line_2"
        case city = "city"
        case county = "county"
        case postal_code = "postal_code"
        case country = "country"
        case latitude = "latitude"
        case longitude = "longitude"
        case phone = "phone"
        case email = "email"
        case day = "day"
        case start_time = "start_time"
        case end_time = "end_time"
        case distance = "distance"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        org_chapter_id = try values.decodeIfPresent(String.self, forKey: .org_chapter_id)
        chapter_name = try values.decodeIfPresent(String.self, forKey: .chapter_name)
        contact_person_name = try values.decodeIfPresent(String.self, forKey: .contact_person_name)
        building_name = try values.decodeIfPresent(String.self, forKey: .building_name)
        address_line_1 = try values.decodeIfPresent(String.self, forKey: .address_line_1)
        address_line_2 = try values.decodeIfPresent(String.self, forKey: .address_line_2)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        county = try values.decodeIfPresent(String.self, forKey: .county)
        postal_code = try values.decodeIfPresent(String.self, forKey: .postal_code)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        day = try values.decodeIfPresent(String.self, forKey: .day)
        start_time = try values.decodeIfPresent(String.self, forKey: .start_time)
        end_time = try values.decodeIfPresent(String.self, forKey: .end_time)
        distance = try values.decodeIfPresent(Double.self, forKey: .distance)
    }

}
