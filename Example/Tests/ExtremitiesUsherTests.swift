import XCTest
import UsherKit

class ExtremitiesUsherTests: XCTestCase {


    struct Bottom: BottomVerticalUsher {
        var verticalSpacing: Float
        var insets: UsherInsets
    }

    struct Top: TopVerticalUsher {
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

    func testTopRequiredSizeForPositioning() {
        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 20, height: 10),
            CGSize(width: 50, height: 30),
            CGSize(width: 30, height: 20),
            ]
        let verticalSpacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: 0, right: inset, bottom: 0, left: inset)
        let layout = Top(verticalSpacing: verticalSpacing,
                         insets: insets)
        let requiredSize = layout.requiredSizeForPositioning(sizes: sizes)
        XCTAssertTrue(requiredSize != CGSize.zero)
        XCTAssertTrue(requiredSize.layoutWidth == 50)
        XCTAssertTrue(requiredSize.layoutHeight == 30)
    }

    func testBottomRequiredSizeForPositioning() {
        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 20, height: 10),
            CGSize(width: 50, height: 30),
            CGSize(width: 30, height: 20),
            ]
        let verticalSpacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: inset, right: 0, bottom: inset, left: 0)
        let layout = Bottom(verticalSpacing: verticalSpacing,
                         insets: insets)
        let requiredSize = layout.requiredSizeForPositioning(sizes: sizes)
        XCTAssertTrue(requiredSize != CGSize.zero)
        XCTAssertTrue(requiredSize.layoutWidth == 50)
        XCTAssertTrue(requiredSize.layoutHeight == 30)
    }

    func testCorrectTopPositioning() {
        let spacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: inset, right: inset, bottom: inset, left: inset)

        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 55, height: 10),
            CGSize(width: 40, height: 30),
            CGSize(width: 25, height: 20),
            ]
        let bounds = CGRect(origin: CGPoint(x: 0, y: 10), size: CGSize(width: 100, height: 100))

        let expectedResults: [CGRect] = [
            CGRect(x: 0,
                   y: bounds.origin.y + CGFloat(inset),
                   width: sizes[0].width,
                   height: sizes[0].height),
            CGRect(x: 0,
                   y: bounds.origin.y + CGFloat(inset),
                   width: sizes[1].width,
                   height: sizes[1].height),
            CGRect(x: 0,
                   y: bounds.origin.y + CGFloat(inset),
                   width: sizes[2].width,
                   height: sizes[2].height),
            CGRect(x: 0,
                   y: bounds.origin.y + CGFloat(inset),
                   width: sizes[3].width,
                   height: sizes[3].height)
        ]

        let layout = Top(verticalSpacing: spacing,
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

    func testCorrectBottomPositioning() {
        let spacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: inset, right: inset, bottom: inset, left: inset)

        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 55, height: 10),
            CGSize(width: 40, height: 30),
            CGSize(width: 25, height: 20),
            ]
        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100))

        let expectedResults: [CGRect] = [
            CGRect(x: 0,
                   y: CGFloat(inset) + bounds.height - sizes[0].height - CGFloat(inset),
                   width: sizes[0].width,
                   height: sizes[0].height),
            CGRect(x: 0,
                   y: CGFloat(inset) + bounds.height - sizes[1].height - CGFloat(inset),
                   width: sizes[1].width,
                   height: sizes[1].height),
            CGRect(x: 0,
                   y: CGFloat(inset) + bounds.height - sizes[2].height - CGFloat(inset),
                   width: sizes[2].width,
                   height: sizes[2].height),
            CGRect(x: 0,
                   y: CGFloat(inset) + bounds.height - sizes[3].height - CGFloat(inset),
                   width: sizes[3].width,
                   height: sizes[3].height)
        ]

        let layout = Bottom(verticalSpacing: spacing,
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
}
