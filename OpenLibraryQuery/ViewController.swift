//
//  ViewController.swift
//  OpenLibraryQuery
//
//  Created by Joaquín Cerdá Boluda on 17/11/15.
//  Copyright © 2015 Ximo Cerdà. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let baseUrls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN"
    var urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:978-84-376-0494-7"
    var url = NSURL(string: "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:978-84-376-0494-7")!
    var textoTemporal = ""
    var transferenciaTerminada = false
    var errorDeRed = false

    @IBOutlet weak var salidaTexto: UITextView!
    @IBOutlet weak var entradaISBN: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        entradaISBN.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TextFieldDoneEditing (sender: UITextField) {
        sender.resignFirstResponder()
        urls = baseUrls + entradaISBN.text!
        url = NSURL(string: urls)!
        asincrono()
    }
    
    @IBAction func backgroundTap (sender: UIControl) {
        entradaISBN.resignFirstResponder()
        urls = baseUrls + entradaISBN.text!
        url = NSURL(string: urls)!
        asincrono()
    }

    // NO LA USO
    /*
    func sincrono() {
        let datos: NSData? = NSData(contentsOfURL: url)
        let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
        salidaTexto.text = texto! as String
    }
    */
    
    func asincrono() {
        transferenciaTerminada = false
        errorDeRed = false
        let sesion = NSURLSession.sharedSession()
        let bloque = { (datos: NSData?, resp: NSURLResponse?, error: NSError?) -> Void in
            if error != nil {
                self.errorDeRed = true
            } else {
                let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                self.textoTemporal = texto! as String
            }
            self.transferenciaTerminada = true
        }
        let dt = sesion.dataTaskWithURL(url, completionHandler: bloque)
        dt.resume()
        salidaTexto.text = "Buscando la información solicitada..."
        esperaResultado()
    }
    
    func esperaResultado() {
        while (!transferenciaTerminada) {
            // Espera el resultado
            // Aquí podría hacer otras cosas
        }
        if (errorDeRed) {
            salidaTexto.text = "Ha ocurrido un error de red. Por favor, vuelve a intentarlo."
        } else {
            salidaTexto.text = textoTemporal
        }
    }


}


/*

CÓDIGO PARA INTRODUCIR EN INFO.PLIST

<key>NSAppTransportSecurity</key>
<dict>
    <!--Permite todas las conexiones (cuidado) -->
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>

ó

<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>dia.ccm.itesm.mx</key>
        <dict>
            <!--Incluir todos los subdominios-->
            <key>NSIncludesSubdomains</key>
            <true/>
            <!--Para que se pueda realizar peticiones HTTP-->
            <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
    </dict>
</dict>

*/
