//
// Created by 郑虎 on 15 年 五月. 25..
// Copyright (c) 2015 郑虎. All rights reserved.
//

import Foundation
import UIKit

//enum Color {
//    case Red
//    case Green
//    case Yellow
//}

struct SingleHex {
//    let color: Color
    let expectedSurroundings: Int
    var actualSurroudings: Int {
//        didSet {
//            switch actualSurroudings {
//                case let a where a > expectedSurroundings:
//                    color = Color.Red // Too much coupling for color here?
//                case let a where a == expectedSurroundings:
//                    color = Color.Yellow
//                case let a where a < expectedSurroundings:
//                    color = Color.Green
//            }
//        }
    }


}


struct HexGameBoard<T> {
    let dimension: Int
    var boardArray: [[T]] = [[]]

    var reverseIndex: [[(Int, Int)]] = [[]] // Decoupling?

    init (dimension d: Int, initialValue: T) {
        dimension = d
        if d >= 0 {
            boardArray[0][0] = initialValue
        }
        for i in 1..<d {
            for j in 0..<(6 * i) {
                boardArray[i][j] = initialValue
            }
        }

        for i in (0 - d)..<(d + 1) {
            for j in (0 - d)..<(d + 1) {
                reverseIndex[i][j] = twoToHex((i, j))
            }
        }


    }

    func neighborIndex (cor: (x: Int, y: Int)) -> [(Int, Int)] {
        let (tx, ty) = (hexToTwo(cor))
        let twoNeighbors = [(tx + 1, ty), (tx - 1, ty), (tx + 1, ty + 1), (tx, ty + 1), (tx, ty - 1), (tx - 1, ty - 1)]
        return twoNeighbors.map{(var cor) -> (Int, Int) in
            return self.twoToHex(cor)
        }
    }

    func twoToHex(cor: (x: Int, y: Int)) -> (Int, Int) {
        var (cX, cY): (Int, Int)
        let (x, y) = cor
        switch x {
        case let tx where tx >= 0:
            cX = x
            switch y {
            case let ty where ty < 0:
                cX = x - y
                cY = (6 * cX) - (0 - y)
            case let ty where ty > x:
                //                cX = x + (y - x)
                cX = y
                cY = y + 1
            default:
                cY = y
            }
        case let tx where tx < 0:
            cX = 0 - x
            switch y {
            case let ty where ty > 0:
                cX = 0 - x + y
                cY = (3 * cX) - 1
            case let ty where ty < x:
                //                cX = (- x) + (x - y)
                cX = 0 - y
                cY = 5 * cX + x
            default:
                cY = (3 * (0 - x)) + (0 - y)
            }
        default:
            cX = 0
            cY = 0
        }
        return (cX, cY)
    }

    func hexToTwo(cor: (x: Int, y: Int)) -> (Int, Int) {
        return reverseIndex[cor.x][cor.y]

    }

}







protocol HexGameModelProtocol: class {

}

/**
Implements the hex game model
**/
class HexGameModel: NSObject {

    let dimension: Int
    let delegate: HexGameModelProtocol



    var finished = false
    /**
    Initialize the hex game model

    :param: dimension The dimension of the gameboard.
    :param: delegate The delegate of the game
    **/
    init(dimension d: Int, delegate: HexGameModelProtocol) {
        self.dimension = d
        self.delegate = delegate

        super.init()
    }

    func reset() {

    }

    func randomInit() {

    }

    func singleHexDown() {

    }

    func singleHexUp() {

    }



}

class HexGameController: HexGameModelProtocol, UIViewController {
    var dimension: Int





}
// Why is it not delegated?
class SingleHexView: UIView {
    var color: UIColor
    var numberLabel: UILabel
    var delegate: AppearanceProviderProtocol
    let angleOffSet: CGFloat
    let radius: CGFloat
    let center: CGPoint
    let value: Int


    var expectedNumber: Int = 0 {
       didSet {
           backgroundColor = delegate.singleHexColor(expectedNumber, actualNumber: actualNumber)
           numberLabel.textColor = delegate.singleHexTextColor(expectedNumber, actualNumber: actualNumber)
           numberLabel.text = "\(actualNumber)"
       }
    }
    var actualNumber: Int = 0

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    init(position: CGPoint, radius: CGFloat, color: UIColor, angleOffSet: CGFloat, value: Int, delegate d: AppearanceProviderProtocol) {
        delegate = d

        self.angleOffSet = angleOffSet
        super.init(frame: CGRectMake(position.x, position.y, radius, radius))
    }

    func degreeToRadian(a: CGFloat) -> CGFloat {
        return (CGFloat)(M_PI) / 2 * a
    }

    func polygonVertices(number: Int, point: CGPoint, radius: CGFloat, angleOffSet: CGFloat = 0) -> [CGPoint] {
        let angleShare = degreeToRadian(360 / number)
        let angle = angleOffSet
        var points = [CGPoint]
        for i in 0..<number {
            points.append(CGPoint(point.x + radius * cos(angle), point.y + radius * sin(angle)))
            angle += angleShare
        }
        return points
    }

    func drawPolygon(#ctx:CGContextRef, #x:CGFloat, #y:CGFloat, #radius:CGFloat, #sides:Int, #color:UIColor) {

        let points = polygonVertices(sides, CGPoint(x, y), radius)

        CGContextAddLines(ctx, points, UInt(points.count))

        let cgcolor = color.CGColor
        CGContextSetFillColorWithColor(ctx,cgcolor)
        CGContextFillPath(ctx)
    }

    override func drawRect(rect: CGRect) {
        let angleOff = self.angleOffSet
        let xOffSet = CGFloat(radius)
        var ctx = UIGraphicsGetCurrentContext()
        drawPolygon(ctx: ctx, x: CGRectGetMidX(rect),y: CGRectGetMidY(rect),radius: CGRectGetWidth(rect)/5, sides: 6, color: UIColor.greenColor())
    }

}

class HexGameboardView: UIView {
    var dimension: Int

    var singleHexRadius: CGFloat
    var singleHexPadding: CGFloat
    var hexes: Dictionary<(Int, Int), SingleHexView>

    let provider = AppearanceProvider()

    // Not ready for animations

    init(dimension d: Int, singleHexRadius radius: CGFloat, singleHexPadding padding: CGFloat, backgroundColor: UIColor, foregroundColor: UIColor) {
        assert(d > 0)

        dimension = d
        singleHexRadius = radius
        singleHexPadding = padding
        hexes = Dictionary()


    }


    func getCordinate((Int, Int)) -> CGPoint {

    }



}





protocol AppearanceProviderProtocol: class {
    func singleHexColor(expectedNumber: Int, actualNumber: Int) -> UIColor
    func singleHexTextColor(expectedNumber: Int, actualNumber: Int) -> UIColor
}

class AppearanceProvider: AppearanceProviderProtocol {
    func SingleHexColor() -> UIColor {

    }

}