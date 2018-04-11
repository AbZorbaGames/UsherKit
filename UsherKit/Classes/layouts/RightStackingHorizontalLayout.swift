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

//public protocol RightStackingHorizontalUsher: HorizontalUsher {}
//
//public extension RightStackingHorizontalUsher {
//
//    func positioning(ofRectangulars rectangulars: [UsherRect],
//                     inBounds bounds: UsherRect) throws -> [UsherRect] {
//        let size = self.requiredSizeForPositioning(rectangulars: rectangulars)
//
//        print("asking to layout rects: \(rectangulars) in bounds: \(bounds) requiredSize: \(size)")
//        guard bounds.width >= size.width,
//            bounds.height >= size.height else { throw UsherError.cannotFit }
//
//        guard rectangulars.isEmpty == false else { throw UsherError.noInput }
//
//        var positions: [UsherRect] = []
//        var previous = rectangulars[0]
//        previous.origin.x = self.insets.left
//        positions.append(previous)
//        for (index, _) in rectangulars.enumerated() {
//            guard index > 0 else { continue }
//            var rect = previous
//            rect.origin.x = previous.minX + previous.width + self.horizontalSpacing
//            positions.append(rect)
//            previous = rect
//        }
//        print("responses rects: \(positions)")
//        return positions
//    }
//}

