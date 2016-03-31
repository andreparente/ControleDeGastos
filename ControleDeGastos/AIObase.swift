//
//  AIObase.swift
//  ControleDeGastos
//
//  created by cAIO fAbIO valente on 2016-03-27
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//
import Foundation

public var base = AIO()
public var hasLaunchedOnce = Bool()

public class AIO {
    // separadores de texto da base
    internal let objectSeparator = "\n +++ \n"
    internal let attributeSeparator = " - \n"
    internal let arraySeparator = " && "
    
    // se der erro, tem que criar essas pastas na mao
    internal let dir = "/Users/Shared/app/app-gastos"
    
    // formato padrao dos nomes dos arquivos da base
    internal let file_usuarios = "usuarios"
    internal let file_ultimoUsuario = "ultimoUsuario"
    internal let file_gastos = "gastos"
    internal let file_cartoes = "cartoes"
    internal let file_format = "aio"
    
    // variaveis utilizaveis externamente
    var usuarioLogado: Usuario?
    var listaUsuarios = [Usuario]()
    
    // rodar assim que o app for iniciado
    func carregarBaseDeDados() { // a ordem do load nao pode ser alterada
        carregarUsuariosSemObjetos()
        hasLaunchedOnce = base.carregarUltimoUsuario()
        if (hasLaunchedOnce) {
            login(self.usuarioLogado!)
        }
    }
    
    // rodar antes de fechar o app ou antes de desloggar um usuario
    func salvarBaseDeDados() {
        for cartao in (usuarioLogado!.getCartoes()) {
            salvarCartao(cartao, usuario: usuarioLogado!)
        }
        for gasto in (usuarioLogado?.getGastos())!{
            salvarGasto(gasto, usuario: usuarioLogado!)
        }
        for usuario in self.listaUsuarios {
            print("salvando usuario ", usuario.email)
            salvarUsuario(usuario)
        }
        salvarUltimoUsuario(self.usuarioLogado!)
    }
    
    func login (usuario: Usuario) {
        usuarioLogado = usuario
        carregarCartoes(self.usuarioLogado!)
        carregarGastos(self.usuarioLogado!)
    }
    
    func logout () {
        for cartao in (usuarioLogado!.getCartoes()) {
            salvarCartao(cartao, usuario: usuarioLogado!)
        }
        for gasto in (usuarioLogado?.getGastos())!{
            salvarGasto(gasto, usuario: usuarioLogado!)
        }
        usuarioLogado = nil
    }
    
    func salvarCartao (cartao: Cartao, usuario: Usuario) {
        adicionarCartao(cartao, usuario: usuario)
    }
    
    func salvarGasto (gasto: Gasto, usuario: Usuario) {
        adicionarGasto(gasto, usuario: usuario)
    }
    
    func salvarUsuario (usuario: Usuario) {
        self.adicionarUsuario(usuario)
    }
    
