##############################################################################
#
#  std.mk  (c) 1995,6 E. KrÑmer (ekraemer@pluto.camelot.de)
#
# This file is not under the GNU Copyleft.
# It is Copyright (c) 1996 Ekkehard KrÑmer and may only be distributed  
# unchanged and together with the software package it came with. 
#
# Provided "as is".
#
##############################################################################

##############################################################################
# Allgemein                                                                  #
##############################################################################
#
# PROG          - Name des Executables (PROG.exe oder PROG.dll)
# SRC           - Liste aller .o-Files ohne Extension
# TYPE          - Typ des Programms (PM, VIO, LIBA, LIBOMF oder DLL)
#                 Bei DLL wird DLL und Import-LIB (.a und .lib) erzeugt, 
#                 bei LIBA eine Unix-Library (.a / .o),
#                 bei LIBOMF eine OMF-Library (.lib / .obj),
#                 sonst EXE
#
##############################################################################
# Von diesem File bereitgestellt                                             #
##############################################################################
#
# DEF           - Name des .def-Files ($(PROG).def, falls nicht vorbelegt)
# DEFSRC        - Falls TYPE==DLL: die Def-Source-Datei, an die Exports angehÑngt
#                 werden ($(PROG).df, falls nicht vorbelegt)
# DLL           - Name der DLL ($(PROG).dll, falls nicht vorbelegt)
# EXE           - Name des Exes ($(PROG).exe, falls nicht vorbelegt)
# LIBA          - Name der .a  ($(PROG).a, falls nicht vorbelegt)
# LIBADLL       - Name der .a LIB zur DLL ($(PROG).a, falls nicht vorbelegt)
# LIBOMF        - Name der .lib ($(PROG).lib, falls nicht vorbelegt)
# LIBOMFDLL     - Name der OMF-LIB zur DLL ($(PROG).lib, falls nicht vorbelegt)
#
# run           - Target zum Starten des EXEs, falls Typ PM oder VIO
# clean         - Entfernt .o und evtl. .d / $(DEPFILE)
# profile       - Startet Programm, gprof, Ausgabe in profile.txt
#
##############################################################################
# Optionen ('Y' fÅr Aktiv, 'N' fÅr Inaktiv)                                  #
##############################################################################
#
# ALLWARNINGS   - -Wall (Default)
# AUTOTEMPLATE  - falls ==N, -fno-implicit-templates (Default)
# CHECKBOUNDS   - -fbounds-checking (N. Default)
# CPPLIB        - C++ library linken (N. Default)
# DEBUG         - -g (N. Default)
# EKLIB         - EK library linken (N. Default)
# EXCEPTIONS    - -fhandle-exceptions (N. Default, deaktiviert Optimierungen)
# LIBDEPS	- Pfade zu Libraries (EKLIB) - fÅr Dependencies
# M486          - -m486 (Default)
# MAKEDEF       - .def File verwenden, wird angelegt, falls nicht vorhanden
# MAKEDEP       - Dependencies herstellen (Default)
# MAKERES       - Resourcefile PROG.res aus PROG.rc (Default, falls Type==PM)
# MULTITHREAD   - -Zmt (Default, falls TYPE==PM)
# NICE          - gcc auf niedrigster PrioritÑt (Default)
# NOWARNINGS    - Keine Warnungen (N. Default)
# OMF           - -Zomf (Default, falls TYPE==DLL oder TYPE==LIBOMF)
# OPTIMIZE      - -O3 (Default)
# PROFILE       - -pg (N. Default)
# PROFILEPARAMS - Parameter, die dem Executable vom profile-Target Åbergeben werden
# QUIET         - gcc-Aufrufe nicht wiedergeben (N. Default)
# RUNPARAMS     - Parameter, die dem Executable vom run-Target Åbergeben werden
# STRIP         - -s (Fest Y, falls OMF oder !DEBUG, sonst N. Default)
# USEDLL        - DLL-Versionen der C-Library verwenden (Default)
# WARNERR       - -Werror (Default)
#
##############################################################################
# Optionale Makros                                                           #
##############################################################################
#
# ADDOBJS       - Weitere .o oder .lib etc. fÅrs Exe
# ADDLIBS	- Weitere Libraries (mit Pfad, NUR FöR DEPEDENCIES (-> LFLAGS))
# CFLAGS	- Compileroptionen
# DEPFILE       - Dependencies-Datei, Default=dependencies
# LFLAGS	- Linkeroptionen
# NEXTMAKEFILE  - Evtl. zusÑtzlich aufzurufendes Makefile (selbe Kommandozeilenoptionen)
# RCFILE	- RC-File (Defaullt PROG.rc)
# RES2          - Res-File, das an das eigentliche Resfile angehÑngt wird (DlgEdit!)
# RESH          - Includefile(s) fÅr Resfile (Default=ressource.h, falls MAKERES)
#
##############################################################################

