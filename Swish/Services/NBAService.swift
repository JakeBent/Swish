//
//  NBAService.swift
//  Swish
//
//  Created by Jacob Benton on 2/12/20.
//  Copyright © 2020 Jacob Benton. All rights reserved.
//

import UIKit
import Alamofire

class NBAService: NSObject {
    static let shared = NBAService()
    
    struct Endpoints {
        private static let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            return formatter
        }()
        private static var currentDay: String { formatter.string(from: Date()) }
        private static let currentSeason = "current";
        
        static func todayGames() -> String { return "\(Constants.urls.nbaApi)/\(currentSeason)/date/\(currentDay)/games.json"
        }
        static func seasonGames() -> String {
            return "\(Constants.urls.nbaApi)/\(currentSeason)/games.json"
        }
        static func gameBoxscore(id: Int) -> String {
            return "\(Constants.urls.nbaApi)/\(currentSeason)/games/\(id)/boxscore.json"
        }
    }
    
    struct Headers {
        static let auth: HTTPHeaders = {
            var headers = HTTPHeaders()
            headers["Authorization"] = "Basic \(Constants.keys.nbaApi)"
            return headers
        }()
    }
    
    func getTodayGames(done: @escaping (Error?, [Game]) -> Void) {
        request(
            Endpoints.todayGames(),
            headers: Headers.auth
        ).responseJSON { response in
            guard let json = response.value as? [String: Any?],
                response.error == nil
            else {
                done(response.error ?? Errors.badData, [])
                return
            }
            
            done(nil, Game.createMany(fromJson: json))
        }
    }
    
    func getSeasonGames(progress: ((Double) -> Void)? = nil, done: @escaping (Error?, [Date: [Game]]) -> Void) {
        let utilityQueue = DispatchQueue.global(qos: .utility)

        request(
            Endpoints.seasonGames(),
            headers: Headers.auth
        ).downloadProgress(queue: utilityQueue) { info in
            progress?(info.fractionCompleted)
        }
        .responseJSON { response in
            guard let json = response.value as? [String: Any?],
                response.error == nil
            else {
                done(response.error ?? Errors.badData, [:])
                return
            }
            
            let games = Game.createMany(fromJson: json)
            done(nil, Dictionary(grouping: games, by: { $0.gameDay }))
        }
    }
    
    func getBoxscore(id: Int, progress: ((Double) -> Void)? = nil, done: @escaping (Error?, Boxscore?) -> Void) {
        let utilityQueue = DispatchQueue.global(qos: .utility)
        request(
            Endpoints.gameBoxscore(id: id),
            headers: Headers.auth
        ).downloadProgress(queue: utilityQueue) { info in
            progress?(info.fractionCompleted)
        }
        .responseJSON { response in
            guard let json = response.value as? [String: Any],
                response.error == nil
            else {
                done(response.error ?? Errors.badData, nil)
                return
            }
                        
            let boxScore = Boxscore.create(fromJson: json)
            done(nil, boxScore)
        }
    }
}
