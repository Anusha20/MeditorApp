//
//  Tagger.swift
//
//  Created by Sivaprakash Ragavan on 10/13/15.
//  Copyright © 2015 Sivaprakash Ragavan. All rights reserved.
//

import Foundation

var properNouns: [String] = []

var WFreq  = Dictionary<String,Int> ()



func updateFrequency( token:String , tag : String){
    
    
    if let freq = WFreq[token] as Int?{
        WFreq[token] = freq + 1;
    }else{
        WFreq[token] = 1;
    }
    
    let freq = WFreq[token]
    
    if NSLinguisticTagOrganizationName == tag {
        WFreq[token] = freq! + 2
    }
}

func sortByFreq() -> [String]{
    
    var topTenTags = [String]()
    var i = 0
    for (k,_) in (Array(WFreq).sort {$0.1 > $1.1}) {
        if(i < 10){
            topTenTags.append(k)
        }
        i++;
    }
    return topTenTags
}


func updateProperNouns() {
    let options: NSLinguisticTaggerOptions = [.OmitWhitespace, .OmitPunctuation, .JoinNames,.OmitOther]
    let schemes = NSLinguisticTagger.availableTagSchemesForLanguage("en")
    print(schemes)
    let tagger = NSLinguisticTagger(tagSchemes: schemes, options: Int(options.rawValue))
    
    let inputTextViewLocal = "With U.S. commercial electricity prices at their highest point in nearly a decade, many businesses are looking to solar to meaningfully increase their bottom line and drive incremental enterprise value.The value that solar can create for businesses becomes especially staggering when you look at how many low-margin industries have energy costs as a meaningful percentage of overall revenue, and therefore how small changes in energy costs can greatly improve company profitability.For sectors from agriculture to mining to waste management, a 30% reduction in overall energy bills can improve net margin — and therefore enterprise value — by over 45%. Even industries with a more modest energy bill, like real estate development, retail, and food and grocery, can still achieve double digit increases in profitability.In the 18 industries below, these savings equate to over $25B in Net Income and $770B in Market Cap. That’s a lot of money to leave on the table.Among the many ways to cut energy consumption, solar is a top choice for three reasons 1. Innovative financing Power Purchase Agreements (PPAs) have revolutionized solar financing by allowing businesses to lock in (nearly) risk-free savings for $0 down. The concept is simple: a third party pays for the installation of solar on a business’ roof, charges the business nothing up-front, but locks the business into a long-term (usually 20 year) contract to buy the energy produced from the solar installation at a predetermined rate (the PPA rate) with a fixed escalator (usually around 1–2% per year).Since the PPA rate is lower than the retail price of electricity, and the system is owned and maintained by the third party, businesses have limited risk from entering into this type of agreement. In addition to PPAs, there are solar leases, traditional loans, and even Property Assessed Clean Energy (PACE) loans that are repaid through property taxes.The shift towards Third Party Owned (TPO) systems like PPAs, where the business who has solar on their roof does not actually own the system, has been dramatic. This trend is encapsulated well by the New Jersey Clean Energy Program interconnect data, which shows the share of installed solar capacity from TPO systems spike from 12% to 73% in just one year.2. Tangible, predictable savings In any capital investment, having a clearly traceable and highly predictable ROI is critical for financiers (who must backstop the asset) and system owners (who want to ensure that their investment pencils out).Solar energy system output is easily measured with an energy meter, which makes its impact straightforward to quantify. When it comes to prediction, there is a wealth of historical climate data available from organizations like ASHRAE, along with solar energy system design and performance tools like PV Syst, Folsom Labs, and now Google’s Project Sunroof, to provide high accuracy estimates of future energy savings.3. Minimal disruption to the core busines. Solar does not require a behavioral change on the part of employees or customers, or an aesthetic change to the inside of the building, in order to accrue savings. By allowing companies to run their business as usual, they can take advantage of the benefits of solar without bearing the costs of productivity disruptions.These favorable dynamics have precipitated a steep growth curve in the U.S. commercial solar market, with installations growing nearly four-fold from 2010 to 2015 according to I.H.S. Solar.What’s the catch?While these high-level facts make commercial solar an attractive investment, there are important risks that must be mitigated in order to ensure that commercial solar systems are performing optimally.Next Monday, I’ll outline 4 of the biggest risks to financial performance — specifically, to risk-adjusted return — and show how they can be mitigated."
    tagger.string = inputTextViewLocal
    
    var results = ""
    properNouns = []
    
    tagger.enumerateTagsInRange(NSMakeRange(0, (inputTextViewLocal as NSString).length), scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass, options: options) { (tag, tokenRange, sentenceRange, _) in
        let token = (inputTextViewLocal as NSString).substringWithRange(tokenRange)
        
        results += "\(token): \(tag)\n"
      //  print(token+":"+tag)
        if [NSLinguisticTagPersonalName, NSLinguisticTagPlaceName, NSLinguisticTagOrganizationName,NSLinguisticTagNoun].contains(tag) {
            properNouns.append(token)
            updateFrequency(token,tag:tag)
           // print(token)
        }
        
       
        
    }
    
}
