COMPOSER_CMD=composer
PHIVE_CMD=phive
GPG_CMD=gpg

BOX_CMD=tools/box

.DEFAULT_GOAL=all

TARGET=phpeg.phar

SIGNATURE=${TARGET}.asc
SIGNATURE_ID=hannes.forsgard@fripost.org

.PHONY: all
all: build sign

.PHONY: clean
clean:
	rm -f composer.lock
	rm -rf vendor
	rm -rf tools
	rm -f $(TARGET)
	rm -f $(SIGNATURE)

.PHONY: build
build: $(TARGET)

$(TARGET): composer.lock box.json $(BOX_CMD)
	# TODO box does not currently run with php8, this is a temporary fix
	php7.4 -d phar.readonly=0 $(BOX_CMD) compile --no-restart
	# $(BOX_CMD) compile

.PHONY: sign
sign: $(SIGNATURE)

$(SIGNATURE): $(TARGET)
	$(GPG_CMD) -u $(SIGNATURE_ID) --detach-sign --output $@ $<

composer.lock:
	$(COMPOSER_CMD) install

$(BOX_CMD):
	$(PHIVE_CMD) install --force-accept-unsigned
