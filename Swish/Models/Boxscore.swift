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
    let fgAttPerGame: Double?
    let fgMade: Int
    let fgMadePerGame: Double?
    let fgPct: Double
    let fg2PtAtt: Int
    let fg2PtAttPerGame: Double?
    let fg2PtMade: Int
    let fg2PtMadePerGame: Double?
    let fg2PtPct: Double
    let fg3PtAtt: Int
    let fg3PtAttPerGame: Double?
    let fg3PtMade: Int
    let fg3PtMadePerGame: Double?
    let fg3PtPct: Double
    let ftAtt: Int
    let ftAttPerGame: Double?
    let ftMade: Int
    let ftMadePerGame: Double?
    let ftPct: Double
    let offReb: Int
    let offRebPerGame: Double?
    let defReb: Int
    let defRebPerGame: Double?
    let reb: Int
    let rebPerGame: Double?
    let ast: Int
    let astPerGame: Double?
    let pts: Int
    let ptsPerGame: Double?
    let tov: Int
    let tovPerGame: Double?
    let stl: Int
    let stlPerGame: Double?
    let blk: Int
    let blkPerGame: Double?
    let blkAgainst: Int
    let blkAgainstPerGame: Double?
    let ptsAgainst: Int?
    let ptsAgainstPerGame: Double?
    let fouls: Int
    let foulsPerGame: Double?
    let foulsDrawn: Int
    let foulsDrawnPerGame: Double?
    let foulPers: Int?
    let foulPersPerGame: Double?
    let foulTech: Int?
    let foulTechPerGame: Double?
    let foulTechDrawn: Int?
    let foulTechDrawnPerGame: Double?
    let ejections: Int
    let plusMinus: Int
    let plusMinusPerGame: Double?
    let minSeconds: Int?
    let gamesStarted: Int?
    
    static func create(fromJson json: [String: Any]?) -> GameStats? {
        guard let fg = json?["fieldGoals"] as? [String: Any],
            let ft = json?["freeThrows"] as? [String: Any],
            let rb = json?["rebounds"] as? [String: Any],
            let off = json?["offense"] as? [String: Any],
            let def = json?["defense"] as? [String: Any],
            let misc = json?["miscellaneous"] as? [String: Any],
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
            let offReb = rb["offReb"] as? Int,
            let defReb = rb["defReb"] as? Int,
            let reb = rb["reb"] as? Int,
            let ast = off["ast"] as? Int,
            let pts = off["pts"] as? Int,
            let tov = def["tov"] as? Int,
            let stl = def["stl"] as? Int,
            let blk = def["blk"] as? Int,
            let blkAgainst = def["blkAgainst"] as? Int,
            let fouls = misc["fouls"] as? Int,
            let foulsDrawn = misc["foulsDrawn"] as? Int,
            let ejections = misc["ejections"] as? Int,
            let plusMinus = misc["plusMinus"] as? Int
            else { return nil }
        
        return GameStats(
            fgAtt: fgAtt,
            fgAttPerGame: fg["fgAttPerGame"] as? Double,
            fgMade: fgMade,
            fgMadePerGame: fg["fgMadePerGame"] as? Double,
            fgPct: fgPct,
            fg2PtAtt: fg2PtAtt,
            fg2PtAttPerGame: fg["fg2PtAttPerGame"] as? Double,
            fg2PtMade: fg2PtMade,
            fg2PtMadePerGame: fg["fg2PtMadePerGame"] as? Double,
            fg2PtPct: fg2PtPct,
            fg3PtAtt: fg3PtAtt,
            fg3PtAttPerGame: fg["fg3PtAttPerGame"] as? Double,
            fg3PtMade: fg3PtMade,
            fg3PtMadePerGame: fg["fg3PtMadePerGame"] as? Double,
            fg3PtPct: fg3PtPct,
            ftAtt: ftAtt,
            ftAttPerGame: ft["ftAttPerGame"] as? Double,
            ftMade: ftMade,
            ftMadePerGame: ft["ftMadePerGame"] as? Double,
            ftPct: ftPct,
            offReb: offReb,
            offRebPerGame: rb["offRebPerGame"] as? Double,
            defReb: defReb,
            defRebPerGame: rb["defRebPerGame"] as? Double,
            reb: reb,
            rebPerGame: rb["rebPerGame"] as? Double,
            ast: ast,
            astPerGame: off["astPerGame"] as? Double,
            pts: pts,
            ptsPerGame: off["ptsPerGame"] as? Double,
            tov: tov,
            tovPerGame: def["tovPerGame"] as? Double,
            stl: stl,
            stlPerGame: def["stlPerGame"] as? Double,
            blk: blk,
            blkPerGame: def["blkPerGame"] as? Double,
            blkAgainst: blkAgainst,
            blkAgainstPerGame: def["blkAgainstPerGame"] as? Double,
            ptsAgainst: def["ptsAgainst"] as? Int,
            ptsAgainstPerGame: def["ptsAgainstPerGame"] as? Double,
            fouls: fouls,
            foulsPerGame: misc["foulsPerGame"] as? Double,
            foulsDrawn: foulsDrawn,
            foulsDrawnPerGame: misc["foulsDrawnPerGame"] as? Double,
            foulPers: misc["foulPers"] as? Int,
            foulPersPerGame: misc["foulPersPerGame"] as? Double,
            foulTech: misc["foulTech"] as? Int,
            foulTechPerGame: misc["foulTechPerGame"] as? Double,
            foulTechDrawn: misc["foulTechDrawn"] as? Int,
            foulTechDrawnPerGame: misc["foulTechDrawnPerGame"] as? Double,
            ejections: ejections,
            plusMinus: plusMinus,
            plusMinusPerGame: misc["plusMinusPerGame"] as? Double,
            minSeconds: misc["minSeconds"] as? Int,
            gamesStarted: misc["gamesStarted"] as? Int
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

enum Conference: String {
    case west = "Western"
    case east = "Eastern"
}

struct TeamStats {
    let team: Team
    let stats: GameStats?
    let gamesPlayed: Int
    let wins: Int
    let losses: Int
    let winPct: Double
    let overallRank: Int
    let overallGamesBack: Double
    let conference: Conference
    let conferenceRank: Int
    let conferenceGamesBack: Double
    let inPlayoffs: Bool
    
    static func createMany(fromJson json: [String: Any]?) -> [TeamStats] {
        guard let json = json,
            let teamsJson = json["teams"] as? [[String: Any]]
            else { return [] }
        return teamsJson.compactMap { create(fromJson: $0) }
    }
    
    static func create(fromJson json: [String: Any]?) -> TeamStats? {
        guard let teamInfo = json?["team"] as? [String: Any],
            let stats = json?["stats"] as? [String: Any],
            let overallInfo = json?["overallRank"] as? [String: Any],
            let conferenceInfo = json?["conferenceRank"] as? [String: Any],
            let teamAbbreviation = teamInfo["abbreviation"] as? String,
            let team = Constants.Teams(rawValue: teamAbbreviation)?.team,
            let gamesPlayed = stats["gamesPlayed"] as? Int,
            let overallRank = overallInfo["rank"] as? Int,
            let overallGamesBack = overallInfo["gamesBack"] as? Double,
            let standings = stats["standings"] as? [String: Any],
            let wins = standings["wins"] as? Int,
            let losses = standings["losses"] as? Int,
            let winPct = standings["winPct"] as? Double,
            let conferenceString = conferenceInfo["conferenceName"] as? String,
            let conference = Conference(rawValue: conferenceString),
            let conferenceRank = conferenceInfo["rank"] as? Int,
            let conferenceGamesBack = conferenceInfo["gamesBack"] as? Double,
            let playoffsInfo = json?["playoffRank"] as? [String: Any],
            let playoffsRank = playoffsInfo["rank"] as? Int
            else { return nil }
        
        return TeamStats(
            team: team,
            stats: GameStats.create(fromJson: stats),
            gamesPlayed: gamesPlayed,
            wins: wins,
            losses: losses,
            winPct: winPct,
            overallRank: overallRank,
            overallGamesBack: overallGamesBack,
            conference: conference,
            conferenceRank: conferenceRank,
            conferenceGamesBack: conferenceGamesBack,
            inPlayoffs: playoffsRank <= 8
        )
    }
}
