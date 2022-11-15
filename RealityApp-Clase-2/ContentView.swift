//
//  ContentView.swift
//  RealityApp-Clase-2
//
//  Created by Jose Castillo on 11/11/22.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        NavigationView() {
            ARViewContainer()
                .navigationTitle("AR APP")
                .navigationBarTitleDisplayMode(.inline)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ARViewContainer : UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ARViewContainer>) -> ARViewController {
        
        let viewController = ARViewController()
        return viewController
        
    }
    
    func updateUIViewController(_ uiView: ARViewController, context: UIViewControllerRepresentableContext<ARViewContainer>) {
        
        
        
    }
    
}

#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
#endif
