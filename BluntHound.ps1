function Invoke-BluntHound
{
    

    [CmdletBinding(PositionalBinding =  ${f`AlSE} )]
    param(  
        [Alias("c" )]
        [String[]]
        ${CO`llecTi`oNMetH`odS} =   [String[]]@(("{0}{2}{1}"-f'Defa','t','ul')  ),

        [Alias( "d"  )]
        [String]
        ${dom`Ain},
        
        [Alias(  "s" )]
        [Switch]
        ${se`ArChf`o`R`eSt},

        [Switch]
        ${s`Tea`Lth},

        [String]
        ${L`D`APF`ILtEr},

        [String]
        ${DiSTInG`UIs`Hed`NaME},

        [String]
        ${c`Om`PutERFiLE},

        [ValidateScript(  { &("{1}{0}{2}" -f's','Te','t-Path') -Path ${_} } )]
        [String]
        ${ou`T`puTDIrE`CTO`RY}  =   $( &("{0}{2}{1}{3}"-f'Ge','L','t-','ocation') ),

        [ValidateNotNullOrEmpty()]
        [String]
        ${OUT`PU`TP`REfIX},

        [String]
        ${C`AchenA`me},

        [Switch]
        ${mEmC`Ac`hE},

        [Switch]
        ${ReBUILD`CAc`HE},

        [Switch]
        ${ra`NDOMFIL`EN`AmeS},

        [String]
        ${z`i`pFI`LEnaME},
        
        [Switch]
        ${NO`z`ip},
        
        [String]
        ${zIpPA`SsW`ORD},
        
        [Switch]
        ${T`RA`ckCOMp`U`TEr`cAlLS},
        
        [Switch]
        ${prEt`TYprI`NT},

        [String]
        ${lD`APu`s`E`RnAME},

        [String]
        ${ldA`PP`AsSWoRD},

        [string]
        ${dO`M`A`inCoNtroLLEr},

        [ValidateRange( 0, 65535 )]
        [Int]
        ${lD`APpO`Rt},

        [Switch]
        ${s`ECu`RelDap},
        
        [Switch]
        ${DISaB`lEC`e`RtveR`if`ICATi`oN},

        [Switch]
        ${D`iS`ABlesIg`NInG},

        [Switch]
        ${SkiPp`oR`TC`HeCK},

        [ValidateRange(50, 5000 )]
        [Int]
        ${P`o`RTche`CkTIme`O`Ut}  =   500,

        [Switch]
        ${sK`IPp`ASswo`R`DchE`ck},

        [Switch]
        ${ex`ClUDED`cs},

        [Int]
        ${th`Rot`TLe},

        [ValidateRange( 0, 100 )]
        [Int]
        ${jIT`TeR},

        [Int]
        ${TH`RE`Ads},

        [Switch]
        ${S`kI`PREgiS`TRY`LO`ggE`DON},

        [String]
        ${oVER`RIDE`U`sErN`Ame},

        [String]
        ${rEalDN`S`NaMe},

        [Switch]
        ${C`OLle`c`TalL`P`ROPe`RtIES},

        [Switch]
        ${l`Oop},

        [String]
        ${LO`oPd`U`RatiOn},

        [String]
        ${looP`Interv`AL},

        [ValidateRange( 500, 60000  )]
        [Int]
        ${stATus`iNT`eRV`AL},
        
        [Alias( "v"  )]
        [ValidateRange(  0, 5)]
        [Int]
        ${VErb`Os`iTy},

        [Alias(  "h")]
        [Switch]
        ${H`Elp},

        [Switch]
        ${ve`Rs`ion}
    )

    ${v`ARs}  = &("{0}{3}{2}{1}"-f 'N','t','ec','ew-Obj') System.Collections.Generic.List[System.Object]
    
    if(  !( ${ps`BoU`N`dParamE`TeRs}.ContainsKey(  ("{0}{1}"-f 'he','lp') ) -or ${pSBO`UNDp`A`RAMe`TErS}.ContainsKey( ("{1}{0}{2}" -f 'rsi','ve','on') )  ) ){
        ${pSBo`UNd`pa`RAmeTErS}.Keys   |  &('%') {
            if ( ${_} -notmatch ("{1}{0}{2}"-f 'erbo','v','sity') ){
                ${Va`Rs}.add( "--$_" )
                if(  ${pSB`OuNDpar`A`mE`Ters}.item(  ${_}  ).gettype(   ).name -notmatch ("{0}{1}" -f'switc','h') ){
                    ${va`Rs}.add(${pSBo`UNdparA`Me`Te`Rs}.item(${_})  )
                }
            }
            elseif (  ${_} -match ("{1}{0}{2}" -f'r','ve','bosity')  ) {
                ${vA`Rs}.add(  "-v" )
                ${v`ARs}.add( ${psBO`Un`DpA`RaM`eters}.item(  ${_} ) )
            }
        }
    }
    else {
        ${P`Sb`Ou`ND`PARAmEtErs}.Keys  |  &('?') {${_} -match ("{0}{1}"-f 'he','lp') -or ${_} -match ("{1}{0}"-f'ersion','v')} |   &('%') {
            ${V`ARs}.add( "--$_"  )
        }
    }
    
    ${p`AS`SEd}  = [string[]]${V`ARS}.ToArray(  )

	${dEFL`Ate`dSt`ReAm}  =  &("{1}{0}{2}"-f 'w-Obj','Ne','ect') IO.Compression.DeflateStream([IO.MemoryStream][Convert]::FromBase64String(  ${encO`d`e`d`cO`MpResSeDFIle}),[IO.Compression.CompressionMode]::Decompress )
	${u`NComP`Ress`ed`FiLe`B`yTEs} =  &("{2}{1}{0}" -f 'bject','-O','New') Byte[](1046528  )
	${DEflatedS`T`REAM}.Read( ${Un`co`mprEsSe`df`iLeByT`es}, 0, 1046528 ) | &("{0}{1}" -f'Out-Nul','l')
	${aSs`emb`lY}   =   [Reflection.Assembly]::Load( ${uNCo`m`prE`sSe`dFiLE`BYT`es} )
	${bindI`Ng`FlAgS}  =   [Reflection.BindingFlags] ("{2}{0}{1}" -f ',','Static','Public')
	${a}  = @(  )
	${aS`seM`BlY}.GetType(("{0}{4}{3}{1}{2}"-f 'Costu','semblyLoade','r','a.As','r'), ${fA`L`Se} ).GetMethod(("{1}{0}"-f'tach','At'), ${bi`NDi`NgF`LAGS}).Invoke(${Nu`LL}, @( )  )
	${As`SEMbLy}.GetType(("{0}{1}{2}{3}"-f'Sh','ar','phound.Prog','ram')  ).GetMethod( ("{0}{2}{1}{4}{3}"-f 'Inv','keSha','o','und','rpHo') ).Invoke(  ${Nu`ll}, @(,${PAss`eD}))
}
