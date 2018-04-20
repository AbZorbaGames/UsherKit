//
//  HorizontalFittingUsher.swift
//  UsherKit
//
//  Created by Georges Boumis on 12/04/2018.
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

public protocol CenterStackingHorizontalUsher: HorizontalUsher {}


internal enum Style {
    case odd
    case even
    case unit
    
    init(_ things: [Any]) {
        let items = things.count
        if items == 1 {
            self = Style.unit
        }
        else if items.quotientAndRemainder(dividingBy: 2).remainder != 0 {
            self = Style.odd
        }
        else {
            self = Style.even
        }
    }
}

public extension CenterStackingHorizontalUsher {

    
    func requiredSizeForPositioning<Size>(sizes: [Size]) -> Size where Size: UsherSize {
        guard sizes.isEmpty == false else { return Size(layoutWidth: 0, layoutHeight: 0) }
        
        if sizes.count == 1 {
            var requiredSize = sizes[0]
            requiredSize.layoutWidth += (self.insets.left + self.insets.right)
            return requiredSize
        }
        
        let maxHeight = sizes.max(by: { (s1: UsherSize, s2: UsherSize) -> Bool in
            return s1.layoutHeight < s2.layoutHeight
        })!.layoutHeight
        let horizontalSpacing = self.horizontalSpacing
        let totalWidth = sizes.reduce(Float(0), { (sum: Float, size: UsherSize) -> Float in
            return sum + size.layoutWidth + horizontalSpacing
        }) + (self.insets.left + self.insets.right) - horizontalSpacing
        
        let type = Style(sizes)
        switch type {
        case .unit: break
        case .odd: break
        case .even: break
        }
        return Size(layoutWidth: totalWidth, layoutHeight: maxHeight)
    }
    
    func positioning<Rect>(ofRects rects: [Rect], inBounds bounds: Rect) throws -> [Rect]
        where Rect: UsherRect {
            
            guard rects.isEmpty == false else { throw UsherError.noInput }
            
            let sizes = rects.map({ (rect: UsherRect) -> USize in
                let size = rect.layoutSize
                return USize(layoutWidth: size.layoutWidth, layoutHeight: size.layoutHeight)
            })
            let requiredSize = self.requiredSizeForPositioning(sizes: sizes)
            guard bounds.layoutWidth >= requiredSize.layoutWidth,
                bounds.layoutHeight >= requiredSize.layoutHeight else { throw UsherError.cannotFit }
            
            let centerX = (bounds.layoutWidth / 2)
            
            var positions: [Rect] = []
            positions.reserveCapacity(rects.count)
            
            switch Style(rects) {
            case .unit:
                let r = rects[0]
                let x = centerX - (r.layoutWidth / 2)
                let origin = UPoint(layoutX: x, layoutY: r.layoutOrigin.layoutY)
                let rect = Rect(layoutOrigin: origin, layoutSize: r.layoutSize)
                positions.append(rect)
            case .odd:
                positions.append(contentsOf:
                    self.layoutOdd(rects: rects, inBounds: bounds)
                )
            case .even:
                positions.append(contentsOf:
                    self.layoutEven(rects: rects, inBounds: bounds)
                )
            }
            return positions
    }
    
