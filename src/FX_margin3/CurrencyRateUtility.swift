// 
// FX_margin3
// CurrencyRateUtility.swift
//
//


import UIKit

class CurrencyRateUtility: NSObject {
    
    enum JPY_PAIR: String {
        case USD = "USD"
        case EUR = "EUR"
        case GBP = "GBP"
        case AUD = "AUD"
        case NZD = "NZD"
    }

    enum USD_PAIR: String {
        case EUR = "EUR"
        case GBP = "GBP"
        case AUD = "AUD"
        case NZD = "NZD"
    }

    struct JsonRate: Codable {
        var JPY: Double?
        var USD: Double?
    }

    struct JsonBase: Codable {
        var base: String
        var date: String
        var rates: JsonRate
    }
    
    static func GetCrossYenRate(pair: JPY_PAIR) -> Decimal? {

        let url: URL = URL(string: "https://api.exchangeratesapi.io/latest?base=" + pair.rawValue + "&symbols=JPY")!
        
        guard let price_data = try? Data(contentsOf: url) else { return nil }

        var rtn_price: Decimal? = nil
        do {
            let price_json = try JSONDecoder().decode(JsonBase.self, from: price_data)
            rtn_price = Decimal(price_json.rates.JPY!).rounded(3)
        } catch {
            rtn_price = nil
        }
        
        return rtn_price
    }
    
    static func GetCrossDollarRate(pair: USD_PAIR) -> Decimal? {
        
        let url: URL = URL(string: "https://api.exchangeratesapi.io/latest?base=" + pair.rawValue + "&symbols=USD")!

        guard let price_data = try? Data(contentsOf: url) else { return nil }
        
        var rtn_price: Decimal? = nil
        do {
            let price_json = try JSONDecoder().decode(JsonBase.self, from: price_data)
            rtn_price = Decimal(price_json.rates.USD!).rounded(5)
        } catch {
            rtn_price = nil
        }
        
        return rtn_price
    }
 }

