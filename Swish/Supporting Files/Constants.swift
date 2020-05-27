import UIKit

struct Constants {
    static let urls = Urls()
    static let keys = Keys()

    struct Urls {
        let firebase = "https://nba-app-ca681.firebaseio.com"
        let nbaApi = "https://api.mysportsfeeds.com/v2.1/pull/nba"
    }

    struct Keys {
        let nbaApi = "OTRhNTAzODUtYmY4NS00NzFjLWEwOWMtMGFlY2EwOk1ZU1BPUlRTRkVFRFM="
    }

    enum Teams: String {
        case TOR = "TOR"
        case BOS = "BOS"
        case NYK = "NYK"
        case BRO = "BRO"
        case PHI = "PHI"
        case CLE = "CLE"
        case IND = "IND"
        case DET = "DET"
        case CHI = "CHI"
        case MIL = "MIL"
        case ATL = "ATL"
        case MIA = "MIA"
        case CHA = "CHA"
        case WAS = "WAS"
        case ORL = "ORL"
        case OKL = "OKL"
        case POR = "POR"
        case UTA = "UTA"
        case DEN = "DEN"
        case MIN = "MIN"
        case GSW = "GSW"
        case LAC = "LAC"
        case SAC = "SAC"
        case PHX = "PHX"
        case LAL = "LAL"
        case SAS = "SAS"
        case MEM = "MEM"
        case DAL = "DAL"
        case HOU = "HOU"
        case NOP = "NOP"
        
