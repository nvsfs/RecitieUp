//
//  DetalheEventosViewController.swift
//  Recitie
//
//  Created by Natalia Souza on 10/14/15.
//  Copyright © 2015 Natalia. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Social
import EventKit


class DetalheEventosViewController: UIViewController {
    
    var foto : PFFile!
    var dataEvent : String!
    
    var savedEventId : String = ""
    
    // Container to store the view table selected object
    var currentObject : PFObject?
    
    @IBOutlet weak var hora: UILabel!
    // Some text fields
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var place: UILabel!
    
    @IBOutlet weak var nameEnglish: UILabel!
    @IBOutlet weak var contato: UILabel!
    @IBOutlet weak var nameLocal: UITextView!
    @IBOutlet weak var capital: UITextField!
    @IBOutlet weak var currencyCode: UITextField!
    @IBOutlet var numeroEvento: UILabel!
    @IBOutlet weak var foto_evento: PFImageView!
    
    
    //INÍCIO BOTAO CONFIRMAR/DESCONFIRMAR
    @IBOutlet var botaoConfirmaPresenca: UIButton!
    
    @IBOutlet weak var buttonCalendar: UIButton!
    @IBOutlet var confirmadosCount: UILabel!
    var presenteNoEvento = false
    var objectIdParseEventoSelecionado: String = ""
    var qtdParcticipantes: NSNumber = 0
    //FINAL BOTAO CONFIRMAR/DESCONFIRMAR
    
    override func viewWillAppear(animated: Bool) {
        if let objetoAtual = currentObject {
            
            let initialThumbnail = UIImage(named: "placeholder.png")
            foto_evento.image = initialThumbnail
            
            // Replace question image if an image exists on the parse platform
            if let thumbnail = objetoAtual["imagem"] as? PFFile {
                foto_evento.file = thumbnail
                foto_evento.loadInBackground()
            }
            foto_evento = objetoAtual["imagem"] as? PFImageView
            nameEnglish.text = (objetoAtual["name"] as! String)
            nameLocal.text = (objetoAtual["description"] as! String)
            userLabel.text = (objetoAtual["user"]["first_name"] as! String)
            data.text = (objetoAtual["data"] as! String)
            place.text = (objetoAtual["place"]["name"] as! String)
            
            contato.text = (objetoAtual["contato"] as! String)

            
            hora.text = (objetoAtual["hora"] as! String)

             dataEvent = (objetoAtual["NSDate"] as! String)
            //qtdParcticipantes = (objetoAtual["qtdParticipantes"] as! NSNumber)
            //print(qtdParcticipantes)
            //confirmadosCount.text = String(qtdParcticipantes)
            objectIdParseEventoSelecionado = objetoAtual.objectId! as String
            //print("EVENTO SELECIONADO: \(objectIdParseEventoSelecionado)")
            //presenteNoEvento = object
            //print (objetoAtual)
            let user = PFUser.currentUser()
            let relation = user?.relationForKey("Events")
            relation?.query()?.whereKey("objectId", equalTo: objetoAtual.objectId!)
            relation?.query()?.findObjectsInBackgroundWithBlock{
                (objects: [PFObject]?, error: NSError?) -> Void in
                self.botaoConfirmaPresenca.setTitle("Eu vou.", forState:UIControlState.Normal)
                if error == nil {
                    if (objects != nil){
                        if let confirmados = objects?.count{
                            self.confirmadosCount.text = String(confirmados)
                        }
                        else{
                            self.confirmadosCount.text = String(0)
                        }
                    }
                    else {
                        self.confirmadosCount.text = String(0)
                    }
                    for object in objects!{
                        //print("EVENTO ENCONTRADO: \(object.objectId)")
                        if object.objectId == objetoAtual.objectId{
                            self.presenteNoEvento = true
                            //self.verificaPresencaNoEvento()
                            self.botaoConfirmaPresenca.setTitle("Não vou.", forState:UIControlState.Normal)
                            print("Presencaaaa!!! - true")
                        }
                        else{
                            self.presenteNoEvento = false
                            //self.verificaPresencaNoEvento()
                            self.botaoConfirmaPresenca.setTitle("Eu vou.", forState:UIControlState.Normal)
                            print("Presencaaaa!!! - false")
                        }
                    }
                }
                else{
                    print("Erro na verificação da presença no evento!")
                }
            }
        }
    }
    
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = nameEnglish.text!
        print(event.title)
        print(dataEvent)
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "dd-MM-yy hh:mm aa"
        dateformatter.timeZone = NSTimeZone(name: "BRST")
        
        
        
