//
//  AIObase.swift
//  ControleDeGastos
//
//  created by cAIO fAbIO valente on 2016-03-27
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//
/*import Foundation

public var base = AIO()
public var hasLaunchedOnce = Bool()

public class AIO {
    // separadores de texto da base
    internal let objectSeparator = "\n +++ \n"
    internal let attributeSeparator = " - \n"
    internal let arraySeparator = " && "
    
    // se der erro, tem que criar essas pastas na mao
    //internal let dir = "/Users/Shared/app/app-gastos"
    internal let dir = String(NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
    
    // formato padrao dos nomes dos arquivos da base
    internal let file_usuarios = "usuarios"
    internal let file_ultimoUsuario = "ultimoUsuario"
    internal let file_gastos = "gastos"
    internal let file_cartoes = "cartoes"
    internal let file_format = "aio"
    
    // variaveis utilizaveis externamente
    var usuarioLogado: Usuario?
    var ramUsuarios = [Usuario]()
    var ramGastosQtd = 0    // numero de gastos que ainda nao foi salvo na base
    var ramCartoesQtd = 0   // numero de cartoes que ainda nao foi salvo na base
    
    // rodar assim que o app for iniciado
    func carregarBaseDeDados() { // a ordem do load nao pode ser alterada
        carregarUsuariosSemObjetos()
        hasLaunchedOnce = base.carregarUltimoUsuario()
        if (hasLaunchedOnce) {
            login(self.usuarioLogado!)
        }
        print (dir)
    }
    
    // rodar antes de fechar o app
    func salvarBaseDeDados() {
        base.logout()
        for usuario in self.ramUsuarios {
            print("salvando usuario ", usuario.email)
            adicionarUsuario(usuario)
        }
    }
    
    func login (usuario: Usuario) {
        usuarioLogado = usuario
        // se os cartoes ainda nao foram carregados, carrega
        if (self.usuarioLogado!.getCartoes().count <= 0) {
            carregarCartoes(self.usuarioLogado!)
        }
        // se os gastos ainda nao foram carregados, carrega
        if (self.usuarioLogado!.getGastos().count <= 0) {
            carregarGastos(self.usuarioLogado!)
        }
    }
    
    func logout () {
        var i = 0
        var limInferior = 0
        var limSuperior = 0
        
        // em teoria esses dois FORs abaixo nunca vao rodar
        // pq os gastos e cartoes estao sendo salvos diretamente no disco
        
        // salva os cartoes que ainda nao foram salvos
        limSuperior = usuarioLogado!.getCartoes().count
        limInferior = limSuperior - ramCartoesQtd - 1
        limInferior = (limInferior > 0) ? limInferior : limSuperior
        for (i=limInferior; i < limSuperior; i += 1) {
            print("inferior: \(limInferior), superior: \(limSuperior)")
            adicionarCartao(usuarioLogado!.getCartoes()[i], usuario: usuarioLogado!)
        }
        
        // salva os gastos que ainda nao foram salvos
        limSuperior = usuarioLogado!.getGastos().count
        limInferior = limSuperior - ramGastosQtd - 1
        limInferior = (limInferior > 0) ? limInferior : limSuperior
        for (i=limInferior; i < limSuperior; i += 1) {
            adicionarGasto(usuarioLogado!.getGastos()[i], usuario: usuarioLogado!)
        }
        
        // salva ultimo usuario
        salvarUltimoUsuario(usuarioLogado!)
        
        // zera variaveis globais
        ramCartoesQtd = 0
        ramGastosQtd = 0
        usuarioLogado = nil
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
                let novoUsuario = stringToUsuario(entries[i])
                // adiciona o novo usuario ao array de usuarios
                ramUsuarios.append(novoUsuario)
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
                ramUsuarios[indUsuario].addCartao(novoCartao)
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
            var newEntrie = cartaoToString(cartao)
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
                let novoGasto = stringToGasto(entries[i], usuario: usuario)
                // adiciona o gasto ao seu respectivo usuario
                let indUsuario = indiceUsuarioPorEmail(usuario.email)
                ramUsuarios[indUsuario].addGasto(novoGasto)
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
        let path = dir + "/" + file + "-" + usuario.email + "." + file_format /* ./gastos-caio@hotmail.com.aio */
        
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
            let newEntrie = gastoToString(gasto)
            entries += newEntrie
            
            try entries.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
            print ("Adicionei ao arquivo \(file) a entrada:\n\(newEntrie)")
        } catch {
            print ("erro na escrita do arquivo \(file)")
        }
    }
    
    func editarGasto (gastoEditado: Gasto, usuario: Usuario) {
        let file = file_gastos
        let path = dir + "/" + file + "-" + usuario.email + "." + file_format
        
        //reading and writing
        do {
            let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            let entries = text.componentsSeparatedByString(objectSeparator)
            var result = ""
            //print ("Li do arquivo \(file) a string:\n\(text)")
            
            for var i in 0..<entries.count-1 {
                var gasto = stringToGasto(entries[i], usuario: usuario)
                
                // se for o objeto desejado, edita
                if (gastoEditado.nome == gasto.nome && gastoEditado.data == gasto.data) {
                    // substitui o objeto pelo editado
                    gasto = gastoEditado
                    // edita na RAM
                    usuarioLogado!.gastos[i] = gasto
                }
                // substitui o objeto pelo editado
                result += gastoToString(gasto)
            }
            try result.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
        } catch {
            print ("erro na leitura do arquivo \(path)")
        }
    }
    
    // gera uma string que eh a descricao do usuario na base
    internal func usuarioToString (usuario: Usuario) -> String {
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
        return newEntrie
    }
    
    // gera uma string que eh a descricao do gasto na base
    // possiveis formatos:
    // "nome \n categoria \n valor \n data \n nomeCartao"
    // "nome \n categoria \n valor \n data "
    internal func gastoToString (gasto: Gasto) -> String {
        var newEntrie = "\(gasto.nome)\(attributeSeparator)"
        newEntrie += "\(gasto.categoria)\(attributeSeparator)"
        newEntrie += "\(gasto.valor)\(attributeSeparator)"
        newEntrie += "\(gasto.data)"
        if !gasto.ehDinheiro { // se tiver cartao, escreve o cartao
            newEntrie += "\(attributeSeparator)\(gasto.cartao!.nome)"
        }
        newEntrie += "\(objectSeparator)"
        return newEntrie
    }

    // gera uma string que eh a descricao do cartao na base
    internal func cartaoToString (cartao: Cartao) -> String {
        var newEntrie = "\(cartao.nome)\(attributeSeparator)"
        newEntrie += "\(cartao.limite)\(attributeSeparator)"
        newEntrie += "\(cartao.cor)\(objectSeparator)"
        return newEntrie
    }
    
    // pega um gasto e gera uma string pra guardar na base
    internal func stringToGasto(str: String, usuario: Usuario) -> Gasto {
        let attributes = str.componentsSeparatedByString(attributeSeparator)
        let numParametros = attributes.count
        let novoGasto = Gasto(nome: attributes[0], categoria: attributes[1], valor: attributes[2].toDouble()!, data: attributes[3])
        
        let indUsuario = indiceUsuarioPorEmail(usuario.email)
        if (numParametros == 5) { // quando possui cartao, adiciona o cartao
            let indCartao = ramUsuarios[indUsuario].getCartaoIndex(attributes[4])
            if (indCartao != -1) {
                novoGasto.cartao = ramUsuarios[indUsuario].cartoes[indCartao]
            }
        }
        return novoGasto
    }
    
    // pega um usuario e gera uma string pra guardar na base
    internal func stringToUsuario(str: String) -> Usuario {
        let attributes = str.componentsSeparatedByString(attributeSeparator)
        let novoUsuario = Usuario(nome: attributes[0], email: attributes[1], senha: attributes[2])
        // adiciona as categorias ao novo usuario
        let categorias = attributes[3].componentsSeparatedByString(arraySeparator)
        for (var i = 0; i < categorias.count; i += 1) {
            novoUsuario.addCategoriaGasto(categorias[i])
        }
        return novoUsuario
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
            let newEntrie = usuarioToString(usuario)
            entries += newEntrie
            
            try entries.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
            print ("Adicionei ao arquivo \(file) a entrada:\n\(newEntrie)")
        } catch {
            print ("erro na escrita do arquivo \(file)")
        }
        
    }
    
    internal func editarUsuario (usuarioEditado: Usuario) {
        let file = file_usuarios
        let path = dir + "/" + file + "." + file_format /* ./usuarios.aio */
        
        //reading and writing
        do {
            let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            let entries = text.componentsSeparatedByString(objectSeparator)
            var result = ""
            //print ("Li do arquivo \(file) a string:\n\(text)")
            
            for var i in 0..<entries.count-1 {
                var usuario = stringToUsuario(entries[i])
                
                // se for o objeto desejado, edita
                if (usuarioEditado.email == usuario.email) {
                    // substitui o objeto pelo editado
                    usuario = usuarioEditado
                    // edita na RAM
                    ramUsuarios[i] = usuario
                }
                // salva no disco
                result += usuarioToString(usuario)
            }
            try result.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
        } catch {
            print ("erro na leitura do arquivo \(path)")
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
            self.usuarioLogado = self.ramUsuarios[i]
        }
        return ok
    }
    
    // encontra o usuario pelo email
    func indiceUsuarioPorEmail (email: String) -> Int {
        var indice = -1
        for (var i=0; i<ramUsuarios.count; i += 1) {
            if ramUsuarios[i].email == email {
                indice = i
                break
            }
        }
        return indice
    }
}*/