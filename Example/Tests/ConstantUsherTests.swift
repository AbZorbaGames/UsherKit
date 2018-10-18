import XCTest
import UsherKit

class ConstantUsherTests: XCTestCase {


    struct Horizontal: ConstantHorizontalUsher {
        var horizontalValue: Float
        var horizontalSpacing: Float
        var insets: UsherInsets
    }

    struct Vertical: ConstantVerticalUsher {
        var verticalValue: Float
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

    func testHorizontalRequiredSizeForPositioning() {
        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 20, height: 10),
            CGSize(width: 50, height: 30),
            CGSize(width: 30, height: 20),
            ]
        let horizontalSpacing = Float(5)
        let inset = Float(2)
        let horizontalValue = Float(15)
        let insets = UsherInsets(top: 0, right: inset, bottom: 0, left: inset)
        let layout = Horizontal(horizontalValue: horizontalValue,
                                horizontalSpacing: horizontalSpacing,
                                insets: insets)
        let requiredSize = layout.requiredSizeForPositioning(sizes: sizes)
        XCTAssertTrue(requiredSize != CGSize.zero)
        XCTAssertTrue(requiredSize.layoutWidth == 79)
        XCTAssertTrue(requiredSize.layoutHeight == 30)
    }

    func testVerticalRequiredSizeForPositioning() {
        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 20, height: 10),
            CGSize(width: 50, height: 30),
            CGSize(width: 30, height: 20),
            ]
        let verticalSpacing = Float(5)
        let inset = Float(2)
        let verticalValue = Float(15)
        let insets = UsherInsets(top: inset, right: 0, bottom: inset, left: 0)
        let layout = Vertical(verticalValue: verticalValue,
                              verticalSpacing: verticalSpacing,
                              insets: insets)
        let requiredSize = layout.requiredSizeForPositioning(sizes: sizes)
        XCTAssertTrue(requiredSize != CGSize.zero)
        XCTAssertTrue(requiredSize.layoutWidth == 50)
        XCTAssertTrue(requiredSize.layoutHeight == 79)
    }

    func testBoth() {
        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 20, height: 10),
            CGSize(width: 50, height: 30),
            CGSize(width: 30, height: 20),
            ]
        let spacing = Float(5)
        let inset = Float(2)
        let value = Float(15)
        let insets = UsherInsets(top: inset, right: inset, bottom: inset, left: inset)
        let vertical = Vertical(verticalValue: value,
                                verticalSpacing: spacing,
                                insets: insets)
        let horizontal = Horizontal(horizontalValue: value,
                                    horizontalSpacing: spacing,
                                    insets: insets)
        let layout = CompositeUsher(ushers: [vertical, horizontal],
                                    insets: UsherInsets.zero)
        let requiredSize = layout.requiredSizeForPositioning(sizes: sizes)
        XCTAssertTrue(requiredSize != CGSize.zero)
        XCTAssertTrue(requiredSize.layoutWidth == 79)
        XCTAssertTrue(requiredSize.layoutHeight == 79)
    }

    func testCorrectPositioning() {
        let spacing = Float(5)
        let inset = Float(2)
        let value = Float(15)
        let insets = UsherInsets(top: inset, right: inset, bottom: inset, left: inset)

        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 55, height: 10),
            CGSize(width: 40, height: 30),
            CGSize(width: 25, height: 20),
            ]
        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100))

        let dimension = CGFloat(value)
        let expectedResults: [CGRect] = [
            CGRect(x: 0,
                   y: 0,
                   width: dimension,
                   height: dimension),
            CGRect(x: 0,
                   y: 0,
                   width: dimension,
                   height: dimension),
            CGRect(x: 0,
                   y: 0,
                   width: dimension,
                   height: dimension),
            CGRect(x: 0,
                   y: 0,
                   width: dimension,
                   height: dimension)
        ]

        let vertical = Vertical(verticalValue: value,
                                verticalSpacing: spacing,
                                insets: insets)
        let horizontal = Horizontal(horizontalValue: value,
                                    horizontalSpacing: spacing,
                                    insets: insets)
        let layout = CompositeUsher(ushers: [vertical, horizontal],
                                    insets: UsherInsets.zero)

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
        let spacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: inset, right: inset, bottom: inset, left: inset)
        let value = Float(15)

        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 50, height: 10),
            CGSize(width: 50, height: 30),
            CGSize(width: 50, height: 20),
            ]

        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 60, height: 98))
        let vertical = Vertical(verticalValue: value,
                                verticalSpacing: spacing,
                                insets: insets)
        let horizontal = Horizontal(horizontalValue: value,
                                    horizontalSpacing: spacing,
                                    insets: insets)
        let layout = CompositeUsher(ushers: [vertical, horizontal],
                                    insets: UsherInsets.zero)
        let inRects = sizes.map { (size: CGSize) -> CGRect in
            return CGRect(origin: CGPoint.zero, size: size)
        }
        XCTAssertThrowsError(try layout.positioning(ofRects: inRects, inBounds: bounds))
    }

    struct Left: LeftStackingHorizontalUsher {
        var horizontalSpacing: Float
        var insets: UsherInsets
    }
    struct Bottom: BottomStackingVerticalUsher {
        var verticalSpacing: Float
        var insets: UsherInsets
    }

    func testComposite() {
        let spacing = Float(5)
        let inset = Float(2)
        let value = Float(15)
        let insets = UsherInsets(top: inset, right: inset, bottom: inset, left: inset)

        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 55, height: 10),
            CGSize(width: 40, height: 30),
            CGSize(width: 25, height: 20),
            ]
        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 200))

        let dimension = CGFloat(value)
        let expectedResults: [CGRect] = [
            CGRect(x: dimension * 0,
                   y: 0,
                   width: dimension,
                   height: dimension),
            CGRect(x: dimension * 1,
                   y: 0,
                   width: dimension,
                   height: dimension),
            CGRect(x: dimension * 2,
                   y: 0,
                   width: dimension,
                   height: dimension),
            CGRect(x: dimension * 3,
                   y: 0,
                   width: dimension,
                   height: dimension)
        ]

        let vertical = Vertical(verticalValue: value,
                                verticalSpacing: spacing,
                                insets: insets)
        let horizontal = Horizontal(horizontalValue: value,
                                    horizontalSpacing: spacing,
                                    insets: insets)
        let left = Left(horizontalSpacing: 0, insets: UsherInsets.zero)
        let bottom = Bottom(verticalSpacing: 0, insets: UsherInsets.zero)
        let layout = CompositeUsher(ushers: [vertical, horizontal, bottom],
                                    insets: UsherInsets.zero)

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
