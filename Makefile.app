# Command Line Application Makefile
#
# Copyright (C) 2011 Jeffrey S. Perry
#
# contact: jeffsp@gmail.com

.SUFFIXES:
.PHONY: all install clean release

# You must define TARGET before you include this make file
MAKE_FILE=$(TARGET).Makefile
PRO_FILE=$(TARGET).pro
MAN_FILE=$(TARGET).1.gz
GROFF_FILE=$(TARGET).groff
QTFLAGS=CONFIG+=debug CONFIG-=qt

all: $(MAKE_FILE) $(MAN_FILE)
	$(MAKE) -f $<

$(MAKE_FILE): $(PRO_FILE)
	qmake -o $@ $< $(QTFLAGS) INCLUDEPATH+="$(INCLUDEPATH)" DEPENDPATH+="$(DEPENDPATH)" SOURCES+="$(EXTRA_SOURCES)" LIBS+="$(LIBS)" OBJECTS_DIR+=obj

%.pro: Makefile
	qmake -project -nopwd -o $*.pro $*.cc

$(MAN_FILE): $(GROFF_FILE)
	groff -man -Tascii $(GROFF_FILE) | gzip -c > $(MAN_FILE)

install: clean release
	sudo install $(TARGET) /usr/local/bin
	sudo install $(MAN_FILE) /usr/local/share/man/man1

clean:
	-$(MAKE) -f $(MAKE_FILE) clean
	rm -f *.o $(TARGET) $(PRO_FILE) $(MAKE_FILE)
	rm -f $(MAN_FILE)

%.clean:

release:
	$(MAKE) "QTFLAGS=CONFIG+=release DEFINES+=NDEBUG CONFIG-=qt"
