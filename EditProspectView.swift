//
//  EditProspectView.swift
//  NewProspects
//
//  Created by Adrino Rosario on 22/12/24.
//

import SwiftUI

struct EditProspectView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    var prospect: Prospects
    
    @State private var name: String = ""
    @State private var emailAddress: String = ""
    @State private var mobile: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Prospect name", text: $name)
                    .font(.title)
                TextField("Prospect email address", text: $emailAddress)
                    .font(.title)
                TextField("Prospect mobile number", text: $mobile)
                    .font(.title)
            }
            .navigationTitle("Edit \(prospect.name)'s Details")
            .toolbar {
                Button("Save") {
                    updateProspect()
                    dismiss()
                }
            }
            .navigationBarBackButtonHidden()
        }
        .onAppear(perform: updateStateDetails)
    }
    
    func updateProspect() {
        let updatedProspect = Prospects(name: name, mobile: mobile, emailAddress: emailAddress, dateCreated: prospect.dateCreated, isContacted: prospect.isContacted)
        modelContext.delete(prospect)
        modelContext.insert(updatedProspect)
    }
    
    func updateStateDetails() {
        name = prospect.name
        emailAddress = prospect.emailAddress
        mobile = prospect.mobile
    }
}

#Preview {
    EditProspectView(prospect: Prospects(name: "Adrino", mobile: "94820481", emailAddress: "you@yoursite.com", dateCreated: Date.now, isContacted: false))
}
