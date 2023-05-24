//
//  LanguageModel.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 5/22/23.
//

func toEmoji(languageAbbr: String) -> String {
    switch languageAbbr {
    case "eng":
        return "🇬🇧 English"
    case "kor":
        return "🇰🇷 한국어"
    case "rus":
        return "🇷🇺 Русский"
    case "spa":
        return "🇪🇸 Español"
    case "por":
        return "🇵🇹 Português"
    case "zho":
        return "中文"
    case "deu":
        return "🇩🇪 Deutsch"
    case "jpn":
        return "🇯🇵 日本語"
    case "fra":
        return "🇫🇷 Français"
    case "swe":
        return "🇸🇪 Svenska"
    case "nld":
        return "🇳🇱 Nederlands"
    case "pol":
        return "🇵🇱 Polski"
    case "dan":
        return "🇩🇰 Dansk"
    case "nor":
        return "🇳🇴 Norsk"
    case "ita":
        return "🇮🇹 Italiano"
    case "tha":
        return "🇹🇭 ภาษาไทย"
    case "fin":
        return "🇫🇮 Suomi"
    case "hun":
        return "🇭🇺 Magyar"
    case "ces":
        return "🇨🇿 Čeština"
    case "tur":
        return "🇹🇷 Türkçe"
    case "ara":
        return "العربية"
    case "ron":
        return "🇷🇴 Română"
    case "vie":
        return "🇻🇳 Tiếng Việt"
    case "ukr":
        return "🇺🇦 украї́нська"
    case "ase":
        return "🇺🇸🤟 American Sign Language"
    case "bfi":
        return "🇬🇧🤟 British Sign Language"
    case "dse":
        return "🇳🇱🤟 Dutch Sign Language"
    case "fsl":
        return "🇫🇷🤟 French Sign Language"
    case "jsl":
        return "🇯🇵🤟 Japanese Sign Language"
    case "kvk":
        return "🇰🇷🤟 Korean Sign Language"
    case "ADD":
        return "Add"
    default:
        return "🌍 \(languageAbbr)"
    }
}

let languagesAbbrs = ["ADD", "eng", "kor", "rus", "spa", "por", "zho", "deu", "jpn", "fra", "swe", "nld", "pol", "dan", "nor", "ita", "tha", "fin", "hun", "ces", "tur", "ara", "ron", "vie", "ukr", "ase", "bfi", "dse", "fsl", "jsl", "kvk"]