#
# dmake options
#
.KEEP_STATE:
.IGNORE:

#
# Standard Definitions
#
CC              = gcc
OBJ             = o

.IF $(SRC)==
ERRDEFAULT      = Y
default:
  @echo SRC has not been defined!
.ELIF $(PROG)==
ERRDEFAULT      = Y
default:
  @echo PROG has not been defined!
.ENDIF

#
# Defaults
#
.IF $(TYPE)==
  DEFAULT       += typewarning
  TYPE           = VIO
.ENDIF

.IF $(TYPE)==PM
  MULTITHREAD   *= Y
  MAKERES       *= Y
  MAKEDEF       *= Y
  MAKERUNTARGET  = Y
  MAKEEXE        = Y
.ELIF $(TYPE)==VIO
  MAKERUNTARGET  = Y
  MAKEEXE        = Y
.ELIF $(TYPE)==DLL
  OMF           *= Y
  USEDLL        *= Y
  LFLAGS        += -Zdll
  MAKEDLL        = Y
  MAKEDLLLIB     = Y
  MAKEDEF        = Y
.ELIF $(TYPE)==LIBA
  MAKELIBA       = Y
.ELIF $(TYPE)==LIBOMF
  OMF           *= Y
  MAKELIBOMF     = Y
.ELSE
  ERRDEFAULT     = Y
default:
  @echo Wrong type!
.ENDIF

ALLWARNINGS     *= Y
AUTOTEMPLATE    *= Y
CHECKBOUNDS     *= N
CPPLIB          *= N
DEBUG           *= N
EKLIB           *= N
EXCEPTIONS      *= N
M486            *= Y
MAKEDEF         *= N
MAKEDEP         *= Y
MAKERES         *= N
MULTITHREAD     *= N
NICE            *= Y
NOWARNINGS	*= N
OMF             *= N
OPTIMIZE        *= Y
PROFILE         *= N
QUIET           *= Y
STRIP           *= N
USEDLL          *= Y
WARNERR         *= Y

#
# Auswertung der Optionen
#
.IF $(MAKELIBOMF)==Y
  LIB           *= $(PROG).lib
  DEFAULT       += $(LIB)
.ENDIF

.IF $(MAKELIBA)==Y
  LIBA          *= $(PROG).a
  DEFAULT       += $(LIBA)
.ENDIF  

.IF $(MAKEDLLLIB)==Y
  LIBOMFDLL     *= $(PROG).lib
  LIBADLL       *= $(PROG).a
  DEFAULT       += $(LIBOMFDLL) $(LIBADLL)
.ENDIF

.IF $(MAKEDLL)==Y
  DLL           *= $(PROG).dll
  DEFAULT       += $(DLL)
.ENDIF

.IF $(MAKEEXE)==Y
  EXE           *= $(PROG).exe
  DEFAULT       += $(EXE)
.ENDIF

.IF $(MAKERES)==Y
  RES          *= $(PROG).res
  RESH         *= ressource.h
.ENDIF

.IF $(MAKEDEF)==Y
  DEF          *= $(PROG).def
.IF $(TYPE)==DLL
  DEFSRC       *= $(PROG).df
.ENDIF
.ENDIF

.IF $(MAKEDEP)==Y
  DEPFILE       *= dependencies
  DEFAULT       += $(DEPFILE)
.ENDIF

.IF $(DEBUG)==Y
  CFLAGS        += -g
.ELSE
  STRIP          = Y
.ENDIF

.IF $(EXCEPTIONS)==Y
  OPTIMIZE       = N
  CFLAGS        += -fhandle-exceptions 
.ENDIF

