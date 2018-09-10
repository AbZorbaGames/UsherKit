//
//  CGAdaptation.swift
//  UsherKit_Tests
//
//  Created by Georges Boumis on 10/09/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import QuartzCore
import UsherKit

extension CGPoint: UsherPoint {
    public var layoutX: Float {
        get { return Float(self.x) }
        set { self.x = CGFloat(newValue) }
    }

    public var layoutY: Float {
        get { return Float(self.y) }
        set { self.y = CGFloat(newValue) }
    }

    public init(layoutX: Float, layoutY: Float) {
        self.init(x: CGFloat(layoutX),
                  y: CGFloat(layoutY))
    }

    public init(usherPoint: UsherPoint) {
        self.init(layoutX: usherPoint.layoutX,
                  layoutY: usherPoint.layoutY)
    }
}

extension CGSize: UsherSize {
    public var layoutWidth: Float {
        get { return Float(self.width) }
        set { self.width = CGFloat(newValue) }
    }

    public var layoutHeight: Float {
        get { return Float(self.height) }
        set { self.height = CGFloat(newValue) }
    }

    public init(layoutWidth: Float, layoutHeight: Float) {
        self.init(width: CGFloat(layoutWidth),
                  height: CGFloat(layoutHeight))
    }

    public init(layoutSize: UsherSize) {
        self.init(layoutWidth: layoutSize.layoutWidth,
                  layoutHeight: layoutSize.layoutHeight)
    }
}

extension CGRect: UsherRect {
    public var layoutOrigin: UsherPoint {
        get { return self.origin }
        set { self.origin = CGPoint(usherPoint: newValue) }
    }

    public var layoutSize: UsherSize {
        get { return self.size }
        set { self.size = CGSize(layoutSize: newValue) }
    }

    public init(layoutOrigin: UsherPoint, layoutSize: UsherSize) {
        self.init(origin: CGPoint(usherPoint: layoutOrigin),
                  size: CGSize(layoutSize: layoutSize))
    }

    public init(usherRect: UsherRect) {
        self.init(layoutOrigin: usherRect.layoutOrigin,
                  layoutSize: usherRect.layoutSize)
    }
}

