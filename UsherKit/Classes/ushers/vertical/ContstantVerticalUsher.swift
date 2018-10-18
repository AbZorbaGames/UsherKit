//
//  ConstantVerticalUsher.swift
//  UsherKit
//
//  Created by Georges Boumis on 19/04/2018.
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

public protocol ConstantVerticalUsher: VerticalUsher {
    var verticalValue: Float { get }
}

public extension ConstantVerticalUsher {

    func requiredSizeForPositioning<Size>(sizes: [Size]) -> Size where Size: UsherSize {
        guard sizes.isEmpty == false else { return Size(layoutWidth: 0, layoutHeight: 0) }

        if sizes.count == 1 {
            var requiredSize = sizes[0]
            requiredSize.layoutHeight = self.verticalValue + (self.insets.left + self.insets.right)
            return requiredSize
        }

        let maxWidth = sizes.max(by: { (s1: UsherSize, s2: UsherSize) -> Bool in
            return s1.layoutWidth < s2.layoutWidth
        })!.layoutWidth
        let verticalSpacing = self.verticalSpacing
        let totalHeight = sizes.reduce(Float(0), { (sum: Float, size: UsherSize) -> Float in
            return sum + self.verticalValue + verticalSpacing
        }) + (self.insets.top + self.insets.bottom) - verticalSpacing
        return Size(layoutWidth: maxWidth.rounded(FloatingPointRoundingRule.down),
                    layoutHeight: totalHeight.rounded(FloatingPointRoundingRule.down))
    }

    func positioning<Rect>(ofRects rects: [Rect], inBounds bounds: Rect) throws -> [Rect]
        where Rect: UsherRect {

            guard rects.isEmpty == false else { throw UsherError.noInput }

            let sizes = rects.map({ (rect: UsherRect) -> USize in
                let size = rect.layoutSize
                return USize(layoutWidth: self.verticalValue, layoutHeight: size.layoutHeight)
            })
            let requiredSize = self.requiredSizeForPositioning(sizes: sizes)
            guard bounds.layoutWidth >= requiredSize.layoutWidth,
                bounds.layoutHeight >= requiredSize.layoutHeight else { throw UsherError.cannotFit }

            return rects.map({ (rect: Rect) -> Rect in
                let size = USize(layoutWidth: rect.layoutWidth, layoutHeight: self.verticalValue)
                return Rect(layoutOrigin: rect.layoutOrigin,
                            layoutSize: size)
            })
    }
}
