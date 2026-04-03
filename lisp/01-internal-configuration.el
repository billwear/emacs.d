;; make eshell treat ~/bin as the load path for user-written code
(add-to-list 'exec-path (expand-file-name "~/bin"))
(setenv "PATH" (concat (expand-file-name "~/bin") ":" (getenv "PATH")))

;; set error recovery modes; currently on by default, but don't assume
(setq attempt-orderly-shutdown-on-fatal-signal t)
(setq attempt-stack-overflow-recovery t)

;; raise the garbage collection threshold
(setq gc-cons-threshold (* 16 1024 1024))
(setq gc-cons-percentage 0.2)

;; read from external processes in bigger chunks
(setq read-process-output-max (* 1024 1024))

;; do native compilation in the background without warnings
(when (featurep 'native-compile)
  (setq native-comp-async-report-warnings-errors 'silent
	native-comp-deferred-compilation t))

;; don't choke on absurdly long lines (JSON, log files, etc)
(global-so-long-mode 1)

;; tell emacs to use the os-level file watcher instead of
;; polling itself; much less use of resources
(setq auto-revert-use-notify t
      auto-revert-avoid-polling t)
(global-auto-revert-mode)

;; use UTF-8 everywhere, so Emacs never guesses wrong
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; disable any site-wide startup file; no surprises
(setq inhibit-default-init t)
