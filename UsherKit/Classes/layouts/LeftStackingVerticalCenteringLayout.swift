//
//  LeftStackingCenteringLayout.swift
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

public struct LeftStackingVerticalCenteringLayout: Usher {
    public let insets: UsherInsets
    
    private struct Left:LeftStackingHorizontalUsher {
        let horizontalSpacing: Float
        let insets: UsherInsets
    }
    private struct Center: VerticalCenteringUsher {
        let insets: UsherInsets
    }
    private let left: Left
    private let center: Center
    
    public init(horizontalSpacing: Float, insets: UsherInsets) {
        self.insets = insets
        self.left = Left(horizontalSpacing: horizontalSpacing, insets: insets)
        self.center = Center(insets: insets)
    }
    
    public func requiredSizeForPositioning<Size>(sizes: [Size]) -> Size where Size : UsherSize {
        let left = self.left.requiredSizeForPositioning(sizes: sizes)
        let center = self.center.requiredSizeForPositioning(sizes: sizes)
        let maxWidth = left.layoutWidth > center.layoutWidth ? left.layoutWidth : center.layoutWidth
        let maxHeight = left.layoutHeight > center.layoutHeight ? left.layoutHeight : center.layoutHeight
        return Size(layoutWidth: maxWidth, layoutHeight: maxHeight)
    }
    
    public func positioning<Rect>(ofRects rects: [Rect], inBounds bounds: Rect) throws -> [Rect] where Rect : UsherRect {
        let sizes = rects.map({ (rect: UsherRect) -> USize in
            let size = rect.layoutSize
            return USize(layoutWidth: size.layoutWidth, layoutHeight: size.layoutHeight)
        })
        let requiredSize = self.requiredSizeForPositioning(sizes: sizes)
        print("asking to layout rects: \(rects) in bounds: \(bounds) requiredSize: \(requiredSize)")
        guard bounds.layoutWidth >= requiredSize.layoutWidth,
            bounds.layoutHeight >= requiredSize.layoutHeight else { throw UsherError.cannotFit }
        
        let left = try self.left.positioning(ofRects: rects, inBounds: bounds)
        let leftAndCenter = try self.center.positioning(ofRects: left, inBounds: bounds)
        return leftAndCenter
    }
}
