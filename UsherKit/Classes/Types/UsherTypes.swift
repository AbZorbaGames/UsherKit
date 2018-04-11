//
//  UsherTypes.swift
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

public protocol UsherPoint {
    var layoutX: Float { get set }
    var layoutY: Float { get set }
    
    init(layoutX: Float, layoutY: Float)
    
    static var zero: UsherPoint { get }
}

public extension UsherPoint {
    static var zero: UsherPoint { return UPoint(layoutX: 0, layoutY: 0) }
}



public protocol UsherSize {
    var layoutWidth: Float { get set }
    var layoutHeight: Float { get set }
    
    init(layoutWidth: Float, layoutHeight: Float)
    
    static var zero: UsherSize { get }
}

public extension UsherSize {
    static var zero: UsherSize { return USize(layoutWidth: 0, layoutHeight: 0) }
}



public protocol UsherRect {
    var layoutOrigin: UsherPoint { get set }
    var UsherSize: UsherSize { get set }
    
    init(layoutOrigin: UsherPoint, UsherSize: UsherSize)
    
    static var zero: UsherRect { get }
}

public extension UsherRect {
    
    var layoutWidth: Float {
        get { return self.UsherSize.layoutWidth }
        set { self.UsherSize.layoutWidth = newValue }
    }
    var layoutHeight: Float {
        get { return self.UsherSize.layoutHeight }
        set { self.UsherSize.layoutHeight = newValue }
    }
    
    static var zero: UsherRect { return URect(layoutOrigin: UPoint.zero,
                                              UsherSize: USize.zero) }
}
