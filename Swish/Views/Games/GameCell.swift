import UIKit

class GameCell: UITableViewCell {

    let homeIcon = Generators.makeImageView()
    let awayIcon = Generators.makeImageView()
    let homeNameLabel = Generators.makeLabel(align: .center)
    let awayNameLabel = Generators.makeLabel(align: .center)
    let homeScoreLabel = Generators.makeLabel(fontSize: 20, weight: .bold)
    let awayScoreLabel = Generators.makeLabel(fontSize: 20, weight: .bold)
    let infoLabel = Generators.makeLabel()
    var views: [UIView] {
        return [homeIcon, awayIcon, homeNameLabel, awayNameLabel, homeScoreLabel, awayScoreLabel, infoLabel]
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        views.forEach { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        infoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        awayIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        awayIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        awayIcon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.65).isActive = true
        awayIcon.widthAnchor.constraint(equalTo: awayIcon.heightAnchor).isActive = true
        
        awayNameLabel.leftAnchor.constraint(equalTo: awayIcon.leftAnchor).isActive = true
        awayNameLabel.rightAnchor.constraint(equalTo: awayIcon.rightAnchor).isActive = true
        awayNameLabel.topAnchor.constraint(equalTo: awayIcon.bottomAnchor, constant: 4).isActive = true

        homeIcon.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        homeIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        homeIcon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.65).isActive = true
        homeIcon.widthAnchor.constraint(equalTo: homeIcon.heightAnchor).isActive = true
        
        homeNameLabel.leftAnchor.constraint(equalTo: homeIcon.leftAnchor).isActive = true
        homeNameLabel.rightAnchor.constraint(equalTo: homeIcon.rightAnchor).isActive = true
        homeNameLabel.topAnchor.constraint(equalTo: homeIcon.bottomAnchor, constant: 4).isActive = true
        
        homeScoreLabel.rightAnchor.constraint(equalTo: homeIcon.leftAnchor, constant: -8).isActive = true
        homeScoreLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
       
        awayScoreLabel.leftAnchor.constraint(equalTo: awayIcon.rightAnchor, constant: 8).isActive = true
        awayScoreLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func setup() {
        infoLabel.text = "7:30pm"
        homeIcon.image = #imageLiteral(resourceName: "hawks_logo")
        awayIcon.image = #imageLiteral(resourceName: "hawks_logo")
        homeNameLabel.text = "ATL"
        awayNameLabel.text = "ATL"
        homeScoreLabel.text = "95"
        awayScoreLabel.text = "102"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
