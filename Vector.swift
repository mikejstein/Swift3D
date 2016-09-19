//
//  Vector.swift
//  3DNator
//
//  Created by Michael Stein on 9/17/16.
//  Copyright © 2016 Mike Stein Online. All rights reserved.
//

import Foundation


struct Vertex {
    var x, y, z: Float // Positions
    var r,g,b,a : Float //  Colors
    
    func floatBuffer() -> [Float] {
        return [x,y,z,r,g,b,a]
    }
}

class Vector {
    
    var x,y,z:Double
    
    init(newX:Double, newY:Double, newZ:Double) {
        x = newX
        y = newY
        z = newZ
    }

    
    //Dot Product Vectors
    func DotProduct(vector:Vector) -> Double {
        return (self.x * vector.x) + (self.y + vector.y) + (self.z + vector.z)
        
    }
    
    //XYZZY : X + YZZY
    func CrossProduct(vector:Vector) -> Vector {
        let x = (self.y * vector.z) - (self.z * vector.y)
        let y = (self.z * vector.x) - (self.x * vector.z)
        let z = (self.x * vector.y) - (self.y * vector.x)
        return Vector(newX: x, newY: y, newZ: z)
        
    }
    
    
    //Normalize Vector
    
    func Normalized() -> Vector
    {
        return self / self.Length()
    }
    
    /*
     *  Returns the length of a vector
     */
    func Length() -> Double
    {
        return sqrt(x*x + y*y + z*z)
    }
    
    /// Overloaded Ops
    
    static func +(left:Vector, right:Vector) -> Vector {
        let x = left.x + right.x
        let y = left.y + right.y
        let z = left.z + right.z
        return Vector(newX: x,newY: y,newZ: z)
    }
    
    static func *(left:Vector, right:Double) -> Vector {
        let x = left.x * right
        let y = left.y * right
        let z = left.z * right
        return Vector(newX: x, newY:y, newZ:z)
    }
    
    static func /(left:Vector, right:Double) -> Vector {
        let divisor =  1.0 / right
        return left * divisor
    }
    
    // Remember, a-b is a vector Running FROM b to a. DESTINATION - SOURCE
    static func -(left:Vector, right:Vector) -> Vector {
        let x = left.x - right.x
        let y = left.y - right.y
        let z = left.z - right.z
        return Vector(newX: x, newY: y, newZ: z)
    }
    

}
