//
//  CompositeUsher.swift
//  UsherKit
//
//  Created by Georges Boumis on 20/04/2018.
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

public struct CompositeUsher: Usher {
    
    private let ushers: [Usher]
    public let insets: UsherInsets
    
    public init(ushers: [Usher], insets: UsherInsets) {
        self.ushers = ushers
        self.insets = insets
    }
    
    public func positioning<Rect>(ofRects rects: [Rect], inBounds bounds: Rect) throws -> [Rect] where Rect : UsherRect {
        let sizes = rects.map({ (rect: UsherRect) -> USize in
            let size = rect.layoutSize
            return USize(layoutWidth: size.layoutWidth, layoutHeight: size.layoutHeight)
        })
        let requiredSize = self.requiredSizeForPositioning(sizes: sizes)
        guard bounds.layoutWidth >= requiredSize.layoutWidth,
            bounds.layoutHeight >= requiredSize.layoutHeight else { throw UsherError.cannotFit }
        
        let outRects = try self.ushers.reduce(rects, { (partialRects: [Rect], usher: Usher) -> [Rect] in
            return try usher.positioning(ofRects: partialRects, inBounds: bounds)
        })
        return outRects
    }
    
    public func requiredSizeForPositioning<Size>(sizes: [Size]) -> Size where Size : UsherSize {
        guard sizes.isEmpty == false else { return Size(layoutWidth: 0, layoutHeight: 0) }
        
        let requiredSizes = self.ushers.map({ (usher: Usher) -> Size in
            return usher.requiredSizeForPositioning(sizes: sizes)
        })
        let maxWidth = requiredSizes.max(by: { (s1: UsherSize, s2: UsherSize) -> Bool in
            return (s1.layoutWidth < s2.layoutWidth)
        })!
        let maxHeight = requiredSizes.max(by: { (s1: UsherSize, s2: UsherSize) -> Bool in
            return (s1.layoutHeight < s2.layoutHeight)
        })!
        return Size(layoutWidth: maxWidth.layoutWidth + (self.insets.left + self.insets.right),
                    layoutHeight: maxHeight.layoutHeight + (self.insets.top + self.insets.bottom))
    }
}
