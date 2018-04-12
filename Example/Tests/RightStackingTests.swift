//
//  RightStackingTests.swift
//  UsherKit_Tests
//
//  Created by Georges Boumis on 12/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import UsherKit

class RightStackingTests: XCTestCase {
    
    
    struct RightStackingLayout: RightStackingHorizontalUsher {
        var horizontalSpacing: Float
        var insets: UsherInsets
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRequiredSizeForPositioning() {
        // This is an example of a functional test case.
        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 50, height: 10),
            CGSize(width: 50, height: 30),
            CGSize(width: 50, height: 20),
            ]
        let horizontalSpacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: 0, right: inset, bottom: 0, left: inset)
        let layout = RightStackingLayout(horizontalSpacing: horizontalSpacing,
                                        insets: insets)
        let requiredSize = layout.requiredSizeForPositioning(sizes: sizes)
        XCTAssertTrue(requiredSize != CGSize.zero)
        XCTAssertTrue(requiredSize.layoutWidth == Float(219))
        XCTAssertTrue(requiredSize.layoutHeight == Float(30))
    }
    
    func testEmptyRequierdSizeForPositiong() {
        let sizes: [CGSize] = []
        let horizontalSpacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: 0, right: inset, bottom: 0, left: inset)
        let layout = RightStackingLayout(horizontalSpacing: horizontalSpacing,
                                        insets: insets)
        let requiredSize = layout.requiredSizeForPositioning(sizes: sizes)
        XCTAssertTrue(requiredSize == CGSize.zero)
    }
    
    
    func testCorrectPositioning() {
        let horizontalSpacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: 0, right: inset, bottom: 0, left: inset)
        
        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 55, height: 10),
            CGSize(width: 40, height: 30),
            CGSize(width: 20, height: 20),
            ]
        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 250, height: 50))
        let expectedResults = [
            CGRect(x: bounds.width - CGFloat(insets.right) - sizes[3].width - CGFloat(horizontalSpacing * 3) - sizes[2].width - sizes[1].width - sizes[0].width, y: 0, width: sizes[0].width, height: sizes[0].height),
            CGRect(x: bounds.width - CGFloat(insets.right) - sizes[3].width - CGFloat(horizontalSpacing * 2) - sizes[2].width - sizes[1].width, y: 0, width: sizes[1].width, height: sizes[1].height),
            CGRect(x: bounds.width - CGFloat(insets.right) - sizes[3].width - CGFloat(horizontalSpacing) - sizes[2].width, y: 0, width: sizes[2].width, height: sizes[2].height),
            CGRect(x: bounds.width - CGFloat(insets.right) - sizes[3].width, y: 0, width: sizes[3].width, height: sizes[3].height)
        ]
        
        let layout = RightStackingLayout(horizontalSpacing: horizontalSpacing,
                                        insets: insets)
        let inRects = sizes.map { (size: CGSize) -> CGRect in
            return CGRect(origin: CGPoint.zero, size: size)
        }
        do {
            let outRects = try layout.positioning(ofRects: inRects, inBounds: bounds)
            XCTAssert(outRects.count == inRects.count)
            XCTAssert(outRects == expectedResults)
        } catch {
            XCTFail()
        }
    }
    
    func testWrongPositioning() {
        let horizontalSpacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: 0, right: inset, bottom: 0, left: inset)
        
        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 50, height: 10),
            CGSize(width: 50, height: 30),
            CGSize(width: 50, height: 20),
            ]
        
        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 50))
        let layout = RightStackingLayout(horizontalSpacing: horizontalSpacing,
                                        insets: insets)
        let inRects = sizes.map { (size: CGSize) -> CGRect in
            return CGRect(origin: CGPoint.zero, size: size)
        }
        XCTAssertThrowsError(try layout.positioning(ofRects: inRects, inBounds: bounds))
    }
    
    func testEmptyPositioning() {
        let horizontalSpacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: 0, right: inset, bottom: 0, left: inset)
        
        let sizes: [CGSize] = []
        
        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 50))
        let layout = RightStackingLayout(horizontalSpacing: horizontalSpacing,
                                        insets: insets)
        let inRects = sizes.map { (size: CGSize) -> CGRect in
            return CGRect(origin: CGPoint.zero, size: size)
        }
        XCTAssertThrowsError(try layout.positioning(ofRects: inRects, inBounds: bounds))
    }
}
