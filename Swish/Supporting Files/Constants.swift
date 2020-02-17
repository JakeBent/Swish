import UIKit

struct Constants {
    static let urls = Urls()
    static let keys = Keys()
    static let logos = Logos()
    
    struct Urls {
        let firebase = "https://nba-app-ca681.firebaseio.com"
        let nbaApi = "https://api.mysportsfeeds.com/v2.1/pull/nba"
    }

    struct Keys {
        let nbaApi = "OTRhNTAzODUtYmY4NS00NzFjLWEwOWMtMGFlY2EwOk1ZU1BPUlRTRkVFRFM="
    }

    struct Logos {
        let hawks = #imageLiteral(resourceName: "hawks_logo")
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
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
                    teamColors: [],
                    twitter: "pelicansnba",
                    logo: #imageLiteral(resourceName: "NOP_logo")
                )
            }
        }
    }
}
