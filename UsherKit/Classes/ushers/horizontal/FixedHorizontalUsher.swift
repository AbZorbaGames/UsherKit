//
//  FixedHorizontalUsher.swift
//  UsherKit
//
//  Created by Georges Boumis on 10/09/2018.
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

public protocol FixedHorizontalUsher: HorizontalUsher {
    var fixedHorizontalValue: Float { get }
}

public extension FixedHorizontalUsher {

    func requiredSizeForPositioning<Size>(sizes: [Size]) -> Size where Size: UsherSize {
        let width = self.fixedHorizontalValue - (self.insets.left + self.insets.right)
        guard sizes.isEmpty == false else { return Size(layoutWidth: width,
                                                        layoutHeight: 0) }

        if sizes.count == 1 {
            var requiredSize = sizes[0]
            requiredSize.layoutWidth = width
            return requiredSize
        }

        let maxHeight = sizes.max(by: { (s1: UsherSize, s2: UsherSize) -> Bool in
            return s1.layoutHeight < s2.layoutHeight
        })!.layoutHeight
        return Size(layoutWidth: width,
                    layoutHeight: maxHeight.rounded(FloatingPointRoundingRule.down))
    }

    public func positioning<Rect>(ofRects rects: [Rect], inBounds bounds: Rect) throws -> [Rect]
        where Rect: UsherRect {

            guard rects.isEmpty == false else { throw UsherError.noInput }

            let sizes = rects.map({ (rect: UsherRect) -> USize in
                let size = rect.layoutSize
                return USize(layoutWidth: size.layoutWidth, layoutHeight: size.layoutHeight)
            })
            let requiredSize = self.requiredSizeForPositioning(sizes: sizes)
            guard bounds.layoutWidth >= requiredSize.layoutWidth,
                bounds.layoutHeight >= requiredSize.layoutHeight else { throw UsherError.cannotFit }

            let layout = Horizontal(horizontalSpacing: self.horizontalSpacing, insets: self.insets)
            let fixedBounds = Rect(layoutOrigin: bounds.layoutOrigin,
                                   layoutSize: USize(layoutWidth: self.fixedHorizontalValue,
                                                    layoutHeight: bounds.layoutHeight))
            return try layout.positioning(ofRects: rects,
                                          inBounds: fixedBounds)
    }
}

private struct Horizontal: LeftStackingHorizontalUsher {
    var horizontalSpacing: Float = 0
    var insets: UsherInsets = UsherInsets.zero
}
