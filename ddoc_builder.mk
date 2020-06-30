DDOCREPO?=${shell git rev-parse --show-toplevel}

ifndef DDOCHELP
DDOCHELP:=help-ddoc
HELP+=$(DDOCHELP)
else
CADRYROOT:=$(DDOCREPO)/candydoc/
DOCBEGIN:= $(DDOCREPO)/begin.html
DOCEND:= $(DDOCREPO)/end.html
DDOCSCRIPT:=$(DDOCREPO)/scripts/ddocmodule.pl
DDOCINDEX?=$(DDOCROOT)/index.html
DDOCWORKDIR?=/tmp/$(GIT_HASH)/
DDOCMODULES?=modules.ddoc

help-ddoc:
	@echo "make ddoc      : Creates source documentation"
	@echo

ddoc: $(DDOCINDEX)

$(DDOCINDEX): $(DDOCWORKDIR) $(DDOCMODULES)
	@echo "########################################################################################"
	@echo "## Creating DDOC"
	${PRECMD}cp -a $(CADRYROOT) $(DDOCROOT)
	$(PRECMD)$(DC) ${INCFLAGS} $(DDOCFLAGS) $(DDOCFILES) $(DFILES) $(DD)$(DDOCWORKDIR)
	$(PRECMD)cat $(DDOCBEGIN) $(DDOCWORKDIR)/*.html $(DOCBEGIN) > $@


$(DDOCMODULES): $(DFILES)
	$(PRECMD)echo $(DFILES) | $(DDOCSCRIPT) > $@

$(DDOCWORKDIR):
	mkdir -p $@

clean-ddoc:
	rm -fR $(DDOCWORKDIR)

CLEANER+=clean-ddoc

endif
