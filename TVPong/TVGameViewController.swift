//
//  TVGameViewController.swift
//  WatchPong
//
//  Created by Felipe Lukavei Ferreira on 5/31/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit
import GameController
import SceneKit

class TVGameViewController: GCEventViewController, ReactToMotionEvents {

     var lastDate = NSDate()
    
    enum flowMovement {
        case right
        case left
    }
    let pongController = PongController()

    let controllers = GCController.controllers()
    var userAccelerationMax: Double = 0.6
    var userAccelerationAtMaxAcceleration: Dictionary<String, Double> = [:]
    var gravityAtMaxAcceleration: Dictionary<String, Double> = [:]
    var lastRemoteMovementTime: NSDate? = nil

    var currentDataFromGamepad: [dataFromGamePad] = []

    var flow: flowMovement = .right
    var savingData: Dictionary<Int, [dataFromGamePad]> = [:]

    var previousMovement = GCAcceleration(x: 0, y: 0, z: 0)

    let minimumAcceleration = 0.3
    let forceConstant = 0.2
    
    @IBOutlet weak var sceneView: PongSceneView!
    let necessaryStrnght = 0.5

    //MARK: ESCREVI "MUDEI ISTO" EM TUDO O Q MUDEI FORA DESTA CLASSE

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.scene!.paused = false
        for controller in controllers {
            controller.microGamepad?.allowsRotation = false
        }

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.motionDelegate = self
    }

    func motionUpdate(motion: GCMotion) {

        let totalX = motion.gravity.x + motion.userAcceleration.x
        let totalY = motion.gravity.y + motion.userAcceleration.y
        let totalZ = motion.gravity.z + motion.userAcceleration.z
        
        let treshould: Double = 3
        if (totalX > treshould || totalX < -treshould) {
            print(" ---- ")
            print("x: \(totalX)")
            print("y: \(totalY)")
            print("z: \(totalZ)")
            print(" ---- ")
        }
        
        if NSDate().timeIntervalSince1970 > self.lastDate.dateByAddingTimeInterval(1).timeIntervalSince1970 {
            if totalX > 3 {
                lastDate = NSDate()
                pongController.processLeftAction()
            } else if totalX < -3 {
                lastDate = NSDate()
                pongController.processRightAction()
            }
        }
        
        
//        if lastRemoteMovementTime == nil {
//            lastRemoteMovementTime = NSDate()
//        }
//        if NSDate().timeIntervalSinceDate(lastRemoteMovementTime!) > 0.05{
//            clearDataFromGamePad()}
//
//        else if motion.userAcceleration.z>minimumAcceleration{
////            NSLog("destro batendo do lado esquerdo // zAcc: \(motion.userAcceleration.z) // xAcc: \(motion.userAcceleration.x) // yAcc: \(motion.userAcceleration.y) // zGrav: \(motion.gravity.z) // yGrav: \(motion.gravity.y) // xGrav: \(motion.gravity.z) // TIME: \(NSDate().timeIntervalSinceDate(lastRemoteMovementTime!))") // canhoteiro batendo do lado direito
//
//            if flow == flowMovement.right {
//                flow = .left
//                clearDataFromGamePad()
//            }
//            if previousMovement.x != motion.userAcceleration.x && previousMovement.y != motion.userAcceleration.y && previousMovement.z != motion.userAcceleration.z{
//                currentDataFromGamepad = (filtrateData(dataFromGamePad(acceleration: GCAcceleration(x: -motion.userAcceleration.x, y:motion.userAcceleration.y, z: -motion.userAcceleration.z), gravity: GCAcceleration(x: motion.gravity.x*0.5,y:motion.gravity.y,z:motion.gravity.z), yAcceleration: motion.userAcceleration.y)))
//            }
//
//        } else if motion.userAcceleration.z < -minimumAcceleration {
////            NSLog("destro batendo do lado direito // zAcc: \(motion.userAcceleration.z) // xAcc: \(motion.userAcceleration.x) // yAcc: \(motion.userAcceleration.y) // zGrav: \(motion.gravity.z) // yGrav: \(motion.gravity.y) // xGrav: \(motion.gravity.z) // TIME: \(NSDate().timeIntervalSinceDate(lastRemoteMovementTime!))") // canhoteiro batendo do lado esquerdo
//
//            if flow == flowMovement.left {
//                flow = .right
//                clearDataFromGamePad()
//            }
//            if previousMovement.x != motion.userAcceleration.x && previousMovement.y != motion.userAcceleration.y && previousMovement.z != motion.userAcceleration.z {
//                currentDataFromGamepad = (filtrateData(dataFromGamePad(acceleration: GCAcceleration(x:10*motion.userAcceleration.x,y:motion.userAcceleration.y,z:motion.userAcceleration.z), gravity: motion.gravity, yAcceleration: motion.userAcceleration.y)))
//            }
//
//            //MARK: batida do lado direito para destro o acc.z é negativo, inverte o lado e é positivo && batido do lado esquerdo para canhotos o acc.z é negativo
//        }
//        lastRemoteMovementTime = NSDate()
//
//        if let first = currentDataFromGamepad.first{
//            if flow == .right{
//                if pongController.myTurn && first.acceleration.z /** first.gravity.z*/ > necessaryStrnght{
//                    averageForce(currentDataFromGamepad)
//                }
//            }
//            else{
//                if pongController.myTurn && first.acceleration.z /** first.gravity.z*/ < -necessaryStrnght/2{
//                    averageForce(currentDataFromGamepad)
//                }
//            }
//        }
    }


    func applyForceFromAcceleration (gravity: GCAcceleration, userAcceleration: GCAcceleration) {
        //MARK: enquanto maior o gravity.x maior a força aplicada em x, enquanto maior o gravity.z maior a força aplicada em z
        //MARK: Z aplica a força para a frente, Y aplica a força para cima, X aplica a força para a direita
        var strenght = forceConstant
        if flow == .right{
            let necessaryStrenght = -0.9
            if strenght*userAcceleration.z > necessaryStrenght{
                strenght = necessaryStrenght/userAcceleration.z
            }

        }
        else{
            let necessaryStrenght = 0.9
            if -strenght*userAcceleration.z < necessaryStrenght{
                strenght = -necessaryStrenght/userAcceleration.z
            }

        }
        var side = -1.0
        if flow == .left{
            side = 1.0
        }
        let force = SCNVector3Make(Float(side*strenght*userAcceleration.x*(gravity.x)), Float(strenght*userAcceleration.y*(gravity.y)), Float(-strenght*userAcceleration.z*(gravity.z)))
        if pongController.myTurn{
            pongController.applyBallFoce(force)
            clearDataFromGamePad()
            print(force, gravity)
        }
        
        //MARK: controle corre de ré Z positivo, de frente Z negativo

        //MARK: a força é aplicada na bolinha (com destro batendo) quando há a inflexão na aceleração X, deve-se então fazer uma média do angulo proporcionado pelos inputs anteriores a esta inflexão com acc.z semelhantes OU a força é aplicada no pico de Z  ->> ATUALIZAÇÃO: pegar inputs semelhantes logo antes do pico da acc em Y
        //MARK: se não tem aumento para pico de aceleração em Y não é uma batida

    }

    func filtrateData(currentData: dataFromGamePad) -> [dataFromGamePad] {
        var currentGroupsCount = savingData.keys.count

        if currentGroupsCount == 0 {
            savingData[0] = [currentData]
            currentGroupsCount = 1
        }
        if let previousData = savingData[currentGroupsCount-1]!.last?.yAcceleration{
            var variation : Double = previousData-currentData.yAcceleration
            if variation != 0{
                if variation < 0{
                    variation = -variation
                }
                if variation < 0.2/*currentData.yAcceleration/10*/{
                    savingData[currentGroupsCount-1]!.append(currentData)
                }
                else{
                    savingData[currentGroupsCount] = [currentData]
                }
            }
        }

        if savingData.keys.count == 1 {
            return savingData[0]!
        }
        if let data = savingData[indexOfTheCorrectForce()]{
            return data
        }
        return savingData[savingData.keys.count-2]!
    }
      override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    func indexOfTheCorrectForce()->Int {

        
        var maxYAcceleration = 0.0
        var groupAcceleration = 0.0
        var indexOfMaxAcceleration = 0
        if flow == .right{
            for key: Int in Array(savingData.keys) {
                if let data = savingData[key]
                {
                    if let currentAcc = data[0].yAcceleration as? Double where currentAcc > maxYAcceleration{ //data.1[0].yAcceleration as? Double where maxAcceleration > maxYAcceleration{
                        groupAcceleration = maxYAcceleration
                        maxYAcceleration = currentAcc
                        indexOfMaxAcceleration = key
                    }
                }
            }
        }
        
        if flow == .left{
            for key: Int in Array(savingData.keys) {
                if let data = savingData[key]
                {
                    if let currentAcc = data[0].yAcceleration as? Double where currentAcc < maxYAcceleration{ //data.1[0].yAcceleration as? Double where maxAcceleration > maxYAcceleration{
                        groupAcceleration = maxYAcceleration
                        maxYAcceleration = currentAcc
                        indexOfMaxAcceleration = key
                    }
                }
            }
        }
        return indexOfMaxAcceleration-1
    }

    func averageForce(arrayOfForces: [dataFromGamePad]){
        if pongController.myTurn && savingData.keys.count>3{
            var acceleration : GCAcceleration = GCAcceleration(x: 0, y: 0, z: 0)
            var gravity : GCAcceleration = GCAcceleration(x: 0, y: 0, z: 0)
            for data in arrayOfForces{
                acceleration = GCAcceleration(x: acceleration.x + data.acceleration.x,y: acceleration.y+data.acceleration.y, z: acceleration.z+data.acceleration.z)
              
                gravity = GCAcceleration(x: gravity.x + data.acceleration.x,y: gravity.y+data.acceleration.y, z: gravity.z+data.acceleration.z)
            }
            acceleration = GCAcceleration(x: acceleration.x/Double(arrayOfForces.count),y: acceleration.y/Double(arrayOfForces.count), z: acceleration.z/Double(arrayOfForces.count))
            
            gravity = GCAcceleration(x: gravity.x/Double(arrayOfForces.count),y: gravity.y/Double(arrayOfForces.count), z: gravity.z/Double(arrayOfForces.count))
            NSLog(#function)
            applyForceFromAcceleration(gravity, userAcceleration: acceleration)
        }
    }
    
    func clearDataFromGamePad (){
//        NSLog("\(savingData)")

        savingData = [:]
        currentDataFromGamepad = []
    }
}

struct dataFromGamePad {
    var acceleration: GCAcceleration
    var gravity: GCAcceleration
    var yAcceleration: Double
}
