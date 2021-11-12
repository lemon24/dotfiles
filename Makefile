install: install-zsh install-xonsh install-direnv install-kate

install-sh:
	rm -f ~/.shrc
	ln -s `pwd`/shrc ~/.shrc

install-zsh: install-sh
	rm -f ~/.zshrc
	ln -s `pwd`/zshrc ~/.zshrc

install-xonsh: install-sh
	rm -f ~/.xonshrc
	ln -s `pwd`/xonshrc ~/.xonshrc

install-direnv:
	rm -f ~/.config/direnv/direnvrc
	ln -s `pwd`/direnvrc ~/.config/direnv/direnvrc

install-kate:
	mkdir -p ~/Library/Application\ Support/org.kde.syntax-highlighting/themes
	ln -sf `pwd`/kate/themes/* ~/Library/Application\ Support/org.kde.syntax-highlighting/themes
	mkdir -p ~/Library/Application\ Support/katepart5
	rm -rf ~/Library/Application\ Support/katepart5/syntax
	ln -s `pwd`/kate/syntax ~/Library/Application\ Support/katepart5/syntax
