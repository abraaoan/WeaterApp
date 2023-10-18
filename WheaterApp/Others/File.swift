import Foundation

// DataServiceError

struct ResponseError: Decodable {
    let code: String
    let description: String
    
    init(code: String, description: String) {
        self.code = code
        self.description = description
    }
}

enum DataServiceError: CustomNSError {
    case invalidURL
    case invalidResponseType
    case invalidstatusCode
    
    static var errorDomain: String { "XCAStocksAPI" }
    
    var errorUserInfo: [String : Any] {
        let text: String
        switch self {
        case .invalidURL:
            text = "Invalid URL"
        case .invalidResponseType:
            text = "Invalid Response Type"
        case .invalidstatusCode:
            text = "Error: Invalid Status Code"
        }
        return [NSLocalizedDescriptionKey: text]
    }
}

// ---------------------------------- || =----------------------- //
// Chart.swift

struct ChartResponse: Decodable {
    let data: [ChartData]?
    let error: ResponseError?
    
    enum CodingKeys: CodingKey {
        case chart
    }
    
    enum ChartKeys: CodingKey {
        case result
        case error
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let chartContainer = try? container.nestedContainer(keyedBy: ChartKeys.self, forKey: .chart) {
            data = try? chartContainer.decodeIfPresent([ChartData].self, forKey: .result)
            error = try? chartContainer.decodeIfPresent(ResponseError.self, forKey: .error)
        } else {
            data = nil
            error = nil
        }
    }
}

struct ChartData: Decodable {
    let meta: ChartMeta
    let indicators: [Indicator]
    
    enum CodingKeys: CodingKey {
        case meta
        case timestamp
        case indicators
    }
    
    enum IndicatorsKeys: CodingKey {
        case quote
    }
    
    enum QuoteKeys: CodingKey {
        case high
        case close
        case low
        case open
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        meta = try container.decode(ChartMeta.self, forKey: .meta)
        
        let timestamps = try container.decodeIfPresent([Date].self, forKey: .timestamp) ?? []
        if let indicatorsContainer = try? container.nestedContainer(keyedBy: IndicatorsKeys.self, forKey: .indicators),
           var quotes = try? indicatorsContainer.nestedUnkeyedContainer(forKey: .quote),
           let quoteContainer = try? quotes.nestedContainer(keyedBy: QuoteKeys.self) {
            
            let highs = try quoteContainer.decodeIfPresent([Double?].self, forKey: .high) ?? []
            let lows = try quoteContainer.decodeIfPresent([Double?].self, forKey: .low) ?? []
            let opens = try quoteContainer.decodeIfPresent([Double?].self, forKey: .open) ?? []
            let closes = try quoteContainer.decodeIfPresent([Double?].self, forKey: .close) ?? []
            
            indicators = timestamps.enumerated().compactMap { (offset, timestamp) in
                guard
                    let open = opens[offset],
                    let low = lows[offset],
                    let close = closes[offset],
                    let high = highs[offset]
                else { return nil }
                return Indicator(timestamp: timestamp,
                                 open: open,
                                 high: high,
                                 low: low,
                                 close: close)
            }
        } else {
            self.indicators = []
        }
    }
    
    init(meta: ChartMeta, indicators: [Indicator]) {
        self.meta = meta
        self.indicators = indicators
    }
}

struct ChartMeta: Decodable {
    let currency: String
    let symbol: String
    let regularMarketPrice: Double?
    let previousClose: Double?
    let gmtOffset: Int
    let regularTradingPeriodStartDate: Date
    let regularTradingPeriodEndDate: Date
    
    enum CodingKeys: CodingKey {
        case currency
        case symbol
        case regularMarketPrice
        case previousClose
        case gmtoffset
        case currentTradingPeriod
    }
    
    enum CurrentTradingPeriodKeys: String, CodingKey {
        case pre
        case regular
        case post
    }
    
    enum TradingPeriodKeys: String, CodingKey {
        case start
        case end
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        symbol = try container.decodeIfPresent(String.self, forKey: .symbol) ?? ""
        regularMarketPrice = try container.decodeIfPresent(Double.self, forKey: .regularMarketPrice)
        previousClose = try container.decodeIfPresent(Double.self, forKey: .previousClose)
        gmtOffset = try container.decodeIfPresent(Int.self, forKey: .gmtoffset) ?? 0
        
        let currentTradingPeriodContainer = try? container.nestedContainer(keyedBy: CurrentTradingPeriodKeys.self, forKey: .currentTradingPeriod)
        let regularTradingPeriodContainer = try? currentTradingPeriodContainer?.nestedContainer(keyedBy: TradingPeriodKeys.self, forKey: .regular)
        regularTradingPeriodStartDate = try regularTradingPeriodContainer?.decode(Date.self, forKey: .start) ?? Date()
        regularTradingPeriodEndDate = try regularTradingPeriodContainer?.decode(Date.self, forKey: .end) ?? Date()
    }
}

struct Indicator: Decodable {
    let timestamp: Date
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    
    init(timestamp: Date, open: Double, high: Double, low: Double, close: Double) {
        self.timestamp = timestamp
        self.open = open
        self.high = high
        self.low = low
        self.close = close
    }
}

// ---------------------------------- || =----------------------- //
// Quotes
struct QuoteResponse: Decodable {
    let data: [Quote]?
    let error: ResponseError?
    
    enum CodingKeys: CodingKey {
        case quoteResponse
        case finance
    }
    
