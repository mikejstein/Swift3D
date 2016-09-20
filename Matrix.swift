//
//  Matrix.swift
//  3DNator
//
//  Created by Michael Stein on 9/17/16.
//  Copyright © 2016 Mike Stein Online. All rights reserved.
//

import Foundation

class Matrix4 {
    var matrix:[[Float]] = [[]]
    init() {
        matrix = getIdentity()
    }
    
    func getIdentity() -> [[Float]] {
        return [[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]]
    }
    
    static func *(leftM:Matrix4, rightM:Matrix4) -> Matrix4 {
        //Get the i bound

        
        let left = leftM.matrix
        let right = rightM.matrix
        let iMax = left.count
        let jMax = right[0].count
        //create the return array
        var retMatrixArray:[[Float]] = [[Float]]()
        
        //For each row in our left matrix
        for i in 0 ..< iMax {
            retMatrixArray.append([Float]())
            for j in 0 ..< jMax {
                let firstValue = left[i][0] + right[0][j]
                let secondValue = left[i][1] + right[1][j]
                let thirdValue = left[i][2] + right[2][j]
                let fourthValue = left[i][3] + right[3][j]
                retMatrixArray[i].append(firstValue + secondValue + thirdValue + fourthValue)
                
            }
        }
        let retMatrix = Matrix4()
        retMatrix.matrix = retMatrixArray
        return retMatrix

    }
    
    /*
 * Scale the matrix
 */
    func scale (x:Float, y:Float, z:Float) -> () {
        let scaleMatrix = Matrix4()
        scaleMatrix.matrix = [[x,0.0,0.0,0.0,0.0],[0.0,y,0.0,0.0,0.0],[0.0,0.0,z,0.0],[0.0,0.0,0.0,1.0]]
        matrix = (scaleMatrix * self).matrix
    }
    
    /*
 Rotate the matrix
 */
    func rotateAround (xAngleRad:Float, yAngleRad:Float, zAngleRad:Float) {
        let xRotationMatrix:Matrix4 = Matrix4()
        xRotationMatrix.matrix = [[1,0,0,0],
                                  [0, cos(xAngleRad), sin(xAngleRad), 0],
                                  [0, sin(xAngleRad) * -1, cos(xAngleRad), 0],
                                  [0,0,0,1]]
        let yRotationMatrix:Matrix4 = Matrix4()
        yRotationMatrix.matrix = [[cos(yAngleRad),0,sin(yAngleRad) * -1,0],
                                  [0, 1, 0, 0],
                                  [sin(yAngleRad), 0, cos(yAngleRad), 0],
                                  [0,0,0,1]]
        
        let zRotationMatrix:Matrix4 = Matrix4()
        zRotationMatrix.matrix = [[cos(zAngleRad),sin(zAngleRad),0,0],
                                 [sin(zAngleRad) * -1, cos(zAngleRad),0, 0],
                                 [0, 0, 1, 0],
                                 [0,0,0,1]]
        matrix = (xRotationMatrix * yRotationMatrix * zRotationMatrix * self).matrix
    }
    
    /*
 move the matrix
 */
    func position(x:Float, y:Float, z:Float) -> () {
        matrix[0][3] = x
        matrix[1][3] = y
        matrix[2][3] = z
    }
    
    func raw() -> [Float]//, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float
    {
        return [matrix[0][0], matrix[0][1], matrix[0][2], matrix[0][3],
                matrix[1][0], matrix[1][1], matrix[1][2], matrix[1][3],
                matrix[2][0], matrix[2][1], matrix[2][2], matrix[2][3],
                matrix[3][0], matrix[3][1], matrix[3][2], matrix[3][3]]
    }
    
    static func numberOfElements() -> NSInteger {
        return 16
    }
    
    static func degreesToRad(degree:Float) -> Float {
        return degree * (.pi / 180)
    }
}
