COMMONFORM=node_modules/.bin/commonform
BUILD=build
FORMS=$(wildcard *.cform)

all: docx pdf

docx: $(addprefix $(BUILD)/,$(FORMS:.cform=.docx))

pdf: $(addprefix $(BUILD)/,$(FORMS:.cform=.pdf))

$(BUILD):
	mkdir $(BUILD)

$(BUILD)/%.docx: %.cform %.json %.options | $(COMMONFORM) $(BUILD)
	$(COMMONFORM) render -f docx $(shell cat $*.options) -s $*.json $< > $@

$(BUILD)/%.pdf: $(BUILD)/%.docx
	doc2pdf $<

$(COMMONFORM):
	npm install

.PHONY: clean docker

clean:
	rm -rf $(BUILD)

DOCKER_TAG=safte

docker:
	docker build -t $(DOCKER_TAG) .
	docker run --name $(DOCKER_TAG) $(DOCKER_TAG)
	docker cp $(DOCKER_TAG):/workdir/$(BUILD) .
	docker rm $(DOCKER_TAG)