        var team: Team {
            switch self {
            case .TOR: return Team(
                    id: 81,
                    city: "Toronto",
                    name: "Raptors",
                    abbreviation: "TOR",
                    homeVenueId: 1,
                    homeVenueName: "Scotiabank Arena",
                    teamColors: [
                        UIColor(rgb: 0xce1141, alpha: 1),
                        .black,
                        UIColor(rgb: 0xa1a1a4, alpha: 1),
                        UIColor(rgb: 0xb4975a, alpha: 1),
                    ],
                    twitter: "raptors",
                    logo: #imageLiteral(resourceName: "TOR_logo")
                )
            case .BOS: return Team(
                    id: 82,
                    city: "Boston",
                    name: "Celtics",
                    abbreviation: "BOS",
                    homeVenueId: 27,
                    homeVenueName: "TD Garden",
                    teamColors: [
                        UIColor(rgb: 0x007a33, alpha: 1),
                        UIColor(rgb: 0xba9653, alpha: 1),
                        UIColor(rgb: 0x963821, alpha: 1),
                        UIColor(rgb: 0xe596d, alpha: 1),
                        UIColor(rgb: 0x000000, alpha: 1),
                    ],
                    twitter: "celtics",
                    logo: #imageLiteral(resourceName: "BOS_logo")
                )
            case .NYK: return Team(
                    id: 83,
                    city: "New York",
                    name: "Knicks",
                    abbreviation: "NYK",
                    homeVenueId: 12,
                    homeVenueName: "Madison Square Garden",
                    teamColors: [
                        UIColor(rgb: 0x006bb6, alpha: 1),
                        UIColor(rgb: 0xf58426, alpha: 1),
                        UIColor(rgb: 0xbec0c2, alpha: 1),
                        UIColor(rgb: 0x000000, alpha: 1),
                    ],
                    twitter: "nyknicks",
                    logo: #imageLiteral(resourceName: "NYK_logo")
                )
            case .BRO: return Team(
                    id: 84,
                    city: "Brooklyn",
                    name: "Nets",
                    abbreviation: "BRO",
                    homeVenueId: 78,
                    homeVenueName: "Barclays Center",
                    teamColors: [
                        UIColor(rgb: 0x000000, alpha: 1),
                        UIColor(rgb: 0xffffff, alpha: 1),
                    ],
                    twitter: "brooklynnets",
                    logo: #imageLiteral(resourceName: "BKN_logo")
                )
            case .PHI: return Team(
                    id: 85,
                    city: "Philadelphia",
                    name: "76ers",
                    abbreviation: "PHI",
                    homeVenueId: 29,
                    homeVenueName: "Wells Fargo Center",
                    teamColors: [
                        UIColor(rgb: 0x006bb6, alpha: 1),
                        UIColor(rgb: 0xed174c, alpha: 1),
                        UIColor(rgb: 0x002b5c, alpha: 1),
                        UIColor(rgb: 0xc4ced4, alpha: 1),
                    ],
                    twitter: "sixers",
                    logo: #imageLiteral(resourceName: "PHI_logo")
                )
            case .CLE: return Team(
                    id: 86,
                    city: "Cleveland",
                    name: "Cavaliers",
                    abbreviation: "CLE",
                    homeVenueId: 80,
                    homeVenueName: "Rocket Mortgage FieldHouse",
                    teamColors: [
                        UIColor(rgb: 0x6f263d, alpha: 1),
                        UIColor(rgb: 0x041e42, alpha: 1),
                        UIColor(rgb: 0xffb81c, alpha: 1),
                        UIColor(rgb: 0x000000, alpha: 1),
                    ],
                    twitter: "cavs",
                    logo: #imageLiteral(resourceName: "CLE_logo")
                )
            case .IND: return Team(
                    id: 87,
                    city: "Indiana",
                    name: "Pacers",
                    abbreviation: "IND",
                    homeVenueId: 81,
                    homeVenueName: "Bankers Life Fieldhouse",
                    teamColors: [
                        UIColor(rgb: 0x002d62, alpha: 1),
                        UIColor(rgb: 0xfdbb30, alpha: 1),
                        UIColor(rgb: 0xbec0c2, alpha: 1),
                    ],
                    twitter: "pacers",
                    logo: #imageLiteral(resourceName: "IND_logo")
                )
            case .DET: return Team(
                    id: 88,
                    city: "Detroit",
                    name: "Pistons",
                    abbreviation: "DET",
                    homeVenueId: 145,
                    homeVenueName: "Little Caesars Arena",
                    teamColors: [
                        UIColor(rgb: 0x006bb6, alpha: 1),
                        UIColor(rgb: 0x006bb6, alpha: 1),
                        UIColor(rgb: 0xbec0c2, alpha: 1),
                        UIColor(rgb: 0x002d62, alpha: 1),
                    ],
                    twitter: "detroitpistons",
                    logo: #imageLiteral(resourceName: "DET_logo")
                )
            case .CHI: return Team(
                    id: 89,
                    city: "Chicago",
                    name: "Bulls",
                    abbreviation: "CHI",
                    homeVenueId: 28,
                    homeVenueName: "United Center",
                    teamColors: [
                        UIColor(rgb: 0xce1141, alpha: 1),
                        UIColor(rgb: 0x000000, alpha: 1),
                    ],
                    twitter: "chicagobulls",
                    logo: #imageLiteral(resourceName: "CHI_logo")
                )
            case .MIL: return Team(
                    id: 90,
                    city: "Milwaukee",
                    name: "Bucks",
                    abbreviation: "MIL",
                    homeVenueId: 152,
                    homeVenueName: "Fiserv Forum",
                    teamColors: [
                        UIColor(rgb: 0x00471b, alpha: 1),
                        UIColor(rgb: 0xeee1c6, alpha: 1),
                    ],
                    twitter: "bucks",
                    logo: #imageLiteral(resourceName: "MIL_logo")
                )
            case .ATL: return Team(
                    id: 91,
                    city: "Atlanta",
                    name: "Hawks",
                    abbreviation: "ATL",
                    homeVenueId: 20,
                    homeVenueName: "State Farm Arena",
                    teamColors: [
                        UIColor(rgb: 0xe03a3e, alpha: 1),
                        UIColor(rgb: 0xc1d32f, alpha: 1),
                    ],
                    twitter: "atlhawks",
                    logo: #imageLiteral(resourceName: "ATL_logo")
                )
            case .MIA: return Team(
                    id: 92,
                    city: "Miami",
                    name: "Heat",
                    abbreviation: "MIA",
                    homeVenueId: 86,
                    homeVenueName: "American Airlines Arena",
                    teamColors: [
                        UIColor(rgb: 0x98002e, alpha: 1),
                        UIColor(rgb: 0xf9a01b, alpha: 1),
                    ],
                    twitter: "miamiheat",
                    logo: #imageLiteral(resourceName: "MIA_logo")
                )
            case .CHA: return Team(
                    id: 93,
                    city: "Charlotte",
                    name: "Hornets",
                    abbreviation: "CHA",
                    homeVenueId: 87,
                    homeVenueName: "Spectrum Center",
                    teamColors: [
                        UIColor(rgb: 0x1d1160, alpha: 1),
                        UIColor(rgb: 0x00788c, alpha: 1),
                    ],
                    twitter: "hornets",
                    logo: #imageLiteral(resourceName: "CHA_logo")
                )
            case .WAS: return Team(
                    id: 94,
                    city: "Washington",
                    name: "Wizards",
                    abbreviation: "WAS",
                    homeVenueId: 13,
                    homeVenueName: "Capital One Arena",
                    teamColors: [
                        UIColor(rgb: 0x002b5c, alpha: 1),
                        UIColor(rgb: 0xe31837, alpha: 1),
                    ],
                    twitter: "washwizards",
                    logo: #imageLiteral(resourceName: "WAS_logo")
                )
            case .ORL: return Team(
                    id: 95,
                    city: "Orlando",
                    name: "Magic",
                    abbreviation: "ORL",
                    homeVenueId: 89,
                    homeVenueName: "Amway Center",
                    teamColors: [
                        UIColor(rgb: 0x0077c0, alpha: 1),
                        UIColor(rgb: 0xc4ced4, alpha: 1),
                    ],
                    twitter: "orlandomagic",
                    logo: #imageLiteral(resourceName: "ORL_logo")
                )
            case .OKL: return Team(
                    id: 96,
                    city: "Oklahoma City",
                    name: "Thunder",
                    abbreviation: "OKL",
                    homeVenueId: 90,
                    homeVenueName: "Chesapeake Energy Arena",
                    teamColors: [
                        UIColor(rgb: 0x007ac1, alpha: 1),
                        UIColor(rgb: 0xef3b24, alpha: 1),
                    ],
                    twitter: "okcthunder",
                    logo: #imageLiteral(resourceName: "OKC_logo")
                )
            case .POR: return Team(
                    id: 97,
                    city: "Portland",
                    name: "Trail Blazers",
                    abbreviation: "POR",
                    homeVenueId: 91,
                    homeVenueName: "Moda Center",
                    teamColors: [
                        UIColor(rgb: 0xe03a3e, alpha: 1),
                        UIColor(rgb: 0x000000, alpha: 1),
                    ],
                    twitter: "trailblazers",
                    logo: #imageLiteral(resourceName: "POR_logo")
                )
            case .UTA: return Team(
                    id: 98,
                    city: "Utah",
                    name: "Jazz",
                    abbreviation: "UTA",
                    homeVenueId: 92,
                    homeVenueName: "Vivant Smart Home Arena",
                    teamColors: [
                        UIColor(rgb: 0x002b5c, alpha: 1),
                        UIColor(rgb: 0x00471b, alpha: 1),
                    ],
                    twitter: "utahjazz",
                    logo: #imageLiteral(resourceName: "UTA_logo")
                )
            case .DEN: return Team(
                    id: 99,
                    city: "Denver",
                    name: "Nuggets",
                    abbreviation: "DEN",
                    homeVenueId: 19,
                    homeVenueName: "Pepsi Center",
                    teamColors: [
                        UIColor(rgb: 0x0e2240, alpha: 1),
                        UIColor(rgb: 0xfec524, alpha: 1),
                    ],
                    twitter: "nuggets",
                    logo: #imageLiteral(resourceName: "DEN_logo")
                )
            case .MIN: return Team(
                    id: 100,
                    city: "Minnesota",
                    name: "Timberwolves",
                    abbreviation: "MIN",
                    homeVenueId: 94,
                    homeVenueName: "Target Center",
                    teamColors: [
                        UIColor(rgb: 0x0c2340, alpha: 1),
                        UIColor(rgb: 0x236192, alpha: 1),
                    ],
                    twitter: "timberwolves",
                    logo: #imageLiteral(resourceName: "MIN_logo")
                )
            case .GSW: return Team(
                    id: 101,
                    city: "Golden State",
                    name: "Warriors",
                    abbreviation: "GSW",
                    homeVenueId: 150,
                    homeVenueName: "Chase Center",
                    teamColors: [
                        UIColor(rgb: 0x006bb6, alpha: 1),
                        UIColor(rgb: 0xfdb927, alpha: 1),
                    ],
                    twitter: "warriors",
                    logo: #imageLiteral(resourceName: "GSW_logo")
                )
            case .LAC: return Team(
                    id: 102,
                    city: "Los Angeles",
                    name: "Clippers",
                    abbreviation: "LAC",
                    homeVenueId: 25,
                    homeVenueName: "Staples Center",
                    teamColors: [
                        UIColor(rgb: 0xc8102e, alpha: 1),
                        UIColor(rgb: 0x1d428a, alpha: 1),
                    ],
                    twitter: "laclippers",
                    logo: #imageLiteral(resourceName: "LAC_logo")
                )
            case .SAC: return Team(
                    id: 103,
                    city: "Sacramento",
                    name: "Kings",
                    abbreviation: "SAC",
                    homeVenueId: 151,
                    homeVenueName: "Golden 1 Center",
                    teamColors: [
                        UIColor(rgb: 0x5a2d81, alpha: 1),
                        UIColor(rgb: 0x63727a, alpha: 1),
                    ],
                    twitter: "sacramentokings",
                    logo: #imageLiteral(resourceName: "SAC_logo")
                )
            case .PHX: return Team(
                    id: 104,
                    city: "Phoenix",
                    name: "Suns",
                    abbreviation: "PHX",
                    homeVenueId: 98,
                    homeVenueName: "Talking Stick Resort Arena",
                    teamColors: [
                        UIColor(rgb: 0x1d1160, alpha: 1),
                        UIColor(rgb: 0xe56020, alpha: 1),
                    ],
                    twitter: "suns",
                    logo: #imageLiteral(resourceName: "PHX_logo")
                )
            case .LAL: return Team(
                    id: 105,
                    city: "Los Angeles",
                    name: "Lakers",
                    abbreviation: "LAL",
                    homeVenueId: 25,
                    homeVenueName: "Staples Center",
                    teamColors: [
                        UIColor(rgb: 0x552583, alpha: 1),
                        UIColor(rgb: 0xfdb927, alpha: 1),
                    ],
                    twitter: "lakers",
                    logo: #imageLiteral(resourceName: "LAL_logo")
                )
            case .SAS: return Team(
                    id: 106,
                    city: "San Antonio",
                    name: "Spurs",
                    abbreviation: "SAS",
                    homeVenueId: 99,
                    homeVenueName: "AT&T Center",
                    teamColors: [
                        UIColor(rgb: 0xc4ced4, alpha: 1),
                        UIColor(rgb: 0x000000, alpha: 1),
                    ],
                    twitter: "spurs",
                    logo: #imageLiteral(resourceName: "SAS_logo")
                )
            case .MEM: return Team(
                    id: 107,
                    city: "Memphis",
                    name: "Grizzlies",
                    abbreviation: "MEM",
                    homeVenueId: 100,
                    homeVenueName: "Fedex Forum",
                    teamColors: [
                        UIColor(rgb: 0x5d76a9, alpha: 1),
                        UIColor(rgb: 0x12173f, alpha: 1),
                    ],
                    twitter: "memgrizz",
                    logo: #imageLiteral(resourceName: "MEM_logo")
                )
            case .DAL: return Team(
                    id: 108,
                    city: "Dallas",
                    name: "Mavericks",
                    abbreviation: "DAL",
                    homeVenueId: 2,
                    homeVenueName: "American Airlines Center",
                    teamColors: [
                        UIColor(rgb: 0x00538c, alpha: 1),
                        UIColor(rgb: 0x002b5e, alpha: 1),
                    ],
                    twitter: "dallasmavs",
                    logo: #imageLiteral(resourceName: "DAL_logo")
                )
            case .HOU: return Team(
                    id: 109,
                    city: "Houston",
                    name: "Rockets",
                    abbreviation: "HOU",
                    homeVenueId: 102,
                    homeVenueName: "Toyota Center",
                    teamColors: [
                        UIColor(rgb: 0xce1141, alpha: 1),
                        UIColor(rgb: 0x000000, alpha: 1),
                    ],
                    twitter: "houstonrockets",
                    logo: #imageLiteral(resourceName: "HOU_logo")
                )
            case .NOP: return Team(
                    id: 110,
                    city: "New Orleans",
                    name: "Pelicans",
                    abbreviation: "NOP",
                    homeVenueId: 103,
                    homeVenueName: "Smoothie King Center",
                    teamColors: [
                        UIColor(rgb: 0x0c2340, alpha: 1),
                        UIColor(rgb: 0xc8102e, alpha: 1),
                    ],
                    twitter: "pelicansnba",
                    logo: #imageLiteral(resourceName: "NOP_logo")
                )
            }
        }
    }
}
