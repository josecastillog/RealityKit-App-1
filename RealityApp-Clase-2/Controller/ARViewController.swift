//
//  ARViewController.swift
//  RealityApp-Clase-2
//
//  Created by Jose Castillo on 11/11/22.
//

import UIKit
import ARKit
import RealityKit
import SwiftUI
import Combine

class ARViewController: UIViewController, ARSessionDelegate, ARCoachingOverlayViewDelegate {
    
    private var arView: ARView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        arView = ARView(frame: view.bounds)
        view.addSubview(arView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        
        arView.session.run(config)
        arView.session.delegate = self
//        addTapGesture()
        
//        placeBox()
        placeModel()
        
    }
    
    func placeBox(transform: simd_float4x4) {
        
        let arAnchor = ARAnchor(name: "Box", transform: transform)
        let anchorEntity = AnchorEntity(anchor: arAnchor)

        let boxEntity = ModelEntity(mesh: .generateBox(size: [0.1, 0.1, 0.1], cornerRadius: 0.02))
        
        boxEntity.generateCollisionShapes(recursive: true)
        
        let physics = PhysicsBodyComponent(massProperties: .default,
                                           material: .default,
                                           mode: .dynamic)
        boxEntity.components.set(physics)
        
        let material = SimpleMaterial(color: .blue, isMetallic: true)
        boxEntity.model?.materials = [material]

        anchorEntity.addChild(boxEntity)

        arView.scene.addAnchor(anchorEntity)

    }
    
    func placeModel() {
        
        guard let drummer = try? Entity.load(named: "toy_drummer") else { return }
        
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(drummer)
//        anchor.scale *= 0.2
        
        arView.scene.addAnchor(anchor)
        
        for animation in drummer.availableAnimations {
            drummer.playAnimation(animation.repeat())
        }
        
    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.arView.addGestureRecognizer(tap)
    }

    @objc func handleTap(recognizer: UITapGestureRecognizer?) {
        
        print("Tap")

        guard let location = recognizer?.location(in: self.arView) else {
            return
        }

        // Encontre un plano o encontre una entidad ??
        if let hitEntity = self.arView.entity(at: location) as? ModelEntity {

            hitEntity.addForce([0,0,-100], relativeTo: nil)

        } else {

            let results = self.arView.raycast(from: location,
                                              allowing: .existingPlaneInfinite,
                                              alignment: .horizontal)

            if let firstResult = results.first {
                print("Tap")
                placeBox(transform: firstResult.worldTransform)
            }

        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
    }

}

extension ARViewController {
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print("didAdd")
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        print("didRemove")
    }
    
}
