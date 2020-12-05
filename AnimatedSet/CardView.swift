//
//  CardView.swift
//  GraphicalSet
//
//  Created by Federico Veronesi on 21/11/2020.
//

import UIKit

class CardView: UIView {
    private(set) var shape: Shape?
    private(set) var color: UIColor?
    private(set) var shading: Shading?
    private(set) var number: Int?
    private lazy var separator: CGFloat = scaled(2.0)
    private var aspectRatio: AspectRatio {
        bounds.width / bounds.height > 1 ? .landscape : .portrait
    }
    private var scaleFactor: CGFloat {
        aspectRatio == .portrait ? bounds.width / 37.22 : bounds.height / 32.77
    }
    var selected = false {
        didSet {
            setNeedsDisplay()
        }
    }
    var facedUp = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    convenience init(frame: CGRect, shape: Shape, color: UIColor, shading: Shading, number: Int) {
        self.init(frame: frame)
        self.shape = shape
        self.color = color
        self.shading = shading
        self.number = number
        contentMode = .redraw
    }
    
    override func draw(_ rect: CGRect) {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            UIColor.black.setFill()
        default:
            UIColor.white.setFill()
        }
        UIRectFill(rect)
        
        let cardPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: scaled(2.0), y: scaled(2.0)),
                                                        size: CGSize(width: bounds.maxX - scaled(4.0),
                                                                     height: bounds.maxY - scaled(4.0))),
                                    cornerRadius: scaled(3.0))
        if facedUp {
            UIColor.setGameBackground.setFill()
            cardPath.lineWidth = scaled(1.5)
            if selected {
                UIColor.setGameSelected.setStroke()
                cardPath.stroke()
            }
        } else {
            UIColor.black.setFill()
        }
        
        cardPath.fill()
        
        if facedUp, let shape = self.shape, let color = self.color, let shading = self.shading, let number = self.number {
            let picturePaths = paths(for: shape, times: number)
            if shading == .striped {
                picturePaths.forEach { stripe($0, withColor: color) }
            }
            fillAndStroke(color: color, forPattern: shading)
            picturePaths.forEach { path in
                path.lineWidth = scaled(2.0)
                path.fill()
                path.stroke()
            }
        }
    }
    
    private func scaled(_ value: CGFloat) -> CGFloat {
        return value * scaleFactor
    }
    
    private func paths(for shape: Shape, times: Int) -> [UIBezierPath] {
        switch shape {
        case .diamond:
            let path = UIBezierPath()
            path.move(to: CGPoint(x: bounds.midX - scaled(8.0), y: bounds.midY))
            path.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY - scaled(4.0)))
            path.addLine(to: CGPoint(x: bounds.midX + scaled(8.0), y: bounds.midY))
            path.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY + scaled(4.0)))
            path.close()
            return repeatPath(path, times: times)
        case .oval:
            let path = UIBezierPath(roundedRect: CGRect(x: bounds.midX - scaled(8.0),
                                                        y: bounds.midY - scaled(4.0),
                                                        width: scaled(16.0),
                                                        height: scaled(8.0)),
                                    cornerRadius: 100.0)
            return repeatPath(path, times: times)
        case .squiggle:
            let path = UIBezierPath()
            path.move(to: CGPoint(x: bounds.midX - scaled(8.0), y: bounds.midY + scaled(4.0)))
            path.addLine(to: CGPoint(x: bounds.midX - scaled(5.0), y: bounds.midY - scaled(4.0)))
            path.addLine(to: CGPoint(x: bounds.midX + scaled(3.0), y: bounds.midY - scaled(2.5)))
            path.addLine(to: CGPoint(x: bounds.midX + scaled(8.0), y: bounds.midY - scaled(4.0)))
            path.addLine(to: CGPoint(x: bounds.midX + scaled(5.0), y: bounds.midY + scaled(4.0)))
            path.addLine(to: CGPoint(x: bounds.midX - scaled(3.0), y: bounds.midY + scaled(2.5)))
            path.close()
            
            return repeatPath(path, times: times)
        }
    }
    
    private func repeatPath(_ path: UIBezierPath, times: Int) -> [UIBezierPath] {
        switch times {
        case 1:
            return [path]
        case 2:
            switch aspectRatio {
            case .portrait:
                path.apply(CGAffineTransform(translationX: 0, y: scaled(-6.0)))
                let secondPath = path.copy() as! UIBezierPath
                secondPath.apply(CGAffineTransform(translationX: 0, y: scaled(12.0)))
                return [path, secondPath]
            case .landscape:
                path.apply(CGAffineTransform(translationX: scaled(-10.0), y: 0))
                let secondPath = path.copy() as! UIBezierPath
                secondPath.apply(CGAffineTransform(translationX: scaled(20.0), y: 0))
                return [path, secondPath]
            }
        case 3:
            switch aspectRatio {
            case .portrait:
                let secondPath = path.copy() as! UIBezierPath
                secondPath.apply(CGAffineTransform(translationX: 0, y: scaled(-12.0)))
                let thirdPath = path.copy() as! UIBezierPath
                thirdPath.apply(CGAffineTransform(translationX: 0, y: scaled(12.0)))
                return [path, secondPath, thirdPath]
            case .landscape:
                let secondPath = path.copy() as! UIBezierPath
                secondPath.apply(CGAffineTransform(translationX: scaled(-20.0), y: 0))
                let thirdPath = path.copy() as! UIBezierPath
                thirdPath.apply(CGAffineTransform(translationX: scaled(20.0), y: 0))
                return [path, secondPath, thirdPath]
            }
        default:
            return []
        }
    }
    
    private func fillAndStroke(color: UIColor, forPattern shading: CardView.Shading) {
        switch shading {
        case .open:
            break
        case .solid:
            color.setFill()
        case .striped:
            color.withAlphaComponent(0.3).setFill()
        }
        color.setStroke()
    }
    
    private func stripe(_ path: UIBezierPath, withColor color: UIColor) {
        let stripedPath = UIBezierPath()
        for x in stride(from: path.bounds.minX, to: path.bounds.maxX, by: scaled(3)) {
            stripedPath.move(to: CGPoint(x: x + scaled(2.0), y: path.bounds.minY))
            stripedPath.addLine(to: CGPoint(x: x, y: path.bounds.maxY))
        }
        stripedPath.lineWidth = scaled(1.0)
        
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        
        path.addClip()
        color.setStroke()
        stripedPath.stroke()
        stripedPath.fill()
        
        context.restoreGState()
    }
}

extension CardView {
    /*
     TODO: Refactor with `rawValue`s and add number and color
     or accept: uicolor for color, [cgpoint] for shape, cgfloat/(uicolor, [cgpoint]) for shading, int for number
     then refactor the controller to convert these values into model enums
     */
    enum Shape {
        case diamond, squiggle, oval
    }
    
    enum Shading {
        case solid, striped, open
    }
    
    enum AspectRatio {
        case portrait, landscape
    }
}
