//
//  EventStepVC3.swift
//  MyHHS_iOS
//
//  Created by Patel on 28/04/2023.
//

//import UIKit
//
//class EventStepVC3: UIViewController {
//    @IBOutlet weak var upcomingTableView: UITableView!
//    @IBOutlet weak var pastTableView: UITableView!
//    
//    private var upcomingEvents: [Event] = []
//    private var pastEvents: [Event] = []
//    private var events: [Event] = []
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Set the data sources and delegates for the table views
//        upcomingTableView.dataSource = self
//        upcomingTableView.delegate = self
//        pastTableView.dataSource = self
//        pastTableView.delegate = self
//        
//        // Register the table view cell classes
//        upcomingTableView.register(UITableViewCell.self, forCellReuseIdentifier: "upcomingCell")
//        pastTableView.register(UITableViewCell.self, forCellReuseIdentifier: "pastCell")
//        
//        // Fetch the initial events
//        fetchEvents(timeline: .upcoming, page: 1) // fetch upcoming events
//        fetchEvents(timeline: .past, page: 1) // fetch past events
//    }
//    
//    private func fetchEvents(timeline: Timeline, page: Int) {
//        let url = URL(string: "https://dev.myhss.org.uk/api/v1/events/eventlist")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        let body = "timeline=(timeline.rawValue)&current_page=(page)"
//        
//        request.httpBody = body.data(using: .utf8)
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                print("Error fetching events: \(error)")
//                return
//            }
//            
//            do {
//                let results = try JSONDecoder().decode(EventListing.self, from: data)
//                var sortedEvents = timeline == .upcoming ? results.data.upcoming.events : results.data.past.events
//                
//                let correctOrder = ["event title 2", "event title 5", "event title 7", "event title 8", "event title 10"]
//                sortedEvents.sort { correctOrder.firstIndex(of: $0.eventTitle) ?? Int.max < correctOrder.firstIndex(of: $1.eventTitle) ?? Int.max }
//                
//                self.events = sortedEvents
//            } catch let error {
//                print("Decoding error: \(error)")
//            }
//        }
//        .resume()
//    }
//    
//    // MARK: - Table view data source
//    
//    //    extension EventStepVC3: UITableViewDataSource {
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return events.count
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventCell
//        let event = events[indexPath.row]
//        cell.configure(with: event)
//        return cell
//    }
//    //    }
//    
//    // MARK: - Navigation
//    
//    //    extension EventStepVC3: UITableViewDelegate {
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let event = events[indexPath.row]
//        let detailVC = DetailViewController(event: event)
//        navigationController?.pushViewController(detailVC, animated: true)
//    }
//    //    }
//    
//    // MARK: - Event Cell
//    
//    class EventCell: UITableViewCell {
//        @IBOutlet private weak var eventImageView: UIImageView!
//        @IBOutlet private weak var titleLabel: UILabel!
//        @IBOutlet private weak var dateLabel: UILabel!
//        
//        func configure(with event: Event) {
//            titleLabel.text = event.eventTitle
//            dateLabel.text = "\(event.eventStartDate) - \(event.eventEndDate)"
//            if let imageURL = URL(string: event.eventImg) {
//                DispatchQueue.global().async {
//                    if let imageData = try? Data(contentsOf: imageURL) {
//                        let image = UIImage(data: imageData)
//                        DispatchQueue.main.async {
//                            self.eventImageView.image = image
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    // MARK: - Detail View Controller
//    
//    
//    class DetailViewController: UIViewController {
//        var event: Event
//        
//        let imageView: UIImageView = {
//            let imageView = UIImageView()
//            imageView.contentMode = .scaleAspectFill
//            imageView.layer.cornerRadius = 8
//            imageView.clipsToBounds = true
//            return imageView
//        }()
//        
//        let titleLabel: UILabel = {
//            let label = UILabel()
//            label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
//            label.numberOfLines = 0
//            return label
//        }()
//        
//        let dateLabel: UILabel = {
//            let label = UILabel()
//            label.font = UIFont.systemFont(ofSize: 16)
//            return label
//        }()
//        
//        let descriptionLabel: UILabel = {
//            let label = UILabel()
//            label.font = UIFont.systemFont(ofSize: 16)
//            label.numberOfLines = 0
//            return label
//        }()
//        
//        init(event: Event) {
//            self.event = event
//            super.init(nibName: nil, bundle: nil)
//        }
//        
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//        
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            view.backgroundColor = .white
//            
//            imageView.image = UIImage(named: event.eventImg)
//            view.addSubview(imageView)
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//                imageView.widthAnchor.constraint(equalToConstant: 120),
//                imageView.heightAnchor.constraint(equalToConstant: 120)
//            ])
//            
//            titleLabel.text = event.eventTitle
//            view.addSubview(titleLabel)
//            titleLabel.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
//                titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
//                titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
//            ])
//            
//            dateLabel.text = "\(event.eventStartDate) - \(event.eventEndDate)"
//            view.addSubview(dateLabel)
//            dateLabel.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//                dateLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
//                dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
//            ])
//            
//            descriptionLabel.text = event.eventDetailedDescription
//            view.addSubview(descriptionLabel)
//            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
//                descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//                descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//                descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
//            ])
//        }
//    }
//}