        event.startDate = dateformatter.dateFromString(dataEvent!)!
        print(event.startDate)
       event.endDate = dateformatter.dateFromString(dataEvent)!
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
            savedEventId = event.eventIdentifier
        } catch {
            print("Bad things happened")
        }
    }
    
    
    @IBAction func buttonCalendar(sender: AnyObject) {
        
        let eventStore = EKEventStore()
        
        let startDate = NSDate()
        let endDate = startDate.dateByAddingTimeInterval(60 * 60) // One hour
        
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                granted, error in
                self.createEvent(eventStore, title: "DJ's Test Event", startDate: startDate, endDate: endDate)
            })
        } else {
            createEvent(eventStore, title: "DJ's Test Event", startDate: startDate, endDate: endDate)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialThumbnail = UIImage(named: "placeholder.png")

        
        self.botaoConfirmaPresenca.layer.cornerRadius = botaoConfirmaPresenca.frame.size.width / 40
        self.botaoConfirmaPresenca.layer.masksToBounds = true
        
        self.buttonCalendar.layer.cornerRadius = buttonCalendar.frame.size.width / 40
        self.buttonCalendar.layer.masksToBounds = true
    }
    
    var numero:String?
    var eventoteste:Event?
    
    
    
    // The save button
    @IBAction func saveButton(sender: AnyObject) {
        
        // Unwrap the current object object
        if let object = currentObject {
            
            object["name"] = nameEnglish.text
            object["description"] = nameLocal.text
            //object["capital"] = capital.text
            //object["currencyCode"] = currencyCode.text
            
            // Save the data back to the server in a background task
            object.saveEventually(nil)
            
        }
        
        // Return to table view
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // INÍCIO DO CÓDIGO DO BOTÃO DE CONFIRMAR/DESCONFIRMAR
    
    
    //    func verificaPresencaNoEvento(){
    //        if (presenteNoEvento == true) {
    //            botaoConfirmaPresenca.setTitle("Não vou.", forState:UIControlState.Normal)
    //            print("Presencaaaa!!! - \(presenteNoEvento)")
    //        } else {
    //            botaoConfirmaPresenca.setTitle("Eu vou.", forState:UIControlState.Normal)
    //            print("Presencaaaa!!! - \(presenteNoEvento)")
    //        }
    //
    //    }
    @IBAction func confirmarDesconfirmar(sender: UIButton) {
        if (presenteNoEvento == true) {
            sender.setTitle("Não vou.", forState: UIControlState.Normal)
            desconfirmarPresencaParse()
            sender.setTitle("Eu vou.", forState: UIControlState.Normal)
        } else {
            sender.setTitle("Eu vou.", forState:UIControlState.Normal)
            confirmarPresencaParse()
            sender.setTitle("Não vou", forState:UIControlState.Normal)
        }
    }
    
    func confirmarPresencaParse(){
        let eventoPQuery = PFQuery(className: "Event")
        var eventoParticipar = PFObject(className: "Event")
        do {
            eventoParticipar = try eventoPQuery.getObjectWithId(objectIdParseEventoSelecionado)
            //print("EVENTO PARTICIPAR: \(eventoParticipar)")
            let user = PFUser.currentUser()
            let relation = user!.relationForKey("Events")
            relation.addObject(eventoParticipar)
            user!.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    print("The post has been added to the user's likes relation.")
                    self.presenteNoEvento = true;
                } else {
                    print("There was a problem, check error.description")
                    self.presenteNoEvento = false;
                }
            }
        }
        catch{print("Deu erro no try da query ConfirmarPresença")}
        //print("EVENTO QUE QUERO PARTICIPAR FORA: \(eventoParticipar)")
        contadorPessoaMais()
    }
    
    func desconfirmarPresencaParse(){
        let eventoPQuery = PFQuery(className: "Event")
        var eventoParticipar = PFObject(className: "Event")
        do {
            eventoParticipar = try eventoPQuery.getObjectWithId(objectIdParseEventoSelecionado)
            //print("EVENTO PARTICIPAR: \(eventoParticipar)")
            let user = PFUser.currentUser()
            let relation = user!.relationForKey("Events")
            relation.removeObject(eventoParticipar)
            user!.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    print("The post has been removed to the user's likes relation.")
                    self.presenteNoEvento = false;
                } else {
                    print("There was a problem, check error.description")
                    self.presenteNoEvento = true;
                }
            }
        }
        catch{print("Deu erro no try da query DesconfirmarPresença")}
        //print("EVENTO QUE QUERO PARTICIPAR: \(eventoParticipar)")
        contadorPessoaMenos()
    }
    
    func contadorPessoaMais(){
        //Atualizando número de avaliações
        if var nPessoas = Int(self.confirmadosCount.text!){
            nPessoas = nPessoas + 1
            confirmadosCount.text = String(nPessoas)
        }else{
            confirmadosCount.text = String(0)
        }
    }
    
    func contadorPessoaMenos(){
        //Atualizando número de avaliações
        if var nPessoas = Int(self.confirmadosCount.text!){
            nPessoas = nPessoas - 1
            confirmadosCount.text = String(nPessoas)
        }else{
            confirmadosCount.text = String(0)
        }
    }
    // FINAL DO CÓDIGO DO BOTÃO DE CONFIRMAR/DESCONFIRMAR
    
    @IBAction func back(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func share(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Evou para o \(nameEnglish.text!) venha voce tambem! www.google.com")
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
