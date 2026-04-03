;;; 99-keybindings.el --- all personal keybindings -*- lexical-binding: t -*-

;; ══════════════════════════════════════════════════
;; C-c m = my keymap.  Organized alphabetically.
;; Lowercase = daily drivers.  Uppercase = deeper tools.
;; Mnemonic: the letter is what you'd say aloud.
;;
;;   "agenda"    → a     "git"       → g     "outreach"  → o
;;   "capture"   → c     "journal"   → j     "replace"   → r
;;   "daily"     → d     "kill"      → k     "shell"     → s
;;   "emacs"     → e     "lookup"    → l     "today"     → t
;;   "focus"     → f     "mail"      → m     "writing"   → w
;;
;; ══════════════════════════════════════════════════

;; ── aliases: what which-key shows you ───────────

;; agenda
(defalias 'agenda      #'org-agenda)                 ; a — dispatcher
(defalias 'daily       #'my/show-hybrid-agenda)      ; d — 3-day default

;; capture & clock
(defalias 'capture     #'org-capture)                ; c
(defalias 'clock-last  #'my/clock-in-last)           ; C

;; config
(defalias 'emacs-conf  #'my/edit-init)               ; e

;; focus & files
(defalias 'focus       #'delete-other-windows)       ; f

;; git
(defalias 'git         #'my/magit-repo)              ; g — pick any repo
(defalias 'git-time    #'git-timemachine)            ; G

;; insert
(defalias 'timestamp   #'my/insert-date-and-time)    ; i
(defalias 'epoch       #'my/insert-time-and-epoch)   ; I

;; journal
(defalias 'journal     #'org-journal-new-entry)      ; j
(defalias 'jrnl-search #'my/journal-search)          ; J
(defalias 'jrnl-agenda #'my/journal-refresh-agenda)  ; C-j

;; kill
(defalias 'kill-others #'my/kill-other-buffers)      ; k

;; lookup
(defalias 'lookup      #'define-word-at-point)       ; l
(defalias 'langtool    #'langtool-check)             ; L

;; mail
(defalias 'mail        #'mu4e)                       ; m

