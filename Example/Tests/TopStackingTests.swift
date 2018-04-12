import XCTest
import UsherKit

class TopStackingTests: XCTestCase {
    
    
    struct TopStackingLayout: TopStackingVerticalUsher {
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
            CGSize(width: 60, height: 10),
            CGSize(width: 20, height: 30),
            CGSize(width: 10, height: 20),
            ]
        let verticalSpacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: inset, right: 0, bottom: inset, left: 0)
        let layout = TopStackingLayout(verticalSpacing: verticalSpacing,
                                        insets: insets)
        let requiredSize = layout.requiredSizeForPositioning(sizes: sizes)
        XCTAssertTrue(requiredSize != CGSize.zero)
        XCTAssertTrue(requiredSize.layoutWidth == Float(60))
        XCTAssertTrue(requiredSize.layoutHeight == Float(99))
    }
    
    func testEmptyRequiredSizeForPositiong() {
        let sizes: [CGSize] = []
        let verticalSpacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: inset, right: 0, bottom: inset, left: 0)
        let layout = TopStackingLayout(verticalSpacing: verticalSpacing,
                                        insets: insets)
        let requiredSize = layout.requiredSizeForPositioning(sizes: sizes)
        XCTAssertTrue(requiredSize == CGSize.zero)
    }
    
    
    func testCorrectPositioning() {
        let verticalSpacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: 0, right: inset, bottom: 0, left: inset)
        
        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 60, height: 10),
            CGSize(width: 20, height: 30),
            CGSize(width: 10, height: 20),
            ]
        let expectedResults = [
            CGRect(x: 0, y: CGFloat(insets.top), width: sizes[0].width, height: sizes[0].height),
            CGRect(x: 0, y: CGFloat(insets.top) + CGFloat(verticalSpacing) + sizes[0].height, width: sizes[1].width, height: sizes[1].height),
            CGRect(x: 0, y: CGFloat(insets.top) + CGFloat(verticalSpacing * 2) + sizes[0].height + sizes[1].height, width: sizes[2].width, height: sizes[2].height),
            CGRect(x: 0, y: CGFloat(insets.top) + CGFloat(verticalSpacing * 3) + sizes[0].height + sizes[1].height + sizes[2].height, width: sizes[3].width, height: sizes[3].height)
        ]
        
        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 60, height: 100))
        let layout = TopStackingLayout(verticalSpacing: verticalSpacing,
                                        insets: insets)
        do {
            let inRects = sizes.map { (size: CGSize) -> CGRect in
                return CGRect(origin: CGPoint.zero, size: size)
            }
            let outRects = try layout.positioning(ofRects: inRects, inBounds: bounds)
            XCTAssert(outRects.count == inRects.count)
            XCTAssert(outRects == expectedResults)
        } catch {
            XCTFail()
        }
    }
    
    func testWrongPositioning() {
        let verticalSpacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: 0, right: inset, bottom: 0, left: inset)
        
        let sizes = [
            CGSize(width: 50, height: 20),
            CGSize(width: 50, height: 10),
            CGSize(width: 50, height: 30),
            CGSize(width: 50, height: 20),
            ]
        
        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 50))
        let layout = TopStackingLayout(verticalSpacing: verticalSpacing,
                                        insets: insets)
        let inRects = sizes.map { (size: CGSize) -> CGRect in
            return CGRect(origin: CGPoint.zero, size: size)
        }
        XCTAssertThrowsError(try layout.positioning(ofRects: inRects, inBounds: bounds))
    }
    
    func testEmptyPositioning() {
        let verticalSpacing = Float(5)
        let inset = Float(2)
        let insets = UsherInsets(top: 0, right: inset, bottom: 0, left: inset)
        
        let sizes: [CGSize] = []
        
        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 50))
        let layout = TopStackingLayout(verticalSpacing: verticalSpacing,
                                        insets: insets)
        let inRects = sizes.map { (size: CGSize) -> CGRect in
            return CGRect(origin: CGPoint.zero, size: size)
        }
        XCTAssertThrowsError(try layout.positioning(ofRects: inRects, inBounds: bounds))
    }
}
