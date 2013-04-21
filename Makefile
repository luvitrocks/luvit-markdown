PREFIX?=/usr/local
LIBDIR?=${PREFIX}/lib/luvit

.PHONY: test

install:
	@mkdir -p "${LIBDIR}"
	@mkdir -p "${LIBDIR}/markdown"

	@if [ ! -w "${LIBDIR}" ]; then \
		echo "Target directory \"${LIBDIR}\" is not writable."; \
		echo "Try installing with a suitable user."; \
		exit 1; \
	fi

	@cp    src/markdown.lua "${LIBDIR}/markdown.lua";
	@cp -R src/markdown 	"${LIBDIR}"

	@echo "Installation completed!"

uninstall:
	@if [ -f "${LIBDIR}/markdown.lua" ] && [ ! -w "${LIBDIR}/markdown.lua" ]; then \
		echo "Not allowed to delete \"${LIBDIR}/markdown.lua\"."; \
		echo "Try uninstalling with a suitable user."; \
		exit 1; \
	fi

	@rm -f  "${LIBDIR}/markdown.lua"
	@rm -rf "${LIBDIR}/markdown"

	@echo "Uninstallation completed!"

test:
	@luvit test/markdown.lua
	@echo "Tests completed!"
