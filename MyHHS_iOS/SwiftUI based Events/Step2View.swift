//
//  NextView.swift
//  MyHHS_iOS
//
//  Created by Patel on 27/04/2023.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct Step2View: View {
    @State private var currentStep = 1
    let event2: Event
    @State private var agreedToTerms = false
    
    var body: some View {
        if #available(iOS 14.0, *) {
            ScrollView {
                DottedStepper(steps: ["1", "2", "3"], currentIndex: currentStep)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 16) {
                    Section(header: Text("Summary").bold()) {
                        Text(event2.eventTitle)
                            .font(.headline)
                            .bold()
                        HStack {
                            Image(systemName: "calendar")
                            Text("\(event2.eventStartDate) - \(event2.eventEndDate)")
                                .font(.subheadline)
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    Section(header: Text("Contact").bold()) {
                        Text("Email: \(event2.eventID)")
                        Text("Phone: \(event2.eventContact)")
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    Section(header: Text("Venue").bold()) {
                        Text("Address: \(event2.eventTitle)")
                        Text("Zipcode: \(event2.postalCode)")
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    Section(header: Text("Charges").bold()) {
                        Text(event2.eventChargableOrNot ?? "Free")
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Agreement:")
                            .font(.headline)
                            .bold()
                        
                        Group {
                            Text("• I will be responsible for transportation to and from the SSV site.")
                            Text("• I hereby release Hindu Swayamsevak Sangh (UK) referred to as HSS (UK) and its officers of any liability for any accidents or injuries or loss of personal effects I may incur while travelling to and from SSV and/or while attending the SSV.")
                        }
                        .padding(.leading, 16)
                        
                        HStack {
                            Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                            Button(action: { agreedToTerms.toggle() }) {
                                Text("I understand that the personal data collected will be kept confidential and will be used by HSS (UK) for its activities in accordance with HSS (UK) Privacy Policy. I shall notify HSS (UK) of any changes to my details.")
                            }
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.leading, 16)
                        .onTapGesture {
                            agreedToTerms.toggle()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                }
                .padding(.horizontal)
                
                NavigationLink(destination: Step3View(event3: event2)) {
                    Text("Confirm Registration")
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(30)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 16)
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Step 2")
        } else {
            // Fallback on earlier versions
        }
    }
}
