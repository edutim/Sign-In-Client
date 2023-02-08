
//  ContentView.swift
//  MyTests
//
//  Created by Chris Maggio on 11/12/22.
//

import SwiftUI

extension UISegmentedControl {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setContentHuggingPriority(.defaultLow, for: .vertical)  // << here !!
    }
}

struct ContentView: View {
    @State var myBackGround = Color.white
    @State var textFieldFName: String = ""
    @State var textFieldLName: String = ""

    @State var textFieldReason: String = ""
    @State var myData: [String] = []
    @State var randPic = "USCL"
    @State var selection: String = "Student"
    
    let roleOptions: [String] = ["Student", "Faculty", "Staff", "Community"]
    @State var role = "Student"
    
    @State var showSettings = false
    @State var settingsPassword = "1234" // This is is the password to get into the settings. Should be only numbers.
    @State var settingsPasswordText = ""
    @State var showSettingsAlert = false

    var body: some View {
        
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
            myBackground
            
            VStack {
                Spacer()
                Text("version 1.0")
                    .foregroundColor(.white)
                    .onTapGesture() {
                        showSettingsAlert = true
                    }
                    .alert("Settings Password", isPresented: $showSettingsAlert) {
                        TextField("Enter your name", text: $settingsPasswordText)
                            .keyboardType(.numberPad)
                        Button("OK") {
                            if settingsPassword == settingsPasswordText {
                                showSettings = true
                                settingsPasswordText = ""
                            } else {
                                
                            }
                        }
                    }
                    .sheet(isPresented: $showSettings, content: {
                        SettingsView()
                    })
                
                myView
                
                SignInView()
                                
                Spacer()
                Spacer()
                
            }
        }
   
    }
    var myBackground: some View {
        Image("BK")
            .resizable()
            .scaledToFit()
       
    }
    var myView: some View {
        
        Image("Salk")
            .resizable()
            .scaledToFit()
            .padding(45)
            .background(.white)
            .cornerRadius(10)
    
            .frame(width:600, height: 200)
            .border(.gray).cornerRadius(10)
            
    
    }

        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct DefaultButtonViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: 300, height: 50)
            
            .background(.white).cornerRadius(10)
            //.padding()
           
            .font(.headline)

    }
}
