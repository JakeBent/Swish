import UIKit

class CommentView: UIView {
    let bodyLabel = Generators.makeLabel(fontSize: 14, numberOfLines: 0)
    let upvoteButton = Generators.makeIconButton(image: #imageLiteral(resourceName: "carat"), rotation: 3 * .pi / 2)
    let downvoteButton = Generators.makeIconButton(image: #imageLiteral(resourceName: "carat"), rotation: .pi / 2)
    let replyButton = Generators.makeIconButton(image: #imageLiteral(resourceName: "reply"))
    
    var views: [UIView] {
        return [bodyLabel, upvoteButton, downvoteButton, replyButton]
    }
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        views.forEach { addSubview($0) }
        
        bodyLabel.pinTop(to: topAnchor)
        bodyLabel.pinLeft(to: leftAnchor)
        bodyLabel.pinRight(to: rightAnchor)
        
        upvoteButton.pinTop(to: bodyLabel.bottomAnchor)
        upvoteButton.pinRight(to: rightAnchor, constant: -8)
        upvoteButton.pinBottom(to: bottomAnchor)
        upvoteButton.pinWidth(to: upvoteButton.heightAnchor)
        
        downvoteButton.pinTop(to: upvoteButton.topAnchor)
        downvoteButton.pinRight(to: upvoteButton.leftAnchor, constant: -8)
        downvoteButton.pinBottom(to: bottomAnchor)
        downvoteButton.pinWidth(to: upvoteButton.heightAnchor)
        
        replyButton.pinTop(to: downvoteButton.topAnchor)
        replyButton.pinRight(to: downvoteButton.leftAnchor, constant: -8)
        replyButton.pinBottom(to: bottomAnchor)
        replyButton.pinWidth(to: upvoteButton.heightAnchor)
    }
    
    func clear() {
        bodyLabel.text = nil
        upvoteButton.isSelected = false
        downvoteButton.isSelected = false
    }
    
    func setup(with comment: Comment) {
        bodyLabel.text = comment.body
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
