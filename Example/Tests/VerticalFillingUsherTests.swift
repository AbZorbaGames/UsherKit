import XCTest
import UsherKit

class VerticalFillingTests: XCTestCase {


    struct VerticalFillingLayout: VerticalFillingUsher {
        var verticalSpacing: Float
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
            CGSize(width: 20, height: 10),
            CGSize(width: 50, height: 30),
            CGSize(width: 30, height: 20),
            ]
        let verticalSpacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: inset, right: 0, bottom: inset, left: 0)
        let layout = VerticalFillingLayout(verticalSpacing: verticalSpacing,
                                             insets: insets)
        let requiredSize = layout.requiredSizeForPositioning(sizes: sizes)
        XCTAssertTrue(requiredSize != CGSize.zero)
        XCTAssertTrue(requiredSize.layoutWidth == Float(50))
        XCTAssertTrue(requiredSize.layoutHeight == Float(99))
    }

    func testEmptyRequiredSizeForPositiong() {
        let sizes: [CGSize] = []
        let horizontalSpacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: inset, right: 0, bottom: inset, left: 0)
        let layout = VerticalFillingLayout(verticalSpacing: horizontalSpacing,
                                             insets: insets)
        let requiredSize = layout.requiredSizeForPositioning(sizes: sizes)
        XCTAssertTrue(requiredSize == CGSize.zero)
    }

    func testCorrectPositioning() {
        let horizontalSpacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: inset, right: 0, bottom: inset, left: 0)

        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 55, height: 10),
            CGSize(width: 40, height: 30),
            CGSize(width: 25, height: 20),
            ]
        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 60, height: 100))
        let height = (bounds.height - CGFloat(insets.top + insets.bottom)) / CGFloat(sizes.count)

        let expectedRsults = [
            CGRect(x: 0,
                   y: CGFloat(insets.top) + height * 0,
                   width: sizes[0].width,
                   height: height),
            CGRect(x: 0,
                   y: CGFloat(insets.top) + height * 1,
                   width: sizes[1].width,
                   height: height),
            CGRect(x: 0,
                   y: CGFloat(insets.top) + height * 2,
                   width: sizes[2].width,
                   height: height),
            CGRect(x: 0,
                   y: CGFloat(insets.top) + height * 3,
                   width: sizes[3].width,
                   height: height)
        ]


        let layout = VerticalFillingLayout(verticalSpacing: horizontalSpacing,
                                             insets: insets)
        let inRects = sizes.map { (size: CGSize) -> CGRect in
            return CGRect(origin: CGPoint.zero, size: size)
        }
        do {
            let outRects = try layout.positioning(ofRects: inRects, inBounds: bounds)
            XCTAssert(outRects.count == inRects.count)
            XCTAssert(outRects == expectedRsults)
        } catch {
            XCTFail()
        }
    }

    func testWrongPositioning() {
        let horizontalSpacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: inset, right: 0, bottom: inset, left: 0)

        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 50, height: 10),
            CGSize(width: 50, height: 30),
            CGSize(width: 50, height: 20),
            ]

        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 60, height: 98))
        let layout = VerticalFillingLayout(verticalSpacing: horizontalSpacing,
                                             insets: insets)
        let inRects = sizes.map { (size: CGSize) -> CGRect in
            return CGRect(origin: CGPoint.zero, size: size)
        }
        XCTAssertThrowsError(try layout.positioning(ofRects: inRects, inBounds: bounds))
    }

    func testEmptyPositioning() {
        let horizontalSpacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: inset, right: 0, bottom: inset, left: 0)

        let sizes: [CGSize] = []

        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 50, height: 80))
        let layout = VerticalFillingLayout(verticalSpacing: horizontalSpacing,
                                             insets: insets)
        let inRects = sizes.map { (size: CGSize) -> CGRect in
            return CGRect(origin: CGPoint.zero, size: size)
        }
        XCTAssertThrowsError(try layout.positioning(ofRects: inRects, inBounds: bounds))
    }
}
