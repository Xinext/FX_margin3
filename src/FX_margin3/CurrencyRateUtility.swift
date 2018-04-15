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

        let pair = pair.rawValue + "_JPY"
        let url: URL = URL(string: "https://free.currencyconverterapi.com/api/v3/convert?q=" + pair + "&compact=ultra")!
        
        guard let price_data = try? Data(contentsOf: url) else { return nil }

        var rtn_price: Decimal? = nil
        do {
            let price_json = try JSONSerialization.jsonObject(with: price_data, options: JSONSerialization.ReadingOptions.allowFragments)
            let price_dct = price_json as! NSDictionary
            rtn_price = Decimal(price_dct[pair] as! Double).rounded(3)
        } catch {
            rtn_price = nil
        }
        
        return rtn_price
    }
    
    static func GetCrossDollarRate(pair: USD_PAIR) -> Decimal? {
        
        let pair = pair.rawValue + "_USD"
        let url: URL = URL(string: "https://free.currencyconverterapi.com/api/v3/convert?q=" + pair + "&compact=ultra")!
        
        guard let price_data = try? Data(contentsOf: url) else { return nil }
        
        var rtn_price: Decimal? = nil
        do {
            let price_json = try JSONSerialization.jsonObject(with: price_data, options: JSONSerialization.ReadingOptions.allowFragments)
            let price_dct = price_json as! NSDictionary
            rtn_price = Decimal(price_dct[pair] as! Double).rounded(5)
        } catch {
            rtn_price = nil
        }
        
        return rtn_price
    }
 }

