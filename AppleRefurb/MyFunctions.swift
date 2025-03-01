//
//  MyFunctions.swift
//  AppleRefurb
//
//  Created by Tahren Ponnusamy on 1/3/2025.
//

import Foundation

let appleProductURLs = ["https://www.apple.com/au/shop/refurbished/mac", "https://www.apple.com/au/shop/refurbished/ipad", "https://www.apple.com/au/shop/refurbished/watch", "https://www.apple.com/au/shop/refurbished/airpods", "https://www.apple.com/au/shop/refurbished/homepod", "https://www.apple.com/au/shop/refurbished/appletv"]

struct AppleProduct: Identifiable {
    var id = UUID()
    var type: AppleProductType
    var name: String
    var url: String
    var price: Double
    var imageURL: String
    var description: String
    var colour: String?
    var screenSize: String?
    var processor: String?
    var cpu: String?
    var gpu: String?
    var memory: String?
    var storage: String?
    var material: String?
    var macType: String?
    var series: String?
}

enum AppleProductType: Int, CaseIterable {
    case Mac = 0
    case iPad
    case Watch
    case Airpods
    case Homepod
    case AppleTV
    var index: Int {
        return rawValue
    }
    var value: String {
        return String(describing: self)
    }
}

func clipStringSuffix(inputString: String, start: String) -> String? {
    if let range = inputString.range(of: start) {
        let startIndex = inputString.distance(from: inputString.startIndex, to: range.upperBound)
        let output = inputString.suffix(inputString.count - startIndex)
        return String(output)
    }
    return nil
}

func findStringBetween(inputString: String, start: String, end: String) -> String {
    if let range = inputString.range(of: start) {
        let startIndex = inputString.distance(from: inputString.startIndex, to: range.lowerBound)
        var appendText = String(inputString.suffix(inputString.count - startIndex - start.count))
        if let range2 = appendText.range(of: end) {
            let endIndex = appendText.distance(from: appendText.startIndex, to: range2.lowerBound)
            appendText = String(appendText.prefix(endIndex))
            return appendText
        }
        if let range2 = appendText.range(of: end) {
            let endIndex = appendText.distance(from: appendText.startIndex, to: range2.lowerBound)
            appendText = String(appendText.prefix(endIndex))
            return appendText
        }
    }
    return ""
}

func loadURL(url: String) async -> String {
    if let url1 = URL(string: url) {
        do {
            let contents = try String(contentsOf: url1, encoding: .utf8)
            return contents
        } catch {
            // contents could not be loaded
        }
    } else {
        return "Something went wrong :("
        // the URL was bad!
    }
    return ""
}

func splitURLText(text: String) -> [String] {
    let textComponents = text.components(separatedBy: CharacterSet(charactersIn: "<>"))
    var returnTexts: [String] = []
    for textPart in textComponents {
        if !textPart.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            returnTexts.append(textPart)
        }
    }
    return returnTexts
}


func searchForString(texts: [String], searchString: String) -> [String] {
    var searchedTexts: [String] = []
    for text in texts {
        if text.contains(searchString) {
            searchedTexts.append(text)
        }
    }
    return searchedTexts
}

func makeStringASCII(inputString: String) -> String {
    var outputString = inputString
    for i in (0..<inputString.count) {
        let letter = Array(inputString)[i]
        if !letter.isASCII {
            if letter.unicodeScalars.first!.value == 8209 {
                // Non unicode - character
                outputString.remove(at: outputString.index(outputString.startIndex, offsetBy: i))
                outputString.insert(contentsOf: "-", at: outputString.index(outputString.startIndex, offsetBy: i))
            }
            if letter.unicodeScalars.first!.value == 160 {
                // Non unicode space character
                outputString.remove(at: outputString.index(outputString.startIndex, offsetBy: i))
                outputString.insert(contentsOf: " ", at: outputString.index(outputString.startIndex, offsetBy: i))
            }
        }
    }
    return outputString
}

func generateAppleProduct(product: String, appleProductType: AppleProductType) -> AppleProduct {
    let name = makeStringASCII(inputString: findStringBetween(inputString: product, start: "name\":\"", end: "\""))
    let url = findStringBetween(inputString: product, start: "url\":\"", end: "\"")
    let price = findStringBetween(inputString: product, start: "price\":", end: ",")
    let image = findStringBetween(inputString: product, start: "image\":\"", end: "\"")
    let description = findStringBetween(inputString: product, start: "description\":\"", end: "\"")
    print(description)

    var colour: String?
    var screenSize: String?
    var processor: String?
    var material: String?
    var cpu: String?
    var gpu: String?
    var memory: String?
    var storage: String?
    var macType: String?
    var series: String?

    if appleProductType == .Mac {
        colour = clipStringSuffix(inputString: name, start: " - ")
        if colour == nil {
            colour = "Silver"
        }
        screenSize = findStringBetween(inputString: name, start: " ", end: " ")
        if !screenSize!.contains("inch") {
            screenSize = "No Screen"
        }
        processor = findStringBetween(inputString: name, start: "Apple ", end: " Chip")
        if processor == "" {
            processor = "Intel"
        }
        if name.contains("Book") {
            macType = "Laptop"
        } else {
            macType = "Desktop"
        }
        var descriptionComponents: [String] = []
        if description.contains("\\") && description.contains("|") {
            print("Contains \\ and |")
            descriptionComponents = description.components(separatedBy: ["|", "\\"])
            print("Components: \(descriptionComponents.count)")
            if descriptionComponents.count > 5 {
                print("\(descriptionComponents[4])")
            }
        } else {
            descriptionComponents = description.components(separatedBy: ["|", "\\"])
            print("Components: \(descriptionComponents.count)")
            if descriptionComponents.count > 3 {
                print("\(descriptionComponents[2])")
            }
        }
    }
    
    else if appleProductType == .iPad {
        colour = clipStringSuffix(inputString: name, start: " -")
        if colour != nil {
            if colour!.contains("(") {
                colour = findStringBetween(inputString: colour!, start: " ", end: " (")
            }
            if colour!.first == " " {
                colour!.removeFirst()
            }
        }
    }
    
    else if appleProductType == .Watch {
        colour = findStringBetween(inputString: name, start: "mm ", end: " ")
        screenSize = findStringBetween(inputString: name, start: ", ", end: " ")
        material = findStringBetween(inputString: name, start: "mm ", end: "Case")
        var materialSplit = material!.split(separator: " ")
        if materialSplit.count == 2 {
            material = String(materialSplit[1])
        } else {
            material = String(materialSplit[1] + " " + materialSplit[2])
        }
        series = findStringBetween(inputString: name, start: "Watch ", end: " GPS")
    }
    
    return AppleProduct(type: appleProductType, name: name, url: url, price: Double(price) ?? 0.0, imageURL: image, description: description, colour: colour, screenSize: screenSize, processor: processor, cpu: cpu, gpu: gpu, material: material, macType: macType, series: series)
}
