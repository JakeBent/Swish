import UIKit

class GameCellView: UIView {

    private let homeIcon = Generators.makeImageView()
    private let awayIcon = Generators.makeImageView()
    private let homeNameLabel = Generators.makeLabel(align: .center, text: "-")
    private let awayNameLabel = Generators.makeLabel(align: .center, text: "-")
    private let homeScoreLabel = Generators.makeLabel(fontSize: 20, weight: .bold)
    private let awayScoreLabel = Generators.makeLabel(fontSize: 20, weight: .bold)
    private let infoStack = Generators.makeStack()
    private let statusLabel = Generators.makeLabel()
    private let broadcasterLabel = Generators.makeLabel(fontSize: 8, align: .center, numberOfLines: 2, color: .gray)
    private var views: [UIView] {
        return [homeIcon, awayIcon, homeNameLabel, awayNameLabel, homeScoreLabel, awayScoreLabel, infoStack]
    }
    private var infoViews: [UIView] {
        return [statusLabel, broadcasterLabel]
    }
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        views.forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        infoViews.forEach { view in
            infoStack.addArrangedSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        infoStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        infoStack.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.25).isActive = true
        
        awayIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        awayIcon.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        awayIcon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        awayIcon.widthAnchor.constraint(equalTo: awayIcon.heightAnchor).isActive = true
        
        awayNameLabel.leftAnchor.constraint(equalTo: awayIcon.leftAnchor).isActive = true
        awayNameLabel.rightAnchor.constraint(equalTo: awayIcon.rightAnchor).isActive = true
        awayNameLabel.topAnchor.constraint(equalTo: awayIcon.bottomAnchor, constant: 4).isActive = true

        homeIcon.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        homeIcon.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        homeIcon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        homeIcon.widthAnchor.constraint(equalTo: homeIcon.heightAnchor).isActive = true
        
        homeNameLabel.leftAnchor.constraint(equalTo: homeIcon.leftAnchor).isActive = true
        homeNameLabel.rightAnchor.constraint(equalTo: homeIcon.rightAnchor).isActive = true
        homeNameLabel.topAnchor.constraint(equalTo: homeIcon.bottomAnchor, constant: 4).isActive = true
        
        homeScoreLabel.rightAnchor.constraint(equalTo: homeIcon.leftAnchor, constant: -4).isActive = true
        homeScoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
       
        awayScoreLabel.leftAnchor.constraint(equalTo: awayIcon.rightAnchor, constant: 4).isActive = true
        awayScoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
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
    
    func setup(withBoxscore boxscore: Boxscore?) {
        resetAppearance()
        guard let boxscore = boxscore else { return }
        
        if let homeScore = boxscore.homeScore, let awayScore = boxscore.awayScore {
            homeScoreLabel.text = " \(homeScore) "
            awayScoreLabel.text = " \(awayScore) "
            
            if boxscore.isComplete {
                let homeWin = homeScore > awayScore
                homeScoreLabel.addOutline(color: homeWin ? .black : .lightGray)
                awayScoreLabel.addOutline(color: homeWin ? .lightGray : .black)
                homeScoreLabel.textColor = homeWin ? .black : .lightGray
                awayScoreLabel.textColor = homeWin ? .lightGray : .black
            }
        }
        
        broadcasterLabel.numberOfLines = 5

        broadcasterLabel.text = boxscore.broadcasters.joined(separator: ", ")
        statusLabel.text = boxscore.previewStatus
        homeIcon.image = boxscore.homeTeam.logo
        awayIcon.image = boxscore.awayTeam.logo
        homeNameLabel.text = boxscore.homeTeam.abbreviation
        awayNameLabel.text = boxscore.awayTeam.abbreviation
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

class GameCell: UITableViewCell {

    let view = GameCellView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.pinToEdges(of: contentView)
    }
    
    func setup(withGame game: Game) {
        view.setup(withGame: game)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
