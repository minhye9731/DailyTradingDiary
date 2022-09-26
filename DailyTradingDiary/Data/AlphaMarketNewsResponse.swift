//
//  AlphaMarketNewsModel.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/26/22.
//

import Foundation

struct AlphaMarketNewsResponse: Decodable {
    let items, sentimentScoreDefinition, relevanceScoreDefinition: String
    let feed: [Feed]

    enum CodingKeys: String, CodingKey {
        case items
        case sentimentScoreDefinition = "sentiment_score_definition"
        case relevanceScoreDefinition = "relevance_score_definition"
        case feed
    }
}

// MARK: - Feed
struct Feed: Decodable {
    let title: String
    let url: String
    let timePublished: String
    let authors: [String]
    let summary: String
    let bannerImage: String?
    let source, categoryWithinSource, sourceDomain: String
    let topics: [TopicElement]
    let overallSentimentScore: Double
    let overallSentimentLabel: SentimentLabel
    let tickerSentiment: [TickerSentiment]

    enum CodingKeys: String, CodingKey {
        case title, url
        case timePublished = "time_published"
        case authors, summary
        case bannerImage = "banner_image"
        case source
        case categoryWithinSource = "category_within_source"
        case sourceDomain = "source_domain"
        case topics
        case overallSentimentScore = "overall_sentiment_score"
        case overallSentimentLabel = "overall_sentiment_label"
        case tickerSentiment = "ticker_sentiment"
    }
}

enum SentimentLabel: String, Decodable {
    case bearish = "Bearish"
    case bullish = "Bullish"
    case neutral = "Neutral"
    case somewhatBearish = "Somewhat-Bearish"
    case somewhatBullish = "Somewhat-Bullish"
}

// MARK: - TickerSentiment
struct TickerSentiment: Decodable {
    let ticker, relevanceScore, tickerSentimentScore: String
    let tickerSentimentLabel: SentimentLabel

    enum CodingKeys: String, CodingKey {
        case ticker
        case relevanceScore = "relevance_score"
        case tickerSentimentScore = "ticker_sentiment_score"
        case tickerSentimentLabel = "ticker_sentiment_label"
    }
}

// MARK: - TopicElement
struct TopicElement: Decodable {
    let topic: TopicEnum
    let relevanceScore: String

    enum CodingKeys: String, CodingKey {
        case topic
        case relevanceScore = "relevance_score"
    }
}

enum TopicEnum: String, Decodable {
    case blockchain = "Blockchain"
    case earnings = "Earnings"
    case economyFiscal = "Economy - Fiscal"
    case economyMacro = "Economy - Macro"
    case economyMonetary = "Economy - Monetary"
    case energyTransportation = "Energy & Transportation"
    case finance = "Finance"
    case financialMarkets = "Financial Markets"
    case ipo = "IPO"
    case lifeSciences = "Life Sciences"
    case manufacturing = "Manufacturing"
    case mergersAcquisitions = "Mergers & Acquisitions"
    case realEstateConstruction = "Real Estate & Construction"
    case retailWholesale = "Retail & Wholesale"
    case technology = "Technology"
}
