import UIKit

class CutoutTabHeaderCell: UIImageView {

    init?(text: String, numTitles: Int, font: UIFont) {
        let width = (Layout.viewWidth / CGFloat(numTitles))
            .keepBetween(min: Layout.minTabWidth, max: Layout.viewWidth / 2)
        let size = CGSize(
            width: width + 16,
            height: CutoutTabHeader.tabHeight - Layout.marginMedium
        )
        UIGraphicsBeginImageContextWithOptions(size, true, 0)

        let context = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -size.height)

        // draw the text
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.white
        ]
        let textSize = text.size(withAttributes: attributes)
        let point = CGPoint(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2
        )
        text.draw(at: point, withAttributes: attributes)

        // capture the image and end context
        let maskImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // create image mask
        guard let cgimage = maskImage?.cgImage,
            let dataProvider = cgimage.dataProvider
            else { return nil }

        guard let mask = CGImage(
            maskWidth: cgimage.width,
            height: cgimage.height,
            bitsPerComponent: cgimage.bitsPerComponent,
            bitsPerPixel: cgimage.bitsPerPixel,
            bytesPerRow: cgimage.bytesPerRow,
            provider: dataProvider,
            decode: nil,
            shouldInterpolate: false
            ) else { return nil }

        // create the actual image
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIGraphicsGetCurrentContext()?.clip(to: rect, mask: mask)
        UIColor.white.withAlphaComponent(1).setFill()
        UIBezierPath(rect: rect).fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // set image
        super.init(image: image)
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

