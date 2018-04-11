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

//public protocol VerticalLayout: Layout {
//    var verticalSpacing: Float { get set }
//}
//
//
//public extension VerticalLayout {
//
//    func requiredSizeForPositioning(rectangulars: [UsherRect]) -> UsherSize {
//        assert(rectangulars.isEmpty == false)
//        guard rectangulars.isEmpty == false else { return UsherSize.zero }
//
//        let first = rectangulars[0]
//        var (width, height) = (first.width, first.height)
//        rectangulars.forEach { (rect: UsherRect) in
//            if rect.width > width {
//                width = rect.width
//            }
//            height += (self.verticalSpacing + rect.height)
//        }
//        width += (self.insets.top + self.insets.bottom)
//        return UsherSize(width: width, height: height)
//    }
//}