    // formato:     nome \n email \n senha \n categorias
    internal func carregarUsuariosSemObjetos () {
        let file = file_usuarios
        let path = dir + "/" + file + "." + file_format
        
        //reading
        do {
            let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            //print (path)
            // transforma o texto lido em um array de strings separando-o pelas virgulas
            let entries = text.componentsSeparatedByString(objectSeparator)
            
            //print ("Li do arquivo \(file) a string:\n\(text)")
            
            for var i in 0..<entries.count-1 {
                let attributes = entries[i].componentsSeparatedByString(attributeSeparator)
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
            print ("erro na leitura do arquivo \(path)")
        }
        
    }
    
    // formato:     nome \n limite \n cor
    internal func carregarCartoes (usuario: Usuario) {
        let file = file_cartoes
        //let path = self.dir.stringByAppendingPathComponent(file)
        let path = dir + "/" + file + "-" + usuario.email + "." + file_format
        
        //reading
        do {
            let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            //print (path)
            // transforma o texto lido em um array de strings separando-o pelas virgulas
            let entries = text.componentsSeparatedByString(objectSeparator)
            
            //print ("Li do arquivo \(file) a string:\n\(text)")
            
            for var i in 0..<entries.count-1 {
                let attributes = entries[i].componentsSeparatedByString(attributeSeparator)
                let novoCartao = Cartao(nome: attributes[0], limite: Int(attributes[1])!, cor: Int(attributes[2])!)
                let indUsuario = indiceUsuarioPorEmail(usuario.email)
                
                // adiciona o cartao ao seu respectivo usuario
                listaUsuarios[indUsuario].addCartao(novoCartao)
            }
        } catch {
            print ("erro na leitura do arquivo \(path)")
        }
    }
    
    // formato:     nome \n limite \n cor
    internal func adicionarCartao (cartao: Cartao, usuario: Usuario) {
        let file = file_cartoes
        let path = dir + "/" + file + "-" + usuario.email + "." + file_format
        
        var textoAntesDoSave = ""
        
        //reading
        do {
            textoAntesDoSave = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
        } catch {
            print ("erro na leitura do arquivo \(path)")
        }
        
        //writing
        do {
            // copia todo o texto anterior
            var entries = textoAntesDoSave
            
            // adiciona a nova entrada
            var newEntrie = "\(cartao.nome)\(attributeSeparator)"
            newEntrie += "\(cartao.limite)\(attributeSeparator)"
            newEntrie += "\(cartao.cor)\(objectSeparator)"
            
            entries += newEntrie
            
            try entries.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
            print ("Adicionei ao arquivo \(file) a entrada:\n\(newEntrie)")
        } catch {
            print ("erro na escrita do arquivo \(file)")
        }
    }
    
    
    // possiveis formatos:
    // "nome \n categoria \n valor \n data \n nomeCartao"
    // "nome \n categoria \n valor \n data "
    internal func carregarGastos (usuario: Usuario) {
        let file = file_gastos
        let path = dir + "/" + file + "-" + usuario.email + "." + file_format
        
        //reading
        do {
            let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            // print (path)
            // transforma o texto lido em um array de strings separando-o pelas virgulas
            let entries = text.componentsSeparatedByString(objectSeparator)
            
            //print ("Li do arquivo \(file) a string:\n\(text)")
            
            for var i in 0..<entries.count-1 {
                let attributes = entries[i].componentsSeparatedByString(attributeSeparator)
                let numParametros = attributes.count
                let novoGasto = Gasto(nome: attributes[0], categoria: attributes[1], valor: Int(attributes[2])!, data: attributes[3])
                
                let indUsuario = indiceUsuarioPorEmail(usuario.email)
                if (numParametros == 5) { // quando possui cartao, adiciona o cartao
                    let indCartao = listaUsuarios[indUsuario].getCartaoIndex(attributes[4])
                    if (indCartao != -1) {
                        novoGasto.cartao = listaUsuarios[indUsuario].cartoes[indCartao]
                    }
                }
                
                // adiciona o gasto ao seu respectivo usuario
                listaUsuarios[indUsuario].addGasto(novoGasto)
            }
            
        } catch {
            print ("erro na leitura do arquivo \(path)")
        }
    }
    
    // possiveis formatos:
    // "nome \n categoria \n valor \n data \n nomeCartao"
    // "nome \n categoria \n valor \n data "
    internal func adicionarGasto (gasto: Gasto, usuario: Usuario) {
        let file = file_gastos
        let path = dir + "/" + file + "-" + usuario.email + "." + file_format
        
        var textoAntesDoSave = ""
        
        //reading
        do {
            textoAntesDoSave = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
        } catch {
            print ("erro na leitura do arquivo \(path)")
        }
        
        //writing
        do {
            // copia todo o texto anterior
            var entries = textoAntesDoSave
            
            // adiciona a nova entrada
            var newEntrie = "\(gasto.nome)\(attributeSeparator)"
            newEntrie += "\(gasto.categoria)\(attributeSeparator)"
            newEntrie += "\(gasto.valor)\(attributeSeparator)"
            newEntrie += "\(gasto.data)"
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
    
    internal func adicionarUsuario (usuario: Usuario) {
        let file = file_usuarios
        let path = dir + "/" + file + "." + file_format
        
        var textoAntesDoSave = ""
        
        //reading
        do {
            textoAntesDoSave = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
        } catch {
            print ("erro na leitura do arquivo \(path)")
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
    
    internal func carregarEmailUltimoUsuario () -> String {
        let file = file_ultimoUsuario
        let path = dir + "/" + file + "." + file_format
        
        var email = ""
        
        //reading
        do {
            let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            //print ("Li do arquivo \(file) a string:\n\(text)")
            email = String(text)
        } catch {
            print ("erro na leitura do arquivo \(path)")
            //print ("error \(error)")
        }
        
        return email
    }
    
    func salvarUltimoUsuario (usuario: Usuario) -> Bool {
        let file = file_ultimoUsuario
        let path = dir + "/" + file + "." + file_format
        
        //writing
        let text = usuario.email
        do {
            try text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
            print ("Escrevi no arquivo \(file) a entrada:\n\(text)")
        } catch {
            print ("erro na escrita do arquivo \(file)")
            return false
        }
        
        return true
    }
    
    func carregarUltimoUsuario () -> Bool {
        let email = self.carregarEmailUltimoUsuario()
        let i = self.indiceUsuarioPorEmail(email)
        let ok = (i != -1)
        if (ok) {
            self.usuarioLogado = self.listaUsuarios[i]
        }
        return ok
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