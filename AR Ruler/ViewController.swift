//
//  ViewController.swift
//  AR Ruler
//
//  Created by Eliu Efraín Díaz Bravo on 29/11/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = .showFeaturePoints
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchLocation = touches.first?.location(in: sceneView) {
            guard let query = sceneView.raycastQuery(from: touchLocation, allowing: .estimatedPlane, alignment: .any) else { return }
            
            let results = sceneView.session.raycast(query)
            
            guard let hitTestResult = results.first else {
                print("No surface found<")
                return
            }
            addDot(at: hitTestResult)
        }
    }
    
    func addDot(at location: ARRaycastResult) {
        let dotGeometry = SCNSphere(radius: 0.005)
        let dotMaterial = SCNMaterial()
        dotMaterial.diffuse.contents = UIColor.systemRed
        dotGeometry.materials = [dotMaterial]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        dotNode.position = SCNVector3(location.worldTransform.columns.3.x, location.worldTransform.columns.3.y, location.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
    }
}
