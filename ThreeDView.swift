//
//  3DView.swift
//  RebuildLoFo
//
//  Created by Nicholas on 14/05/25.
//

import SwiftUI
import SceneKit

struct ThreeDView: UIViewRepresentable {
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true

        if let sceneURL = Bundle.main.url(forResource: "ModelYogeh", withExtension: "scn"),
           let scene = try? SCNScene(url: sceneURL, options: nil) {
            sceneView.scene = scene
        } else {
            print("⚠️ Failed to load 'ModelYogeh.scn' from bundle")
        }

        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
}


struct ModelViewerScreen: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .topLeading) {
            ThreeDView()
                .edgesIgnoringSafeArea(.all)

            Button(action: {
                dismiss()
            }) {
                Image(systemName: "arrow.left") // You can use "chevron.left" instead
                    .font(.title2)
                    .foregroundColor(Color(hex: "F7C154"))
                    .padding(10)
            }
                .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}
