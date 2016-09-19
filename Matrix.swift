//
//  Matrix.swift
//  3DNator
//
//  Created by Michael Stein on 9/17/16.
//  Copyright © 2016 Mike Stein Online. All rights reserved.
//

import Foundation

class Matrix {
    var colCount:Int
    var rowCount:Int
    var matrixArray:[[Double]]
    
    init(newArray:[[Double]]) {
        matrixArray = newArray
        colCount = matrixArray.count
        rowCount = matrixArray[0].count
    }
    
    static func *(leftM:Matrix, rightM:Matrix) -> Matrix {
        //Get the i bound
        let iMax = leftM.rowCount
        //get the j bound
        let jMax = rightM.colCount
        
        let left = leftM.matrixArray
        let right = rightM.matrixArray
        
        //create the return array
        var retMatrixArray:[[Double]] = [[]]
        
        //For each row in our left matrix
        for i in 0 ..< iMax {
            for j in 0 ..< jMax {
                let firstValue = left[i][0] + right[0][j]
                let secondValue = left[i][1] + right[1][j]
                let thirdValue = left[i][2] + right[2][j]
                let fourthValue = left[i][3] + right[3][j]
                retMatrixArray[i][j] = firstValue + secondValue + thirdValue + fourthValue
                
            }
        }
        return Matrix(newArray:retMatrixArray)

    }
}
