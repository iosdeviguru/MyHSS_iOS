//
//  RegistrationView.swift
//  MyHHS_iOS
//
//  Created by Patel on 21/04/2023.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct DottedStepper: View {
  // Properties
  let steps: [String]
  let currentIndex: Int

  // View
  var body: some View {
    ScrollView {
      VStack {
        HStack(spacing: 0) {
          ForEach(0..<steps.count) { index in
            Circle()
              .fill(currentIndex >= index ? Color.blue : Color.gray.opacity(0.2))
              .frame(width: 20, height: 20)
              .overlay(
                Text(steps[index])
                  .font(.footnote)
                  .foregroundColor(Color.white)
              )
              .overlay(
                Circle()
                  .stroke(
                    currentIndex >= index ? Color.blue : Color.gray.opacity(0.2), lineWidth: 3)
              )

            if index < steps.count - 1 {
              Rectangle()
                .fill(currentIndex >= index ? Color.blue : Color.gray.opacity(0.2))
                .frame(width: 50, height: 3)
            }
          }
        }
      }

    }
  }
}

@available(iOS 13.0.0, *)
struct Step1View: View {

  // State properties
  @State private var currentStep = 0
  @State private var selectedButton = "self"
  @State private var showMedicalInfo = false
  //    let profileData = ProfileDataModel(dicData: [])

  // API data
  let name = "John Doe"
  let contact = "johndoe@example.com"
  let place = "New York"
  let members = ["Mother", "Father", "Sibling"]

  // Form properties
  @State private var medicalInfo = ""
  @State private var medication = ""

  //    var dicData: [[String : Any]]?
  //    var dicMember: [[String : Any]]?
  let event: Event

  let profileManager = ProfileVC()
  let dicDataModel = _appDelegator.ProfileDataModel
  let dicMemberModel = _appDelegator.ProfileMemberModel

  //    let FamilymemberManager = MyShakhaVC()
  // create an instance of the class that contains the getProfileAPI() function

  var body: some View {

    if #available(iOS 14.0, *) {
      VStack {

        ScrollView {
          VStack {
            DottedStepper(steps: ["1", "2", "3"], currentIndex: currentStep)
              .padding()
          }
          // Buttons view
          HStack {
            Button(
              action: {
                selectedButton = "self"
                //                            profileManager.getProfileAPI()

              },
              label: {
                Text("Self")
                  .foregroundColor(selectedButton == "self" ? .white : .black)
              }
            )
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(selectedButton == "self" ? Color.blue : Color.gray.opacity(0.2))

            Button(
              action: {
                selectedButton = "family"
              },
              label: {
                Text("Family")
                  .foregroundColor(selectedButton == "family" ? .white : .black)
              }
            )
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(selectedButton == "family" ? Color.blue : Color.gray.opacity(0.2))
          }
          .padding()

          // Form view
          VStack(alignment: .leading) {
            if selectedButton == "self" {
              Text((dicDataModel?.username)!)
                .padding()
              Text((dicMemberModel?.email)!)
                .padding()
              Text((dicMemberModel?.city)!)
                .padding()
              TextField("Specify medical info if different from profile", text: $medicalInfo)
                .padding()
              TextField("Medication you take", text: $medication)
                .padding()

            } else {
              if #available(iOS 14.0, *) {
                Picker(selection: .constant(0), label: Text("")) {
                  ForEach(0..<members.count) { index in
                    Text(members[index])
                  }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
              } else {
                // Fallback on earlier versions
              }
              TextField("Specify medical info if different from profile", text: $medicalInfo)
                .padding()
              TextField("Medication you take", text: $medication)
                .padding()
            }
          }
          .padding()

          NavigationLink(destination: Step2View(event2: event)) {
            Text("Next Step")
              .frame(maxWidth: .infinity, minHeight: 60)
              .foregroundColor(.white)
              .background(Color.blue)
              .cornerRadius(30)
              .padding(.bottom, 20)
              .padding(.horizontal, 5)
          }
        }

      }
      .navigationTitle("Step 1")
    } else {
      // Fallback on earlier versions
    }

  }
}
