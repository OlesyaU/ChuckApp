//
//  Model.swift
//  ChuckFirst
//
//  Created by Олеся on 05.01.2023.
//

import Foundation
//JSON {
//"categories": [],
//"created_at": "2020-01-05 13:42:23.484083",
//"icon_url": "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
//"id": "ENCeUlMOQtOrJZZ5vEw0Nw",
//"updated_at": "2020-01-05 13:42:23.484083",
//"url": "https://api.chucknorris.io/jokes/ENCeUlMOQtOrJZZ5vEw0Nw",
//"value": "Super Man's nacked eye can withstand a bullet. Chuck Norris' middle finger can reflect a laser beam and kill the shooter between the eyes."
//}

// создаем структуру данных с полями которые называем в точности так как ключ в Json-е. Если прописать в структуре все поля- то соответственно будет доступ ко всем значениям /Если значение по ключу может быть потенциально опциональным- надо его таким и указывать в структуре например  var value: String?, чтобы не крашнуться
// это структура для загрузки шутки
struct Joke: Decodable {
    var url: String
    var value: String
    
}

// а это для коллекции шуток
struct Answer: Decodable {
    var total: Int
    var result: [Joke]
}

class Model {
//    метод до JSONDecoder()
//    func downloadJoke(completion: ((_ textJoke: String?, _ errorText: String?)-> Void)?)
    func downloadJoke(completion: ((_ joke: Joke?, _ errorText: String?)-> Void)?) {
        //        создаём сессию с конфигурацией по дефолту
        let session = URLSession(configuration: .default)
        //        преобразуем строку в урлу
        guard let url = URL(string: "https://api.chucknorris.io/jokes/random") else {return}
        //        создаём таску, кастим респонс и берем у него статускод...все, что не 200 - не оч. 200 - всё ок
        let task = session.dataTask(with: url) { data, response, error in
            //         проверяем есть ли ошибка- через иф лет, через гард - выкинет ошибку и выйдет из метода
            if let error  {
                print(" Error is \(error.localizedDescription)")
                completion?(nil, "Error is \(error.localizedDescription)")
                return
            }
            //          кастим респонс и берём статус код
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if  statusCode != 200 {
                print("statusCode is \(String(describing: statusCode))")
                completion?(nil,"statusCode is \(String(describing: statusCode))" )
                return
            }
            
            //         всё проверяем на ошибки и выводим в случаях элс сообщения о том, что и где не так пошло
            //             тут нам нужна дата- или выводим мессадж о том что она нил
            
            guard let data else {
                print("data = nil")
                completion?(nil, "data = nil")
                return
            }
            //          ошибку в последнюю очередь лучше обрабатывать иначе на ней выйдет из метода- тапа еcли через гард ошибку проверять и не распарсить- выдает ошибку и выходит....дальше не идёт по методу...а можно вообще закомментить и не использовать...но можно и свои создать- всё зависит от хотелок. Если сначала делаем- то через иф лет - как тут...а потом собственно парсим дату))
            
            do {
// реализация через JSONDecoder().decode лучше исользовать протокол , но тут маленькое приложение поэтому без
//                первый вариант
                /*
               let joke = try JSONDecoder().decode(Joke.self, from: data)
                completion?(joke.value, nil)
                */
                
//                второй вариант
                let joke = try JSONDecoder().decode(Joke.self, from: data)
                
                completion?(joke, nil)
                
                /*
                реализация через JSONSerialization.jsonObject
                if let answer = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let textJoke = answer["value"]  as? String {
                        completion?(textJoke, nil)
                    }
                }
                 */
            }
            catch {
                completion?(nil, error.localizedDescription)
                print(error)
            }
        }
        //        ОБЯЗАТЕЛЬНО НЕ ЗАБЫВАЕМ РЕЗЬЮМИТЬ ТАСКУ! Вызываем в апп делегате, или в координаторах или где загружаем аппку или контроллер определённый
        task.resume()
    }

    func downloadJokesList(queryText: String,  completion: ((_ jokesArray: [String]?)-> Void)?) {
        
        guard let url = URL(string: "https://api.chucknorris.io/jokes/search?query=\(queryText)") else {
            print("проблема с урлом")
            return
        }
        
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { data, response, error in
            if let error {
                print(error.localizedDescription)
                completion?(nil)
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if statusCode != 200 {
                print("Status code isn't 200, statusCode \(String(describing: statusCode))")
                completion?(nil)
                return
            }
            
            guard let data  else {
                print("data - nil")
                completion?(nil)
                return
            }
            
            do {

                let answer = try JSONDecoder().decode(Answer.self, from: data)
                var answerArray: [String] = []
                for item in answer.result {
                    answerArray.append(item.value)
                }
                completion?(answerArray)
             
/*
                guard let answer = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print ("Error parcing json answer")
                    return
                }
                guard let result =  answer["result"] as? [[String: Any]] else { print ("Error parcing json result ")
                    return
                }
                
                var resultArray: [String] = []
                
                for item in result {
                    if let joketext = item["value"] as? String {
                        resultArray.append(joketext)
                    }
                }
                completion?(resultArray)
                */
            }
            catch {
                completion?(nil)
                print(error)
            }
        }
        
        //        не забываем резьюмить таску!
        task.resume()
    }
}
