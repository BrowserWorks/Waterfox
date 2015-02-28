;;; loaddefs.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (ede-cpp-root-project-root) "ede/cpp-root" "cpp-root.el"
;;;;;;  "390335e8b40807bcc7dd6b9ecfbbb786")
;;; Generated autoloads from cpp-root.el

(autoload 'ede-cpp-root-project-root "ede/cpp-root" "\
Get the root directory for DIR.

\(fn &optional DIR)" nil nil)

(ede-add-project-autoload (ede-project-autoload "cpp-root" :name "CPP ROOT" :file 'ede-cpp-root :proj-file 'ede-cpp-root-project-file-for-dir :proj-root 'ede-cpp-root-project-root :load-type 'ede-cpp-root-load :class-sym 'ede-cpp-root :new-p nil :safe-p t) 'unique)

;;;***

;;;### (autoloads (ede-project-sort-targets ede-customize-current-target
;;;;;;  ede-customize-project) "ede/custom" "custom.el" "856181c6583938388b9fa46720cb2b25")
;;; Generated autoloads from custom.el

(autoload 'ede-customize-project "ede/custom" "\
Edit fields of the current project through EIEIO & Custom.

\(fn)" t nil)

(defalias 'customize-project 'ede-customize-project)

(autoload 'ede-customize-current-target "ede/custom" "\
Edit fields of the current target through EIEIO & Custom.

\(fn)" t nil)

(defalias 'customize-target 'ede-customize-current-target)

(autoload 'ede-project-sort-targets "ede/custom" "\
Create a custom-like buffer for sorting targets of current project.

\(fn)" t nil)

;;;***

;;;### (autoloads (ede-emacs-project-root) "ede/emacs" "emacs.el"
;;;;;;  "314cd162c83d80b4e3e58e70e5298438")
;;; Generated autoloads from emacs.el

(autoload 'ede-emacs-project-root "ede/emacs" "\
Get the root directory for DIR.

\(fn &optional DIR)" nil nil)

(ede-add-project-autoload (ede-project-autoload "emacs" :name "EMACS ROOT" :file 'ede/emacs :proj-file "src/emacs.c" :proj-root-dirmatch "emacs[^/]*" :proj-root 'ede-emacs-project-root :load-type 'ede-emacs-load :class-sym 'ede-emacs-project :new-p nil :safe-p t) 'unique)

;;;***

;;;### (autoloads (ede-find-file) "ede/files" "files.el" "feaabd59d89f91d8c0a2684a5c1094de")
;;; Generated autoloads from files.el

(autoload 'ede-find-file "ede/files" "\
Find FILE in project.  FILE can be specified without a directory.
There is no completion at the prompt.  FILE is searched for within
the current EDE project.

\(fn FILE)" t nil)

;;;***

;;;### (autoloads (ede-enable-generic-projects) "ede/generic" "generic.el"
;;;;;;  "f8cee9b06faf0fbfd680e27f27cd0a86")
;;; Generated autoloads from generic.el

(autoload 'ede-enable-generic-projects "ede/generic" "\
Enable generic project loaders.

\(fn)" t nil)

;;;***

;;;### (autoloads (ede-linux-load ede-linux-project-root) "ede/linux"
;;;;;;  "linux.el" "1dffda7f812a76dc23f1bddb1b75b0ba")
;;; Generated autoloads from linux.el

(autoload 'ede-linux-project-root "ede/linux" "\
Get the root directory for DIR.

\(fn &optional DIR)" nil nil)

(autoload 'ede-linux-load "ede/linux" "\
Return an Linux Project object if there is a match.
Return nil if there isn't one.
Argument DIR is the directory it is created for.
ROOTPROJ is nil, since there is only one project.

\(fn DIR &optional ROOTPROJ)" nil nil)

(ede-add-project-autoload (ede-project-autoload "linux" :name "LINUX ROOT" :file 'ede/linux :proj-file "scripts/ver_linux" :proj-root-dirmatch "linux[^/]*" :proj-root 'ede-linux-project-root :load-type 'ede-linux-load :class-sym 'ede-linux-project :new-p nil :safe-p t) 'unique)

;;;***

;;;### (autoloads (ede-enable-locate-on-project) "ede/locate" "locate.el"
;;;;;;  "75746759e62640f3ca35db80d57481dc")
;;; Generated autoloads from locate.el

(autoload 'ede-enable-locate-on-project "ede/locate" "\
Enable an EDE locate feature on PROJECT.
Attempt to guess which project locate style to use
based on `ede-locate-setup-options'.

\(fn &optional PROJECT)" t nil)

;;;***

;;;### (autoloads (ede-make-check-version) "ede/make" "make.el" "84364d952d6bc626c1a605a7e823c3cb")
;;; Generated autoloads from make.el

(autoload 'ede-make-check-version "ede/make" "\
Check the version of GNU Make installed.
The check passes if the MAKE version is no high enough, or if it
is not GNU make.
If NOERROR is non-nil, return t for success, nil for failure.
If NOERROR is nil, then throw an error on failure.  Return t otherwise.

\(fn &optional NOERROR)" t nil)

;;;***

;;;### (autoloads (ede-speedbar-file-setup) "ede/speedbar" "speedbar.el"
;;;;;;  "ac8d088844e4cfc7ec3aa18e85f395d1")
;;; Generated autoloads from speedbar.el

(autoload 'ede-speedbar-file-setup "ede/speedbar" "\
Setup some keybindings in the Speedbar File display.

\(fn)" nil nil)

;;;***

;;;### (autoloads (ede-vc-project-directory ede-upload-html-documentation
;;;;;;  ede-upload-distribution ede-edit-web-page ede-web-browse-home)
;;;;;;  "ede/system" "system.el" "af9b58fc58b806c47ac6eebb05f595dd")
;;; Generated autoloads from system.el

(autoload 'ede-web-browse-home "ede/system" "\
Browse the home page of the current project.

\(fn)" t nil)

(autoload 'ede-edit-web-page "ede/system" "\
Edit the web site for this project.

\(fn)" t nil)

(autoload 'ede-upload-distribution "ede/system" "\
Upload the current distribution to the correct location.
Use /user@ftp.site.com: file names for FTP sites.
Download tramp, and use /r:machine: for names on remote sites w/out FTP access.

\(fn)" t nil)

(autoload 'ede-upload-html-documentation "ede/system" "\
Upload the current distributions documentation as HTML.
Use /user@ftp.site.com: file names for FTP sites.
Download tramp, and use /r:machine: for names on remote sites w/out FTP access.

\(fn)" t nil)

(autoload 'ede-vc-project-directory "ede/system" "\
Run `vc-dir' on the current project.

\(fn)" t nil)

;;;***

;;;### (autoloads (ede-update-version) "ede/util" "util.el" "7694c70ea28eab86440b482cf66e8f73")
;;; Generated autoloads from util.el

(autoload 'ede-update-version "ede/util" "\
Update the current projects main version number.
Argument NEWVERSION is the version number to use in the current project.

\(fn NEWVERSION)" t nil)

;;;***

(provide 'loaddefs)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; loaddefs.el ends here
