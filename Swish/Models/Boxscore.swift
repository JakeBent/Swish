//
//  Boxscore.swift
//  Swish
//
//  Created by Jacob Benton on 2/13/20.
//  Copyright © 2020 Jacob Benton. All rights reserved.
//

import UIKit

struct Boxscore {
    let gameId: Int
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
    let homeTeamStats: GameStats?
    let awayTeamStats: GameStats?
    let homePlayerStats: [PlayerStats]
    let awayPlayerStats: [PlayerStats]
    
    var isComplete: Bool {
        return playedStatus == "COMPLETED"
    }
    
    static func create(fromJson json: [String: Any]?) -> Boxscore? {
        guard let game = json?["game"] as? [String: Any?],
            let score = json?["scoring"] as? [String: Any?],
            let stats = json?["stats"] as? [String: Any],
            let gameId = game["id"] as? Int,
            let startTimeString = game["startTime"] as? String,
            let startTime = Utility.isoFormatter.date(from: startTimeString),
            let gameDay = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: startTime)),
            let scheduleStatus = game["scheduleStatus"] as? String,
            let playedStatus = game["playedStatus"] as? String,
            let broadcasters = game["broadcasters"] as? [String],
            let homeTeamInfo = game["homeTeam"] as? [String: Any?],
            let awayTeamInfo = game["awayTeam"] as? [String: Any?],
            let homeTeamAbbreviation = homeTeamInfo["abbreviation"] as? String,
            let awayTeamAbbreviation = awayTeamInfo["abbreviation"] as? String,
            let homeTeam = Constants.Teams(rawValue: homeTeamAbbreviation)?.team,
            let awayTeam = Constants.Teams(rawValue: awayTeamAbbreviation)?.team,
            let away = stats["away"] as? [String: Any],
            let awayStats = (away["teamStats"] as? [[String: Any]])?.first,
            let awayPlayers = away["players"] as? [[String: Any]],
            let home = stats["home"] as? [String: Any],
            let homeStats = (home["teamStats"] as? [[String: Any]])?.first,
            let homePlayers = home["players"] as? [[String: Any]]
            else { return nil }
        
        return Boxscore(
            gameId: gameId,
            startTime: startTime,
            gameDay: gameDay,
            scheduleStatus: scheduleStatus,
            delayedOrPostponedReason: game["delayedOrPostponedReason"] as? String,
            playedStatus: playedStatus,
            broadcasters: broadcasters,
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            currentQuarter: score["currentQuarter"] as? Int,
            currentQuarterSecondsRemaining: score["currentQuarterSecondsRemaining"] as? String,
            currentIntermission: score["currentIntermission"] as? String,
            homeScore: score["homeScoreTotal"] as? Int,
            awayScore: score["awayScoreTotal"] as? Int,
            quarters: Quarter.createMany(fromJson: score["quarters"] as? [[String: Any?]]),
            homeTeamStats: GameStats.create(fromJson: homeStats),
            awayTeamStats: GameStats.create(fromJson: awayStats),
            homePlayerStats: PlayerStats.createMany(fromJson: homePlayers),
            awayPlayerStats: PlayerStats.createMany(fromJson: awayPlayers)
        )
    }
}

struct GameStats {
    let fgAtt: Int
    let fgMade: Int
    let fgPct: Double
    let fg2PtAtt: Int
    let fg2PtMade: Int
    let fg2PtPct: Double
    let fg3PtAtt: Int
    let fg3PtMade: Int
    let fg3PtPct: Double
    let ftAtt: Int
    let ftMade: Int
    let ftPct: Double
    let offReb: Int
    let defReb: Int
    let reb: Int
    let ast: Int
    let pts: Int
    let tov: Int
    let stl: Int
    let blk: Int
    let blkAgainst: Int
    let ptsAgainst: Int?
    let fouls: Int
    let foulsDrawn: Int
    let ejections: Int
    let plusMinus: Int
    let minSeconds: Int?
    let gamesStarted: Int?
    
