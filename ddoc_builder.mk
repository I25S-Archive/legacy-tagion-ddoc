DDOCREPO?=${shell git rev-parse --show-toplevel}

ifndef DDOCHELP
DDOCHELP:=help-ddoc
HELP+=$(DDOCHELP)
help-ddoc:
	@echo "make ddoc      : Creates source documentation"
	@echo

else
CADRYDOOT:=$(DDOCREPO)/candydoc/
DOCBEGIN:= $(DDOCREPO)/begin.html
DOCEND:= $(DDOCREPO)/end.html
DDOCSCRIPT:=$(DDOCREPO)/scripts/ddocmodule.pl
DDOCINDEX?=$(DDOCROOT)/index.html
DDOCWORKDIR?=/tmp/$(GIT_HASH)/

test:
	git rev-parse HEAD

ddoc: $(DDOCINDEX)

$(DDOCINDEX): $(DDOCWORKDIR) $(DDOCMODULES)
	@echo "########################################################################################"
	@echo "## Creating DDOC"
	${PRECMD}cp -a $(CADRYDOOT) $(DDOCROOT)
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
