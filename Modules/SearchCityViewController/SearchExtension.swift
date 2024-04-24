//
//  SearchExtension.swift
//  WeatherDemoApp
//
//  Created by ahmed on 04/04/2024.
//

import UIKit

extension SearchCityViewController: UISearchBarDelegate {

    // MARK: shouldChangeTextIn
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let whiteSpaceChar = CharacterSet.whitespaces

        // allowing white space in between chars, but not at the begining
        if text.rangeOfCharacter(from: whiteSpaceChar) != nil,
           let searchText = searchBar.text,
            searchText.isEmpty {
            return true
        }
        
        let returnKeyChar = CharacterSet(charactersIn: "\n")
        
//      allowing check if char passed is return key, so i can dismiss keyboard
        if text.rangeOfCharacter(from: returnKeyChar) != nil {
            return true
        }
        
        var allowedCharacters = CharacterSet.alphanumerics
        allowedCharacters.insert(charactersIn: " ")
        
        // allowing only Letters and numbers
        guard text.rangeOfCharacter(from: allowedCharacters) != nil else {
            return false
        }
        
        return true
    }
    
    /// local search functionality
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        self.perform(#selector(textDidChange))
//    }

    // MARK: SearchButtonClicked

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // dismiss keyboard & keep search text
        // sending search text when clicked search
        self.perform(#selector(clickedSearchBtn))
        
        searchBar.resignFirstResponder()
        
    }
}
