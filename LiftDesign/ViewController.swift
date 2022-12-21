//
//  ViewController.swift
//  LiftDesign
//
//  Created by Dipesh Pokhrel on 19/12/22.
//

import UIKit

protocol LiftHandler {
    @discardableResult func openDoor(at floorNumber : Int) -> Bool
    @discardableResult func closeDoor(at floorNumber : Int) -> Bool
    @discardableResult func wait(at floorNumber : Int, seconds : Int )-> Bool
    @discardableResult func handleUserRequest(request : UserRequest,lift : Lift) ->Bool
}

extension LiftHandler {
    @discardableResult func wait(at floorNumber : Int, seconds : Int = 4)-> Bool {
        print("waited for \(seconds) seconds..")
        return true
    }
    @discardableResult func openDoor(at floorNumber : Int) -> Bool {
        print("Door opened at \(floorNumber)")
        return true
    }
    @discardableResult func closeDoor(at floorNumber : Int) -> Bool{
        print("Door closed at \(floorNumber)\n")
        print("Its moving...")
        return true
    }
    
    func processRequest(at floorNumber : Int) {
        openDoor(at: floorNumber)
        wait(at: floorNumber)
        closeDoor(at: floorNumber)
    }
    func handleUserRequest(request : UserRequest,lift : Lift) ->Bool {
        
        if lift.status == .idle {
            processRequest(at: request.floorNumber)
            lift.status = .moving
            processRequest(at: request.destination)
           
            
        }
        else {
            if lift.direction == .up  &&   request.direction == .up {
                if lift.currentFloor < request.destination  {
                    processRequest(at: request.floorNumber)
                    processRequest(at: request.destination)
                    lift.currentFloor = request.destination
                    lift.direction = request.direction
                    lift.status = .moving
                }
            }
            if lift.direction == .down  &&   request.direction == .down {
                if lift.currentFloor > request.destination  {
                    processRequest(at: request.floorNumber)
                    processRequest(at: request.destination)
                    lift.currentFloor = request.destination
                    lift.direction = request.direction
                    lift.status = .moving
                }
            }
        }
        return true
    }
}


class ViewController: UIViewController , LiftHandler {
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let lift : Lift = Lift(direction: .up, status: .idle, currentFloor: 0)!
        var  userRequests : [UserRequest] = [UserRequest(floorNumber: 3, direction: .up, destination: 4),
                                            UserRequest(floorNumber: 5, direction: .up, destination: 7),
                                            UserRequest(floorNumber: 5, direction: .up, destination: 7),
                                            UserRequest(floorNumber: 8, direction: .up, destination: 10),]
        
        while userRequests.count != 0 {
            let completed = handleUserRequest(request: userRequests.removeFirst(), lift:lift )
        }
        print("Its stopped and became idle at ")
        lift.direction = .up
        lift.status = .idle
       
    }
}

enum Direction {
    case up, down
}

enum LiftStatus {
    case moving, idle
}

struct UserRequest{
    var floorNumber : Int
    var direction : Direction
    var destination : Int
}

class Lift {
    var direction : Direction
    var status : LiftStatus
    var currentFloor : Int
    
    private var startingFloor : Int = 0
    private var endingFloor : Int = 10
    
    init?(direction : Direction, status : LiftStatus , currentFloor : Int) { // failable initializer 
        
        if currentFloor < startingFloor || currentFloor > endingFloor {
            return nil
        }
        self.direction = direction
        self.status = status
        self.currentFloor = currentFloor
    }
    
}

