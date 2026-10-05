;;; 12-org-babel.el --- literate programming -*- lexical-binding: t -*-

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell      . t)
     (python     . t)
     (js         . t)
     (sql        . t)
     (css        . t)
     (plantuml   . t)
     (dot        . t)       ; graphviz
     (ditaa      . t)
     (latex      . t)
     (calc       . t)
     (awk        . t)
     (sed        . t)
     (org        . t)       ; org blocks inside org — useful for templates
     (makefile   . t)))

  ;; don't prompt for trusted languages
  ;; everything else still asks before executing
  (defvar my/trusted-babel-langs '("emacs-lisp" "shell" "python" "awk" "sed" "calc" "org")
    "Languages that can execute without confirmation.")
  (setq org-confirm-babel-evaluate
        (lambda (lang _body)
          (not (member lang my/trusted-babel-langs))))

  ;; syntax highlighting in source blocks
  (setq org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-src-preserve-indentation t
        org-edit-src-content-indentation 0)

  ;; open source edit buffer in the current window, not a split
  (setq org-src-window-setup 'current-window)

  ;; default header arguments for common languages
  ;; :results output means print statements show up, not return values
  ;; :exports both means code AND results appear on export
  (setq org-babel-default-header-args:shell
        '((:results . "output") (:exports . "both")))
  (setq org-babel-default-header-args:python
        '((:results . "output") (:exports . "both") (:python . "python3")))
  (setq org-babel-default-header-args:emacs-lisp
        '((:results . "value") (:exports . "both")))

  ;; where to find external tools
  ;; adjust these paths if they live somewhere else on your system
  (setq org-plantuml-jar-path
        (expand-file-name "/usr/share/plantuml/plantuml.jar"))
  (setq org-ditaa-jar-path
        (expand-file-name "/usr/share/ditaa/ditaa.jar"))

  ;; tangle: when extracting code from org to files,
  ;; make scripts executable by default
  (setq org-babel-tangle-use-relative-file-links t)
  (add-hook 'org-babel-post-tangle-hook
            (lambda ()
              (when (string-match-p "\\.\\(sh\\|bash\\|py\\|rb\\|pl\\)$"
                                    (buffer-file-name))
                (set-file-modes (buffer-file-name) #o755))))

  ;; structure templates — type <s TAB to get a source block
  ;; org-tempo (loaded in org-modules) provides this
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("js" . "src js"))
  (add-to-list 'org-structure-template-alist '("sq" . "src sql"))
  (add-to-list 'org-structure-template-alist '("aw" . "src awk"))
  (add-to-list 'org-structure-template-alist '("do" . "src dot"))
  (add-to-list 'org-structure-template-alist '("mk" . "src makefile")))
