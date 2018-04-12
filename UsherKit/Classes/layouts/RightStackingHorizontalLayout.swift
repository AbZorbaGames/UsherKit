//
//  RightStackingHorizontalUsher.swift
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

public protocol RightStackingHorizontalUsher: HorizontalUsher {}

public extension RightStackingHorizontalUsher {

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
            let x = (bounds.layoutWidth - self.insets.right) - previous.layoutWidth
            previous.layoutOrigin.layoutX = x
            positions.append(previous)
            let horizontalSpacing = self.horizontalSpacing
            let butLast = sizes.reversed().suffix(from: 1)
            for size in butLast {
                let x =
                    previous.layoutOrigin.layoutX
                        - horizontalSpacing
                        - size.layoutWidth
                let origin = UPoint(layoutX: x, layoutY: 0)
                let rect = Rect(layoutOrigin: origin, layoutSize: size)
                positions.append(rect)
                previous = rect
            }
            print("responses rects: \(positions)")
            return positions
    }
}

