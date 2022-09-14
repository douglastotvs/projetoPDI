<<<<<<< HEAD
#Include "PROTHEUS.ch"
#Include "RESTFUL.ch"

#xtranslate @{Header <(cName)>} => ::GetHeader( <(cName)> )
#xtranslate @{Param <n>} => ::aURLParms\[ <n> \]
#xtranslate @{EndRoute} => EndCase
#xtranslate @{Route} => Do Case
#xtranslate @{When <path>} => Case NGIsRoute( ::aURLParms, <path> )
#xtranslate @{Default} => Otherwise


WsRestful apiteste Description "WebService REST para testes"

    WsMethod GET Description "Sincronização de dados via GET" WsSyntax "/GET/{method}"

End WsRestful

WsMethod GET WsService apiteste

Local cJson      := ''
Local nList      := 0
Local nX         := 0
Local cCorte     := 10
Local nInit      := 1
Local nTerm      := cCorte
Local aList      := {}
Local aAux       := {}
Local aUsrPass   := {}
Local aUser      := {}

    ::SetContentType('application/json')

        @{Route}
            @{When '/produtos/{id}'}
                
                aList  := fQryProd(.F.,'')
                nDivid := Ceiling(Len(aList)/cCorte)

                For nX := 1 To nDivid
                    cJson := '['

                    For nList := nInit to Iif(nX=nDivid,Len(aList),nTerm)
                        cJson += '{'
                        cJson += '	"codigo":"'+aList[nList,1]+'",'
                        cJson += '	"descricao":"'+aList[nList,2]+'",'
                        cJson += '	"tipo":"'+aList[nList,3]+'",'
                        cJson += '	"unidmed":"'+aList[nList,4]+'",'
                        cJson += '	"armazem":"'+aList[nList,5]+'",'
                        cJson += '	"grupo":"'+aList[nList,6]+'"'
                        cJson += '},'
                    Next nList

                    nInit := nInit+cCorte
                    nTerm := nTerm+cCorte
                    cJson := Left(cJson, RAT(",", cJson) - 1)
                    cJson += ']'

                    Aadd(aAux,cJson)
                Next nX

                If Val(@{Param 2}) <= Len(aAux)
                    ::SetResponse(aAux[Val(@{Param 2})])
                Else
                    SetRestFault(400,'Ops')
                EndIf

            @{When '/searchprod/{id}'}
                aList := fQryProd(.T.,Alltrim(Upper(@{Param 2})))
                cJson := '['
                
                For nList := 1 to Len(aList)
                    cJson += '{'
                    cJson += '	"codigo":"'+aList[nList,1]+'",'
                    cJson += '	"descricao":"'+aList[nList,2]+'",'
                    cJson += '	"tipo":"'+aList[nList,3]+'",'
                    cJson += '	"unidmed":"'+aList[nList,4]+'",'
                    cJson += '	"armazem":"'+aList[nList,5]+'",'
                    cJson += '	"grupo":"'+aList[nList,6]+'"'
                    cJson += '},'
                Next nList

                cJson := Left(cJson, RAT(",", cJson) - 1)
                cJson += ']'
                
                If Len(aList)>0
                    ::SetResponse(cJson)
                Else
                    ::SetResponse('[]')
                EndIf

            @{When '/users/{id}'}
                aUsrPass := StrTokArr(Lower(cValToChar(@{Param 2})),"|&|")

                If Len(aUsrPass) > 0
                    PswOrder(2)
                    If PswSeek(aUsrPass[1],.T.)
                        aUser := PswRet()[1]

                        If PswName(aUsrPass[2])
                            cJson := '['
                            cJson += '{'
                            cJson += '"user": '+'"'+aUsrPass[1]+'",'
                            cJson += '"pass": '+'"'+aUsrPass[2]+'",'
                            cJson += '"name": '+'"'+Capital(aUser[4])+'",'
                            cJson += '"mail": '+'"'+aUser[14]+'" '
                            cJson += '}'
                            cJson += ']'

                            ::SetResponse(cJson)
                        Else
                            SetRestFault(400,'Senha Invalida')
                            Return .F.
                        EndIf
                    Else
                        SetRestFault(400,'Usuario Invalido')
                        Return .F.
                    EndIf
                Else
                    SetRestFault(400,'Usuario Invalido')
                    Return .F.
                EndIf
                
            @{When '/lojas/{id}'}
                
                aList  := fQryloja(.F.,'')
                nDivid := Ceiling(Len(aList)/cCorte)

                For nX := 1 To nDivid
                    cJson := '['

                    For nList := nInit to Iif(nX=nDivid,Len(aList),nTerm)
                        cJson += '{'
                        cJson += '	"id":"'+aList[nList,1]+'",'
                        cJson += '	"filial":"'+aList[nList,2]+'",'
                        cJson += '	"armazem":"'+aList[nList,3]+'",'
                        cJson += '	"descricao":"'+aList[nList,4]+'",'
                        cJson += '	"tipolj":"'+aList[nList,5]+'",'
                        cJson += '	"invent":"'+aList[nList,6]+'",'
                        cJson += '	"bloqueado":"'+aList[nList,7]+'"'
                        cJson += '},'
                    Next nList            

                    nInit := nInit+cCorte
                    nTerm := nTerm+cCorte
                    cJson := Left(cJson, RAT(",", cJson) - 1)
                    cJson += ']'

                    Aadd(aAux,cJson)
                Next nX

                If Val(@{Param 2}) <= Len(aAux)
                    ::SetResponse(aAux[Val(@{Param 2})])
                Else
                    SetRestFault(400,'Ops')
                EndIf
                

            @{When '/searchloja/{id}'}

                aList := fQryloja(.T.,Alltrim(Upper(@{Param 2})))
                cJson := '['
                
                For nList := 1 to Len(aList)
                    cJson += '{'
                    cJson += '	"id":"'+aList[nList,1]+'",'
                    cJson += '	"filial":"'+aList[nList,2]+'",'
                    cJson += '	"armazem":"'+aList[nList,3]+'",'
                    cJson += '	"descricao":"'+aList[nList,4]+'",'
                    cJson += '	"tipolj":"'+aList[nList,5]+'",'
                    cJson += '	"invent":"'+aList[nList,6]+'",'
                    cJson += '	"bloqueado":"'+aList[nList,7]+'"'
                    cJson += '},'
                Next nList

                cJson := Left(cJson, RAT(",", cJson) - 1)
                cJson += ']'
                
                If Len(aList)>0
                    ::SetResponse(cJson)
                Else
                    ::SetResponse('[]')
                EndIf

            @{Default}
                SetRestFault(400,"Ops")
                Return .F.    
        @{EndRoute}

