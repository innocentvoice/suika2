usage:
	@echo "Type one of the following commands:"
	@echo "  make setup ... setup wine and python"
	@echo "  make bin   ... build a binary"

setup:
	sudo apt-get update
	sudo apt-get install wine wine64 winetricks
	wget https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe
	WINEPREFIX=`pwd`/.wine64 WINARCH=win64 winetricks corefonts win10
	WINEPREFIX=`pwd`/.wine64 WINARCH=win64 wine cmd /c python-3.11.5-amd64.exe /quiet PrependPath=1
	WINEPREFIX=`pwd`/.wine64 WINARCH=win64 winetricks vcrun2015
	WINEPREFIX=`pwd`/.wine64 WINARCH=win64 wine "C:\\users\\`whoami`\\Local Settings\\Application Data\\Programs\\Python\\Python311\\python.exe" -m pip install pyinstaller

bin:
	WINEPREFIX=`pwd`/.wine64 WINARCH=win64 wine "C:\\users\\`whoami`\\Local Settings\\Application Data\\Programs\\Python\\Python311\\python.exe" -m PyInstaller --icon ../../build/mingw/res/suika.ico --noconsole --onefile routes.py
	rm -rf suika-routes
	mkdir suika-routes
	cp dist/routes.exe suika-routes/suika-routes.exe
	cp -R readme-jp.txt readme-en.txt txt suika-routes/
	if [ ! -z "`which sign.sh`" ]; then sign.sh suika-routes/suika-routes.exe; fi
	zip -r suika-routes.zip suika-routes

clean:
	rm -rf build dist routes.spec suika-routes.zip suika-routes python-3.11.5-amd64.exe
