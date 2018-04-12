//
//  BottomStackingVerticalUsher.swift
//  UsherKit
//
//  Created by Georges Boumis on 12/04/2018.
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

public protocol BottomStackingVerticalUsher: VerticalUsher {}

public extension BottomStackingVerticalUsher {
    
    func positioning<Rect, Size>(ofSizes sizes: [Size], inBounds bounds: Rect) throws -> [Rect]
        where Rect: UsherRect, Size: UsherSize {
            guard sizes.isEmpty == false else { throw UsherError.noInput }
            
            let size = self.requiredSizeForPositioning(sizes: sizes)
            
            print("asking to layout sizes: \(size) in bounds: \(bounds) requiredSize: \(size)")
            guard bounds.layoutWidth >= size.layoutWidth,
                bounds.layoutHeight >= size.layoutHeight else { throw UsherError.cannotFit }
            
            var positions: [Rect] = []
            var previous = Rect(layoutOrigin: UPoint.zero,
                                layoutSize: sizes.last!)
            let y = (bounds.layoutHeight - self.insets.bottom) - previous.layoutHeight
            previous.layoutOrigin.layoutY = y
            positions.append(previous)
            let verticalSpacing = self.verticalSpacing
            let butLast = sizes.reversed().suffix(from: 1)
            for size in butLast {
                let y = previous.layoutOrigin.layoutY
                    - verticalSpacing
                    - size.layoutHeight
                let origin = UPoint(layoutX: 0, layoutY: y)
                let rect = Rect(layoutOrigin: origin,
                                layoutSize: size)
                positions.append(rect)
                previous = rect
            }
            print("responses rects: \(positions)")
            return positions
    }
}
