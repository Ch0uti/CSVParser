// Copyright © 2019 ChouTi. All rights reserved.

import Foundation

extension String {
    // split the string by character

    func split(by characterSet: CharacterSet) -> [String] {
        let quote = "\""
        var apperQuote = false
        let result = utf16.split(maxSplits: Int.max, omittingEmptySubsequences: false) { x in
            if quote == String(UnicodeScalar(x)!) {
                apperQuote = !apperQuote
            }
            if apperQuote {
                return false
            } else {
                return characterSet.contains(UnicodeScalar(x)!)
            }
        }.compactMap(String.init)
        return result
    }

    func split(by character: Character, quote: Character) -> [String] {
        var apperQuote = false
        let result = utf16.split(maxSplits: Int.max, omittingEmptySubsequences: false) { x in
            if String(quote) == String(UnicodeScalar(x)!) {
                apperQuote = !apperQuote
            }
            if apperQuote {
                return false
            } else {
                return Character(UnicodeScalar(x)!) == character
            }
        }.compactMap(String.init)
        return result
    }

    func parseCSV(delimiter: Character, lineSeparator: Character, quote: Character) -> [[String]] {
        var appearQuote = false
        let splitedLines = utf16.split(maxSplits: Int.max, omittingEmptySubsequences: false) {
            let char = Character(UnicodeScalar($0)!)
            if char == quote {
                appearQuote = !appearQuote
            }
            if appearQuote {
                return false
            } else {
                return char == lineSeparator
            }
        }
        appearQuote = false
        return splitedLines.map { line in
            line.split(maxSplits: Int.max, omittingEmptySubsequences: false) {
                let char = Character(UnicodeScalar($0)!)
                if char == quote {
                    appearQuote = !appearQuote
                }
                if appearQuote {
                    return false
                } else {
                    return char == delimiter
                }
            }.compactMap(String.init)
        }
    }
}

extension String {
    // to split to lines
    func nzSplitLines(lineSeparator: Character) -> [String] {
        return utf16.split {
            Character(UnicodeScalar($0)!) == lineSeparator
        }.compactMap(String.init)
    }

    // to split to elements
    func nzSplitElements(delimiter: Character) -> [String] {
        return utf16.split {
            Character(UnicodeScalar($0)!) == delimiter
        }.compactMap(String.init)
    }

    // from string to object data
    func nzSplitElements(lineSeparator: Character, delimiter: Character) -> [[String]] {
        let rowString = utf16.split(maxSplits: Int.max, omittingEmptySubsequences: false) {
            Character(UnicodeScalar($0)!) == lineSeparator
        }
        return rowString.map {
            $0.split(maxSplits: Int.max, omittingEmptySubsequences: false) {
                Character(UnicodeScalar($0)!) == delimiter
            }.compactMap(String.init)
        }
    }

    func index(of char: Character, after: String.Index) -> String.Index? {
        return range(of: String(char), options: .literal, range: after..<endIndex, locale: nil)?.lowerBound
    }

    mutating func removeLast() -> Character {
        return remove(at: index(before: endIndex))
    }
}