    enum ResponseKeys: CodingKey {
        case result
        case error
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let quoteResponseContainer = try? container.nestedContainer(keyedBy: ResponseKeys.self, forKey: .quoteResponse) {
            data = try? quoteResponseContainer.decodeIfPresent([Quote].self, forKey: .result)
            error = try? quoteResponseContainer.decodeIfPresent(ResponseError.self, forKey: .error)
        } else if let financeResponseContainer = try? container.nestedContainer(keyedBy: ResponseKeys.self, forKey: .finance) {
            data = nil
            error = try? financeResponseContainer.decodeIfPresent(ResponseError.self, forKey: .error)
        } else {
            data = nil
            error = nil
        }
    }
}

struct Quote: Decodable, Identifiable, Hashable {
    var id = UUID()
    let symbol: String
    let currency: String?
    let marketState: String?
    let fullExchangeName: String?
    let displayName: String?
    let regularMarketPrice: Double?
    let regularMarketChange: Double?
    let regularMarketChangePercent: Double?
    let regularMarketChangePreviousClose: Double?
    let regularMarketTime: Date?
    let postMarketPrice: Double?
    let postMarketChange: Double?
    let regularMarketOpen: Double?
    let regularMarketDayHigh: Double?
    let regularMarketDayLow: Double?
    let regularMarketVolume: Double?
    let trailingPE: Double?
    let marketCap: Double?
    let fiftyTwoWeekLow: Double?
    let fiftyTwoWeekHigh: Double?
    let averageDailyVolume3Month: Double?
    let trailingAnnualDividendYield: Double?
    let epsTrailingTwelveMonths: Double?
    
    init(symbol: String,
         currency: String? = nil,
         marketState: String? = nil,
         fullExchangeName: String? = nil,
         displayName: String? = nil,
         regularMarketPrice: Double? = nil,
         regularMarketChange: Double? = nil,
         regularMarketChangePercent: Double? = nil,
         regularMarketChangePreviousClose: Double? = nil,
         regularMarketTime: Date? = nil,
         postMarketPrice: Double? = nil,
         postMarketChange: Double? = nil,
         regularMarketOpen: Double? = nil,
         regularMarketDayHigh: Double? = nil,
         regularMarketDayLow: Double? = nil,
         regularMarketVolume: Double? = nil,
         trailingPE: Double? = nil,
         marketCap: Double? = nil,
         fiftyTwoWeekLow: Double? = nil,
         fiftyTwoWeekHigh: Double? = nil,
         averageDailyVolume3Month: Double? = nil,
         trailingAnnualDividendYield: Double? = nil,
         epsTrailingTwelveMonths: Double? = nil) {
        self.symbol = symbol
        self.currency = currency
        self.marketState = marketState
        self.fullExchangeName = fullExchangeName
        self.displayName = displayName
        self.regularMarketPrice = regularMarketPrice
        self.regularMarketChange = regularMarketChange
        self.regularMarketChangePercent = regularMarketChangePercent
        self.regularMarketChangePreviousClose = regularMarketChangePreviousClose
        self.regularMarketTime = regularMarketTime
        self.postMarketPrice = postMarketPrice
        self.postMarketChange = postMarketChange
        self.regularMarketOpen = regularMarketOpen
        self.regularMarketDayHigh = regularMarketDayHigh
        self.regularMarketDayLow = regularMarketDayLow
        self.regularMarketVolume = regularMarketVolume
        self.trailingPE = trailingPE
        self.marketCap = marketCap
        self.fiftyTwoWeekLow = fiftyTwoWeekLow
        self.fiftyTwoWeekHigh = fiftyTwoWeekHigh
        self.averageDailyVolume3Month = averageDailyVolume3Month
        self.trailingAnnualDividendYield = trailingAnnualDividendYield
        self.epsTrailingTwelveMonths = epsTrailingTwelveMonths
    }
}

// ---------------------------------- || =----------------------- //
// Ticker

struct SearchTickersResponse: Decodable {
    let error: ResponseError?
    let data: [Ticker]?
    
    enum CodingKeys: CodingKey {
        case count
        case quotes
        case finance
    }
    
    enum FinanceKeys: CodingKey {
        case error
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try? container.decodeIfPresent([Ticker].self, forKey: .quotes)
        error = try? container.nestedContainer(keyedBy: FinanceKeys.self, forKey: .finance)
            .decodeIfPresent(ResponseError.self, forKey: .error)
    }
}

struct Ticker: Codable, Identifiable, Hashable, Equatable {
    var id = UUID()
    let symbol: String
    let quoteType: String?
    let shortname: String?
    let longname: String?
    let sector: String?
    let industry: String?
    let exchDisp: String?
    
    init(symbol: String, quoteType: String? = nil, shortname: String? = nil, longname: String? = nil, sector: String? = nil, industry: String? = nil, exchDisp: String? = nil) {
        self.symbol = symbol
        self.quoteType = quoteType
        self.shortname = shortname
        self.longname = longname
        self.sector = sector
        self.industry = industry
        self.exchDisp = exchDisp
    }
}


// ---------------------------------- || =----------------------- //
// ChartRange

enum ChartRange: String, CaseIterable {
    
    case oneDay = "1d"
    case oneWeek = "5d"
    case oneMonth = "1mo"
    case threeMonth = "3mo"
    case sixMonth = "6mo"
    case ytd
    case oneYear = "1y"
    case twoYear = "2y"
    case fiveYear = "5y"
    case tenYear = "10y"
    case max
    
    var interval: String {
        switch self {
        case .oneDay: return "1m"
        case .oneWeek: return "5m"
        case .oneMonth: return "90m"
        case .threeMonth, .sixMonth, .ytd, .oneYear, .twoYear: return "1d"
        case .fiveYear, .tenYear: return "1wk"
        case .max: return "3mo"
        }
    }
}
