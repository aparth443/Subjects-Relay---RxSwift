//
//  ViewController.swift
//  Subjects & Relays
//
//  Created by cumulations on 09/06/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

/*
 Observable (sequence) emits events(notification of change) asynchronously
 Observer - subscribes to Observable in order to receive events
 
 Subject = Observable + Observer
    - PublishSubject - only emits new elements to subscribers
    - BehaviorSubject - emits the last element to new subscribers
    - ReplaySubject - emits a buffer size of elements to new subscribers
    - AsyncSubject - emits only the last next event in the sequence and only if the subject receives a completed event
 
 Relays = Wrappers around the subjects that never complete
    - Publish Relay
    - Behavior Relay
 */

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Publish Subject:
        
        let publishSub = PublishSubject<String>()
        publishSub.onNext("pubSub El 1") //not printed
        let ob1 = publishSub.subscribe(onNext: {
            elem in
            print(elem)
        })
        publishSub.onNext("pubSub El 2") //printed
        
        //Behavior Subject:
        let bSub = BehaviorSubject<String>(value: "bSub El 1") //not printed
        bSub.onNext("bSub El 2") //not printed
        bSub.onNext("bSub El 3") //printed (last recent)
        
        let ob2 = bSub.subscribe(onNext: {
            elem in
            print(elem)
        })
        bSub.onNext("bSub El 4") //printed
        
        //Replay Subject:
        
        let repSub = ReplaySubject<Int>.create(bufferSize: 2)
        repSub.onNext(1) //not printed
        repSub.onNext(2) //not printed
        repSub.onNext(3) //printed
        repSub.onNext(4) //printed
        let ob3 = repSub.subscribe(onNext: {
            elem in
            print(elem)
        })
        repSub.onNext(5) //printed
        repSub.onNext(6) //printed
        repSub.onNext(7) //printed
        
        //Async Subject:
        
        let asyncSub = AsyncSubject<String>()
        asyncSub.onNext("asyncSub El 1") //not printed
        asyncSub.onNext("asyncSub El 2") //not printed
        let ob4 = asyncSub.subscribe { ele in
            print(ele)
        }
        asyncSub.onNext("asyncSub El 3") //next printed because it is last event emitted and completed is there.
        asyncSub.onCompleted()
        
        //Relays: Subjects that never terminates or completes and emits only next.
        
        //Publish Relay:
        
        let publishRelay = PublishRelay<String>()
        publishRelay.accept("Hello") //this will not be printed as same as publish subject.
        let ob5 = publishRelay.subscribe { ele in
            print(ele)
        }
        publishRelay.accept("World") //next(World) printed
        
        //Behavior Subject:
        
        let bRelay = BehaviorRelay<Int>(value: 10) //not printed same as behavior subject
        bRelay.accept(20) //next(20) printed.
        let ob6 = bRelay.subscribe { ele in
            print(ele)
        }
        
        
    }


}

