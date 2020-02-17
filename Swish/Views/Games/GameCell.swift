import UIKit

class GameCell: UITableViewCell {

    let homeIcon = Generators.makeImageView()
    let awayIcon = Generators.makeImageView()
    let homeNameLabel = Generators.makeLabel(align: .center, text: "-")
    let awayNameLabel = Generators.makeLabel(align: .center, text: "-")
    let homeScoreLabel = Generators.makeLabel(fontSize: 20, weight: .bold)
    let awayScoreLabel = Generators.makeLabel(fontSize: 20, weight: .bold)
    let infoStack = Generators.makeStack()
    let statusLabel = Generators.makeLabel()
    let broadcasterLabel = Generators.makeLabel(fontSize: 8, align: .center, numberOfLines: 2, color: .gray)
    var views: [UIView] {
        return [homeIcon, awayIcon, homeNameLabel, awayNameLabel, homeScoreLabel, awayScoreLabel, infoStack]
    }
    var infoViews: [UIView] {
        return [statusLabel, broadcasterLabel]
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        views.forEach { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        infoViews.forEach { view in
            infoStack.addArrangedSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        infoStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        infoStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        infoStack.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.25).isActive = true
        
        awayIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4).isActive = true
        awayIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        awayIcon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6).isActive = true
        awayIcon.widthAnchor.constraint(equalTo: awayIcon.heightAnchor).isActive = true
        
        awayNameLabel.leftAnchor.constraint(equalTo: awayIcon.leftAnchor).isActive = true
        awayNameLabel.rightAnchor.constraint(equalTo: awayIcon.rightAnchor).isActive = true
        awayNameLabel.topAnchor.constraint(equalTo: awayIcon.bottomAnchor, constant: 4).isActive = true

        homeIcon.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -4).isActive = true
        homeIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        homeIcon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6).isActive = true
        homeIcon.widthAnchor.constraint(equalTo: homeIcon.heightAnchor).isActive = true
        
        homeNameLabel.leftAnchor.constraint(equalTo: homeIcon.leftAnchor).isActive = true
        homeNameLabel.rightAnchor.constraint(equalTo: homeIcon.rightAnchor).isActive = true
        homeNameLabel.topAnchor.constraint(equalTo: homeIcon.bottomAnchor, constant: 4).isActive = true
        
        homeScoreLabel.rightAnchor.constraint(equalTo: homeIcon.leftAnchor, constant: -4).isActive = true
        homeScoreLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
       
        awayScoreLabel.leftAnchor.constraint(equalTo: awayIcon.rightAnchor, constant: 4).isActive = true
        awayScoreLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func setup(withGame game: Game) {
        resetAppearance()
        
        if let homeScore = game.homeScore, let awayScore = game.awayScore {
            homeScoreLabel.text = " \(homeScore) "
            awayScoreLabel.text = " \(awayScore) "
            
            if game.isComplete {
                let homeWin = homeScore > awayScore
                homeScoreLabel.addOutline(color: homeWin ? .black : .lightGray)
                awayScoreLabel.addOutline(color: homeWin ? .lightGray : .black)
                homeScoreLabel.textColor = homeWin ? .black : .lightGray
                awayScoreLabel.textColor = homeWin ? .lightGray : .black
            }
        }
        
        broadcasterLabel.text = game.broadcasters.joined(separator: ", ")
        statusLabel.text = game.previewStatus
        homeIcon.image = game.homeTeam.logo
        awayIcon.image = game.awayTeam.logo
        homeNameLabel.text = game.homeTeam.abbreviation
        awayNameLabel.text = game.awayTeam.abbreviation
    }
    
    private func resetAppearance() {
        homeScoreLabel.text = nil
        awayScoreLabel.text = nil
        homeScoreLabel.textColor = .black
        awayScoreLabel.textColor = .black
        homeScoreLabel.removeOutline()
        awayScoreLabel.removeOutline()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
