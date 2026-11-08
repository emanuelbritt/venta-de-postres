import AppKit
import CoreGraphics

let root = FileManager.default.currentDirectoryPath
let sizes = [("icon-192.png", 192), ("icon-512.png", 512), ("apple-touch-icon.png", 180), ("favicon-32.png", 32)]
let bg = CGColor(red: 23/255, green: 63/255, blue: 53/255, alpha: 1)
let gold = CGColor(red: 233/255, green: 200/255, blue: 126/255, alpha: 1)
for (name, size) in sizes {
    guard let ctx = CGContext(data: nil, width: size, height: size, bitsPerComponent: 8, bytesPerRow: size * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { fatalError("No bitmap context") }
    ctx.setFillColor(bg); ctx.fill(CGRect(x: 0, y: 0, width: size, height: size))
    ctx.saveGState(); ctx.translateBy(x: 0, y: CGFloat(size)); ctx.scaleBy(x: CGFloat(size) / 512, y: -CGFloat(size) / 512)
    let dessert = CGMutablePath()
    dessert.move(to: CGPoint(x: 256, y: 85))
    dessert.addCurve(to: CGPoint(x: 167, y: 177), control1: CGPoint(x: 236, y: 133), control2: CGPoint(x: 203, y: 154))
    dessert.addCurve(to: CGPoint(x: 112, y: 268), control1: CGPoint(x: 133, y: 199), control2: CGPoint(x: 112, y: 228))
    dessert.addCurve(to: CGPoint(x: 256, y: 419), control1: CGPoint(x: 112, y: 351), control2: CGPoint(x: 173, y: 419))
    dessert.addCurve(to: CGPoint(x: 400, y: 268), control1: CGPoint(x: 339, y: 419), control2: CGPoint(x: 400, y: 351))
    dessert.addCurve(to: CGPoint(x: 345, y: 177), control1: CGPoint(x: 400, y: 228), control2: CGPoint(x: 379, y: 199))
    dessert.addCurve(to: CGPoint(x: 256, y: 85), control1: CGPoint(x: 309, y: 154), control2: CGPoint(x: 276, y: 133))
    dessert.closeSubpath()
    ctx.addPath(dessert); ctx.setFillColor(gold); ctx.fillPath()
    // Small dark highlight gives the mark a clear, recognizable center at app-icon size.
    let seed = CGMutablePath()
    seed.move(to: CGPoint(x: 256, y: 309))
    seed.addCurve(to: CGPoint(x: 293, y: 371), control1: CGPoint(x: 282, y: 330), control2: CGPoint(x: 293, y: 350))
    seed.addCurve(to: CGPoint(x: 256, y: 408), control1: CGPoint(x: 293, y: 392), control2: CGPoint(x: 277, y: 408))
    seed.addCurve(to: CGPoint(x: 219, y: 371), control1: CGPoint(x: 235, y: 408), control2: CGPoint(x: 219, y: 392))
    seed.addCurve(to: CGPoint(x: 256, y: 309), control1: CGPoint(x: 219, y: 350), control2: CGPoint(x: 230, y: 330))
    seed.closeSubpath(); ctx.addPath(seed); ctx.setFillColor(bg); ctx.fillPath()
    ctx.restoreGState()
    guard let image = ctx.makeImage(), let rep = NSBitmapImageRep(cgImage: image), let png = rep.representation(using: .png, properties: [:]) else { fatalError("PNG export failed") }
    try png.write(to: URL(fileURLWithPath: root).appendingPathComponent(name))
}
