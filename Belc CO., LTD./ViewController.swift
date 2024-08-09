//
//  ViewController.swift
//  Belc CO., LTD.
//
//  Created by Revanth Raj on 08/08/24.
//

import UIKit
import ARKit
import SceneKit


class ViewController: UIViewController, ARSCNViewDelegate {

    var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the ARSCNView
        sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        if let scene = SCNScene(named: "") {
            sceneView.scene = scene
        } else {
            print("Error: Scene file walmart.dae not found.")
        }
        // Set the scene to the view
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
    func addPathToFruits() {
        let startPoint = SCNVector3(0, 0, 0) // User's starting point
        let endPoint = SCNVector3(1.5, 0, -2.5) // Approximate location of "Fruits" in the scene

        let pathNode = createPathNode(from: startPoint, to: endPoint)
        sceneView.scene.rootNode.addChildNode(pathNode)
    }

    func createPathNode(from start: SCNVector3, to end: SCNVector3) -> SCNNode {
        let line = SCNGeometry.line(from: start, to: end)
        let pathNode = SCNNode(geometry: line)
        pathNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        return pathNode
    }
    func displayDiscount(on productNode: SCNNode, discountText: String) {
        let text = SCNText(string: discountText, extrusionDepth: 1)
        text.firstMaterial?.diffuse.contents = UIColor.red
        
        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(productNode.position.x, productNode.position.y + 0.1, productNode.position.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    func updateAtNode(node: SCNNode) {
        if node.name == "Fruits" {
            displayDiscount(on: node, discountText: "10% OFF!")
        }
    }


}
extension SCNGeometry {
    class func line(from vectorA: SCNVector3, to vectorB: SCNVector3) -> SCNGeometry {
        let vertices: [SCNVector3] = [vectorA, vectorB]
        let vertexSource = SCNGeometrySource(vertices: vertices)
        let indices: [Int32] = [0, 1]
        let indexData = Data(bytes: indices, count: MemoryLayout<Int32>.size * indices.count)
        let element = SCNGeometryElement(data: indexData, primitiveType: .line, primitiveCount: 1, bytesPerIndex: MemoryLayout<Int32>.size)
        return SCNGeometry(sources: [vertexSource], elements: [element])
    }
}


