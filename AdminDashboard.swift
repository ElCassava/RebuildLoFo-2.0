//
//  AdminDashboard.swift
//  RebuildLoFo
//
//  Created by Nicholas  on 16/05/25.
//

import SwiftUI
import SwiftData


struct AdminDashboard: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
//    private var items: [Item] = [Item.dummy, Item.dummy2, Item.dummy3]

    @State private var selectedTab: Int = 0
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @State private var selectedItem: Item? = nil
    @State private var selectedCategory: String? = nil
    @State private var selectedSort: SortOption = .alphabetical
    
    @Binding public var isLoggedIn: Bool
    
    enum SortOption: String, CaseIterable, Identifiable {
        case alphabetical = "Alphabetical"
        case date = "Date"
        
        var id: String { self.rawValue }
    }
    
    let allCategories = ["Accessories", "Clothing", "Electronics", "Documents", "Miscellaneous"]
    
    var filteredItems: [Item] {
        
        var result = selectedTab == 0
        ? items.filter { $0.itemStatus == "Unclaimed" }
        : items.filter { $0.itemStatus == "Claimed" }
        
        if !searchText.isEmpty {
            result = result.filter {$0.itemName.lowercased().contains(searchText.lowercased())}
        }
        if let category = selectedCategory {
            result = result.filter { $0.itemCategory == category }
        }
        
        switch selectedSort {
            case .alphabetical:
                result.sort {$0.itemName.localizedCompare($1.itemName) == .orderedAscending}
            case .date:
                result.sort { $0.dateFound > $1.dateFound }
        }
        
        return result
    }

    var body: some View {
        
        
        NavigationView {
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        NavigationLink(destination: AddItemView()) {
                            Image(systemName: "plus")
                                .foregroundColor(.gray)
                                .font(.system(size: 30))
                                .padding(.leading, 5)
                        }
                                                
                        
                        Spacer()
                        Picker("Item Status", selection: $selectedTab) {
                            Text("Found").tag(0)
                            Text("Claimed").tag(1)
                        }
                        .pickerStyle(.segmented)
                        .tint(Color.red)
                        .frame(width: 260)
                        
                        Spacer()
                        
                        Menu{
                            Section(header: Text("Sort By")) {
                                Button(action: { selectedSort = .alphabetical }) {
                                            Label("Alphabetical", systemImage: selectedSort == .alphabetical ? "checkmark" : "")
                                        }
                                Button(action: { selectedSort = .date }) {
                                    Label("Date", systemImage: selectedSort == .date ? "checkmark" : "")
                                }
                            }
                            
                            Section(header: Text("Filter By")) {
                                Button(action: { selectedCategory = nil }) {
                                            Label("All", systemImage: selectedCategory == nil ? "checkmark" : "")
                                }
                                ForEach(allCategories, id: \.self) { category in
                                    Button(action: {
                                                    selectedCategory = category
                                                }) {
                                                    Label(category, systemImage: selectedCategory == category ? "checkmark" : "")
                                    }
                                }
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "FDEABA"))
                                    .frame(width: 30, height: 30)
                                
                                Image(systemName: "line.3.horizontal.decrease")
                                    .foregroundColor(Color(hex: "E0893D"))
                                    .font(.system(size: 16, weight: .bold))
                            }
                        }
                    }
                    .padding()
                    
                    
                    HStack {
                        NavigationLink(destination: RebuildLofoView(isLoggedIn: false)) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Color(.gray))
                        }

                        
                        HStack{
                            Image(systemName: "magnifyingglass")
                            TextField("Search items...", text: $searchText, onEditingChanged: { isEditing in
                                withAnimation {
                                    isSearching = isEditing
                                }
                            })
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                            .onSubmit {
                                isSearching = true
                            }
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .animation(.easeInOut(duration: 0.2), value: searchText)
                        .padding(10)
                        .background(Color(.white))
                        .cornerRadius(8)
                        
                        
                        if isSearching {
                            Button("Cancel"){
                                withAnimation {
                                    isSearching = false
                                    searchText = ""
                                    
                                    UIApplication.shared.sendAction(#selector(UIResponder.resolveInstanceMethod(_:)), to: nil, from: nil, for: nil)
                                }
                            }
                            .foregroundColor(Color(.black))
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal)
                    
                }
                .padding(.bottom)
                .background(Color(hex: "FBD166"))
            
         
                ScrollView{
                    LazyVStack(spacing: 0){
                        ForEach(filteredItems) { item in
                            Button(action: {
                                selectedItem = item
                            }){
                                ItemCardView(item: item)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                .sheet(item: $selectedItem) { item in
                    ItemCardDetailView(editableItem: item, isLoggedIn: $isLoggedIn)
                }
                
            }
        }
//        .onAppear(){
//            isLoggedIn = true
//        }
    }
}

#Preview {
    @Previewable @State var isLoggedIn = true
    return AdminDashboard(isLoggedIn: $isLoggedIn)
//    AdminDashboard()
//        .modelContainer(for: Item.self, inMemory: true)
}
