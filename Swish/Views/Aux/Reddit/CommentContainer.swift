import UIKit

class CommentContainer: UIView {
    
    weak var tableView: UITableView?
    var collapseAction: (() -> Void)?
    let collapseArrow = Generators.makeImageView(image: #imageLiteral(resourceName: "carat"), renderingMode: .alwaysTemplate, rotation: .pi / 2)
    let authorLabel = Generators.makeLabel(fontSize: 11, weight: .bold)
    let flairLabel = Generators.makeLabel(fontSize: 11, color: .gray)
    let scoreLabel = Generators.makeLabel(fontSize: 11, weight: .bold)
    let dateLabel = Generators.makeLabel(fontSize: 11, weight: .bold)
    let commentView = CommentView()
    var replies: [CommentContainer] = []
    var mutableConstraints: [NSLayoutConstraint] = []
    lazy var collapseTouchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleCollapse)))
        return view
    }()
    
    var views: [UIView] {
        return [collapseArrow, authorLabel, flairLabel, scoreLabel, dateLabel, commentView, collapseTouchView]
    }

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        views.forEach { addSubview($0) }
        
        collapseArrow.pinLeft(to: leftAnchor, constant: 8)
        collapseArrow.pinCenterY(to: authorLabel.centerYAnchor)
        collapseArrow.pinHeight(toConstant: 6)
        collapseArrow.pinWidth(to: collapseArrow.heightAnchor)
        
        authorLabel.pinTop(to: topAnchor, constant: 4)
        authorLabel.pinLeft(to: collapseArrow.rightAnchor, constant: 4)
        authorLabel.pinRight(to: flairLabel.leftAnchor, constant: -8)
        authorLabel.setContentHuggingPriority(.required, for: .horizontal)
        authorLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        flairLabel.pinTop(to: topAnchor, constant: 4)
        flairLabel.pinRight(to: scoreLabel.leftAnchor, constant: -8)
        flairLabel.pinBottom(to: authorLabel.bottomAnchor)
        flairLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        scoreLabel.pinTop(to: topAnchor, constant: 4)
        scoreLabel.pinRight(to: dateLabel.leftAnchor)
        scoreLabel.pinBottom(to: authorLabel.bottomAnchor)
        scoreLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        dateLabel.pinTop(to: topAnchor, constant: 4)
        dateLabel.pinRight(to: rightAnchor, constant: -8)
        dateLabel.pinBottom(to: authorLabel.bottomAnchor)
        
        commentView.pinTop(to: authorLabel.bottomAnchor, constant: 8)
        commentView.pinLeft(to: leftAnchor, constant: 8)
        commentView.pinRight(to: rightAnchor, constant: -8)
    
        collapseTouchView.pinTop(to: topAnchor)
        collapseTouchView.pinLeft(to: leftAnchor)
        collapseTouchView.pinRight(to: rightAnchor)
        collapseTouchView.pinBottom(to: authorLabel.bottomAnchor)
    }
    
    func clear() {
        authorLabel.text = nil
        flairLabel.text = nil
        scoreLabel.text = nil
        dateLabel.text = nil
        commentView.clear()
        replies.forEach { removeSubview($0) }
        replies = []
        mutableConstraints.forEach { $0.isActive = false }
        mutableConstraints = []
        collapseAction = nil
    }
    
    func setup(with comment: Comment, tableView: UITableView) {
        self.tableView = tableView

        let score = comment.score == nil ? "hidden" : "\(comment.score!)"
        authorLabel.text = comment.author
        scoreLabel.text = score
        flairLabel.text = comment.flair
        dateLabel.text = " • 1h"
        
        collapseAction = { [weak self] in
            comment.isCollapsed = !comment.isCollapsed
            self?.tableView?.reloadData()
        }
        
        if comment.isCollapsed {
            let constraint = authorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            constraint.isActive = true
            mutableConstraints.append(constraint)
            commentView.isHidden = true
            collapseArrow.transform = CGAffineTransform(rotationAngle: 0)
        } else {
            commentView.isHidden = false
            commentView.setup(with: comment)
            collapseArrow.transform = CGAffineTransform(rotationAngle: .pi / 2)
            
            if comment.replies.count == 0 {
                let constraint = commentView.bottomAnchor.constraint(equalTo: bottomAnchor)
                constraint.isActive = true
                mutableConstraints.append(constraint)
            } else {
                replies = comment.replies.map { reply in
                    let container = CommentContainer()
                    container.setup(with: reply, tableView: tableView)
                    container.addBorder(to: .left)
                    return container
                }
                
                var previousAnchor = commentView.bottomAnchor
                replies.forEach { container in
                    addSubview(container)
                    container.pinTop(to: previousAnchor)
                    container.pinRight(to: rightAnchor)
                    container.pinLeft(to: leftAnchor, constant: 12)
                    previousAnchor = container.bottomAnchor
                }
                
                let constraint = replies[replies.count - 1].bottomAnchor.constraint(equalTo: bottomAnchor)
                constraint.isActive = true
                mutableConstraints.append(constraint)
            }
        }
    }
    
    @objc func toggleCollapse() {
        collapseAction?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addBorder(to: .left)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
