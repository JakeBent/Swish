import UIKit

struct Play {
    let secondsElapsed: Int
    let team: Team
    let scoreChange: Int
    let awayScore: Int
    let homeScore: Int
    let playDescription: String
    
    static func createMany(fromJson json: [[String: Any?]]?) -> [Play] {
        guard let json = json else { return [] }
        return json.compactMap { create(fromJson: $0) }
    }
    
    static func create(fromJson json: [String: Any?]?) -> Play? {
        guard let secondsElapsed = json?["quarterSecondsElapsed"] as? Int,
            let teamInfo = json?["team"] as? [String: Any?],
            let teamAbbreviation = teamInfo["abbreviation"] as? String,
            let team = Constants.Teams(rawValue: teamAbbreviation)?.team,
            let scoreChange = json?["scoreChange"] as? Int,
            let awayScore = json?["awayScore"] as? Int,
            let homeScore = json?["homeScore"] as? Int,
            let playDescription = json?["playDescription"] as? String
            else { return nil }
        
        return Play(
            secondsElapsed: secondsElapsed,
            team: team,
            scoreChange: scoreChange,
            awayScore: awayScore,
            homeScore: homeScore,
            playDescription: playDescription
        )
    }
}

struct Quarter {
    let quarterNumber: Int
    let homeScore: Int
    let awayScore: Int
    let plays: [Play]
    
    static func createMany(fromJson json: [[String: Any?]]?) -> [Quarter] {
        guard let json = json else { return [] }
        return json.compactMap { create(fromJson: $0) }
    }
    
    static func create(fromJson json: [String: Any?]?) -> Quarter? {
        guard let quarterNumber = json?["quarterNumber"] as? Int,
            let homeScore = json?["homeScore"] as? Int,
            let awayScore = json?["awayScore"] as? Int
            else { return nil }

        return Quarter(
            quarterNumber: quarterNumber,
            homeScore: homeScore,
            awayScore: awayScore,
            plays: Play.createMany(fromJson: json?["scoringPlays"] as? [[String: Any?]])
        )
    }
}

struct Game {
    let id: Int
    let startTime: Date
    let gameDay: Date
    let scheduleStatus: String
    let delayedOrPostponedReason: String?
    let playedStatus: String
    let broadcasters: [String]
    let homeTeam: Team
    let awayTeam: Team
    let currentQuarter: Int?
    let currentQuarterSecondsRemaining: String?
    let currentIntermission: String?
    let homeScore: Int?
    let awayScore: Int?
    let quarters: [Quarter]
    
    var isComplete: Bool {
        return playedStatus == "COMPLETED"
    }
    
    var isLive: Bool {
        return playedStatus == "LIVE"
    }
    
    var previewStatus: String {
        if isComplete {
            switch quarters.count {
            case 0..<5: return "Final"
            default: return "Final/\(quarters.count == 5 ? "" : "\(quarters.count - 4)")OT"
            }
        }
        
        return Utility.timeString(from: startTime)
    }
    
    static func createMany(fromJson json: [String: Any?]?) -> [Game] {
        guard let json = json,
            let games = json["games"] as? [[String: Any]]
            else { return [] }
        return games.compactMap { create(fromJson: $0) }
    }
    
    static func create(fromJson json: [String: Any]?) -> Game? {
        guard let schedule = json?["schedule"] as? [String: Any?],
            let score = json?["score"] as? [String: Any?],
            let id = schedule["id"] as? Int,
            let startTimeString = schedule["startTime"] as? String,
            let startTime = Utility.isoFormatter.date(from: startTimeString),
            let gameDay = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: startTime)),
            let scheduleStatus = schedule["scheduleStatus"] as? String,
            let playedStatus = schedule["playedStatus"] as? String,
            let broadcasters = schedule["broadcasters"] as? [String],
            let homeTeamInfo = schedule["homeTeam"] as? [String: Any?],
            let awayTeamInfo = schedule["awayTeam"] as? [String: Any?],
            let homeTeamAbbreviation = homeTeamInfo["abbreviation"] as? String,
            let awayTeamAbbreviation = awayTeamInfo["abbreviation"] as? String,
            let homeTeam = Constants.Teams(rawValue: homeTeamAbbreviation)?.team,
            let awayTeam = Constants.Teams(rawValue: awayTeamAbbreviation)?.team
            else { return nil }
                
        return Game(
            id: id,
            startTime: startTime,
            gameDay: gameDay,
            scheduleStatus: scheduleStatus,
            delayedOrPostponedReason: schedule["delayedOrPostponedReason"] as? String,
            playedStatus: playedStatus,
            broadcasters: broadcasters,
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            currentQuarter: score["currentQuarter"] as? Int,
            currentQuarterSecondsRemaining: score["currentQuarterSecondsRemaining"] as? String,
            currentIntermission: score["currentIntermission"] as? String,
            homeScore: score["homeScoreTotal"] as? Int,
            awayScore: score["awayScoreTotal"] as? Int,
            quarters: Quarter.createMany(fromJson: score["quarters"] as? [[String: Any?]])
        )
    }
}
