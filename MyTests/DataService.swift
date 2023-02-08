//
//  DataService.swift
//  MyTests
//
//  Created by Timothy Hart on 2/7/23.
//

import Foundation
import SwiftUI

class DataService : ObservableObject {
    static var shared = DataService()
    
    var serverAddress = ""
    
    @Published var people = [Person]() {
        didSet {
            saveData()
        }
    }
    
    init() {
        loadData()
        var baseAddress = UserDefaults.standard.string(forKey: "baseServerAddress") ?? ""
        serverAddress = baseAddress.appending(":8181")
    }

    func loadData() {
        let ud = UserDefaults.standard
        if let data = ud.data(forKey: "people")  {
            if let decoded = try? JSONDecoder().decode([Person].self, from: data) {
                people = decoded
                return
            }
        }
        
    }
    
    func saveData() {
        var encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let encoded = try? encoder.encode(people) {
            UserDefaults.standard.set(encoded, forKey: "people")
            print("Saved People")
        } else {
            print("Soemthing went wrong")
        }
    }
    
    func setAddress(baseURL: String) {
        UserDefaults.standard.set(baseURL, forKey: "baseServerAddress")
        serverAddress = baseURL.appending(":8181")
        
    }
    
    func addPerson(person: Person) {
        //people.append(person)
        //saveData()
        
        let rawString = "\(serverAddress)/newUser/\(person.email)/\(person.firstName)/\(person.lastName)/\(person.role)/\(person.reasonForVisit)"
        let urlEncoded = rawString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlEncoded ?? "\(serverAddress)")
        //let url = URL(string: "\(serverAddress)/newUser/\(person.email)/\(person.firstName)/\(person.lastName)/\(person.role)/\(person.reasonForVisit)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(String(data: data ?? Data(), encoding: .utf8))
        }
        task.resume()
        
    }
    
    func findPersonWith(email: String) async throws -> ReturnedPerson? {
//        let person = people.first(where: { $0.email == email })
//        print(person)
//        if person == nil {
//            return nil
//        } else {
//            return person
//        }
        let url = URL(string: "\(serverAddress)/findUser/\(email)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"

        var person: ReturnedPerson? = nil
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            var decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            person = try JSONDecoder().decode(ReturnedPerson.self, from: data)
        } catch {
            print("Crap: \(error)")
        }
        
        
        
        return person
    }

    
}
