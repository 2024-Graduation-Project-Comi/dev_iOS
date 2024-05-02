//
//  testView.swift
//  Comi
//
//  Created by yimkeul on 5/1/24.
//

import SwiftUI
struct Contact: Identifiable {
    var id = UUID()
    var name: String
    var phoneNumber: String
    var email: String
}




struct ContactRow: View {
    var contact: Contact

    var body: some View {
        NavigationLink(destination: ContactDetail(contact: contact)) {
            VStack(alignment: .leading) {
                Text(contact.name)
                    .font(.headline)
                Text(contact.phoneNumber)
                    .font(.subheadline)
                Text(contact.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ContactDetail: View {
    var contact: Contact

    var body: some View {
        VStack(alignment: .leading) {
            Text(contact.name)
                .font(.title)
            Divider()
            Text("Phone: \(contact.phoneNumber)")
                .font(.headline)
            Text("Email: \(contact.email)")
                .font(.headline)
        }
            .padding()
            .navigationBarTitle(Text(contact.name), displayMode: .inline)
    }
}

struct testView: View {
    @State private var contacts = [
        Contact(name: "John Doe", phoneNumber: "123-456-7890", email: "john@example.com"),
        Contact(name: "Jane Smith", phoneNumber: "987-654-3210", email: "jane@example.com"),
        Contact(name: "Michael Johnson", phoneNumber: "555-123-4567", email: "michael@example.com"),
        Contact(name: "Emily Brown", phoneNumber: "444-789-0123", email: "emily@example.com"),
        Contact(name: "Daniel Wilson", phoneNumber: "222-333-4444", email: "daniel@example.com")
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedContacts, id: \.0) { firstLetter, contactsInSection in
                    Section(header: Text(firstLetter)) {
                        ForEach(contactsInSection) { contact in
                            ContactRow(contact: contact)
                        }
                    }
                }
            }
            .navigationTitle("Contacts")
        }
    }
    
    private var groupedContacts: [(String, [Contact])] {
        let groupedDictionary = Dictionary(grouping: contacts) { String($0.name.prefix(1)).uppercased() }
        return groupedDictionary.sorted { $0.0 < $1.0 }
    }
}

#Preview {
    testView()
}

