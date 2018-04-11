//
//  UsherInternalTypes.swift
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

internal struct UPoint: UsherPoint {
    var layoutX: Float
    var layoutY: Float
    
    init(layoutX: Float, layoutY: Float) {
        self.layoutX = layoutX
        self.layoutY = layoutY
    }
}


internal struct USize: UsherSize {
    var layoutWidth: Float
    var layoutHeight: Float
    
    init(layoutWidth: Float, layoutHeight: Float) {
        self.layoutWidth = layoutWidth
        self.layoutHeight = layoutHeight
    }
}

internal struct URect: UsherRect {
    var layoutOrigin: UsherPoint
    var UsherSize: UsherSize
    
    init(layoutOrigin: UsherPoint, UsherSize: UsherSize) {
        self.layoutOrigin = layoutOrigin
        self.UsherSize = UsherSize
    }
}
