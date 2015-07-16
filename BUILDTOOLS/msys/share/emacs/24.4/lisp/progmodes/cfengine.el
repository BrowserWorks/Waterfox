;;; cfengine.el --- mode for editing Cfengine files

;; Copyright (C) 2001-2014 Free Software Foundation, Inc.

;; Author: Dave Love <fx@gnu.org>
;; Maintainer: Ted Zlatanov <tzz@lifelogs.com>
;; Keywords: languages
;; Version: 1.3

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Provides support for editing GNU Cfengine files, including
;; font-locking, Imenu and indentation, but with no special keybindings.

;; The CFEngine 3.x support doesn't have Imenu support but patches are
;; welcome.

;; By default, CFEngine 3.x syntax is used.

;; You can set it up so either `cfengine2-mode' (2.x and earlier) or
;; `cfengine3-mode' (3.x) will be picked, depending on the buffer
;; contents:

;; (add-to-list 'auto-mode-alist '("\\.cf\\'" . cfengine-auto-mode))

;; OR you can choose to always use a specific version, if you prefer
;; it:

;; (add-to-list 'auto-mode-alist '("\\.cf\\'" . cfengine3-mode))
;; (add-to-list 'auto-mode-alist '("^cf\\." . cfengine2-mode))
;; (add-to-list 'auto-mode-alist '("^cfagent.conf\\'" . cfengine2-mode))

;; It's *highly* recommended that you enable the eldoc minor mode:

;; (add-hook 'cfengine3-mode-hook 'eldoc-mode)

;; This is not the same as the mode written by Rolf Ebert
;; <ebert@waporo.muc.de>, distributed with cfengine-2.0.5.  It does
;; better fontification and indentation, inter alia.

;;; Code:

