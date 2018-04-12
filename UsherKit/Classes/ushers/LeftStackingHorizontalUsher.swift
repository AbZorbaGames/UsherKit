//
//  LeftStackingHorizontalUsher.swift
//  UsherKit
//
//  Created by Georges Boumis on 22/03/2018.
//
//  Licensed to the Apache Software Foundation (ASF) under one
//  or more contributor license agreements.  See the NOTICE file
//  distributed with this work for additional information
//  regarding copyright ownership.  The ASF licenses this file
//  to you under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in compliance
//  with the License.  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.
//
//
import Foundation

public protocol LeftStackingHorizontalUsher: HorizontalUsher {}

public extension LeftStackingHorizontalUsher {
    
    func positioning<Rect>(ofRects rects: [Rect], inBounds bounds: Rect) throws -> [Rect]
        where Rect: UsherRect {
            
            guard rects.isEmpty == false else { throw UsherError.noInput }
            
            let sizes = rects.map({ (rect: UsherRect) -> USize in
                let size = rect.layoutSize
                return USize(layoutWidth: size.layoutWidth, layoutHeight: size.layoutHeight)
            })
            let requiredSize = self.requiredSizeForPositioning(sizes: sizes)
            print("asking to layout rects: \(rects) in bounds: \(bounds) requiredSize: \(requiredSize)")
            
            guard bounds.layoutWidth >= requiredSize.layoutWidth,
                bounds.layoutHeight >= requiredSize.layoutHeight else { throw UsherError.cannotFit }
            
            
            var positions: [Rect] = []
            var previous = rects[0]
            previous.layoutOrigin.layoutX = self.insets.left
            positions.append(previous)
            let horizontalSpacing = self.horizontalSpacing
            for rect in rects.suffix(from: 1) {
                let x = previous.layoutOrigin.layoutX
                    + previous.layoutWidth
                    + horizontalSpacing
                let origin = UPoint(layoutX: x, layoutY: rect.layoutOrigin.layoutY)
                let result = Rect(layoutOrigin: origin, layoutSize: rect.layoutSize)
                positions.append(result)
                previous = result
            }
            print("responses rects: \(positions)")
            return positions
    }
}
