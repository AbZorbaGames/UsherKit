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
    
    func positioning<Rect, Size>(ofSizes sizes: [Size], inBounds bounds: Rect) throws -> [Rect]
        where Rect: UsherRect, Size: UsherSize {
            let size = self.requiredSizeForPositioning(sizes: sizes)
            
            print("asking to layout sizes: \(size) in bounds: \(bounds) requiredSize: \(size)")
            guard bounds.layoutWidth >= size.layoutWidth,
                bounds.layoutHeight >= size.layoutHeight else { throw UsherError.cannotFit }
            
            guard sizes.isEmpty == false else { throw UsherError.noInput }
            
            var positions: [Rect] = []
            var previous = Rect(layoutOrigin: UPoint.zero,
                                UsherSize: sizes[0])
            previous.layoutOrigin.layoutX = self.insets.left
            positions.append(previous)
            for (index, _) in sizes.enumerated() {
                guard index > 0 else { continue }
                var rect = previous
                rect.layoutOrigin.layoutX = previous.layoutOrigin.layoutX + previous.layoutWidth + self.horizontalSpacing
                positions.append(rect)
                previous = rect
            }
            print("responses rects: \(positions)")
            return positions
    }
    
}

