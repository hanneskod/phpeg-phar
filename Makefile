COMPOSER_CMD=composer
PHIVE_CMD=phive

BOX_CMD=tools/box

.DEFAULT_GOAL=build

TARGET=phpeg.phar

.PHONY: clean
clean:
	rm -f composer.lock
	rm -rf vendor
	rm -rf tools

.PHONY: build
build: $(TARGET)

$(TARGET): composer.lock box.json $(BOX_CMD)
	# TODO box does not currently run with php8, this is a temporary fix
	php7.4 -d phar.readonly=0 $(BOX_CMD) compile --no-restart
	# $(BOX_CMD) compile

composer.lock:
	$(COMPOSER_CMD) install

$(BOX_CMD):
	$(PHIVE_CMD) install --force-accept-unsigned