(autoload 'json-read "json")
(autoload 'regexp-opt "regexp-opt")

(defgroup cfengine ()
  "Editing CFEngine files."
  :group 'languages)

(defcustom cfengine-indent 2
  "Size of a CFEngine indentation step in columns."
  :group 'cfengine
  :type 'integer)

(defcustom cfengine-cf-promises
  (or (executable-find "cf-promises")
      (executable-find "/var/cfengine/bin/cf-promises")
      (executable-find "/usr/bin/cf-promises")
      (executable-find "/usr/sbin/cf-promises")
      (executable-find "/usr/local/bin/cf-promises")
      (executable-find "/usr/local/sbin/cf-promises")
      (executable-find "~/bin/cf-promises")
      (executable-find "~/sbin/cf-promises"))
  "The location of the cf-promises executable.
Used for syntax discovery and checking.  Set to nil to disable
the `compile-command' override.  In that case, the ElDoc support
will use a fallback syntax definition."
  :version "24.4"
  :group 'cfengine
  :type '(choice file (const nil)))

(defcustom cfengine-parameters-indent '(promise pname 0)
  "Indentation of CFEngine3 promise parameters (hanging indent).

For example, say you have this code:

bundle x y
{
  section:
    class::
      promise ...
      promiseparameter => ...
}

You can choose to indent promiseparameter from the beginning of
the line (absolutely) or from the word \"promise\" (relatively).

You can also choose to indent the start of the word
\"promiseparameter\" or the arrow that follows it.

Finally, you can choose the amount of the indent.

The default is to anchor at promise, indent parameter name, and offset 0:

bundle agent rcfiles
{
  files:
    any::
      \"/tmp/netrc\"
      comment => \"my netrc\",
      perms => mog(\"600\", \"tzz\", \"tzz\");
}

Here we anchor at beginning of line, indent arrow, and offset 10:

bundle agent rcfiles
{
  files:
    any::
      \"/tmp/netrc\"
  comment => \"my netrc\",
    perms => mog(\"600\", \"tzz\", \"tzz\");
}

Some, including cfengine_stdlib.cf, like to anchor at promise, indent
arrow, and offset 16 or so:

bundle agent rcfiles
{
  files:
    any::
      \"/tmp/netrc\"
              comment => \"my netrc\",
                perms => mog(\"600\", \"tzz\", \"tzz\");
}
"
  :version "24.4"
  :group 'cfengine
  :type '(list
          (choice (const :tag "Anchor at beginning of promise" promise)
                  (const :tag "Anchor at beginning of line" bol))
          (choice (const :tag "Indent parameter name" pname)
                  (const :tag "Indent arrow" arrow))
          (integer :tag "Indentation amount from anchor")))

(defvar cfengine-mode-debug nil
  "Whether `cfengine-mode' should print debugging info.")

(defvar cfengine-mode-syntax-cache nil
  "Cache for `cfengine-mode' syntax trees obtained from 'cf-promises -s json'.")

(defconst cfengine3-fallback-syntax
  '((functions
     (userexists
      (category . "system") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (usemodule
      (category . "utils") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (unique
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "slist") (status . "normal"))
     (translatepath
      (category . "files") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))])
      (returnType . "string") (status . "normal"))
     (sum
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "real") (status . "normal"))
     (sublist
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . "head,tail") (type . "option"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "slist") (status . "normal"))
     (strftime
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "gmtime,localtime") (type . "option"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "string") (status . "normal"))
     (strcmp
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (splitstring
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "slist") (status . "normal"))
     (splayclass
      (category . "utils") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . "daily,hourly") (type . "option"))])
      (returnType . "context") (status . "normal"))
     (sort
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . "lex") (type . "string"))])
      (returnType . "slist") (status . "normal"))
     (some
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (shuffle
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . ".*") (type . "string"))])
      (returnType . "slist") (status . "normal"))
     (selectservers
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . "@[(][a-zA-Z0-9]+[)]") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))
                     ((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "int") (status . "normal"))
     (reverse
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "slist") (status . "normal"))
     (rrange
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "-9.99999E100,9.99999E100") (type . "real"))
                     ((range . "-9.99999E100,9.99999E100") (type . "real"))])
      (returnType . "rrange") (status . "normal"))
     (returnszero
      (category . "utils") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))
                     ((range . "useshell,noshell,powershell") (type . "option"))])
      (returnType . "context") (status . "normal"))
     (remoteclassesmatching
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "true,false,yes,no,on,off") (type . "option"))
                     ((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (remotescalar
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "true,false,yes,no,on,off") (type . "option"))])
      (returnType . "string") (status . "normal"))
     (regldap
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "subtree,onelevel,base") (type . "option"))
                     ((range . ".*") (type . "string"))
                     ((range . "none,ssl,sasl") (type . "option"))])
      (returnType . "context") (status . "normal"))
     (reglist
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "@[(][a-zA-Z0-9]+[)]") (type . "string"))
                     ((range . ".*") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (regline
      (category . "io") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (registryvalue
      (category . "system") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))])
      (returnType . "string") (status . "normal"))
     (regextract
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (regcmp
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (regarray
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . ".*") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (readtcp
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "string") (status . "normal"))
     (readstringlist
      (category . "io") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "slist") (status . "normal"))
     (readstringarrayidx
      (category . "io") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . "\"?(/.*)") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "int") (status . "normal"))
     (readstringarray
      (category . "io") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . "\"?(/.*)") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "int") (status . "normal"))
     (readreallist
      (category . "io") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "rlist") (status . "normal"))
     (readrealarray
      (category . "io") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . "\"?(/.*)") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "int") (status . "normal"))
     (readintlist
      (category . "io") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "ilist") (status . "normal"))
     (readintarray
      (category . "io") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . "\"?(/.*)") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "int") (status . "normal"))
     (readfile
      (category . "io") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "string") (status . "normal"))
     (randomint
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "-99999999999,9999999999") (type . "int"))
                     ((range . "-99999999999,9999999999") (type . "int"))])
      (returnType . "int") (status . "normal"))
     (product
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "real") (status . "normal"))
     (peerleaders
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "slist") (status . "normal"))
     (peerleader
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "string") (status . "normal"))
     (peers
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "slist") (status . "normal"))
     (parsestringarrayidx
      (category . "io") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . "\"?(/.*)") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "int") (status . "normal"))
     (parsestringarray
      (category . "io") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . "\"?(/.*)") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "int") (status . "normal"))
     (parserealarray
      (category . "io") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . "\"?(/.*)") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "int") (status . "normal"))
     (parseintarray
      (category . "io") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . "\"?(/.*)") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "int") (status . "normal"))
     (or
      (category . "data") (variadic . t)
      (parameters . [])
      (returnType . "string") (status . "normal"))
     (on
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "1970,3000") (type . "int"))
                     ((range . "1,12") (type . "int"))
                     ((range . "1,31") (type . "int"))
                     ((range . "0,23") (type . "int"))
                     ((range . "0,59") (type . "int"))
                     ((range . "0,59") (type . "int"))])
      (returnType . "int") (status . "normal"))
     (nth
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "string") (status . "normal"))
     (now
      (category . "system") (variadic . :json-false)
      (parameters . [])
      (returnType . "int") (status . "normal"))
     (not
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))])
      (returnType . "string") (status . "normal"))
     (none
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (maplist
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "slist") (status . "normal"))
     (maparray
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "slist") (status . "normal"))
     (lsdir
      (category . "files") (variadic . :json-false)
      (parameters . [((range . ".+") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "true,false,yes,no,on,off") (type . "option"))])
      (returnType . "slist") (status . "normal"))
     (length
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "int") (status . "normal"))
     (ldapvalue
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "subtree,onelevel,base") (type . "option"))
                     ((range . "none,ssl,sasl") (type . "option"))])
      (returnType . "string") (status . "normal"))
     (ldaplist
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "subtree,onelevel,base") (type . "option"))
                     ((range . "none,ssl,sasl") (type . "option"))])
      (returnType . "slist") (status . "normal"))
     (ldaparray
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . "subtree,onelevel,base") (type . "option"))
                     ((range . "none,ssl,sasl") (type . "option"))])
      (returnType . "context") (status . "normal"))
     (laterthan
      (category . "files") (variadic . :json-false)
      (parameters . [((range . "0,1000") (type . "int"))
                     ((range . "0,1000") (type . "int"))
                     ((range . "0,1000") (type . "int"))
                     ((range . "0,1000") (type . "int"))
                     ((range . "0,1000") (type . "int"))
                     ((range . "0,40000") (type . "int"))])
      (returnType . "context") (status . "normal"))
     (lastnode
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))])
      (returnType . "string") (status . "normal"))
     (join
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "string") (status . "normal"))
     (isvariable
      (category . "utils") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (isplain
      (category . "files") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (isnewerthan
      (category . "files") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))
                     ((range . "\"?(/.*)") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (islink
      (category . "files") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (islessthan
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (isgreaterthan
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (isexecutable
      (category . "files") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (isdir
      (category . "files") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (irange
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "-99999999999,9999999999") (type . "int"))
                     ((range . "-99999999999,9999999999") (type . "int"))])
      (returnType . "irange") (status . "normal"))
     (iprange
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (intersection
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "slist") (status . "normal"))
     (ifelse
      (category . "data") (variadic . t)
      (parameters . [])
      (returnType . "string") (status . "normal"))
     (hubknowledge
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "string") (status . "normal"))
     (hostswithclass
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_]+") (type . "string"))
                     ((range . "name,address") (type . "option"))])
      (returnType . "slist") (status . "normal"))
     (hostsseen
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . "0,99999999999") (type . "int"))
                     ((range . "lastseen,notseen") (type . "option"))
                     ((range . "name,address") (type . "option"))])
      (returnType . "slist") (status . "normal"))
     (hostrange
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (hostinnetgroup
      (category . "system") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (ip2host
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))])
      (returnType . "string") (status . "normal"))
     (host2ip
      (category . "communication") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))])
      (returnType . "string") (status . "normal"))
     (hashmatch
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))
                     ((range . "md5,sha1,crypt,cf_sha224,cf_sha256,cf_sha384,cf_sha512") (type . "option"))
                     ((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (hash
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . "md5,sha1,sha256,sha512,sha384,crypt") (type . "option"))])
      (returnType . "string") (status . "normal"))
     (groupexists
      (category . "system") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (grep
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "slist") (status . "normal"))
     (getvalues
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "slist") (status . "normal"))
     (getusers
      (category . "system") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))])
      (returnType . "slist") (status . "normal"))
     (getuid
      (category . "system") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))])
      (returnType . "int") (status . "normal"))
     (getindices
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "slist") (status . "normal"))
     (getgid
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))])
      (returnType . "int") (status . "normal"))
     (getfields
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . "\"?(/.*)") (type . "string"))
                     ((range . ".*") (type . "string"))
                     ((range . ".*") (type . "string"))])
      (returnType . "int") (status . "normal"))
     (getenv
      (category . "system") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "string") (status . "normal"))
     (format
      (category . "data") (variadic . t)
      (parameters . [((range . ".*") (type . "string"))])
      (returnType . "string") (status . "normal"))
     (filter
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . "true,false,yes,no,on,off") (type . "option"))
                     ((range . "true,false,yes,no,on,off") (type . "option"))
                     ((range . "0,99999999999") (type . "int"))])
      (returnType . "slist") (status . "normal"))
     (filestat
      (category . "files") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))
                     ((range . "size,gid,uid,ino,nlink,ctime,atime,mtime,mode,modeoct,permstr,permoct,type,devno,dev_minor,dev_major,basename,dirname") (type . "option"))])
      (returnType . "string") (status . "normal"))
     (filesize
      (category . "files") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))])
      (returnType . "int") (status . "normal"))
     (filesexist
      (category . "files") (variadic . :json-false)
      (parameters . [((range . "@[(][a-zA-Z0-9]+[)]") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (fileexists
      (category . "files") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (execresult
      (category . "utils") (variadic . :json-false)
      (parameters . [((range . ".+") (type . "string"))
                     ((range . "useshell,noshell,powershell") (type . "option"))])
      (returnType . "string") (status . "normal"))
     (every
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (escape
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))])
      (returnType . "string") (status . "normal"))
     (diskfree
      (category . "files") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))])
      (returnType . "int") (status . "normal"))
     (dirname
      (category . "files") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))])
      (returnType . "string") (status . "normal"))
     (difference
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
                     ((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))])
      (returnType . "slist") (status . "normal"))
     (countlinesmatching
      (category . "io") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))
                     ((range . "\"?(/.*)") (type . "string"))])
      (returnType . "int") (status . "normal"))
     (countclassesmatching
      (category . "utils") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))])
      (returnType . "int") (status . "normal"))
     (classesmatching
      (category . "utils") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))])
      (returnType . "slist") (status . "normal"))
     (classmatch
      (category . "utils") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (classify
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (changedbefore
      (category . "files") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))
                     ((range . "\"?(/.*)") (type . "string"))])
      (returnType . "context") (status . "normal"))
     (concat
      (category . "data") (variadic . t)
      (parameters . [])
      (returnType . "string") (status . "normal"))
     (canonify
      (category . "data") (variadic . :json-false)
      (parameters . [((range . ".*") (type . "string"))])
      (returnType . "string") (status . "normal"))
     (and
      (category . "data") (variadic . t)
      (parameters . [])
      (returnType . "string") (status . "normal"))
     (ago
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "0,1000") (type . "int"))
                     ((range . "0,1000") (type . "int"))
                     ((range . "0,1000") (type . "int"))
                     ((range . "0,1000") (type . "int"))
                     ((range . "0,1000") (type . "int"))
                     ((range . "0,40000") (type . "int"))])
      (returnType . "int") (status . "normal"))
     (accumulated
      (category . "data") (variadic . :json-false)
      (parameters . [((range . "0,1000") (type . "int"))
                     ((range . "0,1000") (type . "int"))
                     ((range . "0,1000") (type . "int"))
                     ((range . "0,1000") (type . "int"))
                     ((range . "0,1000") (type . "int"))
                     ((range . "0,40000") (type . "int"))])
      (returnType . "int") (status . "normal"))
     (accessedbefore
      (category . "files") (variadic . :json-false)
      (parameters . [((range . "\"?(/.*)") (type . "string"))
                     ((range . "\"?(/.*)") (type . "string"))])
      (returnType . "context") (status . "normal"))))
  "Fallback CFEngine syntax, containing just function definitions.")

