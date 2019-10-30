//
//  main.swift
//  homeworkfour
//
//  Created by Nikita Boiko on 20/10/2019.
//  Copyright © 2019 Nikita Boiko. All rights reserved.
//

import Foundation

enum CarError: Error {
    case noSuchAction
    case isLimitOfQuantity
    case outOfCargo
    
}

enum CargoAction {
    case load
    case upload
}

enum CustomActions: String {
    case trunkActionUp = "Поднятие кузова"
    case trunkActionDown = "Опускание кузова"
    case sportActionStartNitro = "Включение закиси азота"
    case sportActionStopNitro = "Отключение закиси азота"
}

protocol Car {
    var brand: String {get}
    var year: Int {get}
    var volume: UInt {get}
    var isStartEngine: Bool {get set}
    var isOpenWindows: Bool {get set}
    var currentVolume: UInt {get set}
    
    func customAction(action: CustomActions) throws
}

extension Car {
    mutating func useWindows() {
        if isOpenWindows {
            print("У автомобиля \(brand): Окна закрты")
            isOpenWindows = false
        } else {
            print("У автомобиля \(brand): Окна открыты")
            isOpenWindows = true
        }
    }
    
    mutating func useEngine() {
        if isStartEngine {
            print("У автомобиля \(brand): Двигатель запущен")
            isStartEngine = false
        } else {
            print("У автомобиля \(brand): Двигатель заглушен")
            isStartEngine = true
        }
    }
    
    mutating func addCargo(load: CargoAction, volume: UInt) throws {
        if load == .load {
            let amount = volume + currentVolume
            guard amount <= self.volume else {
                currentVolume = volume
                throw CarError.isLimitOfQuantity
            }
            currentVolume += volume
        } else {
            let amount = Int(currentVolume - volume)
            guard amount >= 0 else {
                currentVolume = 0
                throw CarError.outOfCargo
            }
            currentVolume -= volume
            print("У автомобиля \(brand): Текущая загрузка составляет \(currentVolume)")
        }
    }
}

class SportCar: Car {
    var brand: String
    var year: Int
    var volume: UInt
    var isStartEngine: Bool
    var isOpenWindows: Bool
    var currentVolume: UInt
    var nitro: Bool = false
    
    init(brand: String, year: Int, volume: UInt){
        self.brand = brand
        self.year = year
        self.volume = volume
        isOpenWindows = false
        isStartEngine = false
        currentVolume = 0
        nitro = false
    }
    
    func customAction(action: CustomActions) throws {
        guard action == .sportActionStartNitro || action == .sportActionStopNitro else {
            print("этот автомобиль не предназначен для выполнения этого действия")
            throw CarError.noSuchAction
        }
        print("Выполняется действие: \(action.rawValue)")
        nitro(action: action)
    }
    
    private func nitro(action: CustomActions) {
        if !isStartEngine {
            print("Двигатель выключен. Включение нитро бесполезно")
            return
        }
        sleep(3)
        if action == .sportActionStartNitro {
            nitro = true
            print("Закись азота включена")
        } else {
            nitro = false
            print("Закись азота выключена")
        }
    }
}

class TruсkCar: Car {
    var brand: String
    var year: Int
    var volume: UInt
    var isStartEngine: Bool
    var isOpenWindows: Bool
    var currentVolume: UInt
    var dumpRaised: Bool
    
    init(brand: String, year: Int, volume: UInt){
        self.brand = brand
        self.year = year
        self.volume = volume
        isOpenWindows = false
        isStartEngine = false
        currentVolume = 0
        dumpRaised = false
    }
    

    func customAction(action: CustomActions) {
        if action == .trunkActionUp || action == .trunkActionDown {
            print("Выполняется действие: \(action.rawValue)")
            raiseDump(action: action)
        } else {
            print("этот автомобиль не предназначен для выполнения этого действия")
        }
    }
    
    private func raiseDump(action: CustomActions) {
        sleep(3)
        if action == .trunkActionUp {
            dumpRaised = true
            print("Кузов поднят")
            print("Груз сброшен")
            currentVolume = 0
        } else {
            dumpRaised = false
            print("Кузов опущен")
        }
    }
}

extension SportCar: CustomStringConvertible {
    var description: String {
        return "Спортивная тачка \(brand), \(year) года"
    }
}

extension TruсkCar: CustomStringConvertible {
    var description: String {
        return "Тягач \(brand), \(year) года"
    }
}

var nissanGTR = SportCar(brand: "Nissan", year: 2009, volume: 200)
var scaniaTruck = TruсkCar(brand: "Scania", year: 2017, volume: 3000)

do {
   try nissanGTR.customAction(action: .sportActionStartNitro) }
catch let error { print("Ошибка выполнения действия \(error.self)") }

do {
    try nissanGTR.customAction(action: .trunkActionDown) }
catch let error { print("Ошибка выполнения действия \(error.self)") }

do {
try scaniaTruck.addCargo(load: .load, volume: 10000) }
catch let error { print("Ошибка загрузки \(error.self)")}
scaniaTruck.customAction(action: .trunkActionUp)
nissanGTR.useEngine()
scaniaTruck.useWindows()
do {
    try nissanGTR.customAction(action: .sportActionStartNitro) }
catch let error { print("Ошибка выполнения действия \(error.self)") }
scaniaTruck.useWindows()
print(nissanGTR)
print(scaniaTruck)

