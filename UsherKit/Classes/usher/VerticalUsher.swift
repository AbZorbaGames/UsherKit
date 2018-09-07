//
//  VerticalUsher.swift
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

public protocol VerticalUsher: Usher {
    var verticalSpacing: Float { get }
}

public extension VerticalUsher {

    func requiredSizeForPositioning<Size>(sizes: [Size]) -> Size where Size: UsherSize {
        guard sizes.isEmpty == false else { return Size(layoutWidth: 0, layoutHeight: 0) }
        
        if sizes.count == 1 {
            var requiredSize = sizes[0]
            requiredSize.layoutHeight += (self.insets.top + self.insets.bottom)
            return requiredSize
        }

        let maxWidth = sizes.max(by: { (s1: UsherSize, s2: UsherSize) -> Bool in
            return s1.layoutWidth < s2.layoutWidth
        })!.layoutWidth
        
        let verticalSpacing = self.verticalSpacing.rounded(FloatingPointRoundingRule.down)
        let totalHeight = sizes.reduce(Float(0), { (sum: Float, size: UsherSize) -> Float in
            return sum + size.layoutHeight + verticalSpacing
        }) + (self.insets.top + self.insets.bottom) - verticalSpacing
        return Size(layoutWidth: maxWidth.rounded(FloatingPointRoundingRule.down),
                    layoutHeight: totalHeight.rounded(FloatingPointRoundingRule.down))
    }
}

