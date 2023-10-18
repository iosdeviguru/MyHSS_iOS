//
//  EventsModel.swift
//  MyHHS_iOS
//
//  Created by Patel on 21/04/2023.
//
//import SwiftUI
//
//

import Foundation
import SwiftUI
import UIKit

enum Timeline: Int {
  case upcoming = 1
  case past = 2
}

struct EventListing: Codable {
  let status: Bool
  let message: String
  let data: DataClass
}

struct Event: Codable, Identifiable {
  let id = UUID()

  let eventID, eventTitle, eventShortDescription, eventDetailedDescription: String
  let eventStartDate, eventEndDate, eventMode, eventLevel: String
  let eventLevelDetails: String?
  let eventForKaryakartasOnly: String
  let eventForWhichKaryakartas, eventAttendeeKaryakartaRoles: String?
  let eventAttendeeGender: String
  let eventAgeCategory, eventRegPartTimeAllowed, eventRegGuestAllowed, eventChargableOrNot: String?
  let eventCapacity, eventWaitingListAllowed, eventWaitListCapacity: String?
  let eventContact, eventNotes: String
  let eventAdditionalInfoRequired: String?
  let eventImg, eventImgDetail: String
  let eventCreatedDate: String
  let eventCreatedBy: String?
  let status: String
  let eventOnlineDetails, offlineAddressID: String?
  let buildingName, addressLine1, addressLine2: String
  let city, county: String?
  let postalCode: String
  let country, latitude, longitude: String?

  enum CodingKeys: String, CodingKey {
    case country, latitude, longitude, status, city, county
    case eventID = "event_id"
    case eventTitle = "event_title"
    case eventShortDescription = "event_short_description"
    case eventDetailedDescription = "event_detailed_description"
    case eventStartDate = "event_start_date"
    case eventEndDate = "event_end_date"
    case eventMode = "event_mode"
    case eventLevel = "event_level"
    case eventLevelDetails = "event_level_details"
    case eventForKaryakartasOnly = "event_for_karyakartas_only"
    case eventForWhichKaryakartas = "event_for_which_karyakartas"
    case eventAttendeeKaryakartaRoles = "event_attendee_karyakarta_roles"
    case eventAttendeeGender = "event_attendee_gender"
    case eventAgeCategory = "event_age_category"
    case eventRegPartTimeAllowed = "event_reg_part_time_allowed"
    case eventRegGuestAllowed = "event_reg_guest_allowed"
    case eventChargableOrNot = "event_chargable_or_not"
    case eventCapacity = "event_capacity"
    case eventWaitingListAllowed = "event_waiting_list_allowed"
    case eventWaitListCapacity = "event_wait_list_capacity"
    case eventContact = "event_contact"
    case eventNotes = "event_notes"
    case eventAdditionalInfoRequired = "event_additional_info_required"
    case eventImg = "event_img"
    case eventImgDetail = "event_img_detail"
    case eventCreatedDate = "event_created_date"
    case eventCreatedBy = "event_created_by"
    case eventOnlineDetails = "event_online_details"
    case offlineAddressID = "offline_address_id"
    case buildingName = "building_name"
    case addressLine1 = "address_line_1"
    case addressLine2 = "address_line_2"
    case postalCode = "postal_code"
  }
}

struct DataClass: Codable {
  let upcoming: EventDatum
  let past: EventDatum
}

struct EventDatum: Codable {
  var events: [Event]
  let totalPages, currentPage, perPage: Int?
  let paginationLinks: String?
  let next, previous, totalRecords: Int?

  enum CodingKeys: String, CodingKey {
    case next, previous
    case totalPages = "total_pages"
    case currentPage = "current_page"
    case perPage = "per_page"
    case paginationLinks = "pagination_links"
    case totalRecords = "total_records"
  }

  struct AnyKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) { self.stringValue = stringValue }
    init?(intValue: Int) { return nil }
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages)
    currentPage = try values.decodeIfPresent(Int.self, forKey: .currentPage)
    perPage = try values.decodeIfPresent(Int.self, forKey: .perPage)
    next = try values.decodeIfPresent(Int.self, forKey: .next)
    previous = try values.decodeIfPresent(Int.self, forKey: .previous)
    totalRecords = try values.decodeIfPresent(Int.self, forKey: .totalRecords)
    paginationLinks = try values.decodeIfPresent(String.self, forKey: .paginationLinks)
    events = []
    let container = try decoder.container(keyedBy: AnyKey.self)
    container.allKeys.forEach { key in
      if let results = try? container.decode(Event.self, forKey: key) {
        self.events.append(results)
      }
    }
  }
}