    static func create(fromJson json: [String: Any]?) -> GameStats? {
        guard let fg = json?["fieldGoals"] as? [String: Any],
            let ft = json?["freeThrows"] as? [String: Any],
            let rb = json?["rebounds"] as? [String: Int],
            let off = json?["offense"] as? [String: Int],
            let def = json?["defense"] as? [String: Int],
            let misc = json?["miscellaneous"] as? [String: Int],
            let fgAtt = fg["fgAtt"] as? Int,
            let fgMade = fg["fgMade"] as? Int,
            let fgPct = fg["fgPct"] as? Double,
            let fg2PtAtt = fg["fg2PtAtt"] as? Int,
            let fg2PtMade = fg["fg2PtMade"] as? Int,
            let fg2PtPct = fg["fg2PtPct"] as? Double,
            let fg3PtAtt = fg["fg3PtAtt"] as? Int,
            let fg3PtMade = fg["fg3PtMade"] as? Int,
            let fg3PtPct = fg["fg3PtPct"] as? Double,
            let ftAtt = ft["ftAtt"] as? Int,
            let ftMade = ft["ftMade"] as? Int,
            let ftPct = ft["ftPct"] as? Double,
            let offReb = rb["offReb"],
            let defReb = rb["defReb"],
            let reb = rb["reb"],
            let ast = off["ast"],
            let pts = off["pts"],
            let tov = def["tov"],
            let stl = def["stl"],
            let blk = def["blk"],
            let blkAgainst = def["blkAgainst"],
            let fouls = misc["fouls"],
            let foulsDrawn = misc["foulsDrawn"],
            let ejections = misc["ejections"],
            let plusMinus = misc["plusMinus"]
            else { return nil }
        
        return GameStats(
            fgAtt: fgAtt,
            fgMade: fgMade,
            fgPct: fgPct,
            fg2PtAtt: fg2PtAtt,
            fg2PtMade: fg2PtMade,
            fg2PtPct: fg2PtPct,
            fg3PtAtt: fg3PtAtt,
            fg3PtMade: fg3PtMade,
            fg3PtPct: fg3PtPct,
            ftAtt: ftAtt,
            ftMade: ftMade,
            ftPct: ftPct,
            offReb: offReb,
            defReb: defReb,
            reb: reb,
            ast: ast,
            pts: pts,
            tov: tov,
            stl: stl,
            blk: blk,
            blkAgainst: blkAgainst,
            ptsAgainst: def["ptsAgainst"],
            fouls: fouls,
            foulsDrawn: foulsDrawn,
            ejections: ejections,
            plusMinus: plusMinus,
            minSeconds: misc["minSeconds"],
            gamesStarted: misc["gamesStarted"]
        )
    }
}

struct PlayerStats {
    let playerId: Int
    let firstName: String
    let lastName: String
    let position: String
    let jerseyNumber: Int
    let gameStats: GameStats?
    
    static func createMany(fromJson json: [[String: Any]]?) -> [PlayerStats] {
        guard let json = json else { return [] }
        return json.compactMap { create(fromJson: $0) }
    }
    
    static func create(fromJson json: [String: Any]?) -> PlayerStats? {
        guard let player = json?["player"] as? [String: Any],
            let playerId = player["id"] as? Int,
            let firstName = player["firstName"] as? String,
            let lastName = player["lastName"] as? String,
            let position = player["position"] as? String,
            let jerseyNumber = player["jerseyNumber"] as? Int,
            let playerStats = (json?["playerStats"] as? [[String: Any]])?.first
            else { return nil }
        
        return PlayerStats(
            playerId: playerId,
            firstName: firstName,
            lastName: lastName,
            position: position,
            jerseyNumber: jerseyNumber,
            gameStats: GameStats.create(fromJson: playerStats)
        )
    }
}