.IF $(OPTIMIZE)==Y 
  CFLAGS        += -O3 
.ENDIF

.IF $(MULTITHREAD)==Y
  CFLAGS        += -Zmt 
  LFLAGS        += -Zmt
.ENDIF

.IF $(OMF)==Y
  STRIP          = Y
  CFLAGS        += -Zomf        
  LFLAGS        += -Zomf         
  OBJ            = obj
.ENDIF

.IF $(STRIP)==Y
  CFLAGS        += -s
  LFLAGS        += -s
.ENDIF
        
.IF $(NOWARNINGS)==Y
  ALLWARNINGS	 = 
.ENDIF

.IF $(ALLWARNINGS)==Y
  CFLAGS        += -Wall 
.ENDIF

.IF $(WARNERR)==Y
  CFLAGS        += -Werror 
.ENDIF

.IF $(EKLIB)==Y
  LFLAGS        += -L/gcc/lib -leklib
.IF $(OMF)==Y
  LIBDEPS	+= /gcc/lib/eklib.lib
  EKLIBMEMOBJ    = /gcc/lib/memcl.obj
.ELSE
  LIBDEPS	+= /gcc/lib/eklib.a
  EKLIBMEMOBJ    = /gcc/lib/memcl.o
.ENDIF
.ENDIF

.IF $(CPPLIB)==Y
  LFLAGS        += -lgpp -lstdcpp
.ENDIF

.IF $(PROFILE)==Y
  CFLAGS        += -pg
  LFLAGS        += -pg
.ENDIF

.IF $(CHECKBOUNDS)==Y
  CFLAGS        += -fbounds-checking
.ENDIF

.IF $(M486)==Y
  CFLAGS        += -m486
.ENDIF

.IF $(NICE)==Y
  NICECMD       *= nice -i -n -30
.ENDIF

.IF $(AUTOTEMPLATE)==N
  CFLAGS        += -fno-implicit-templates
.ENDIF

.IF $(USEDLL)==Y
  CFLAGS        += -Zcrtdll
  LFLAGS        += -Zcrtdll
.ENDIF

OBJS             = {$(SRC)}.$(OBJ)
RCFILE	      	*= $(PROG).rc

#
# Standard Rules
#
.IF $(QUIET)!=Y
%.o : %.cpp ; $(NICECMD) $(CC) $(CFLAGS) -o $@ -c $<

%.o : %.c ; $(NICECMD) $(CC) $(CFLAGS) -o $@ -c $<

%.obj : %.cpp ; $(NICECMD) $(CC) $(CFLAGS) -o $@ -c $<

%.obj : %.c ; $(NICECMD) $(CC) $(CFLAGS) -o $@ -c $<
.ELSE
%.o : %.cpp ; 
        @ echo Compiling $<
        @ $(NICECMD) $(CC) $(CFLAGS) -o $@ -c $<

%.o : %.c ; 
        @ echo Compiling $<
        @ $(NICECMD) $(CC) $(CFLAGS) -o $@ -c $<

%.obj : %.cpp ; 
        @ echo Compiling $<
        @ $(NICECMD) $(CC) $(CFLAGS) -o $@ -c $<

%.obj : %.c ; 
        @ echo Compiling $<
        @ $(NICECMD) $(CC) $(CFLAGS) -o $@ -c $<
.ENDIF

#
# Targets
#
.IF $(ERRDEFAULT)!=Y
default: $(DEFAULT) $(NEXTMAKEFILE)
.ENDIF

typewarning:
  @echo No TYPE specified, assuming VIO.

.IF $(MAKERUNTARGET)==Y
run:    $(EXE) 
        $(EXE) $(RUNPARAMS)

profile: $(EXE) 
        $(EXE) $(PROFILEPARAMS)
        gprof $(EXE) gmon.out > profile.txt
.ENDIF

clean .PHONY:
        rm *.$(OBJ) _state.mk
        rm *.d $(DEPFILE) 1>nul 2>nul

.IF $(MAKEDEP)==Y
%.d : %.cpp ;
	@ $(NICECMD) gcc $(CFLAGS) -E -MMD $< 1>nul 2>nul
%.d : %.c ;
	@ $(NICECMD) gcc $(CFLAGS) -E -MMD $< 1>nul 2>nul

