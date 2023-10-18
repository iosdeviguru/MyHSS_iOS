//
//  ContentView.swift
//  MyHHS_iOS
//
//  Created by Patel on 17/04/2023.
// Directly via Hosting view controller to MainMenu()
// The View that shows the tabbar for the events , it fetches data for upcoming and past events.
//

import SwiftUI

@available(iOS 13.0, *)
struct MainView: View {

  @State private var events: [Event] = []

  //    var user: User // Add this parameter to store the user details

  var body: some View {

    TabView {
      NavigationView {
        if #available(iOS 14.0, *) {
          List(events) { event in
            NavigationLink(destination: DetailView(event: event)) {
              HStack {
                AsyncImage(urlString: event.eventImg)
                  .scaledToFit()
                  .frame(width: 90, height: 90)
                  .cornerRadius(8)

                VStack(alignment: .leading) {
                  Text(event.eventTitle)
                    .font(.headline)
                    .lineLimit(1)
                  HStack {
                    Image(systemName: "calendar")
                    Text("\(event.eventStartDate) - \(event.eventEndDate)")
                      .font(.subheadline)
                  }
                }
              }
              .padding(.vertical, 8)
            }
          }
          .listStyle(.plain)
          .navigationTitle("Upcoming Events")
        } else {
          // Fallback on earlier versions
        }
      }
      .tabItem {
        Image(systemName: "calendar.badge.plus")
        Text("Upcoming")
      }
      .onAppear {
        fetchEvents(timeline: .upcoming, page: 1)
      }

      NavigationView {
        if #available(iOS 14.0, *) {
          List(events) { event in
            NavigationLink(destination: DetailView(event: event)) {
              HStack {
                AsyncImage(urlString: event.eventImg)
                  .scaledToFit()
                  .frame(width: 80, height: 80)
                  .cornerRadius(5)

                VStack(alignment: .leading) {
                  Text(event.eventTitle)
                    .font(.headline)
                    .lineLimit(1)
                  HStack {
                    Image(systemName: "calendar")
                    Text("\(event.eventStartDate) - \(event.eventEndDate)")
                      .font(.subheadline)
                  }
                }
              }
              .padding(.vertical, 8)
            }
          }
          .listStyle(.plain)
          .navigationTitle("Past Events")
        } else {
          // Fallback on earlier versions
        }
      }
      .tabItem {
        Image(systemName: "calendar.badge.minus")
        Text("Past")
      }
      .onAppear {
        fetchEvents(timeline: .past, page: 1)
      }
      //            .navigationBarBackButtonHidden(false)
    }

  }
  public func fetchEvents(timeline: Timeline, page: Int) {
    let url = URL(string: "https://dev.myhss.org.uk/api/v1/events/eventlist")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    let body = "timeline=\(timeline.rawValue)&current_page=\(page)"

    request.httpBody = body.data(using: .utf8)

    URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print("Error fetching events: \(error)")
        return
      }

      do {
        let results = try JSONDecoder().decode(EventListing.self, from: data)
        var sortedEvents =
          timeline == .upcoming ? results.data.upcoming.events : results.data.past.events

        let correctOrder = [
          "event title 2", "event title 5", "event title 7", "event title 8", "event title 10",
        ]
        sortedEvents.sort {
          correctOrder.firstIndex(of: $0.eventTitle) ?? Int.max < correctOrder.firstIndex(
            of: $1.eventTitle) ?? Int.max
        }

        self.events = sortedEvents

      } catch let error {
        print("Decoding error: \(error)")
      }
    }
    .resume()
  }
}

// unsorted function fetchEvents

//
//            do {
//                let results = try JSONDecoder().decode(EventListing.self, from: data)
//                self.events = timeline == .upcoming ? results.data.upcoming.events : results.data.past.events
//            } catch let error {
//                print("Decoding error: \(error)")
//            }
