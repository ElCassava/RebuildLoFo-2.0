//
//  AddItemView.swift
//  RebuildLoFo
//
//  Created by Nicholas  on 27/05/25.
//

import SwiftData
import UIKit
import SwiftUI
import Foundation


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType = .camera
    
    @Environment(\.dismiss) public var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.modalPresentationStyle = .fullScreen
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // nothing needed here
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}


struct AddItemView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
        
    @State public var itemName = ""
    @State public var itemDescription = ""
    @State public var itemCategory = "Accessories"
    @State public var locationFound = ""
    @State public var dateFound = Date()
    
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera

    
    
    let allCategories = ["Accessories", "Clothing", "Electronics", "Documents", "Miscellaneous"]

    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Item Name", text: $itemName)
                    Picker("Category", selection: $itemCategory) {
                        ForEach(allCategories, id: \.self) { category in
                            Text(category)
                        }
                        
                    }
                    .pickerStyle(.menu)

                    DatePicker("Date Found", selection: $dateFound, displayedComponents: .date)
                    TextField("Location Found", text: $locationFound)
                    TextField("Description", text: $itemDescription)
                }
                
                Section(header: Text("Add Image")) {
//                    VStack {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .padding(.vertical)
                                .onTapGesture {
                                    showImagePicker = true
                                }
                        } else {
                            Button(action: {
                                sourceType = .camera
                                showImagePicker = true
                            }) {
                                Text("Take Photo")
                            }
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                            
                            Button(action: {
                                sourceType = .photoLibrary
                                showImagePicker = true
                            }){
                                Text("Select from Library")
                            }
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                            
                            
                        }
                }
                
                Section(header: Text("Add model")) {
                    NavigationLink(destination:
                            ContentView()

                    ) {
                        Text("Add Model")
                    }
                                    }
                
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)

                        
                        let newItem = Item(
//                            id: UUID(),
                            dateFound: dateFound,
                            dateClaimed: Date(),
                            itemName: itemName,
                            itemDescription: itemDescription,
                            itemCategory: itemCategory,
                            locationFound: locationFound,
                            itemStatus: "Unclaimed",
                            claimerName: "",
                            claimerContact: "",
                            imageData: imageData
//                            isClaimed: false
                        )
                        modelContext.insert(newItem)
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .disabled(itemName.isEmpty || itemCategory.isEmpty || locationFound.isEmpty)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage, sourceType: sourceType)
        }

    }
}

//#Preview {
//    AddItemView()
//}
