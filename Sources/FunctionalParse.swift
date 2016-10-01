//
//  FunctionalParse.swift
//  CSVParser
//
//  Created by Nero Zuo on 16/10/1.
//
//

import Foundation

extension CSVParser {
  func functionalParse(cursor: String.Index, delimiterIndex: String.Index?, lineSIndex: String.Index?,row: [String], rows: [[String]], content: String) -> [[String]] {
    
    
    let charactersView = content.characters
    
    if cursor == charactersView.endIndex {
      return rows
    }
    
    let nextCursor = charactersView.index(after: cursor)
    if charactersView[cursor] == self.quotes {
      return functionalParseQuote(cursor: nextCursor, quoteIndex: cursor, delimiterIndex: delimiterIndex, lineSIndex: lineSIndex, row: row, rows: rows, content: content)
    }else {
      
      //Next delimiter comes before next newline
      if let delimiterIndex = delimiterIndex {
        if let lineSIndex = lineSIndex, delimiterIndex >= lineSIndex {
          // pass
        }else {
          let newRow = row + [content.substring(with: cursor..<delimiterIndex)]
          
          let nextCursor = charactersView.index(delimiterIndex, offsetBy: 1)
          let nextDeiliterIndex = content.index(of: self.delimiter, after: nextCursor)
          return functionalParse(cursor: nextCursor, delimiterIndex: nextDeiliterIndex, lineSIndex: lineSIndex, row: newRow, rows: rows, content: content)
        }
      }
      
      // end of row
      
      if let lineSIndex = lineSIndex {
        let newRow = row + [content.substring(with: cursor..<lineSIndex)]
        
        let nextCursor = charactersView.index(lineSIndex, offsetBy: 1)
        let nextLineSIndex = content.index(of: self.lineSeparator, after: nextCursor)
        
        return functionalParse(cursor: nextCursor, delimiterIndex: delimiterIndex, lineSIndex: nextLineSIndex, row: [], rows: rows + [newRow], content: content)
      }
      
      if cursor != charactersView.endIndex && delimiterIndex == nil && lineSIndex == nil {
        let newRow = row + [content.substring(with: cursor..<charactersView.endIndex)]
        
        return functionalParse(cursor: charactersView.endIndex, delimiterIndex: nil, lineSIndex: nil, row: [], rows: rows + [newRow], content: content)
        
      }
    }
//    return rows
    fatalError("Unexpteted error")
  }
  
  // the cursor must be the cursor.sussor
  func functionalParseQuote(cursor: String.Index, quoteIndex: String.Index, delimiterIndex: String.Index?, lineSIndex: String.Index?,row: [String], rows: [[String]], content: String) -> [[String]] {
    let charactersView = content.characters
    if let nextQuote = self.content.index(of: self.quotes, after: charactersView.index(after: quoteIndex)) {
      // end of file
      if nextQuote == charactersView.endIndex {
        let newRow = row + [content.substring(with: cursor..<nextQuote)]
        return functionalParse(cursor: charactersView.endIndex, delimiterIndex: charactersView.endIndex, lineSIndex: charactersView.endIndex, row: [], rows: rows + [newRow], content: content)
      }
      
      //  two quotes together
      if charactersView[charactersView.index(after: nextQuote)] == self.quotes {
        return functionalParseQuote(cursor: cursor, quoteIndex: nextQuote, delimiterIndex: delimiterIndex, lineSIndex: lineSIndex, row: row, rows: rows, content: content)
      }
      
      // come across delimiter
      if charactersView[charactersView.index(after: nextQuote)] == self.delimiter {
        let newRow = row + [content.substring(with: cursor..<nextQuote)]
        let nextCursor = charactersView.index(nextQuote, offsetBy: 1+1)
        return functionalParse(cursor: nextCursor, delimiterIndex: content.index(of: self.delimiter, after: nextCursor), lineSIndex: content.index(of: self.lineSeparator, after: nextQuote), row: newRow, rows: rows, content: content)
      }
      
      // come across nextline
      if charactersView[charactersView.index(after: nextQuote)] == self.lineSeparator {
        let newRow = row + [content.substring(with: cursor..<nextQuote)]
        let nextCursor = charactersView.index(nextQuote, offsetBy: 1+1)
        return functionalParse(cursor: nextCursor, delimiterIndex: content.index(of: self.delimiter, after: nextCursor), lineSIndex: content.index(of: self.lineSeparator, after: nextCursor), row: [], rows: rows + [newRow], content: content)
      }
      return functionalParseQuote(cursor: cursor, quoteIndex: nextQuote, delimiterIndex: delimiterIndex, lineSIndex: lineSIndex, row: row, rows: rows, content: content)
    }else {
      fatalError("No matched quotes")
    }
    fatalError("Unexpected error")
  }
  
  func newParse() {
    let startIndex = self.content.characters.startIndex
    let delimiterIndex = self.content.index(of: self.delimiter, after: startIndex)
    let lineSIndex = self.content.index(of: self.lineSeparator, after: startIndex)
    self.rows = functionalParse(cursor: startIndex, delimiterIndex: delimiterIndex, lineSIndex: lineSIndex, row: [], rows: [], content: self.content)
  }
  
  
}
