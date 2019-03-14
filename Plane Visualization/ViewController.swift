// Copyright © 2019 Ricky Munz. All rights reserved.

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration)
    }
}

extension ViewController: ARSCNViewDelegate {

    // MARK: Option 1: Geometry as SCNPlane
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        // Cast ARAnchor as ARPlaneAnchor
//        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
//
//        // Create SCNGeometry from ARPlaneAnchor details
//        let width = CGFloat(planeAnchor.extent.x)
//        let height = CGFloat(planeAnchor.extent.z)
//        let planeGeometry = SCNPlane(width: width, height: height)
//
//        // Add material to geometry
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.blue.withAlphaComponent(0.8)
//        planeGeometry.materials = [material]
//
//        // Create a SCNNode from geometry
//        let planeNode = SCNNode(geometry: planeGeometry)
//        planeNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
//        planeNode.eulerAngles.x = -.pi / 2
//
//        // Add the newly created plane node as a child of the node created for the ARAnchor
//        node.addChildNode(planeNode)
//    }
//
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        // Cast ARAnchor as ARPlaneAnchor, get the child node of the anchor, and cast that node's geometry as an SCNPlane
//        guard
//            let planeAnchor = anchor as? ARPlaneAnchor,
//            let planeNode = node.childNodes.first,
//            let planeGeometry = planeNode.geometry as? SCNPlane
//            else { return }
//
//        // Update the dimensions of the plane geometry based on the plane anchor.
//        planeGeometry.width = CGFloat(planeAnchor.extent.x)
//        planeGeometry.height = CGFloat(planeAnchor.extent.z)
//
//        // Update the position of the plane node based on the plane anchor.
//        planeNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
//    }

    // MARK: Option 2: Geometry as ARSCNPlaneGeometry
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Cast ARAnchor as ARPlaneAnchor
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        let planeGeometry = ARSCNPlaneGeometry(device: MTLCreateSystemDefaultDevice()!)!
        planeGeometry.update(from: planeAnchor.geometry)

        // Add material to geometry
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue.withAlphaComponent(0.8)
        planeGeometry.materials = [material]

        // Create a SCNNode from geometry
        let planeNode = SCNNode(geometry: planeGeometry)

        // Add the newly created plane node as a child of the node created for the ARAnchor
        node.addChildNode(planeNode)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // Cast ARAnchor as ARPlaneAnchor, get the child node of the anchor, and cast that node's geometry as an ARSCNPlaneGeometry
        guard
            let planeAnchor = anchor as? ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let planeGeometry = planeNode.geometry as? ARSCNPlaneGeometry
            else { return }

        planeGeometry.update(from: planeAnchor.geometry)
    }
}
