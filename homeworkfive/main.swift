//
//  main.swift
//  homeworkfour
//
//  Created by Nikita Boiko on 20/10/2019.
//  Copyright © 2019 Nikita Boiko. All rights reserved.
//

import Foundation

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
    
    func customAction(action: CustomActions)
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
    
    mutating func addCargo(load: CargoAction, volume: UInt) {
        if load == .load {
            let amount = volume + currentVolume
         if amount > self.volume {
                currentVolume = self.volume
                print("У автомобиля \(brand): Превышен допустимый объем. \(amount - self.volume) осталось не загружено")
            } else {
                currentVolume += volume
            }
        } else {
            let amount = Int(currentVolume - volume)
            if amount < 0 {
                currentVolume = 0
                print("У автомобиля \(brand): Автомобиль разгружен полностью.")
            } else {
                currentVolume -= volume
            }
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
    
    func customAction(action: CustomActions) {
        if action == .sportActionStartNitro || action == .sportActionStopNitro {
            print("Выполняется действие: \(action.rawValue)")
            nitro(action: action)
            
        } else {
            print("этот автомобиль не предназначен для выполнения этого действия")
        }
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

nissanGTR.customAction(action: .sportActionStartNitro)
scaniaTruck.addCargo(load: .load, volume: 1000)
scaniaTruck.customAction(action: .trunkActionUp)
nissanGTR.useEngine()
scaniaTruck.useWindows()
nissanGTR.customAction(action: .sportActionStartNitro)
scaniaTruck.useWindows()
print(nissanGTR)
print(scaniaTruck)
