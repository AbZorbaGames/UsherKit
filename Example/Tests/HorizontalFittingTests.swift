import XCTest
import UsherKit

class CenterStackingFittingTests: XCTestCase {
    
    
    struct HorizontalFittingLayout: CenterStackingHorizontalUsher {
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

    func testCorrectPositioning() {
        let inset = Float(2)
        let horizontalSpacing = Float(5)
        let insets = UsherInsets(top: 0, right: inset, bottom: 0, left: inset)

        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 150, height: 80))
        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 60, height: 10),
            CGSize(width: 20, height: 30),
            ]
        let expectedResults = [
            CGRect(x: 2, y: 30, width: sizes[0].width, height: sizes[0].height),
            CGRect(x: 57, y: 35, width: sizes[1].width, height: sizes[1].height),
            CGRect(x: 122, y: 25, width: sizes[2].width, height: sizes[2].height)
        ]

        let layout = LeftStackingVerticalCenteringLayout(horizontalSpacing: horizontalSpacing, insets: insets)
        let inRects = sizes.map { (size: CGSize) -> CGRect in
            return CGRect(origin: CGPoint.zero, size: size)
        }
        do {
            let outRects = try layout.positioning(ofRects: inRects, inBounds: bounds)
            XCTAssert(inRects.count == outRects.count)

            XCTAssert(outRects == expectedResults)
        } catch {
            XCTFail()
        }
    }
}