$(DEPFILE) .IGNORE: $(OBJS) {$(SRC)}.d
.IF $(QUIET)!=Y
        + type {$(SRC)}.d > $(DEPFILE)
.ELSE
#	@ echo Updating $(DEPFILE)
        @ + type {$(SRC)}.d > $(DEPFILE)
.ENDIF
.ENDIF

.IF $(MAKEDEF)==Y
.IF $(TYPE)!=DLL
$(DEF):
        + echo NAME WINDOWAPI > $(DEF)
        + echo STACKSIZE 32768 >> $(DEF)
.ELSE
$(DEF): $(DEFSRC) $(OBJS)        
        cp $(DEFSRC) $(DEF)
        emxexp -u $(OBJS) >> $(DEF)
.ENDIF
.ENDIF

.IF $(MAKERES)==Y
.IF $(RES2)==
$(RES): $(RCFILE) $(RESH)
       rc -r $(RCFILE)
.ELSE
$(RES): $(RCFILE) $(RES2) $(RESH)
       cp $(RCFILE) tmp.rc
       + type $(RES2) >> tmp.rc
       rc -r tmp.rc
       mv tmp.res $(RES)
.ENDIF
.ENDIF

.IF $(MAKEEXE)==Y
$(EXE): $(OBJS) $(ADDOBJS) $(ADDLIBS) $(DEF) $(RES) $(LIBDEPS)
.IF $(QUIET)!=Y
        $(TMPDIRS) $(NICECMD) $(CC) -o $(EXE) $(EKLIBMEMOBJ) $(OBJS) $(ADDOBJS) $(LFLAGS) $(DEF) $(RES) 
.ELSE
        @ echo Linking $(EXE)
        @ $(TMPDIRS) $(NICECMD) $(CC) -o $(EXE) $(EKLIBMEMOBJ) $(OBJS) $(ADDOBJS) $(LFLAGS) $(DEF) $(RES) 
.ENDIF
.ENDIF

.IF $(MAKEDLL)==Y
$(DLL): $(OBJS) $(ADDOBJS) $(ADDLIBS) $(DEF) $(RES) $(LIBDEPS)
.IF $(QUIET)!=Y
        $(TMPDIRS) $(NICECMD) $(CC) -o $(DLL) $(OBJS) $(ADDOBJS) $(DEF) $(RES) $(LFLAGS)
.ELSE
        @ echo Creating $(DLL)
	@ $(TMPDIRS) $(NICECMD) $(CC) -o $(DLL) $(OBJS) $(ADDOBJS) $(DEF) $(RES) $(LFLAGS)
.ENDIF
.ENDIF

.IF $(MAKEDLLLIB)==Y
$(LIBOMFDLL): $(DEF) 
        emximp -o $(LIBOMFDLL) $(DEF)

$(LIBADLL): $(LIBOMFDLL)
        emximp -o $(LIBADLL) $(LIBOMFDLL)
.ENDIF

.IF $(MAKELIBA)==Y
$(LIBA): $(OBJS) $(ADDOBJS)
	-+@ rm $(LIBA) 1>nul 2>nul
.IF $(QUIET)!=Y
	$(AR) r $(LIBA) $(OBJS) $(ADDOBJS)
.ELSE
        @ echo Creating $(LIBA)
        @ $(AR) r $(LIBA) $(OBJS) $(ADDOBJS)
.ENDIF
.ENDIF

.IF $(MAKELIBOMF)==Y
$(LIB): $(OBJS) $(ADDOBJS)
        emxomfar rv $(LIB) $(OBJS) $(ADDOBJS)
.ENDIF

.IF $(NEXTMAKEFILE)
$(NEXTMAKEFILE) .PHONY .PRECIOUS: $(DEFAULT)
.IF $(QUIET)!=Y
	sh -c "$(MAKECMD) $(MFLAGS) -f $(NEXTMAKEFILE)"
.ELSE
	@ echo ------------------ $(NEXTMAKEFILE) ------------------
	@ sh -c "$(MAKECMD) $(MFLAGS) -f $(NEXTMAKEFILE)"	
.ENDIF
.ENDIF

.IF $(MAKEDEP)==Y
.INCLUDE: $(DEPFILE)
.ENDIF

