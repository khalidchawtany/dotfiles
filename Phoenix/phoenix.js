'use strict';

var modal_keys = [];
var mash = 'cmd+alt+shift+ctrl'.split('+');
var ctrl_alt = 'ctrl+alt'.split('+');
var margin = 0.000001;
var increment = 0.1;
var increment_movement = 10;


/* Mixed Bindings {{{1 */

// Key.on('\\', ctrl_alt , function () {
/*
 * Check if nvim-qt is running if it is running toggle it's focus.
 * If nvim-qt is not running check for MacVim and toggle it's focus.
 * If none is running run nvim-qt
 */
Key.on('return', ctrl_alt , function () {
	var nvim_qt = App.get('nvim-qt');
	var MacVim = App.get('MacVim');
	if(!nvim_qt) {
		//PATH="/usr/local/sbin:/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Volumes/Home/.cargo/bin:/Volumes/Home/bin:/Volumes/Home/.local/bin:/Volumes/Home/.composer/vendor/bin:/Volumes/Home/Library/Developer/Xamarin/android-sdk-macosx/platform-tools:/usr/local/opt/go/libexec/bin:/usr/local/Cellar/php56/5.6.16/bin:/Volumes/Home/Development/go/bin" /Volumes/Home/Development/Applications/neovim-qt/build/bin/nvim-qt &
		//App.launch('nvim-qt');
		if(!MacVim){ //Only Run nvim-qt if MacVim is not running
			//Task.run('/bin/sh', ['/Volumes/Home/bin/nvq']);
			//new Task('/bin/sh', ['/Volumes/Home/bin/nvq']);
			App.launch('nvim-qt');
		}
		else {
			if(MacVim.isActive()) {
				MacVim.hide();
			}
			else if(MacVim.isHidden()) {
				MacVim.show();
				MacVim.focus();
			}
			else {
				MacVim.focus();
			}
		}
	}
	else {
		if(nvim_qt.isActive()) {
			nvim_qt.hide();
		}
		else if(nvim_qt.isHidden()) {
			nvim_qt.show();
			nvim_qt.focus();
		}
		else {
			nvim_qt.show();
			nvim_qt.focus();
		}
	}
});


Key.on('delete', ctrl_alt , function () {
  var firefox = App.get('FirefoxDeveloperEdition');
  if(!firefox)
    App.launch('FirefoxDeveloperEdition');
  else
    if(firefox.isActive())
      firefox.hide();
    else if(firefox.isHidden()) {
      firefox.show();
      firefox.focus();
    }
    else
      firefox.focus();
});


Key.on('home', mash , function () {
  var finder = App.get('Finder');
  if(!finder)
    App.launch('Finder');
  else
    if(finder.isActive())
      finder.hide();
    else if(finder.isHidden()) {
      finder.show();
      finder.focus();
    }
    else
      finder.focus();
});


function alert(message, window) {
  var window = Window.focused().screen().visibleFrameInRectangle();
  var modal = new Modal();
  //modal.origin = {x:window.width/2, y:window.height/2};
  modal.message = message;
  modal.duration = 2;
  var center_hor = window.width/2 - modal.frame().width/2;
  var center_ver = window.height/2 - modal.frame().height/2
  modal.origin={x:center_hor, y:center_ver};
  modal.show();
}

//Key.on('end', mash , function () {
  //alert("hello yy");
//});





Key.on('z', [ 'ctrl', 'shift' ], function () {

  var screen = Screen.main().flippedVisibleFrame();
  var window = Window.focused();

  if (window) {
    window.setTopLeft({
      x: screen.x + (screen.width / 2) - (window.frame().width / 2),
      y: screen.y + (screen.height / 2) - (window.frame().height / 2)
    });
  }
});

