//
//  SignInView.swift
//  MyTests
//
//  Created by Timothy Hart on 2/7/23.
//

import Foundation
import SwiftUI

struct SignInView: View {
    
    //@AppStorage("fname") var textFieldFName = ""
    @StateObject var dataService = DataService.shared
    
    @State var textFieldEmail: String = ""
    @State var textFieldFName: String = ""
    @State var textFieldLName: String = ""
    @State var textFieldReason: String = ""
    @State var selection = 0
    
    let roleOptions: [String] = ["Student", "Faculty", "Staff", "Community"]
    @State var role = "Student"
    @State var showAlert = false
    
    init() {
        //this changes the "thumb" that selects between items
        //UISegmentedControl.appearance().selectedSegmentTintColor = .blue
        //and this changes the color for the whole "bar" background
        //UISegmentedControl.appearance().backgroundColor = .purple

        //this will change the font size
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .title2)], for: .normal)

        //these lines change the text color for various states
        //UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.blue], for: .selected)
        //UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.blue], for: .normal)
    }
    

    
    var body: some View {
        Text("SIGN IN")
            .font(.system(size: 76)).bold()
            .foregroundColor(.white)
        Text("iCarolina Lab")
            .font(.system(size: 36))
            .foregroundColor(.white)
        VStack(alignment: .leading, spacing: 20) {
            //Spacer()
            HStack {
                //Image(systemName: "magnifyingglass").foregroundColor(.white)
                
                TextField("Enter email address", text: $textFieldEmail).padding()
                    .frame(width: 400, height: 55).background(.white).cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                Button(action: {
                    Task {
                        let person = try await dataService.findPersonWith(email: textFieldEmail)
                        
                        if person == nil {
                         print("No user found")
                        } else {
                            textFieldFName = person?.firstName ?? ""
                            textFieldLName = person?.lastName ?? ""
                            textFieldReason = person?.reasonForVisit ?? ""
                            let role = person?.role ?? ""
                            print(role)
                            switch role {
                            case "Student":
                                selection = 0
                            case "Faculty":
                                selection = 1
                            case "Staff":
                                selection = 2
                            case "Community":
                                selection = 3
                            default:
                                print("This should never happen.")
                            }
                        
                        }
                        
                    }
                    
                    
                }, label: {
                    Image(systemName: "magnifyingglass").foregroundColor(.white)
                        .font(.title)
                })
                
                
                
            }
            TextField("Enter First Name", text: $textFieldFName)
                .modifier(DefaultButtonViewModifier())
            
            TextField("Enter Last Name", text: $textFieldLName)
                .modifier(DefaultButtonViewModifier())
            
            TextField("Enter reason for your visit", text: $textFieldReason)
            
                .modifier(DefaultButtonViewModifier())
            
            Picker("",selection: $selection) {
                
                Text("Student").tag(0)
                Text("Faculty").tag(1)
                Text("Staff").tag(2)
                Text("Community").tag(3)
            }.pickerStyle(SegmentedPickerStyle())
                .frame(height: 45)
                //.scaledToFit()
                //.scaleEffect(CGSize(width: 1.0, height: 1.3))
                .background(.gray).cornerRadius(10)
               
        
            Text("Selected: " + roleOptions[selection])
                .foregroundColor(.white)
            
            HStack {
                //Spacer()
                Button(action: {
                    print("Button action")
                    
                    
                    textFieldEmail = ""
                    textFieldFName = ""
                    textFieldLName = ""
                    textFieldReason = ""
                    selection = 0
                    
                    
                }) {
                    HStack {
                        Image(systemName: "xmark.square.fill").foregroundColor(.red)
                        Text("Cancel").foregroundColor(.white).padding()
                    }.padding(.horizontal, 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20.0)
                            .stroke(lineWidth: 2.0)
                    )
                }.padding(.horizontal, 70)
                
                Button(action: {
                    if textFieldEmail == "" {
                        showAlert = true
                        return
                    }
                    
                    var localRole = ""
                    switch selection {
                    case 0:
                        localRole = "Student"
                    case 1:
                        localRole = "Faculty"
                    case 2:
                        localRole = "Staff"
                    case 3:
                        localRole = "Community"
                    default:
                        print("This should never happen.")
                    }
                    
                    let newPerson = Person(id: "001", firstName: textFieldFName, lastName: textFieldLName, email: textFieldEmail, role: localRole, reasonForVisit: textFieldReason, date: Date())
                    DataService.shared.addPerson(person: newPerson)
                    
                    textFieldEmail = ""
                    textFieldFName = ""
                    textFieldLName = ""
                    textFieldReason = ""
                    
                    
                }) {
                    HStack{
                        
                        Image(systemName: "person.circle").foregroundColor(.green)
                        Text("Save and Submit").foregroundColor(.white).padding()
                    } .padding(.horizontal,20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20.0)
                            .stroke(lineWidth: 2.0)
                    )
                }
                .alert("Enter a valid email", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                }
                //.padding(50)
            }
            //.frame(width: 500, height: 15).padding(20)
            
            //.padding(.vertical,35)
            //Spacer()
        }
        .frame(width:600)
        //.background(.gray)
        

        
    }
}