    private func layoutEven<Rect>(rects inRects: [Rect], inBounds bounds: Rect) -> [Rect] where Rect: UsherRect {
        let rects = inRects.map({ (rect: Rect) -> URect in
            let origin = UPoint(layoutX: rect.layoutOrigin.layoutX, layoutY: rect.layoutOrigin.layoutY)
            let size = USize(layoutWidth: rect.layoutWidth, layoutHeight: rect.layoutHeight)
            return URect(layoutOrigin: origin, layoutSize: size)
        })
        guard let lowerMidIndex = rects.evenMiddleLowerIndex else { return inRects }
        guard let upperMidIndex = rects.evenMiddleUpperIndex else { return inRects }

        let centerX = bounds.layoutWidth / 2
        let horizontalSpacing = self.horizontalSpacing
        
        var lowerMiddle = rects[lowerMidIndex]
        var upperMiddle = rects[upperMidIndex]
        
        let lowerX = centerX - lowerMiddle.layoutWidth
        lowerMiddle.layoutOrigin.layoutX = lowerX - (horizontalSpacing / 2)
        
        let upperX = centerX
        upperMiddle.layoutOrigin.layoutX = upperX + (horizontalSpacing / 2)
        
        var positions: [URect] = []
        positions.reserveCapacity(rects.count)
        positions.append(lowerMiddle)
        positions.append(upperMiddle)

        var index = rects.index(before: lowerMidIndex)
        var previous = lowerMiddle
        var current = previous // garbage
        while index >= rects.startIndex {
            current = rects[index]
            let x = previous.layoutOrigin.layoutX - horizontalSpacing - current.layoutWidth
            current.layoutOrigin.layoutX = x
            previous = current
            positions.append(current)
            rects.formIndex(before: &index)
        }

        index = rects.index(after: upperMidIndex)
        previous = upperMiddle
        current = previous // garbage
        while index < rects.endIndex {
            current = rects[index]
            let x = previous.layoutOrigin.layoutX + previous.layoutWidth + horizontalSpacing
            current.layoutOrigin.layoutX = x
            previous = current
            positions.append(current)
            rects.formIndex(after: &index)
        }
        return positions.map({ (rect: URect) -> Rect in
            return Rect(layoutOrigin: rect.layoutOrigin, layoutSize: rect.layoutSize)
        }).sorted(by: { (r1: UsherRect, r2: UsherRect) -> Bool in
            return r1.layoutOrigin.layoutX < r2.layoutOrigin.layoutX
        })
    }

    private func layoutOdd<Rect>(rects inRects: [Rect], inBounds bounds: Rect) -> [Rect] where Rect: UsherRect {
        let rects = inRects.map({ (rect: Rect) -> URect in
            let origin = UPoint(layoutX: rect.layoutOrigin.layoutX, layoutY: rect.layoutOrigin.layoutY)
            let size = USize(layoutWidth: rect.layoutWidth, layoutHeight: rect.layoutHeight)
            return URect(layoutOrigin: origin, layoutSize: size)
        })
        
        guard let midIndex = rects.oddMiddleIndex else { return inRects }
        
        let centerX = bounds.layoutWidth / 2
        let horizontalSpacing = self.horizontalSpacing
        
        var middle = rects[midIndex]
        
        let middleX = centerX - (middle.layoutWidth / 2)
        middle.layoutOrigin.layoutX = middleX
        
        var positions: [URect] = []
        positions.reserveCapacity(rects.count)
        positions.append(middle)
        
        var index = rects.index(before: midIndex)
        var previous = middle
        var current = previous // garbage
        while index >= rects.startIndex {
            current = rects[index]
            let x = previous.layoutOrigin.layoutX - horizontalSpacing - current.layoutWidth
            current.layoutOrigin.layoutX = x
            previous = current
            positions.append(current)
            rects.formIndex(before: &index)
        }
        
        index = rects.index(after: midIndex)
        previous = middle
        current = previous // garbage
        while index < rects.endIndex {
            current = rects[index]
            let x = previous.layoutOrigin.layoutX + previous.layoutWidth + horizontalSpacing
            current.layoutOrigin.layoutX = x
            previous = current
            positions.append(current)
            rects.formIndex(after: &index)
        }
        return positions.map({ (rect: URect) -> Rect in
            return Rect(layoutOrigin: rect.layoutOrigin, layoutSize: rect.layoutSize)
        }).sorted(by: { (r1: UsherRect, r2: UsherRect) -> Bool in
            return r1.layoutOrigin.layoutX < r2.layoutOrigin.layoutX
        })
    }
}


internal extension RandomAccessCollection {
    
    var oddMiddleIndex: Self.Index? {
        guard self.count != 0 else { return nil }
        if self.count % 2 == 0 {
            return nil
        }
        let count = self.count
        let offset = Int(count/2)
        return self.index(self.startIndex, offsetBy: offset)
    }

    var evenMiddleLowerIndex: Self.Index? {
        if let middle = self.evenMiddleUpperIndex {
            return self.index(before: middle)
        }
        return nil
    }

    var evenMiddleUpperIndex: Self.Index? {
        guard self.count != 0 else { return nil }

        let count = self.count
        let offset = Int(count/2)
        return self.index(self.startIndex, offsetBy: offset)
    }
}

