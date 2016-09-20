//
//  ViewController.swift
//  3DNator
//
//  Created by Michael Stein on 9/17/16.
//  Copyright © 2016 Mike Stein Online. All rights reserved.
//

import UIKit
import Metal
import QuartzCore

class ViewController: UIViewController {
    var device: MTLDevice! = nil
    var metalLayer: CAMetalLayer! = nil
    
    var pipelineState: MTLRenderPipelineState! = nil
    var commandQueue: MTLCommandQueue! = nil
    var timer: CADisplayLink! = nil
    
    var objectToDraw: Cube!
    var secondObjectToDraw: Cube2!


    override func viewDidLoad() {
        super.viewDidLoad()
        device = MTLCreateSystemDefaultDevice()
        
        metalLayer = CAMetalLayer()          // 1
        metalLayer.device = device           // 2
        metalLayer.pixelFormat = .bgra8Unorm // 3
        metalLayer.framebufferOnly = true    // 4
        metalLayer.frame = view.layer.frame  // 5
        view.layer.addSublayer(metalLayer)   // 6
        

        objectToDraw = Cube(device: device)
        objectToDraw.positionX = -0.25
        objectToDraw.rotationZ = 45.0
        objectToDraw.scale = 0.5
        
        secondObjectToDraw = Cube2(device: device)
        
        // 1
        let defaultLibrary = device.newDefaultLibrary()
        let fragmentProgram = defaultLibrary!.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary!.makeFunction(name: "basic_vertex")
        
        // 2
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // 3
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch let pipelineError as NSError {
            print("Failed to create pipeline state, error \(pipelineError)")
        }
        
        commandQueue = device.makeCommandQueue()
        
        timer = CADisplayLink(target: self, selector: #selector(ViewController.GameLoop))
        timer.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Render() {
        let drawable = metalLayer.nextDrawable()

        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable!.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderEncoderOpt = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoderOpt.setRenderPipelineState(pipelineState)


        objectToDraw.render(renderEncoderOpt: renderEncoderOpt)
        //secondObjectToDraw.render(renderEncoderOpt: renderEncoderOpt)
        
        renderEncoderOpt.endEncoding()
        
        commandBuffer.present(drawable!)
        commandBuffer.commit()
    }
    
    
    func GameLoop() {
        autoreleasepool {
            self.Render()
        }
    }


}

