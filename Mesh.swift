//
//  Mesh.swift
//  3DNator
//
//  Created by Michael Stein on 9/18/16.
//  Copyright © 2016 Mike Stein Online. All rights reserved.
//

import Foundation
import Metal
import QuartzCore
import GLKit

class Mesh {
    let name: String
    var vertexCount: Int
    var vertexBuffer: MTLBuffer
    var device: MTLDevice
    
    var positionX:Float = 0.0
    var positionY:Float = 0.0
    var positionZ:Float = 0.0
    
    var rotationX:Float = 0.0
    var rotationY:Float = 0.0
    var rotationZ:Float = 0.0
    var scale:Float     = 1.0
    
    var uniformBuffer:MTLBuffer?
    
    
    init(name: String, vertices: Array<Vertex>, device: MTLDevice) {
        var vertexData = Array<Float>()
        
        for vertex in vertices { //add all the vertexes for this mesh into the vertex data
            vertexData += vertex.floatBuffer()
        }
        
        //create a vertex buffer 
        let dataSize = vertexData.count *  MemoryLayout.size(ofValue: vertexData[0])
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options:[])
        
        
        self.name = name
        self.device = device
        vertexCount = vertices.count
        
    }
    
    func render(renderEncoderOpt: MTLRenderCommandEncoder){
        renderEncoderOpt.setVertexBuffer(vertexBuffer, offset: 0, at: 0)
        // 1
        var nodeModelMatrix = self.modelMatrix()
        print("Model Matrix Is: \(nodeModelMatrix.matrix)")
        // 2
        uniformBuffer = device.makeBuffer(length: MemoryLayout<Float>.size * Matrix4.numberOfElements(), options: [])
        // 3
        var bufferPointer = uniformBuffer?.contents()
        // 4
        memcpy(bufferPointer!, nodeModelMatrix.raw(), MemoryLayout<Float>.size*Matrix4.numberOfElements())
        // 5
        renderEncoderOpt.setVertexBuffer(self.uniformBuffer, offset: 0, at: 1)
        renderEncoderOpt.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount, instanceCount: 1)

    }
    
    func modelMatrix() -> Matrix4 {
        let matrix = Matrix4()
        matrix.position(x: positionX, y: positionY, z: positionZ)
        //matrix.rotateAround(xAngleRad: rotationX, yAngleRad: rotationY, zAngleRad: rotationZ)
        matrix.scale(x: scale, y: scale, z: scale)
        return matrix
    }
}

class Triangle: Mesh {
    init(device: MTLDevice){
        
        let V0 = Vertex(x:  0.0, y:   1.0, z:   0.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
        let V1 = Vertex(x: -1.0, y:  -1.0, z:   0.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
        let V2 = Vertex(x:  1.0, y:  -1.0, z:   0.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
        
        let verticesArray = [V0,V1,V2]
        super.init(name: "Triangle", vertices: verticesArray, device: device)
    }
}

class Cube: Mesh {
    init(device: MTLDevice){
        
        
        let A = Vertex(x: -1.0, y:   1.0, z:   1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
        let B = Vertex(x: -1.0, y:  -1.0, z:   1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
        let C = Vertex(x:  1.0, y:  -1.0, z:   1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
        let D = Vertex(x:  1.0, y:   1.0, z:   1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0)
        
        let Q = Vertex(x: -1.0, y:   1.0, z:  -1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
        let R = Vertex(x:  1.0, y:   1.0, z:  -1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
        let S = Vertex(x: -1.0, y:  -1.0, z:  -1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
        let T = Vertex(x:  1.0, y:  -1.0, z:  -1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0)
        
        let verticesArray:Array<Vertex> = [
            A,B,C ,A,C,D,   //Front
            R,T,S ,Q,R,S,   //Back
            
            Q,S,B ,Q,B,A,   //Left
            D,C,T ,D,T,R,   //Right
            
            Q,A,D ,Q,D,R,   //Top
            B,S,T ,B,T,C    //Bot
        ]
        
        super.init(name: "Cube", vertices: verticesArray, device: device)
    }
}

class Cube2: Mesh {
    init(device: MTLDevice){
        
        
        let A = Vertex(x: -0.6, y:   0.0, z:   0.3, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
        let B = Vertex(x: -0.6, y:  -0.6, z:   0.3, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
        let C = Vertex(x:  0.0, y:  -0.6, z:   0.3, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
        let D = Vertex(x:  0.0, y:   0.0, z:   0.3, r:  0.1, g:  0.6, b:  0.4, a:  1.0)
        
        let Q = Vertex(x: -0.6, y:   0.0, z:  -0.3, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
        let R = Vertex(x:  0.0, y:   0.0, z:  -0.3, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
        let S = Vertex(x: -0.6, y:  -0.6, z:  -0.3, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
        let T = Vertex(x:  0.0, y:  -0.6, z:  -0.3, r:  0.1, g:  0.6, b:  0.4, a:  1.0)
        
        let verticesArray:Array<Vertex> = [
            A,B,C ,A,C,D,   //Front
            R,T,S ,Q,R,S,   //Back
            
            Q,S,B ,Q,B,A,   //Left
            D,C,T ,D,T,R,   //Right
            
            Q,A,D ,Q,D,R,   //Top
            B,S,T ,B,T,C    //Bot
        ]
        
        super.init(name: "Cube2", vertices: verticesArray, device: device)
    }
}
