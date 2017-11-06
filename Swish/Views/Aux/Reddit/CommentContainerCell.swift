import UIKit

class CommentContainerCell: UITableViewCell {
    
    let initialCommentContainer = CommentContainer()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(initialCommentContainer)
        
        initialCommentContainer.pinToEdges(of: contentView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initialCommentContainer.clear()
    }
    
    func setup(with comment: Comment, tableView: UITableView) {
        initialCommentContainer.setup(with: comment, tableView: tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

