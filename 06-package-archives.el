;; set basic package archives
(setq package-archives
      '(("gnu"          . "https://elpa.gnu.org/packages/")
        ("melpa"        . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("org"          . "https://orgmode.org/elpa/")))

(require 'package)

;; only refresh package list if cache is older than a day
(let ((archive-cache
       (expand-file-name "archives/melpa/archive-contents"
                         package-user-dir)))
  (when (or (not (file-exists-p archive-cache))
            (> (float-time
                (time-subtract (current-time)
                               (nth 5 (file-attributes archive-cache))))
               (* 24 60 60)))
    (package-refresh-contents)))

;; bootstrap use-package
(unless (package-installed-p 'use-package) (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t
      use-package-verbose nil
      use-package-expand-minimally t
      use-package-compute-statistics t)

;; always load the newer of .el or .elc
(setq load-prefer-newer t)

;; native-comp: keep eln-cache inside .emacs.d
(when (featurep 'native-compile)
  (setq native-comp-eln-load-path
        (list (expand-file-name "eln-cache" user-emacs-directory))))
