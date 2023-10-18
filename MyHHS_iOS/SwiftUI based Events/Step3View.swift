//
//  Step3View.swift
//  MyHHS_iOS
//
//  Created by Patel on 27/04/2023.
//


import SwiftUI

@available(iOS 13.0, *)
struct Step3View: View {
    @State private var currentStep = 3
    let event3: Event
    let profileManager = ProfileVC()
    let dicDataModel = _appDelegator.ProfileDataModel
    let dicMemberModel = _appDelegator.ProfileMemberModel
    @State private var shouldShowMainView = false
    @Environment(\.presentationMode) var presentationMode

    // Add these properties to store the registration response and error
    //    @State private var registrationResponse: RegistrationResponse?
    @State private var registrationError: Error?

    var body: some View {
        if #available(iOS 14.0, *) {
            ScrollView {
                DottedStepper(steps: ["1", "2", "3"], currentIndex: currentStep)
                    .padding(.top, 20)

                VStack(spacing: 20) {
                    Text("Thank you for\nRegistration")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.top, 40)
                        .padding(.bottom, 10)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.green)
                        .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .padding(.top, 20)

                VStack(alignment: .center, spacing: 20) {
                    Image("QRcodemyhss")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .padding()

                    Text("Order Id: \(event3.eventID)0001110515")
                        .font(.title3)
                        .bold()
                        .padding()

                    Text((dicDataModel?.username)!)
                        .font(.title3)
                        .padding()

                    Text((dicDataModel?.member_id)!)
                        .font(.title3)
                        .padding()

                    HStack(alignment: .top) {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                        Text("Start date:")
                            .fontWeight(.bold)
                        Text(event3.eventStartDate)
                    }
                    .padding(.bottom)

                    HStack(alignment: .top) {
                        Image(systemName: "calendar.badge.clock")
                            .foregroundColor(.blue)
                        Text("End date:")
                            .fontWeight(.bold)
                        Text(event3.eventEndDate)
                    }
                    .padding(.bottom)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Building Name: \(event3.buildingName)")
                        Text(
                            "Address: \(event3.addressLine1), \(event3.addressLine2), \(event3.city ?? "City"), \(event3.postalCode), \(event3.country ?? "Country")"
                        )
                    }
                    .padding()

                    //Normal button implementation
                    Button("Complete & Go to List of Events") {
                        shouldShowMainView = true
                        //                        presentationMode.wrappedValue.dismiss()

                    }
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(30)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                    //                    .fullScreenCover(isPresented: $shouldShowMainView) {
                    //                        MainView()
                    //
                    //                    }
                    
                    // API button implementation

                    //                    Button("Complete & Go to List of Events") {
                    //                        shouldShowMainView = true
                    //
                    //                        let memberId = dicDataModel?.member_id ?? ""
                    //                        let eventId = "\(event3.eventID)"
                    ////                        let medicalInfo = profileManager.medicalInfoTextField.text ?? ""
                    //
                    //                        let parameters = [
                    //                            "event_id": eventId,
                    //                            "member_attendance_type": "F",
                    //                            "member_id": memberId,
                    ////                            "member_additional_medical_info": medicalInfo,
                    //                            "reg_payment_status": "0"
                    //                        ]
                    //
                    //                        let urlString = "https://dev.myhss.org.uk/api/v1/events/memberregister"
                    //
                    //                        guard let url = URL(string: urlString) else {
                    //                            print("Invalid URL")
                    //                            return
                    //                        }
                    //
                    //                        var request = URLRequest(url: url)
                    //                        request.httpMethod = "POST"
                    //
                    //                        do {
                    //                            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    //                        } catch let error {
                    //                            print(error.localizedDescription)
                    //                            return
                    //                        }
                    //
                    //                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    //                        request.addValue("Bearer YOUR_AUTH_TOKEN", forHTTPHeaderField: "Authorization")
                    //
                    //                        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    //                            if let error = error {
                    //                                print(error.localizedDescription)
                    //                                return
                    //                            }
                    //
                    //                            guard let data = data else {
                    //                                print("No data received")
                    //                                return
                    //                            }
                    //
                    //                            do {
                    //                                let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //                                print(json)
                    //                                // Handle the response from the server here
                    //                            } catch let error {
                    //                                print(error.localizedDescription)
                    //                                return
                    //                            }
                    //                        }
                    //
                    //                        task.resume()
                    //                    }



                }

              }
              .navigationBarTitleDisplayMode(.inline)
              .navigationTitle("Registration Complete!")

            } else {
              // Fallback on earlier versions
            }

          }
        }



