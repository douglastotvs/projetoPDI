#Include "PROTHEUS.ch"
#Include "RESTFUL.ch"

#xtranslate @{Header <(cName)>} => ::GetHeader( <(cName)> )
#xtranslate @{Param <n>} => ::aURLParms\[ <n> \]
#xtranslate @{EndRoute} => EndCase
#xtranslate @{Route} => Do Case
#xtranslate @{When <path>} => Case NGIsRoute( ::aURLParms, <path> )
#xtranslate @{Default} => Otherwise


WsRestful apict1 Description "WebService REST para testes"

    WsMethod GET Description "Sincronização de dados via GET" WsSyntax "/GET/{method}"

End WsRestful  

WsMethod GET WsService apict1

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
            @{When '/planodecontas/{id}'}
                
                aList  := fQryCt1(.F.,'')
                nDivid := Ceiling(Len(aList)/cCorte)

                For nX := 1 To nDivid
                    cJson := '['

                    For nList := nInit to Iif(nX=nDivid,Len(aList),nTerm)
                        cJson += '{'
                        cJson += '	"id":"'+aList[nList,8]+'",'
                        cJson += '	"filial":"'+aList[nList,1]+'",'
                        cJson += '	"conta":"'+aList[nList,2]+'",'
                        cJson += '	"descricao":"'+aList[nList,3]+'",'
                        cJson += '	"classe":"'+aList[nList,4]+'",'
                        cJson += '	"normal":"'+aList[nList,5]+'",'
                        cJson += '	"ntsped":"'+aList[nList,6]+'",'
                        cJson += '	"dtexist":"'+aList[nList,7]+'"'
                        cJson += '},'
                    Next nList

                    nInit := nInit+cCorte
                    nTerm := nTerm+cCorte
                    cJson := Left(cJson, RAT(",", cJson) - 1)
                    cJson += ']'

                    Aadd(aAux,cJson)
                Next nX

                If Val(::aURLParms[2]) <= Len(aAux)
                    ::SetResponse(aAux[Val(::aURLParms[2])])
                Else
                    SetRestFault(400,'Ops')
                EndIf

            @{When '/searchplanodecontas/{id}'}
                aList := fQryCt1(.T.,Alltrim(Upper(::aURLParms[2])))
                cJson := '['
                
                For nList := 1 to Len(aList)
                        cJson += '{'
                        cJson += '	"id":"'+aList[nList,8]+'",'
                        cJson += '	"filial":"'+aList[nList,1]+'",'
                        cJson += '	"conta":"'+aList[nList,2]+'",'
                        cJson += '	"descricao":"'+aList[nList,3]+'",'
                        cJson += '	"classe":"'+aList[nList,4]+'",'
                        cJson += '	"normal":"'+aList[nList,5]+'",'
                        cJson += '	"ntsped":"'+aList[nList,6]+'",'
                        cJson += '	"dtexist":"'+aList[nList,7]+'"'
                        cJson += '},'
                Next nList

                cJson := Left(cJson, RAT(",", cJson) - 1)
                cJson += ']'
                
                If Len(aList)>0
                    ::SetResponse(cJson)
                Else
                    ::SetResponse('[]')
                EndIf
            /*
            @{When '/users/{id}'}
                aUsrPass := StrTokArr(Lower(cValToChar(::aURLParms[2])),"|&|")

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
                */
            
            @{Default}
                SetRestFault(400,"Ops")
                Return .F.    
        @{EndRoute}

Return .T.


Static Function fQryCt1(lSearch,cSearch)

Local cAliasSQL  := GetNextAlias()
Local cQuery     := ''
Local aRet       := {}

    cQuery := " SELECT * FROM "+RetSqlName('CT1')+" "
	cQuery += " WHERE D_E_L_E_T_ = ' ' " //AND B1_MSBLQL != '1' "
    cQuery += Iif(lSearch," AND CT1_CONTA LIKE '%"+cSearch+"%' ", " ")
    

    MPSysOpenQuery(cQuery,cAliasSQL)

    While (cAliasSQL)->(!EoF())
        Aadd(aRet,{;
            RemoveEspec((cAliasSQL)->CT1_FILIAL)   ,;
            RemoveEspec((cAliasSQL)->CT1_CONTA)   ,;
            RemoveEspec((cAliasSQL)->CT1_DESC01)  ,;
            RemoveEspec((cAliasSQL)->CT1_CLASSE)  ,;
            RemoveEspec((cAliasSQL)->CT1_NORMAL)  ,;
            RemoveEspec((cAliasSQL)->CT1_NTSPED) ,;
            RemoveEspec((cAliasSQL)->CT1_DTEXIS) ,;
            RemoveEspec((cAliasSQL)->R_E_C_N_O_) })

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