Return .T.


Static Function fQryProd(lSearch,cSearch)

Local cAliasSQL  := GetNextAlias()
Local cQuery     := ''
Local aRet       := {}

    cQuery := " SELECT * FROM "+RetSqlName('SB1')+" "
	cQuery += " WHERE D_E_L_E_T_!='*' AND B1_MSBLQL!='1' "
    cQuery += Iif(lSearch," AND B1_DESC LIKE '%"+cSearch+"%' ", " ")

    MPSysOpenQuery(cQuery,cAliasSQL)

    While (cAliasSQL)->(!EoF())
        Aadd(aRet,{;
            RemoveEspec((cAliasSQL)->B1_COD)   ,;
            RemoveEspec((cAliasSQL)->B1_DESC)  ,;
            RemoveEspec((cAliasSQL)->B1_TIPO)  ,;
            RemoveEspec((cAliasSQL)->B1_UM)    ,;
            RemoveEspec((cAliasSQL)->B1_LOCPAD),;
            RemoveEspec((cAliasSQL)->B1_GRUPO) })

        (cAliasSQL)->(DbSkip())
    EndDo

Return aRet


Static Function fQryloja(lSearch,cSearch)

Local cAliasSQL  := GetNextAlias()
Local cQuery     := ''
Local aRet       := {}
Local nId        := 0

    cQuery := " SELECT * FROM "+RetSqlName('NNR')+" "
	cQuery += " WHERE D_E_L_E_T_!='*' "
    cQuery += "     AND RTRIM(LTRIM(SUBSTRING(NNR_DESCRI,1,2))) = 'LJ' "
    cQuery += Iif(lSearch," AND NNR_DESCRI LIKE '%"+cSearch+"%' ", " ")
    cQuery += " ORDER BY NNR_FILIAL,NNR_CODIGO "

    MPSysOpenQuery(cQuery,cAliasSQL)

    While (cAliasSQL)->(!EoF())
        nId++
        Aadd(aRet,{;
            cValToChar(nId) ,;
            RemoveEspec((cAliasSQL)->NNR_FILIAL) ,;
            RemoveEspec((cAliasSQL)->NNR_CODIGO) ,;
            RemoveEspec((cAliasSQL)->NNR_DESCRI) ,;
            Iif(Empty((cAliasSQL)->NNR_XTPLJ),'S',(cAliasSQL)->NNR_XTPLJ),;
            Iif(Empty((cAliasSQL)->NNR_XINV),'N',(cAliasSQL)->NNR_XINV),;
            Iif(Empty((cAliasSQL)->NNR_MSBLQL),'2',(cAliasSQL)->NNR_MSBLQL)})

        (cAliasSQL)->(DbSkip())
    EndDo