;; outreach / org views
(defalias 'outreach    (lambda () (interactive) (org-agenda nil "o")))  ; o

;; pomodoro / projects
(defalias 'pomodoro    #'org-pomodoro)               ; p
(defalias 'projects    (lambda () (interactive) (org-agenda nil "p")))  ; P

;; replace
(defalias 'qreplace    #'query-replace-regexp)       ; q
(defalias 'replace     #'replace-regexp)             ; r
(defalias 'del-lines   #'flush-lines)               ; R — remove lines

;; shell
(defalias 'shell       #'eshell)                     ; s

;; today & time
(defalias 'today       #'my/today)                   ; t
(defalias 'thesaurus   #'powerthesaurus-lookup-dwim) ; T
(defalias 'titlecase   #'titlecase-dwim)

;; writing
(defalias 'writing     #'my/writing-mode)            ; w
(defalias 'write-pipe  (lambda () (interactive) (org-agenda nil "W")))  ; W
(defalias 'wordcount   #'my/word-count-region)

;; scratch
(defalias 'scratch     #'my/scratch)                 ; x

;; ── daily drivers (lowercase) ───────────────────

(keymap-global-set "C-c m a" #'agenda)        ; agenda dispatcher
(keymap-global-set "C-c m c" #'capture)       ; capture anything
(keymap-global-set "C-c m d" #'daily)         ; 3-day agenda, skip dispatcher
(keymap-global-set "C-c m e" #'emacs-conf)    ; edit init files
(keymap-global-set "C-c m f" #'focus)         ; one window, no distractions
(keymap-global-set "C-c m g" #'git)           ; pick a repo, open magit
(keymap-global-set "C-c m i" #'timestamp)     ; insert date + time
(keymap-global-set "C-c m j" #'journal)       ; new journal entry
(keymap-global-set "C-c m k" #'kill-others)   ; kill all other buffers
(keymap-global-set "C-c m l" #'lookup)        ; define word at point
(keymap-global-set "C-c m m" #'mail)          ; mu4e
(keymap-global-set "C-c m o" #'outreach)      ; outreach pipeline view
(keymap-global-set "C-c m p" #'pomodoro)      ; start a pomodoro
(keymap-global-set "C-c m q" #'qreplace)      ; query replace (interactive)
(keymap-global-set "C-c m r" #'replace)       ; replace all (no prompt)
(keymap-global-set "C-c m s" #'shell)         ; eshell
(keymap-global-set "C-c m t" #'today)         ; journal + agenda side by side
(keymap-global-set "C-c m w" #'writing)       ; olivetti writing mode
(keymap-global-set "C-c m x" #'scratch)       ; scratch buffer

;; ── deeper tools (uppercase) ────────────────────

(keymap-global-set "C-c m C" #'clock-last)    ; clock into last task
(keymap-global-set "C-c m G" #'git-time)      ; git timemachine
(keymap-global-set "C-c m I" #'epoch)         ; insert epoch time
(keymap-global-set "C-c m J" #'jrnl-search)   ; search all journals
(keymap-global-set "C-c m L" #'langtool)      ; grammar check buffer
(keymap-global-set "C-c m P" #'projects)      ; all projects view
(keymap-global-set "C-c m R" #'del-lines)     ; remove matching lines
(keymap-global-set "C-c m T" #'thesaurus)     ; synonym lookup
(keymap-global-set "C-c m W" #'write-pipe)    ; writing pipeline view

;; ── editing pass tools (C-c m E prefix) ─────────

(keymap-global-set "C-c m E e" #'my/editing-pass)          ; full editing pass
(keymap-global-set "C-c m E f" #'my/find-filler-words)     ; filler words
(keymap-global-set "C-c m E l" #'my/find-long-sentences)   ; long sentences
(keymap-global-set "C-c m E p" #'my/find-passive-voice)    ; passive voice
(keymap-global-set "C-c m E r" #'my/find-repeated-words)   ; repeated words
(keymap-global-set "C-c m E c" #'my/clear-long-sentences)  ; clear highlights
(keymap-global-set "C-c m E t" #'titlecase)                ; titlecase region
(keymap-global-set "C-c m E w" #'wordcount)                ; word count region
(keymap-global-set "C-c m E g" #'langtool-correct-buffer)  ; walk grammar fixes
(keymap-global-set "C-c m E d" #'langtool-check-done)      ; clear grammar marks

;; ── clock reports (C-c m K prefix) ──────────────

(keymap-global-set "C-c m K t" #'my/clock-report-today)    ; today's time
(keymap-global-set "C-c m K w" #'my/clock-report-week)     ; weekly time report

;; ── journal extras ──────────────────────────────

(keymap-global-set "C-c m j" #'journal)                    ; new timed entry
(keymap-global-set "C-c m J" #'jrnl-search)                ; search journals
(keymap-global-set "C-c C-j" #'jrnl-agenda)                ; refresh agenda in journal

;; ── roam stays on C-c n (set in 15-org-roam.el) ─
;; C-c n f  find node
;; C-c n i  insert link to node
;; C-c n l  toggle backlinks buffer
;; C-c n c  capture to roam
;; C-c n g  graph
;; C-c n t  add tag
;; C-c n T  remove tag
;; C-c n a  add alias
;; C-c n d  dailies: go to today
;; C-c n D  dailies: go to date
;; C-c n j  dailies: capture today
;;
;; filtered finders (bind these if you use them often):
;; M-x my/roam-find-person
;; M-x my/roam-find-concept
;; M-x my/roam-find-book
;; M-x my/roam-find-emacs
;; M-x my/roam-find-reference

;; ── quick reference ─────────────────────────────
;; C-c m a  agenda          C-c m C  clock last
;; C-c m c  capture         C-c m G  git timemachine
;; C-c m d  daily view      C-c m I  epoch
;; C-c m e  edit init       C-c m J  journal search
;; C-c m f  focus           C-c m L  langtool
;; C-c m g  git             C-c m P  projects view
;; C-c m i  timestamp       C-c m R  remove lines
;; C-c m j  journal         C-c m T  thesaurus
;; C-c m k  kill buffers    C-c m W  writing pipeline
;; C-c m l  lookup word
;; C-c m m  mail            C-c m E e  editing pass
;; C-c m o  outreach        C-c m E f  filler words
;; C-c m p  pomodoro        C-c m E l  long sentences
;; C-c m q  query replace   C-c m E p  passive voice
;; C-c m r  replace         C-c m E r  repeated words
;; C-c m s  shell           C-c m E c  clear highlights
;; C-c m t  today           C-c m E t  titlecase
;; C-c m w  writing mode    C-c m E w  word count
;; C-c m x  scratch         C-c m E g  grammar walk
;;                          C-c m E d  grammar clear
;; C-c n *  roam
;; C-c C-j  refresh journal agenda
;; C-; flyspell correct     C-c m K t  clock today
;; C-c L  org-cliplink      C-c m K w  clock week
