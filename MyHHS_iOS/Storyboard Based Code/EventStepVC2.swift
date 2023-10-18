//
//  EventStepVC2.swift
//  MyHHS_iOS
//
//  Created by Patel on 14/04/2023.
//
// for the storyboard based code for EVENTS, implemented*



//import UIKit
//
//class EventListViewController: UITableViewController {
//    var events: [EventData] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "Cell")
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 100
//        
//        getEventData(eventType: 1) { [weak self] result in
//            switch result {
//            case .success(let eventData):
//                self?.events = eventData
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//    func getEventData(eventType: Int, completion: @escaping (Result<[EventData], Error>) -> Void) {
//        let url = URL(string: "https://dev.myhss.org.uk/api/v1/events/eventlist")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        let parameters: [String: Any] = [
//            "event_type": eventType
//        ]
////        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
////        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.httpBody = "event_type=\(eventType)".data(using: .utf8)!
//        
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard let data = data else {
//                completion(.failure(error!))
//                return
//            }
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let result = try decoder.decode(APIResponse<[EventData]>.self, from: data)
//                if result.status {
//                    completion(.success(result.data))
//                } else {
//                    completion(.failure(APIError.message(result.message)))
//                }
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//    
//    
//    
//    
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return events.count
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventTableViewCell
//        let event = events[indexPath.row]
//        cell.eventTitleLabel.text = event.eventTitle
//        cell.eventStartDateLabel.text = event.eventStartDate
//        return cell
//    }
//}
//
//class EventTableViewCell: UITableViewCell {
//    let eventTitleLabel = UILabel()
//    let eventStartDateLabel = UILabel()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        contentView.addSubview(eventTitleLabel)
//        contentView.addSubview(eventStartDateLabel)
//        
//        eventTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
//        eventTitleLabel.numberOfLines = 0
//        eventTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        eventTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
//        eventTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
//        eventTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
//        
//        eventStartDateLabel.font = UIFont.systemFont(ofSize: 14)
//        eventStartDateLabel.textColor = .gray
//        eventStartDateLabel.translatesAutoresizingMaskIntoConstraints = false
//        eventStartDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
//        eventStartDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
//        eventStartDateLabel.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor, constant: 8).isActive = true
//        eventStartDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//}
//
//struct EventData: Decodable {
//    let eventId: String
//    let eventTitle: String
//    let eventStartDate: String
//    
//    enum CodingKeys: String, CodingKey {
//        case eventId = "event_id"
//        case eventTitle = "event_title"
//        case eventStartDate = "event_start_date"
//    }
//
//}
//
//struct APIResponse<T: Decodable>: Decodable {
//let status: Bool
//let message: String
//let data: T
//}
//
//enum APIError: Error {
//case message(String)
//}


