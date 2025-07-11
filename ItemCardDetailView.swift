//
//  ItemCardDetailView.swift
//  RebuildLoFo
//
//  Created by Nicholas  on 13/05/25.
//

import SwiftUI

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    var iconColor: Color = Color(hex: "F7C154")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack(alignment: .top, spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 20)
                Text(value)
                    .font(.body)
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct EditableDetailRow: View {
    @State var icon: String
    @State var title: String
    @Binding var value: String
    var iconColor: Color = Color(hex: "F7C154")

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)

            HStack(alignment: .top, spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 20)

                TextField("Enter \(title)", text: $value)
                    .font(.body)
                    .foregroundColor(.black)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}

struct DatePickerRow: View {
    let icon: String
    let title: String
    @Binding var date: Date
    var iconColor: Color = Color(hex: "F7C154")

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)

            HStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 20)

                DatePicker("", selection: $date, displayedComponents: [.date])
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct ItemCardDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var editableItem: Item
    let columns = [
        GridItem(.flexible(), spacing: 24),
        GridItem(.flexible())
        ]
    
    @Binding public var isLoggedIn: Bool

    // Store the selected USDZ file URL as a bookmark for persistence
    @State private var usdzURL: URL?
    @State private var showPicker = false

    // Helper to get a unique key for the item (use a better unique id if available)
    private var usdzBookmarkKey: String { "usdzBookmark-\(editableItem.itemName)" }

    // Load the bookmark if available
    private func loadUSDZURL() {
        if let data = UserDefaults.standard.data(forKey: usdzBookmarkKey) {
            var isStale = false
            if let url = try? URL(resolvingBookmarkData: data, options: [], bookmarkDataIsStale: &isStale), !isStale {
                usdzURL = url
            }
        }
    }

    // Save the bookmark for the selected URL
    private func saveUSDZURL(_ url: URL) {
        if let data = try? url.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil) {
            UserDefaults.standard.set(data, forKey: usdzBookmarkKey)
            usdzURL = url
        }
    }

    var body: some View {
        NavigationView{
            ScrollView{
                
                Capsule()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 40, height: 5)
                    .padding(.top, 10)
                
                VStack{
                    HStack{
                        Text("Item Detail")
                        Spacer()
                        
                        Button(action: {
                            dismiss()
                        }){
                            Image(systemName: "xmark.circle")
                                .foregroundColor(Color(hex: "F7C154"))
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 25)
                    
                    ZStack {
                        if let imageData = editableItem.imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 300, height: 300)
                                .cornerRadius(20)
                        }

                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                // Admin logic
                                if isLoggedIn {
                                    if let url = usdzURL {
                                        HStack(spacing: 8) {
                                            NavigationLink(
                                                destination: ThreeDView(usdzURL: url),
                                                label: {
                                                    Image("3DButton")
                                                        .padding(10)
                                                }
                                            )
                                            Button(action: {
                                                showPicker = true
                                            }) {
                                                Image(systemName: "arrow.clockwise.circle.fill")
                                                    .font(.system(size: 25))
                                                    .padding(10)
                                            }
                                        }
                                    } else {
                                        Button(action: {
                                            showPicker = true
                                        }) {
                                            Image("3DButton")
                                                .padding(10)
                                        }
                                    }
                                } else {
                                    // User logic
                                    if let url = usdzURL {
                                        NavigationLink(
                                            destination: ThreeDView(usdzURL: url),
                                            label: {
                                                Image("3DButton")
                                                    .padding(10)
                                            }
                                        )
                                    }
                                    // else: show nothing if no model
                                }
                            }
                        }
                        .frame(width: 300, height: 300)
                    }
                    if(isLoggedIn == false){
                        if(editableItem.itemStatus == "Unclaimed"){
                            VStack (alignment: .leading, spacing: 20){
                                LazyVGrid(columns: columns ,alignment: .leading, spacing: 20) {
                                    DetailRow(icon: "cube.box.fill", title: "Item", value: editableItem.itemName)
                                    DetailRow(icon: "tag.fill", title: "Category", value: editableItem.itemCategory)
                                    DetailRow(icon: "calendar", title: "Date Found", value: formattedDate(editableItem.dateFound))
                                    DetailRow(icon: "clock.fill", title: "Status", value: editableItem.itemStatus)
                                    DetailRow(icon: "location.fill", title: "Found At", value: editableItem.locationFound)
                                    DetailRow(icon: "mappin", title: "Claim At", value: editableItem.locationClaimed)
                                }
                                DetailRow(icon: "doc.text", title: "Description", value: editableItem.itemDescription)
                            }
                            .padding(.horizontal)
                            .padding()
                            .padding(.leading, 20)
                        }
                        else{
                            VStack (alignment: .leading, spacing: 20){
                                LazyVGrid(columns: columns ,alignment: .leading, spacing: 20) {
                                    DetailRow(icon: "cube.box.fill", title: "Item", value: editableItem.itemName)
                                    DetailRow(icon: "tag.fill", title: "Category", value: editableItem.itemCategory)
                                    DetailRow(icon: "calendar", title: "Date Found", value: formattedDate(editableItem.dateFound))
                                    DetailRow(icon: "checkmark.circle.fill", title: "Status", value: editableItem.itemStatus, iconColor: .green)
                                    DetailRow(icon: "calendar", title: "Date Claimed", value: formattedDate(editableItem.dateClaimed))
                                    DetailRow(icon: "location.fill", title: "Found At", value: editableItem.locationFound)
                                    DetailRow(icon: "person.fill", title: "Claimer", value: editableItem.claimerName)
                                    DetailRow(icon: "phone.fill", title: "Claimer Contact", value: editableItem.claimerContact)
                                    
                                }
                                DetailRow(icon: "doc.text", title: "Description", value: editableItem.itemDescription)
                            }
                            .padding(.horizontal)
                            .padding()
                            .padding(.leading, 20)
                            
                        }
                        
                    }
                    else {
                        if(editableItem.itemStatus == "Unclaimed"){
                            VStack (alignment: .leading, spacing: 20){
                                LazyVGrid(columns: columns ,alignment: .leading, spacing: 20) {
                                    EditableDetailRow(icon: "cube.box.fill", title: "Item", value: $editableItem.itemName)
                                    EditableDetailRow(icon: "tag.fill", title: "Category", value: $editableItem.itemCategory)
                                    DatePickerRow(icon: "calendar", title: "Date Found", date: $editableItem.dateFound)
                                    EditableDetailRow(icon: "clock.fill", title: "Status", value: $editableItem.itemStatus)
                                    EditableDetailRow(icon: "location.fill", title: "Found At", value: $editableItem.locationFound)
                                    EditableDetailRow(icon: "mappin", title: "Claim At", value: $editableItem.locationClaimed)
                                    
                                    if(editableItem.itemStatus == "Claimed"){
                                        DatePickerRow(icon: "calendar", title: "Date Claimed", date: $editableItem.dateClaimed)
                                        EditableDetailRow(icon: "location.fill", title: "Found At", value: $editableItem.locationFound)
                                        EditableDetailRow(icon: "person.fill", title: "Claimer", value: $editableItem.claimerName)
                                        EditableDetailRow(icon: "phone.fill", title: "Claimer Contact", value: $editableItem.claimerContact)
                                    }
                                    
                                }
                                EditableDetailRow(icon: "doc.text", title: "Description", value: $editableItem.itemDescription)
                            }
                            .padding(.horizontal)
                            .padding()
                            .padding(.leading, 20)
                        }
                        else{
                            VStack (alignment: .leading, spacing: 20){
                                LazyVGrid(columns: columns ,alignment: .leading, spacing: 20) {
                                    EditableDetailRow(icon: "cube.box.fill", title: "Item", value: $editableItem.itemName)
                                    EditableDetailRow(icon: "tag.fill", title: "Category", value: $editableItem.itemCategory)
                                    DatePickerRow(icon: "calendar", title: "Date Found", date: $editableItem.dateFound)
                                    EditableDetailRow(icon: "checkmark.circle.fill", title: "Status", value: $editableItem.itemStatus, iconColor: .green)
                                    DatePickerRow(icon: "calendar", title: "Date Claimed", date: $editableItem.dateClaimed)
                                    EditableDetailRow(icon: "location.fill", title: "Found At", value: $editableItem.locationFound)
                                    EditableDetailRow(icon: "person.fill", title: "Claimer", value: $editableItem.claimerName)
                                    EditableDetailRow(icon: "phone.fill", title: "Claimer Contact", value: $editableItem.claimerContact)
                                    
                                }
                                EditableDetailRow(icon: "doc.text", title: "Description", value: $editableItem.itemDescription)
                            }
                            .padding(.horizontal)
                            .padding()
                            .padding(.leading, 20)
                            
                            
                            
                        }
                        Button(action: {
                            // Save logic here, e.g., update CloudKit, CoreData, etc.
                            dismiss()
                        }) {
                            Text("Update")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "F7C154"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                    
                }
                .padding(.top, 20)
            }
            
        }
        .onAppear {
            loadUSDZURL()
        }
        .sheet(isPresented: $showPicker) {
            DocumentPickerView { url in
                // Save bookmark and update state
                saveUSDZURL(url)
            }
        }
    }
    
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    ItemCardDetailView(editableItem: Item.dummy, isLoggedIn:.constant(false))
}

