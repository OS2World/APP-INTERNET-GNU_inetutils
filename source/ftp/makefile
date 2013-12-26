TYPE		= VIO
SRC 		= cmds cmdtab ftp main ruserpass domacro
PROG		= ftp
CFLAGS		= -I../include -I../headers -I../bsd-h 
CFLAGS		+= -DHAVE_TERMIO_H -DHAVE_TERMIOS_H -DHAVE_MALLOC_H -DHAVE_NETINET_IP_H \
		   -DHAVE_NETINET_IN_SYSTM_H -DHAS_GETTOS \
		   -DNO_CC_T -DRETSIGTYPE=void -Dstrncasecmp=strnicmp -Dunix \
		   -Dstrcasecmp=stricmp -include ../headers/emx.h \
                   -DTERMCAP -DENV_HACK -DHAVE_STRDUP -Dfd_set=_fd_set 
LFLAGS		= -lsocket -lcurses \
                  -L../libinetutils -llibinetutils
ALLWARNINGS	= N
WARNERR		= N
NICE		= Y
DEBUG		= N

.INCLUDE: "../std.mk"

