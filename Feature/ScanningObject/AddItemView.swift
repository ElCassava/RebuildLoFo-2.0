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
import RealityKit
import CloudKit

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
    @State private var show3DScanner = false
    @State private var usdzFileURL: URL? = nil
    @State private var isUploading = false
    @State private var uploadError: String? = nil

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
                    if ObjectCaptureSession.isSupported {
                        Button(action: {
                            show3DScanner = true
                        }) {
                            Text("Add Model")
                        }
                        if let url = usdzFileURL {
                            Text("Model ready: \(url.lastPathComponent)")
                                .font(.caption)
                        }
                    } else {
                        Text("3D scanning is not supported on this device.")
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }
                
                if isUploading {
                    ProgressView("Uploading model to CloudKit...")
                }
                if let uploadError {
                    Text("Upload error: \(uploadError)")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)

                        let newItem = Item(
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
                        )
                        modelContext.insert(newItem)
                        
                        if let usdzURL = usdzFileURL {
                            uploadUSDZToCloudKit(usdzURL: usdzURL)
                        }
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
        .sheet(isPresented: $show3DScanner) {
            ContentView()
                .environment(AppDataModel.instance)
        }
    }

    private func uploadUSDZToCloudKit(usdzURL: URL) {
        isUploading = true
        uploadError = nil
        let record = CKRecord(recordType: "Model")
        record["modelFile"] = CKAsset(fileURL: usdzURL)
        record["itemName"] = itemName as CKRecordValue
        record["dateFound"] = dateFound as CKRecordValue

        let privateDB = CKContainer.default().privateCloudDatabase
        privateDB.save(record) { _, error in
            DispatchQueue.main.async {
                self.isUploading = false
                if let error = error {
                    self.uploadError = error.localizedDescription
                }
            }
        }
    }
}
