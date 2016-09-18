note_files = $(patsubst %.md,%.html,$(shell find notes/ -type f -name "*.md"))

all: notes

notes: $(note_files) notes.html

notes/%.html: notes/%.md stasi/templates/notes/header.html stasi/templates/notes/footer.html
	./stasi/md2html.sh $^ > $@

notes.html: stasi/notes.sh stasi/templates/default/header.html stasi/templates/default/footer.html $(note_files)
	./stasi/notes.sh > $@

%.html: %.md stasi/templates/default/header.html stasi/templates/default/footer.html
	./stasi/md2html.sh $^ > $@
