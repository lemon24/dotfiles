install: install-zsh install-xonsh install-direnv

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
