//
//  AIObase.swift
//  ControleDeGastos
//
//  created by cAIO fAbIO valente on 2016-03-27
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//
import Foundation

public var usuarioLogado: Usuario?
public var listaUsuarios = [Usuario]()

public class AIO {
    internal var objectSeparator = "\n +++ \n"
    internal var attributeSeparator = " - \n"
    internal var arraySeparator = " && "
    
    // rodar assim que o app for iniciado
    func carregarBaseDeDados() {
        carregarUsuariosSemObjetos()
        carregarCartoes()
        carregarGastos()
    }
    
    // rodar antes de fechar o app ou antes de desloggar um usuario
    func salvarBaseDeDados() {
        for cartao in (usuarioLogado?.getCartoes())! {
            salvarCartao(cartao, usuario: usuarioLogado!)
        }
        for gasto in (usuarioLogado?.getGastos())! {
            salvarGasto(gasto, usuario: usuarioLogado!)
        }
    }

    // formato:     nome \n email \n senha \n categorias
    internal func carregarUsuariosSemObjetos () {
        let file = "usuarios.aio"
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(file)
            
            //reading
            do {
                let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                print (path)
                // transforma o texto lido em um array de strings separando-o pelas virgulas
                let entries = text.componentsSeparatedByString(objectSeparator)
                
                print ("Li do arquivo \(file) a string:\n\(text)")
                
                for entry in entries {
                    let attributes = entry.componentsSeparatedByString(attributeSeparator)
                    let novoUsuario = Usuario(nome: attributes[0], email: attributes[1], senha: attributes[2])
                    // adiciona as categorias ao novo usuario
                    let categorias = attributes[3].componentsSeparatedByString(arraySeparator)
                    for categ in categorias {
                        novoUsuario.addCategoriaGasto(categ)
                    }
                    // adiciona o novo usuario ao array de usuarios
                    listaUsuarios.append(novoUsuario)
                }
            } catch {
                print ("erro na leitura do arquivo \(file)")
            }
        }
    }
    
    // formato:     nome \n limite \n cor \n emailUsuario
    internal func carregarCartoes () {
        let file = "cartoes.aio"
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(file)
            
            //reading
            do {
                let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                print (path)
                // transforma o texto lido em um array de strings separando-o pelas virgulas
                let entries = text.componentsSeparatedByString(objectSeparator)
                
                print ("Li do arquivo \(file) a string:\n\(text)")
                
                for entry in entries {
                    let attributes = entry.componentsSeparatedByString(attributeSeparator)
                    let novoCartao = Cartao(nome: attributes[0], limite: Int(attributes[1])!, cor: Int(attributes[2])!)
                    let indUsuario = indiceUsuarioPorEmail(attributes[3])
                    
                    // adiciona o cartao ao seu respectivo usuario
                    listaUsuarios[indUsuario].addCartao(novoCartao)
                }
            } catch {
                print ("erro na leitura do arquivo \(file)")
            }
        }
    }
    
    // formato:     nome \n limite \n cor \n emailUsuario
    func salvarCartao (cartao: Cartao, usuario: Usuario) {
        let file = "cartoes.aio"
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(file)
            
            var textoAntesDoSave = ""
            
            //reading
            do {
                textoAntesDoSave = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
            } catch {
                print ("erro na leitura do arquivo \(file)")
            }
            
            //writing
            do {
                // copia todo o texto anterior
                var entries = textoAntesDoSave
                
                // adiciona a nova entrada
                var newEntrie = "\(cartao.nome)\(attributeSeparator)"
                newEntrie += "\(cartao.limite)\(attributeSeparator)"
                newEntrie += "\(cartao.cor)\(attributeSeparator)"
                newEntrie += "\(usuario.email)\(objectSeparator)"
                
                entries += newEntrie
                
                try entries.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
                print ("Adicionei ao arquivo \(file) a entrada:\n\(newEntrie)")
            } catch {
                print ("erro na escrita do arquivo \(file)")
            }
        }
    }
    
    
    // possiveis formatos:
    // "nome \n categoria \n valor \n data \n emailUsuario \n nomeCartao"
    // "nome \n categoria \n valor \n data \n emailUsuario"
    internal func carregarGastos () {
        let file = "gastos.aio"
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(file)
            
            //reading
            do {
                let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                print (path)
                // transforma o texto lido em um array de strings separando-o pelas virgulas
                let entries = text.componentsSeparatedByString(objectSeparator)
                
                print ("Li do arquivo \(file) a string:\n\(text)")
                
                for entry in entries {
                    let attributes = entry.componentsSeparatedByString(attributeSeparator)
                    let numParametros = attributes.count
                    let novoGasto = Gasto(nome: attributes[0], categoria: attributes[1], valor: Int(attributes[2])!, data: attributes[3])
                    
                    let indUsuario = indiceUsuarioPorEmail(attributes[4])
                    if (numParametros == 6) { // quando possui cartao, adiciona o cartao
                        let indCartao = listaUsuarios[indUsuario].getCartaoIndex(attributes[5])
                        if (indCartao != -1) {
                            novoGasto.cartao = listaUsuarios[indUsuario].cartoes[indCartao]
                        }
                    }
                    
                    // adiciona o gasto ao seu respectivo usuario
                    listaUsuarios[indUsuario].addGasto(novoGasto)
                }
                
            } catch {
                print ("erro na leitura do arquivo \(file)")
            }
        }
    }
    
    // possiveis formatos:
    // "nome \n categoria \n valor \n data \n emailUsuario \n nomeCartao"
    // "nome \n categoria \n valor \n data \n emailUsuario"
    func salvarGasto (gasto: Gasto, usuario: Usuario) {
        let file = "gastos.aio"
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(file)
            
            var textoAntesDoSave = ""
            
            //reading
            do {
                textoAntesDoSave = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
            } catch {
                print ("erro na leitura do arquivo \(file)")
            }
            
            //writing
            do {
                // copia todo o texto anterior
                var entries = textoAntesDoSave
                
                // adiciona a nova entrada
                var newEntrie = "\(gasto.nome)\(attributeSeparator)"
                newEntrie += "\(gasto.categoria)\(attributeSeparator)"
                newEntrie += "\(gasto.valor)\(attributeSeparator)"
                newEntrie += "\(gasto.data)\(attributeSeparator)"
                newEntrie += "\(usuario.email)"
                if !gasto.ehDinheiro { // se tiver cartao, escreve o cartao
                    newEntrie += "\(attributeSeparator)\(gasto.cartao?.nome)"
                }
                newEntrie += "\(objectSeparator)"
                
                entries += newEntrie
                
                try entries.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
                print ("Adicionei ao arquivo \(file) a entrada:\n\(newEntrie)")
            } catch {
                print ("erro na escrita do arquivo \(file)")
            }
        }
    }
    
    func adicionarUsuario (usuario: Usuario) {
        let file = "usuarios.aio"
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(file)
            
            var textoAntesDoSave = ""
            
            //reading
            do {
                textoAntesDoSave = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
            } catch {
                print ("erro na leitura do arquivo \(file)")
            }
            
            //writing
            do {
                // copia todo o texto anterior
                var entries = textoAntesDoSave
                
                // adiciona a nova entrada
                var newEntrie = "\(usuario.nome)\(attributeSeparator)"
                newEntrie += "\(usuario.email)\(attributeSeparator)"
                newEntrie += "\(usuario.senha)\(attributeSeparator)"
                let categorias = usuario.getCategoriasGastos()
                let nCateg = categorias.count
                if (nCateg > 0) {
                    for i in 0..<(nCateg-1) {
                        newEntrie += "\(categorias[i])\(arraySeparator)"
                    }
                    newEntrie += "\(categorias[nCateg-1])\(attributeSeparator)"
                }
                newEntrie += "\(usuario.email)\(objectSeparator)"
                
                entries += newEntrie
                
                try entries.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
                print ("Adicionei ao arquivo \(file) a entrada:\n\(newEntrie)")
            } catch {
                print ("erro na escrita do arquivo \(file)")
            }
        }
    }
    
    internal func carregarEmailUltimoUsuario () -> String {
        let file = "ultimo-usuario.aio"
        
        var email = ""

        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(file)
            
            //reading
            do {
                let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                print ("Li do arquivo \(file) a string:\n\(text)")
                email = String(text)
            } catch {
                print ("erro na leitura do arquivo \(file)")
            }
        }
        return email
    }

    func salvarEmailUltimoUsuario (usuario: Usuario) -> Bool {
        let file = "ultimo-usuarios.aio"
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(file)

            //writing
            do {
                try usuario.email.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
                print ("Escrevi no arquivo \(file) a entrada:\n\(usuario.email)")
            } catch {
                print ("erro na escrita do arquivo \(file)")
                return false
            }
        }
        return true
    }
    

    // encontra o usuario pelo email
    func indiceUsuarioPorEmail (email: String) -> Int {
        var indice = -1
        for (var i=0; i<listaUsuarios.count; i += 1) {
            if listaUsuarios[i].email == email {
                indice = i
                break
            }
        }
        return indice
    }
}