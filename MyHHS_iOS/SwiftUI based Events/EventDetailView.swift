//
//  EventDetailView.swift
//  MyHHS_iOS
//
//  Created by Patel on 21/04/2023.
//

import MapKit
import SwiftUI

struct DetailView: View {
  let event: Event

    @available(iOS 13.0.0, *)
    var body: some View {
    if #available(iOS 14.0, *) {
      ScrollView {

        VStack {
          AsyncImage(urlString: event.eventImgDetail)
            .frame(width: UIScreen.main.bounds.width - 40, height: 250)
            .padding()

          Text(event.eventTitle)
            .font(.largeTitle)
            .padding(.bottom)
        }.padding()
        VStack(alignment: .leading, spacing: 20) {

          HStack(alignment: .top) {
            Image(systemName: "calendar")
            Text("Start date:")
              .fontWeight(.bold)
            Text(event.eventStartDate)
          }
          .padding(.bottom)

          HStack(alignment: .top) {
            Image(systemName: "calendar.badge.clock")
            Text("End date:")
              .fontWeight(.bold)
            Text(event.eventEndDate)
          }
          .padding(.bottom)

          VStack(alignment: .leading, spacing: 10) {
            HStack {
              Image(systemName: "location")
              Text("Location:")
                .fontWeight(.bold)
            }

            VStack(alignment: .leading, spacing: 10) {
              Text("Building Name: \(event.buildingName)")
              Text("Address Line 1: \(event.addressLine1)")
              Text("Address Line 2: \(event.addressLine2)")
              Text("City: \(event.city ?? "City")")
              Text("Postal Code: \(event.postalCode)")
              Text("Country: \(event.country ?? "Country")")

            }

          }
          .padding(.bottom)

          VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
              Image(systemName: "dollarsign.circle")
              Text("Fees:")
                .fontWeight(.bold)
              Text(event.eventChargableOrNot ?? "Free")
            }.padding(.bottom)

          }

          HStack(alignment: .top) {
            Image(systemName: "doc.text")
            Text("Description:")
              .fontWeight(.bold)
          }
          Text(event.eventDetailedDescription)

          NavigationLink(destination: Step1View(event: event)) {
            Text("Register")
              .frame(maxWidth: .infinity, minHeight: 60)
              .foregroundColor(.white)
              .background(Color.blue)
              .cornerRadius(30)
              .padding(.bottom, 20)
              .padding(.horizontal, 5)
          }

        }
        .padding(.horizontal, 20)
        .navigationBarTitleDisplayMode(.inline)
      }
    } else {
      // Fallback on earlier versions
    }
  }
}
