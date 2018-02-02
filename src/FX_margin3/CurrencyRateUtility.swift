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

    static func GetCrossYenRate(pair: JPY_PAIR) -> Decimal? {

        let url: URL = URL(string: "https://finance.google.com/finance/converter?a=1&from=" + pair.rawValue + "&to=JPY")!
        
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let htmlSting = String(data: data, encoding: .iso2022JP ) else { return nil }
        
        var ans: [String] = []
        if htmlSting.pregMatche(pattern: "<span class=bld>((?:.|\n)+?)JPY</span>", matches: &ans) != true {
            return nil
        }
        
        return Decimal(string: ans[1])
    }
    
    static func GetCrossDollarRate(pair: USD_PAIR) -> Decimal? {
        
        let url: URL = URL(string: "https://finance.google.com/finance/converter?a=1&from=" + pair.rawValue + "&to=USD")!
        
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let htmlSting = String(data: data, encoding: .iso2022JP ) else { return nil }
        
        var ans: [String] = []
        if htmlSting.pregMatche(pattern: "<span class=bld>((?:.|\n)+?)USD</span>", matches: &ans) != true {
            return nil
        }
        
        return Decimal(string: ans[1])
    }
 }