(defvar cfengine-mode-syntax-functions-regex
  (regexp-opt (mapcar (lambda (def)
                        (format "%s" (car def)))
                      (cdr (assq 'functions cfengine3-fallback-syntax)))
              'symbols))

(defcustom cfengine-mode-abbrevs nil
  "Abbrevs for CFEngine2 mode."
  :group 'cfengine
  :type '(repeat (list (string :tag "Name")
		       (string :tag "Expansion")
		       (choice  :tag "Hook" (const nil) function))))

(make-obsolete-variable 'cfengine-mode-abbrevs 'edit-abbrevs "24.1")

;; Taken from the doc for pre-release 2.1.
(eval-and-compile
  (defconst cfengine2-actions
    '("acl" "alerts" "binservers" "broadcast" "control" "classes" "copy"
      "defaultroute" "disks" "directories" "disable" "editfiles" "files"
      "filters" "groups" "homeservers" "ignore" "import" "interfaces"
      "links" "mailserver" "methods" "miscmounts" "mountables"
      "processes" "packages" "rename" "required" "resolve"
      "shellcommands" "tidy" "unmount"
      ;; Keywords for cfservd.
      "admit" "grant" "deny")
    "List of the action keywords supported by Cfengine.
This includes those for cfservd as well as cfagent.")

  (defconst cfengine3-defuns
    (mapcar
     'symbol-name
     '(bundle body))
    "List of the CFEngine 3.x defun headings.")

  (defconst cfengine3-defuns-regex
    (regexp-opt cfengine3-defuns t)
    "Regex to match the CFEngine 3.x defuns.")

  (defconst cfengine3-class-selector-regex "\\([[:alnum:]_().&|!:]+\\)::")

  (defconst cfengine3-category-regex "\\([[:alnum:]_]+\\):")

  (defconst cfengine3-vartypes
    (mapcar
     'symbol-name
     '(string int real slist ilist rlist irange rrange counter data))
    "List of the CFEngine 3.x variable types."))

(defvar cfengine2-font-lock-keywords
  `(;; Actions.
    ;; List the allowed actions explicitly, so that errors are more obvious.
    (,(concat "^[ \t]*" (eval-when-compile
			  (regexp-opt cfengine2-actions t))
	      ":")
     1 font-lock-keyword-face)
    ;; Classes.
    ("^[ \t]*\\([[:alnum:]_().|!]+\\)::" 1 font-lock-function-name-face)
    ;; Variables.
    ("$(\\([[:alnum:]_]+\\))" 1 font-lock-variable-name-face)
    ("${\\([[:alnum:]_]+\\)}" 1 font-lock-variable-name-face)
    ;; Variable definitions.
    ("\\_<\\([[:alnum:]_]+\\)[ \t]*=[ \t]*(" 1 font-lock-variable-name-face)
    ;; File, acl &c in group:   { token ... }
    ("{[ \t]*\\([^ \t\n]+\\)" 1 font-lock-constant-face)))

(defvar cfengine3-font-lock-keywords
  `(
    ;; Defuns.  This happens early so they don't get caught by looser
    ;; patterns.
    (,(concat "\\_<" cfengine3-defuns-regex "\\_>"
              "[ \t]+\\_<\\([[:alnum:]_.:]+\\)\\_>"
              "[ \t]+\\_<\\([[:alnum:]_.:]+\\)"
              ;; Optional parentheses with variable names inside.
              "\\(?:(\\([^)]*\\))\\)?")
     (1 font-lock-builtin-face)
     (2 font-lock-constant-face)
     (3 font-lock-function-name-face)
     (4 font-lock-variable-name-face nil t))

    ;; Class selectors.
    (,(concat "^[ \t]*" cfengine3-class-selector-regex)
     1 font-lock-keyword-face)

    ;; Categories.
    (,(concat "^[ \t]*" cfengine3-category-regex)
     1 font-lock-builtin-face)

    ;; Variables, including scope, e.g. module.var
    ("[@$](\\([[:alnum:]_.:]+\\))" 1 font-lock-variable-name-face)
    ("[@$]{\\([[:alnum:]_.:]+\\)}" 1 font-lock-variable-name-face)

    ;; Variable definitions.
    ("\\_<\\([[:alnum:]_]+\\)[ \t]*=[ \t]*(" 1 font-lock-variable-name-face)

    ;; Variable types.
    (,(concat "\\_<" (eval-when-compile (regexp-opt cfengine3-vartypes t)) "\\_>")
     1 font-lock-type-face)))

(defvar cfengine2-imenu-expression
  `((nil ,(concat "^[ \t]*" (eval-when-compile
			      (regexp-opt cfengine2-actions t))
		  ":[^:]")
	 1)
    ("Variables/classes" "\\_<\\([[:alnum:]_]+\\)[ \t]*=[ \t]*(" 1)
    ("Variables/classes" "\\_<define=\\([[:alnum:]_]+\\)" 1)
    ("Variables/classes" "\\_<DefineClass\\>[ \t]+\\([[:alnum:]_]+\\)" 1))
  "`imenu-generic-expression' for CFEngine mode.")

(defun cfengine2-outline-level ()
  "`outline-level' function for CFEngine mode."
  (if (looking-at "[^:]+\\(?:[:]+\\)$")
      (length (match-string 1))))

(defun cfengine2-beginning-of-defun ()
  "`beginning-of-defun' function for CFEngine mode.
Treats actions as defuns."
  (unless (<= (current-column) (current-indentation))
    (end-of-line))
  (if (re-search-backward "^[[:alpha:]]+: *$" nil t)
      (beginning-of-line)
    (goto-char (point-min)))
  t)

(defun cfengine2-end-of-defun ()
  "`end-of-defun' function for CFEngine mode.
Treats actions as defuns."
  (end-of-line)
  (if (re-search-forward "^[[:alpha:]]+: *$" nil t)
      (beginning-of-line)
    (goto-char (point-max)))
  t)

;; Fixme: Should get an extra indent step in editfiles BeginGroup...s.

(defun cfengine2-indent-line ()
  "Indent a line in Cfengine mode.
Intended as the value of `indent-line-function'."
  (let ((pos (- (point-max) (point))))
    (save-restriction
      (narrow-to-defun)
      (back-to-indentation)
      (cond
       ;; Action selectors aren't indented; class selectors are
       ;; indented one step.
       ((looking-at "[[:alnum:]_().|!]+:\\(:\\)?")
	(if (match-string 1)
	    (indent-line-to cfengine-indent)
	  (indent-line-to 0)))
       ;; Outdent leading close brackets one step.
       ((or (eq ?\} (char-after))
	    (eq ?\) (char-after)))
	(condition-case ()
	    (indent-line-to (save-excursion
			      (forward-char)
			      (backward-sexp)
			      (current-column)))
	  (error nil)))
       ;; Inside brackets/parens: indent to start column of non-comment
       ;; token on line following open bracket or by one step from open
       ;; bracket's column.
       ((condition-case ()
	    (progn (indent-line-to (save-excursion
				     (backward-up-list)
				     (forward-char)
				     (skip-chars-forward " \t")
				     (if (looking-at "[^\n#]")
					 (current-column)
				       (skip-chars-backward " \t")
				       (+ (current-column) -1
					  cfengine-indent))))
		   t)
	  (error nil)))
       ;; Indent by  two steps after a class selector.
       ((save-excursion
	  (re-search-backward "^[ \t]*[[:alnum:]_().|!]+::" nil t))
	(indent-line-to (* 2 cfengine-indent)))
       ;; Indent by one step if we're after an action header.
       ((save-excursion
	  (goto-char (point-min))
	  (looking-at "[[:alpha:]]+:[ \t]*$"))
	(indent-line-to cfengine-indent))
       ;; Else don't indent.
       (t
	(indent-line-to 0))))
    ;; If initial point was within line's indentation,
    ;; position after the indentation.  Else stay at same point in text.
    (if (> (- (point-max) pos) (point))
	(goto-char (- (point-max) pos)))))

;; This doesn't work too well in Emacs 21.2.  See 22.1 development
;; code.
(defun cfengine-fill-paragraph (&optional justify)
  "Fill `paragraphs' in Cfengine code."
  (interactive "P")
  (or (if (fboundp 'fill-comment-paragraph)
	  (fill-comment-paragraph justify) ; post Emacs 21.3
	;; else do nothing in a comment
	(nth 4 (parse-partial-sexp (save-excursion
				     (beginning-of-defun)
				     (point))
				   (point))))
      (let ((paragraph-start
	     ;; Include start of parenthesized block.
	     "\f\\|[ \t]*$\\|.*\(")
	    (paragraph-separate
	     ;; Include action and class lines, start and end of
	     ;; bracketed blocks and end of parenthesized blocks to
	     ;; avoid including these in fill.  This isn't ideal.
	     "[ \t\f]*$\\|.*#\\|.*[\){}]\\|\\s-*[[:alpha:]_().|!]+:")
	    fill-paragraph-function)
	(fill-paragraph justify))
      t))

(defun cfengine3-beginning-of-defun ()
  "`beginning-of-defun' function for Cfengine 3 mode.
Treats body/bundle blocks as defuns."
  (unless (<= (current-column) (current-indentation))
    (end-of-line))
  (if (re-search-backward (concat "^[ \t]*" cfengine3-defuns-regex "\\_>") nil t)
      (beginning-of-line)
    (goto-char (point-min)))
  t)

(defun cfengine3-end-of-defun ()
  "`end-of-defun' function for Cfengine 3 mode.
Treats body/bundle blocks as defuns."
  (end-of-line)
  (if (re-search-forward (concat "^[ \t]*" cfengine3-defuns-regex "\\_>") nil t)
      (beginning-of-line)
    (goto-char (point-max)))
  t)

(defun cfengine3-indent-line ()
  "Indent a line in Cfengine 3 mode.
Intended as the value of `indent-line-function'."
  (let ((pos (- (point-max) (point)))
        parse)
    (save-restriction
      (narrow-to-defun)
      (back-to-indentation)
      (setq parse (parse-partial-sexp (point-min) (point)))
      (when cfengine-mode-debug
        (message "%S" parse))

      (cond
       ;; Body/bundle blocks start at 0.
       ((looking-at (concat cfengine3-defuns-regex "\\_>"))
        (indent-line-to 0))
       ;; Categories are indented one step.
       ((looking-at (concat cfengine3-category-regex "[ \t]*\\(#.*\\)*$"))
        (indent-line-to cfengine-indent))
       ;; Class selectors are indented two steps.
       ((looking-at (concat cfengine3-class-selector-regex "[ \t]*\\(#.*\\)*$"))
        (indent-line-to (* 2 cfengine-indent)))
       ;; Outdent leading close brackets one step.
       ((or (eq ?\} (char-after))
            (eq ?\) (char-after)))
        (condition-case ()
            (indent-line-to (save-excursion
                              (forward-char)
                              (backward-sexp)
                              (move-beginning-of-line nil)
                              (skip-chars-forward " \t")
                              (current-column)))
          (error nil)))
       ;; Inside a string and it starts before this line: do nothing.
       ((and (nth 3 parse)
             (< (nth 8 parse) (save-excursion (beginning-of-line) (point))))
        )

       ;; Inside a defun, but not a nested list (depth is 1).  This is
       ;; a promise, usually.

       ;; Indent to cfengine-indent times the nested depth
       ;; plus 2.  That way, promises indent deeper than class
       ;; selectors, which in turn are one deeper than categories.
       ((= 1 (nth 0 parse))
        (let ((p-anchor (nth 0 cfengine-parameters-indent))
              (p-what (nth 1 cfengine-parameters-indent))
              (p-indent (nth 2 cfengine-parameters-indent)))
          ;; Do we have the parameter anchor and location and indent
          ;; defined, and are we looking at a promise parameter?
          (if (and p-anchor p-what p-indent
                   (looking-at  "\\([[:alnum:]_]+[ \t]*\\)=>"))
              (let* ((arrow-offset (* -1 (length (match-string 1))))
                     (extra-offset (if (eq p-what 'arrow) arrow-offset 0))
                     (base-offset (if (eq p-anchor 'promise)
                                      (* (+ 2 (nth 0 parse)) cfengine-indent)
                                    0)))
                (indent-line-to (max 0 (+ p-indent base-offset extra-offset))))
            ;; Else, indent to cfengine-indent times the nested depth
            ;; plus 2.  That way, promises indent deeper than class
            ;; selectors, which in turn are one deeper than categories.
          (indent-line-to (* (+ 2 (nth 0 parse)) cfengine-indent)))))
       ;; Inside brackets/parens: indent to start column of non-comment
       ;; token on line following open bracket or by one step from open
       ;; bracket's column.
       ((condition-case ()
            (progn (indent-line-to (save-excursion
                                     (backward-up-list)
                                     (forward-char)
                                     (skip-chars-forward " \t")
                                     (cond
                                      ((looking-at "[^\n#]")
                                       (current-column))
                                      ((looking-at "[^\n#]")
                                       (current-column))
                                      (t
                                       (skip-chars-backward " \t")
                                       (+ (current-column) -1
                                          cfengine-indent)))))
                   t)
          (error nil)))
       ;; Else don't indent.
       (t (indent-line-to 0))))
    ;; If initial point was within line's indentation,
    ;; position after the indentation.  Else stay at same point in text.
    (if (> (- (point-max) pos) (point))
        (goto-char (- (point-max) pos)))))

;; CFEngine 3.x grammar

;; specification: blocks
;; blocks: block | blocks block;
;; block:                 bundle typeid blockid bundlebody
;;                      | bundle typeid blockid usearglist bundlebody
;;                      | body typeid blockid bodybody
;;                      | body typeid blockid usearglist bodybody;

;; typeid: id
;; blockid: id
;; usearglist: '(' aitems ')';
;; aitems: aitem | aitem ',' aitems |;
;; aitem: id

;; bundlebody: '{' statements '}'
;; statements: statement | statements statement;
;; statement: category | classpromises;

;; bodybody: '{' bodyattribs '}'
;; bodyattribs: bodyattrib | bodyattribs bodyattrib;
;; bodyattrib: class | selections;
;; selections: selection | selections selection;
;; selection: id ASSIGN rval ';' ;

;; classpromises: classpromise | classpromises classpromise;
;; classpromise: class | promises;
;; promises: promise | promises promise;
;; category: CATEGORY
;; promise: promiser ARROW rval constraints ';' | promiser constraints ';';
;; constraints: constraint | constraints ',' constraint |;
;; constraint: id ASSIGN rval;
;; class: CLASS
;; id: ID
;; rval: ID | QSTRING | NAKEDVAR | list | usefunction
;; list: '{' litems '}' ;
;; litems: litem | litem ',' litems |;
;; litem: ID | QSTRING | NAKEDVAR | list | usefunction

;; functionid: ID | NAKEDVAR
;; promiser: QSTRING
;; usefunction: functionid givearglist
;; givearglist: '(' gaitems ')'
;; gaitems: gaitem | gaitems ',' gaitem |;
;; gaitem: ID | QSTRING | NAKEDVAR | list | usefunction

;; # from lexer:

;; bundle: "bundle"
;; body: "body"
;; COMMENT    #[^\n]*
;; NAKEDVAR   [$@][(][a-zA-Z0-9_\200-\377.]+[)]|[$@][{][a-zA-Z0-9_\200-\377.]+[}]
;; ID: [a-zA-Z0-9_\200-\377]+
;; ASSIGN: "=>"
;; ARROW: "->"
;; QSTRING: \"((\\\")|[^"])*\"|\'((\\\')|[^'])*\'|`[^`]*`
;; CLASS: [.|&!()a-zA-Z0-9_\200-\377]+::
;; CATEGORY: [a-zA-Z_]+:

(defun cfengine3--current-function ()
  "Look up current CFEngine 3 function"
  (let* ((syntax (cfengine3-make-syntax-cache))
         (flist (assq 'functions syntax)))
    (when flist
      (let ((w (save-excursion
                 (skip-syntax-forward "w_")
                 (when (search-backward-regexp
                        cfengine-mode-syntax-functions-regex
                        (point-at-bol)
                        t)
                   (match-string 1)))))
        (and w (assq (intern w) flist))))))

;; format from "cf-promises -s json", e.g. "sort" function:
;; ((category . "data")
;;  (variadic . :json-false)
;;  (parameters . [((range . "[a-zA-Z0-9_$(){}\\[\\].:]+") (type . "string"))
;;                 ((range . "lex,int,real,IP,ip,MAC,mac") (type . "option"))])
;;  (returnType . "slist")
;;  (status . "normal"))

(defun cfengine3-format-function-docstring (fdef)
  (let* ((f (format "%s" (car-safe fdef)))
         (def (cdr fdef))
         (rtype (cdr (assq 'returnType def)))
         (plist (cdr (assq 'parameters def)))
         (has-some-parameters (> (length plist) 0))
         (variadic (eq t (cdr (assq 'variadic def)))))

    ;; (format "[%S]%s %s(%s%s)" def
    (format "%s %s(%s%s)"
            (if rtype
                (propertize rtype 'face 'font-lock-variable-name-face)
              "???")
            (propertize f 'face 'font-lock-function-name-face)
            (mapconcat (lambda (p)
                         (let ((type (cdr (assq 'type p)))
                               (range (cdr (assq 'range p))))
                           (cond
                            ((not (stringp type)) "???type???")
                            ((not (stringp range)) "???range???")
                            ;; options are lists of possible keywords
                            ((equal type "option")
                             (propertize (concat "[" range "]")
                                         'face
                                         'font-lock-keyword-face))
                            ;; anything else is a type name as a variable
                            (t (propertize type
                                           'face
                                           'font-lock-variable-name-face)))))
                       plist
                       ", ")
            (if variadic
                (if has-some-parameters ", ..." "...")
              ""))))

(defun cfengine3-clear-syntax-cache ()
  "Clear the internal syntax cache.
Should not be necessary unless you reinstall CFEngine."
  (interactive)
  (setq cfengine-mode-syntax-functions-regex nil)
  (setq cfengine-mode-syntax-cache nil))

(defun cfengine3-make-syntax-cache ()
  "Build the CFEngine 3 syntax cache.
Calls `cfengine-cf-promises' with \"-s json\""
  (let ((syntax (cddr (assoc cfengine-cf-promises cfengine-mode-syntax-cache))))
    (if cfengine-cf-promises
        (or syntax
            (with-demoted-errors
                (with-temp-buffer
                  (call-process-shell-command cfengine-cf-promises
                                              nil   ; no input
                                              t     ; current buffer
                                              nil   ; no redisplay
                                              "-s" "json")
                  (goto-char (point-min))
                  (setq syntax (json-read))
                  (setq cfengine-mode-syntax-cache
                        (cons (cons cfengine-cf-promises syntax)
                              cfengine-mode-syntax-cache))
                  (setq cfengine-mode-syntax-functions-regex
                        (regexp-opt (mapcar (lambda (def)
                                              (format "%s" (car def)))
                                            (cdr (assq 'functions syntax)))
                                    'symbols))))))
    cfengine3-fallback-syntax))

(defun cfengine3-documentation-function ()
  "Document CFengine 3 functions around point.
Intended as the value of `eldoc-documentation-function', which see.
Use it by enabling `eldoc-mode'."
  (let ((fdef (cfengine3--current-function)))
    (when fdef
      (cfengine3-format-function-docstring fdef))))

(defun cfengine3-completion-function ()
  "Return completions for function name around or before point."
  (cfengine3-make-syntax-cache)
  (let* ((bounds (save-excursion
                   (let ((p (point)))
                     (skip-syntax-backward "w_" (point-at-bol))
                     (list (point) p))))
         (syntax (cfengine3-make-syntax-cache))
         (flist (assq 'functions syntax)))
    (when bounds
      (append bounds (list (cdr flist))))))

(defun cfengine-common-settings ()
  (set (make-local-variable 'syntax-propertize-function)
       ;; In the main syntax-table, \ is marked as a punctuation, because
       ;; of its use in DOS-style directory separators.  Here we try to
       ;; recognize the cases where \ is used as an escape inside strings.
       (syntax-propertize-rules ("\\(\\(?:\\\\\\)+\\)\"" (1 "\\"))))
  (set (make-local-variable 'parens-require-spaces) nil)
  (set (make-local-variable 'comment-start)  "# ")
  (set (make-local-variable 'comment-start-skip)
       "\\(\\(?:^\\|[^\\\\\n]\\)\\(?:\\\\\\\\\\)*\\)#+[ \t]*")
  ;; Like Lisp mode.  Without this, we lose with, say,
  ;; `backward-up-list' when there's an unbalanced quote in a
  ;; preceding comment.
  (set (make-local-variable 'parse-sexp-ignore-comments) t))

(defun cfengine-common-syntax (table)
  ;; The syntax defaults seem OK to give reasonable word movement.
  (modify-syntax-entry ?# "<" table)
  (modify-syntax-entry ?\n ">#" table)
  (modify-syntax-entry ?\" "\"" table)  ; "string"
  (modify-syntax-entry ?\' "\"" table)  ; 'string'
  ;; Variable substitution.
  (modify-syntax-entry ?$ "." table)
  ;; Doze path separators.
  (modify-syntax-entry ?\\ "." table))

(defconst cfengine3--prettify-symbols-alist
  '(("->"  . ?→)
    ("=>"  . ?⇒)
    ("::" . ?∷)))

;;;###autoload
(define-derived-mode cfengine3-mode prog-mode "CFE3"
  "Major mode for editing CFEngine3 input.
There are no special keybindings by default.

Action blocks are treated as defuns, i.e. \\[beginning-of-defun] moves
to the action header."
  (cfengine-common-settings)
  (cfengine-common-syntax cfengine3-mode-syntax-table)

  (set (make-local-variable 'indent-line-function) #'cfengine3-indent-line)

  (setq font-lock-defaults
        '(cfengine3-font-lock-keywords
          nil nil nil beginning-of-defun))
  (setq-local prettify-symbols-alist cfengine3--prettify-symbols-alist)

  ;; `compile-command' is almost never a `make' call with CFEngine so
  ;; we override it
  (when cfengine-cf-promises
    (set (make-local-variable 'compile-command)
         (concat cfengine-cf-promises
                 " -f "
                 (when buffer-file-name
                   (shell-quote-argument buffer-file-name)))))

  (set (make-local-variable 'eldoc-documentation-function)
       #'cfengine3-documentation-function)

  (add-hook 'completion-at-point-functions
            #'cfengine3-completion-function nil t)

  ;; Use defuns as the essential syntax block.
  (set (make-local-variable 'beginning-of-defun-function)
       #'cfengine3-beginning-of-defun)
  (set (make-local-variable 'end-of-defun-function)
       #'cfengine3-end-of-defun))

;;;###autoload
(define-derived-mode cfengine2-mode prog-mode "CFE2"
  "Major mode for editing CFEngine2 input.
There are no special keybindings by default.

Action blocks are treated as defuns, i.e. \\[beginning-of-defun] moves
to the action header."
  (cfengine-common-settings)
  (cfengine-common-syntax cfengine2-mode-syntax-table)

  ;; Shell commands can be quoted by single, double or back quotes.
  ;; It's debatable whether we should define string syntax, but it
  ;; should avoid potential confusion in some cases.
  (modify-syntax-entry ?\` "\"" cfengine2-mode-syntax-table)

  (set (make-local-variable 'indent-line-function) #'cfengine2-indent-line)
  (set (make-local-variable 'outline-regexp) "[ \t]*\\(\\sw\\|\\s_\\)+:+")
  (set (make-local-variable 'outline-level) #'cfengine2-outline-level)
  (set (make-local-variable 'fill-paragraph-function)
       #'cfengine-fill-paragraph)
  (define-abbrev-table 'cfengine2-mode-abbrev-table cfengine-mode-abbrevs)
  (setq font-lock-defaults
        '(cfengine2-font-lock-keywords nil nil nil beginning-of-line))
  ;; Fixme: set the args of functions in evaluated classes to string
  ;; syntax, and then obey syntax properties.
  (setq imenu-generic-expression cfengine2-imenu-expression)
  (set (make-local-variable 'beginning-of-defun-function)
       #'cfengine2-beginning-of-defun)
  (set (make-local-variable 'end-of-defun-function) #'cfengine2-end-of-defun))

;;;###autoload
(defun cfengine-auto-mode ()
  "Choose between `cfengine2-mode' and `cfengine3-mode' depending
on the buffer contents"
  (let ((v3 nil))
    (save-restriction
      (goto-char (point-min))
      (while (not (or (eobp) v3))
        (setq v3 (looking-at (concat cfengine3-defuns-regex "\\_>")))
        (forward-line)))
    (if v3 (cfengine3-mode) (cfengine2-mode))))

(defalias 'cfengine-mode 'cfengine3-mode)

(provide 'cfengine3)
(provide 'cfengine)

;;; cfengine.el ends here
