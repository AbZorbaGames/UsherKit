import XCTest
import UsherKit

class HorizontalCenteringTests: XCTestCase {
    
    
    struct HorizontalCenteringLayout: HorizontalCenteringUsher {
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
            CGSize(width: 60, height: 10),
            CGSize(width: 20, height: 30),
            CGSize(width: 10, height: 20),
            ]
        let inset = Float(2)
        let insets = UsherInsets(top: inset, right: 0, bottom: inset, left: 0)
        let layout = HorizontalCenteringLayout(insets: insets)
        let requiredSize = layout.requiredSizeForPositioning(sizes: sizes)
        XCTAssertTrue(requiredSize != CGSize.zero)
        XCTAssertTrue(requiredSize.layoutWidth == Float(60))
        XCTAssertTrue(requiredSize.layoutHeight == Float(30))
    }

    func testEmptyRequiredSizeForPositiong() {
        let sizes: [CGSize] = []
        let inset = Float(2)
        let insets = UsherInsets(top: inset, right: 0, bottom: inset, left: 0)
        let layout = HorizontalCenteringLayout(insets: insets)
        let requiredSize = layout.requiredSizeForPositioning(sizes: sizes)
        XCTAssertTrue(requiredSize == CGSize.zero)
    }


    func testCorrectPositioning() {
        let inset = Float(2)
        let insets = UsherInsets(top: inset, right: 0, bottom: inset, left: 0)

        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 80))
        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 60, height: 10),
            CGSize(width: 20, height: 30),
            CGSize(width: 10, height: 20),
            ]
        let expectedResults = [
            CGRect(x: 25, y: 0, width: sizes[0].width, height: sizes[0].height),
            CGRect(x: 20, y: 0, width: sizes[1].width, height: sizes[1].height),
            CGRect(x: 40, y: 0, width: sizes[2].width, height: sizes[2].height),
            CGRect(x: 45, y: 0, width: sizes[3].width, height: sizes[3].height)
        ]

        let layout = HorizontalCenteringLayout(insets: insets)
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
        let inset = Float(2)
        let insets = UsherInsets(top: inset, right: 0, bottom: inset, left: 0)

        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 50, height: 10),
            CGSize(width: 50, height: 30),
            CGSize(width: 50, height: 20),
            ]

        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 5))
        let layout = HorizontalCenteringLayout(insets: insets)
        let inRects = sizes.map { (size: CGSize) -> CGRect in
            return CGRect(origin: CGPoint.zero, size: size)
        }
        XCTAssertThrowsError(try layout.positioning(ofRects: inRects, inBounds: bounds))
    }

    func testEmptyPositioning() {
        let inset = Float(2)
        let insets = UsherInsets(top: inset, right: 0, bottom: inset, left: 0)

        let sizes: [CGSize] = []

        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 50))
        let layout = HorizontalCenteringLayout(insets: insets)
        let inRects = sizes.map { (size: CGSize) -> CGRect in
            return CGRect(origin: CGPoint.zero, size: size)
        }
        XCTAssertThrowsError(try layout.positioning(ofRects: inRects, inBounds: bounds))
    }
}