Return aRet


Static Function RemoveEspec(cWord)
    cWord := OemToAnsi(AllTrim(cWord))
    cWord := FwNoAccent(cWord)
    cWord := FwCutOff(cWord)
    cWord := strtran(cWord,"ã","a")
    cWord := strtran(cWord,"º","")
    cWord := strtran(cWord,"%","")
    cWord := strtran(cWord,"*","")     
    cWord := strtran(cWord,"&","")
    cWord := strtran(cWord,"$","")
    cWord := strtran(cWord,"#","")
    cWord := strtran(cWord,"§","") 
    cWord := strtran(cWord,"ä","a")
    cWord := strtran(cWord,",","")
    cWord := strtran(cWord,".","")
    cWord := StrTran(cWord, "'", "")
    cWord := StrTran(cWord, "#", "")
    cWord := StrTran(cWord, "%", "")
    cWord := StrTran(cWord, "*", "")
    cWord := StrTran(cWord, "&", "E")
    cWord := StrTran(cWord, ">", "")
    cWord := StrTran(cWord, "<", "")
    cWord := StrTran(cWord, "!", "")
    cWord := StrTran(cWord, "@", "")
    cWord := StrTran(cWord, "$", "")
    cWord := StrTran(cWord, "(", "")
    cWord := StrTran(cWord, ")", "")
    cWord := StrTran(cWord, "_", "")
    cWord := StrTran(cWord, "=", "")
    cWord := StrTran(cWord, "+", "")
    cWord := StrTran(cWord, "{", "")
    cWord := StrTran(cWord, "}", "")
    cWord := StrTran(cWord, "[", "")
    cWord := StrTran(cWord, "]", "")
    cWord := StrTran(cWord, "?", "")
    cWord := StrTran(cWord, ".", "")
    cWord := StrTran(cWord, "\", "")
    cWord := StrTran(cWord, "|", "")
    cWord := StrTran(cWord, ":", "")
    cWord := StrTran(cWord, ";", "")
    cWord := StrTran(cWord, '"', '')
    cWord := StrTran(cWord, '°', '')
    cWord := StrTran(cWord, 'ª', '')
    cWord := strtran(cWord,""+'"'+"","")
    cWord := AllTrim(cWord)
Return cWord
=======
#Include "PROTHEUS.ch"
#Include "RESTFUL.ch"

#xtranslate @{Header <(cName)>} => ::GetHeader( <(cName)> )
#xtranslate @{Param <n>} => ::aURLParms\[ <n> \]
#xtranslate @{EndRoute} => EndCase
#xtranslate @{Route} => Do Case
#xtranslate @{When <path>} => Case NGIsRoute( ::aURLParms, <path> )
#xtranslate @{Default} => Otherwise


WsRestful apiteste Description "WebService REST para testes"

    WsMethod GET Description "Sincronização de dados via GET" WsSyntax "/GET/{method}"

End WsRestful

WsMethod GET WsService apiteste

Local cJson      := ''
Local nList      := 0
Local nX         := 0
Local cCorte     := 10
Local nInit      := 1
Local nTerm      := cCorte
Local aList      := {}
Local aAux       := {}
Local aUsrPass   := {}
Local aUser      := {}

    ::SetContentType('application/json')

        @{Route}
            @{When '/produtos/{id}'}
                
                aList  := fQryProd(.F.,'')
                nDivid := Ceiling(Len(aList)/cCorte)

                For nX := 1 To nDivid
                    cJson := '['

                    For nList := nInit to Iif(nX=nDivid,Len(aList),nTerm)
                        cJson += '{'
                        cJson += '	"codigo":"'+aList[nList,1]+'",'
                        cJson += '	"descricao":"'+aList[nList,2]+'",'
                        cJson += '	"tipo":"'+aList[nList,3]+'",'
                        cJson += '	"unidmed":"'+aList[nList,4]+'",'
                        cJson += '	"armazem":"'+aList[nList,5]+'",'
                        cJson += '	"grupo":"'+aList[nList,6]+'"'
                        cJson += '},'
                    Next nList

                    nInit := nInit+cCorte
                    nTerm := nTerm+cCorte
                    cJson := Left(cJson, RAT(",", cJson) - 1)
                    cJson += ']'

                    Aadd(aAux,cJson)
                Next nX

                If Val(@{Param 2}) <= Len(aAux)
                    ::SetResponse(aAux[Val(@{Param 2})])
                Else
                    SetRestFault(400,'Ops')
                EndIf

            @{When '/searchprod/{id}'}
                aList := fQryProd(.T.,Alltrim(Upper(@{Param 2})))
                cJson := '['
                
                For nList := 1 to Len(aList)
                    cJson += '{'
                    cJson += '	"codigo":"'+aList[nList,1]+'",'
                    cJson += '	"descricao":"'+aList[nList,2]+'",'
                    cJson += '	"tipo":"'+aList[nList,3]+'",'
                    cJson += '	"unidmed":"'+aList[nList,4]+'",'
                    cJson += '	"armazem":"'+aList[nList,5]+'",'
                    cJson += '	"grupo":"'+aList[nList,6]+'"'
                    cJson += '},'
                Next nList

                cJson := Left(cJson, RAT(",", cJson) - 1)
                cJson += ']'
                
                If Len(aList)>0
                    ::SetResponse(cJson)
                Else
                    ::SetResponse('[]')
                EndIf

            @{When '/users/{id}'}
                aUsrPass := StrTokArr(Lower(cValToChar(@{Param 2})),"|&|")

                If Len(aUsrPass) > 0
                    PswOrder(2)
                    If PswSeek(aUsrPass[1],.T.)
                        aUser := PswRet()[1]

                        If PswName(aUsrPass[2])
                            cJson := '['
                            cJson += '{'
                            cJson += '"user": '+'"'+aUsrPass[1]+'",'
                            cJson += '"pass": '+'"'+aUsrPass[2]+'",'
                            cJson += '"name": '+'"'+Capital(aUser[4])+'",'
                            cJson += '"mail": '+'"'+aUser[14]+'" '
                            cJson += '}'
                            cJson += ']'

                            ::SetResponse(cJson)
                        Else
                            SetRestFault(400,'Senha Invalida')
                            Return .F.
                        EndIf
                    Else
                        SetRestFault(400,'Usuario Invalido')
                        Return .F.
                    EndIf
                Else
                    SetRestFault(400,'Usuario Invalido')
                    Return .F.
                EndIf
                
            @{When '/lojas/{id}'}
                
                aList  := fQryloja(.F.,'')
                nDivid := Ceiling(Len(aList)/cCorte)

                For nX := 1 To nDivid
                    cJson := '['

                    For nList := nInit to Iif(nX=nDivid,Len(aList),nTerm)
                        cJson += '{'
                        cJson += '	"id":"'+aList[nList,1]+'",'
                        cJson += '	"filial":"'+aList[nList,2]+'",'
                        cJson += '	"armazem":"'+aList[nList,3]+'",'
                        cJson += '	"descricao":"'+aList[nList,4]+'",'
                        cJson += '	"tipolj":"'+aList[nList,5]+'",'
                        cJson += '	"invent":"'+aList[nList,6]+'",'
                        cJson += '	"bloqueado":"'+aList[nList,7]+'"'
                        cJson += '},'
                    Next nList            

                    nInit := nInit+cCorte
                    nTerm := nTerm+cCorte
                    cJson := Left(cJson, RAT(",", cJson) - 1)
                    cJson += ']'

                    Aadd(aAux,cJson)
                Next nX

                If Val(@{Param 2}) <= Len(aAux)
                    ::SetResponse(aAux[Val(@{Param 2})])
                Else
                    SetRestFault(400,'Ops')
                EndIf
                

            @{When '/searchloja/{id}'}

                aList := fQryloja(.T.,Alltrim(Upper(@{Param 2})))
                cJson := '['
                
                For nList := 1 to Len(aList)
                    cJson += '{'
                    cJson += '	"id":"'+aList[nList,1]+'",'
                    cJson += '	"filial":"'+aList[nList,2]+'",'
                    cJson += '	"armazem":"'+aList[nList,3]+'",'
                    cJson += '	"descricao":"'+aList[nList,4]+'",'
                    cJson += '	"tipolj":"'+aList[nList,5]+'",'
                    cJson += '	"invent":"'+aList[nList,6]+'",'
                    cJson += '	"bloqueado":"'+aList[nList,7]+'"'
                    cJson += '},'
                Next nList

                cJson := Left(cJson, RAT(",", cJson) - 1)
                cJson += ']'
                
                If Len(aList)>0
                    ::SetResponse(cJson)
                Else
                    ::SetResponse('[]')
                EndIf

            @{Default}
                SetRestFault(400,"Ops")
                Return .F.    
        @{EndRoute}

Return .T.


Static Function fQryProd(lSearch,cSearch)

Local cAliasSQL  := GetNextAlias()
Local cQuery     := ''
Local aRet       := {}

    cQuery := " SELECT * FROM "+RetSqlName('SB1')+" "
	cQuery += " WHERE D_E_L_E_T_!='*' AND B1_MSBLQL!='1' "
    cQuery += Iif(lSearch," AND B1_DESC LIKE '%"+cSearch+"%' ", " ")

    MPSysOpenQuery(cQuery,cAliasSQL)

    While (cAliasSQL)->(!EoF())
        Aadd(aRet,{;
            RemoveEspec((cAliasSQL)->B1_COD)   ,;
            RemoveEspec((cAliasSQL)->B1_DESC)  ,;
            RemoveEspec((cAliasSQL)->B1_TIPO)  ,;
            RemoveEspec((cAliasSQL)->B1_UM)    ,;
            RemoveEspec((cAliasSQL)->B1_LOCPAD),;
            RemoveEspec((cAliasSQL)->B1_GRUPO) })

        (cAliasSQL)->(DbSkip())
    EndDo

Return aRet


Static Function fQryloja(lSearch,cSearch)

Local cAliasSQL  := GetNextAlias()
Local cQuery     := ''
Local aRet       := {}
Local nId        := 0

    cQuery := " SELECT * FROM "+RetSqlName('NNR')+" "
	cQuery += " WHERE D_E_L_E_T_!='*' "
    cQuery += "     AND RTRIM(LTRIM(SUBSTRING(NNR_DESCRI,1,2))) = 'LJ' "
    cQuery += Iif(lSearch," AND NNR_DESCRI LIKE '%"+cSearch+"%' ", " ")
    cQuery += " ORDER BY NNR_FILIAL,NNR_CODIGO "

    MPSysOpenQuery(cQuery,cAliasSQL)

    While (cAliasSQL)->(!EoF())
        nId++
        Aadd(aRet,{;
            cValToChar(nId) ,;
            RemoveEspec((cAliasSQL)->NNR_FILIAL) ,;
            RemoveEspec((cAliasSQL)->NNR_CODIGO) ,;
            RemoveEspec((cAliasSQL)->NNR_DESCRI) ,;
            Iif(Empty((cAliasSQL)->NNR_XTPLJ),'S',(cAliasSQL)->NNR_XTPLJ),;
            Iif(Empty((cAliasSQL)->NNR_XINV),'N',(cAliasSQL)->NNR_XINV),;
            Iif(Empty((cAliasSQL)->NNR_MSBLQL),'2',(cAliasSQL)->NNR_MSBLQL)})

        (cAliasSQL)->(DbSkip())
    EndDo

Return aRet


Static Function RemoveEspec(cWord)
    cWord := OemToAnsi(AllTrim(cWord))
    cWord := FwNoAccent(cWord)
    cWord := FwCutOff(cWord)
    cWord := strtran(cWord,"ã","a")
    cWord := strtran(cWord,"º","")
    cWord := strtran(cWord,"%","")
    cWord := strtran(cWord,"*","")     
    cWord := strtran(cWord,"&","")
    cWord := strtran(cWord,"$","")
    cWord := strtran(cWord,"#","")
    cWord := strtran(cWord,"§","") 
    cWord := strtran(cWord,"ä","a")
    cWord := strtran(cWord,",","")
    cWord := strtran(cWord,".","")
    cWord := StrTran(cWord, "'", "")
    cWord := StrTran(cWord, "#", "")
    cWord := StrTran(cWord, "%", "")
    cWord := StrTran(cWord, "*", "")
    cWord := StrTran(cWord, "&", "E")
    cWord := StrTran(cWord, ">", "")
    cWord := StrTran(cWord, "<", "")
    cWord := StrTran(cWord, "!", "")
    cWord := StrTran(cWord, "@", "")
    cWord := StrTran(cWord, "$", "")
    cWord := StrTran(cWord, "(", "")
    cWord := StrTran(cWord, ")", "")
    cWord := StrTran(cWord, "_", "")
    cWord := StrTran(cWord, "=", "")
    cWord := StrTran(cWord, "+", "")
    cWord := StrTran(cWord, "{", "")
    cWord := StrTran(cWord, "}", "")
    cWord := StrTran(cWord, "[", "")
    cWord := StrTran(cWord, "]", "")
    cWord := StrTran(cWord, "?", "")
    cWord := StrTran(cWord, ".", "")
    cWord := StrTran(cWord, "\", "")
    cWord := StrTran(cWord, "|", "")
    cWord := StrTran(cWord, ":", "")
    cWord := StrTran(cWord, ";", "")
    cWord := StrTran(cWord, '"', '')
    cWord := StrTran(cWord, '°', '')
    cWord := StrTran(cWord, 'ª', '')
    cWord := strtran(cWord,""+'"'+"","")
    cWord := AllTrim(cWord)
Return cWord
>>>>>>> 089d6fb8972098ee8519544bf47cd330c8b80b60
