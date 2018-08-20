//
//  ViewController.swift
//  ARSampleApp
//
//  Created by Ahmed Bekhit on 8/19/18.
//  Copyright © 2018 Ahmed Bekhit. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet weak var stateTextView: UITextView!
    @IBOutlet var sceneView: ARSCNView!
    
    // Retrieve 3D character from assets
    var maxCharacter: SCNNode {
        let sceneURL = Bundle.main.url(forResource: "max", withExtension: "scn", subdirectory: "Character.scnassets")!
        let refNode = SCNReferenceNode(url: sceneURL)!
        refNode.load()
        return refNode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard ARWorldTrackingConfiguration.isSupported else {
            let errorAlert = UIAlertController(title: "ARKit Error", message: "This device doesn't support ARKit.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in}))
            self.present(errorAlert, animated: true)
            return
        }
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        sceneView.session.delegate = self
        // enabling debugging feature points
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func didTapOnView(_ sender: UITapGestureRecognizer) {
        // Hit test to find a place for a virtual object.
        guard let hitTestResult = sceneView
            .hitTest(sender.location(in: sceneView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
            .first
            else { return }
        
        // Place an anchor for a virtual character. The model appears in renderer(_:didAdd:for:).
        let anchor = ARAnchor(name: "maxAR", transform: hitTestResult.worldTransform)
        sceneView.session.add(anchor: anchor)
    }
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let name = anchor.name, name.hasPrefix("maxAR") {
            node.addChildNode(maxCharacter)
        }
    }
    
    // MARK: - ARSessionDelegate
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
