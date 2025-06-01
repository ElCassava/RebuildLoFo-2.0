//
//  3DView.swift
//  RebuildLoFo
//
//  Created by Nicholas on 14/05/25.
//

import SwiftUI
import SceneKit
import UniformTypeIdentifiers

struct ThreeDView: UIViewRepresentable {
    let usdzURL: URL

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true

        // Load the .usdz file from the provided URL
        if FileManager.default.fileExists(atPath: usdzURL.path) {
            if let scene = try? SCNScene(url: usdzURL, options: nil) {
                sceneView.scene = scene
            } else {
                print("⚠️ Failed to load '\(usdzURL.lastPathComponent)'")
            }
        } else {
            print("⚠️ File '\(usdzURL.lastPathComponent)' not found")
        }

        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
}

struct ModelViewerScreen: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedURL: URL?
    @State private var showPicker = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            if let url = selectedURL {
                ThreeDView(usdzURL: url)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.black.opacity(0.05)
                VStack {
                    Spacer()
                    Button("Select 3D Model (.usdz)") {
                        showPicker = true
                    }
                    .padding()
                    .background(Color(hex: "F7C154"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    Spacer()
                }
            }

            Button(action: {
                dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(Color(hex: "F7C154"))
                    .padding(10)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showPicker) {
            DocumentPickerView { url in
                selectedURL = url
            }
        }
    }
}

struct DocumentPickerView: UIViewControllerRepresentable {
    var onPick: (URL) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType(filenameExtension: "usdz")!], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onPick: (URL) -> Void

        init(onPick: @escaping (URL) -> Void) {
            self.onPick = onPick
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            // Start accessing security-scoped resource if needed
            if url.startAccessingSecurityScopedResource() {
                onPick(url)
                url.stopAccessingSecurityScopedResource()
            } else {
                onPick(url)
            }
        }
    }
}
