//
//  ProspectsView.swift
//  NewProspects
//
//  Created by Adrino Rosario on 21/12/24.
//

import CodeScanner
import SwiftData
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Prospects.name) var prospects: [Prospects]
    
    enum FilterType {
        case everyone, isContacted, isNotContacted
    }
    
    var filter: FilterType
    
    @State private var sortByDate = false
    
    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<Prospects>()
    
    private var title: String {
        switch filter {
        case .everyone:
            "Everyone"
        case .isContacted:
            "Contacted"
        case .isNotContacted:
            "Uncontacted"
        }
    }
    
    var body: some View {
        NavigationStack {
            List(prospects, selection: $selectedProspects) { prospect in
                NavigationLink {
                    EditProspectView(prospect: prospect)
                } label: {
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline) + Text(" ") +
                        
                        Text(Image(systemName: prospect.isContacted ? "checkmark.circle.fill" : "exclamationmark.circle.fill"))
                            .foregroundStyle(prospect.isContacted ? .blue : .red)
                            .font(.title3)
                        
                        
                        Text(prospect.emailAddress)
                            .foregroundStyle(.secondary)
                    }
                    .swipeActions(edge: .leading) {
                        Button("Notify", systemImage: "bell") {
                            addNotification(for: prospect)
                        }
                        .tint(.orange)
                        Button("Message prospect", systemImage: "plus.message") {
                            // send message
                        }
                        .tint(.purple)
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            modelContext.delete(prospect)
                        }
                        
                        if prospect.isContacted {
                            Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                                prospect.isContacted.toggle()
                            }
                            .tint(.blue)
                        } else {
                            Button("Mark Contacted", systemImage: "person.crop.circle.badge.checkmark") {
                                prospect.isContacted.toggle()
                            }
                            .tint(.green)
                        }
                    }
                    .tag(prospect)
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sort prospects by", systemImage: "arrow.up.arrow.down") {
                        sortByDate.toggle()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Scan Qr Code", systemImage: "qrcode.viewfinder") {
                        isShowingScanner = true
                    }
                }
                
                if selectedProspects.isEmpty == false {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Delete selected prospects") {
                            delete()
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Adrino Rosario James\nadrino@gmail.com\n+91 12345 67809" , completion: handleScan)
            }
        }
    }
    
    init(filter: FilterType) {
        self.filter = filter
        
        let sortDescriptor = sortByDate ? SortDescriptor(\Prospects.dateCreated, order: .forward) : SortDescriptor(\Prospects.name)
        
        if filter != .everyone {
            let showContactedOnly = filter == .isContacted
            
            _prospects = Query(filter: #Predicate<Prospects> {
                $0.isContacted == showContactedOnly
            }, sort: [sortDescriptor])
        } else {
            _prospects = Query(sort: [sortDescriptor])
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let success):
            let details = success.string.components(separatedBy: "\n")
            guard details.count == 3 else { return }
            
            let person = Prospects(name: details[0], mobile: details[2], emailAddress: details[1], dateCreated: Date.now, isContacted: false)
            
            modelContext.insert(person)
        case .failure(let failure):
            print("Error: \(failure.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospects) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = "\(prospect.emailAddress)"
            content.sound = .default
            
//            var dateComponents = DateComponents()
//            dateComponents.hour = 9
//            dateComponents.minute = 30
//            
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.badge, .alert]) { success, error in
                    if success {
                        addRequest()
                    } else if let error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func delete() {
        for items in selectedProspects {
            modelContext.delete(items)
        }
    }
}

#Preview {
    ProspectsView(filter: .everyone)
        .modelContainer(for: Prospects.self)
}
