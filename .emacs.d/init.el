
;;; package.el 設定
;; https://www.wagavulin.jp/entry/2016/07/04/211631
(defvar my-favorite-package-list
  '(undo-tree
    counsel
    ivy
    company
    )
  "packages to be installed")

;; パッケージ取得先を追加
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)
;; パッケージの自動インストール
(unless package-archive-contents (package-refresh-contents))
(dolist (pkg my-favorite-package-list)
  (unless (package-installed-p pkg)
    (package-install pkg)))

;; 環境を日本語、UTF-8にする
(set-locale-environment nil)
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

(menu-bar-mode -1)                  ; menu barを表示しない
(tool-bar-mode -1)                  ; tool barを表示しない
;(if window-system                   ; "Symbol's function definition is void" 対策(2015/1/27 修正)
;    ((tool-bar-mode -1)             ; tool barを表示しない
;     (set-scroll-bar-mode 'right)   ; scroll barを右へ
;))
(line-number-mode t)                ; cursorの行数を表示
(column-number-mode t)              ; cursorの行頭からの文字数を表示
(global-font-lock-mode t)           ; 色付
(show-paren-mode t)                 ; 括弧の対応を表示
(transient-mark-mode t)             ; enable visual feedback on selections
(display-time-mode t)               ; 時刻をモードラインに表示

(global-set-key "\C-x\C-b" 'electric-buffer-list)
(global-set-key "\C-cg" 'goto-line)
(global-set-key "\C-h" 'delete-backward-char)


(setq backup-inhibited t)    ; バックアップファイルを作らない
(setq completion-ignore-case t)  ; 補完時に大文字小文字を区別しない
(electric-pair-mode 1)           ; 括弧を自動で補完する
(setq-default tab-width 4 indent-tabs-mode nil) ; tabにスペース４つを利用
(setq frame-title-format "%f")  ; タイトルにフルパス表示


;;; スクロール設定
(setq scroll-conservatively 1)           ; スクロールを1行に
(setq scroll-margin 5)                   ; 画面の端に到達する前にスクロール
(setq next-screen-context-lines 5)       ; 1画面スクロール時に重複させる行数
(setq scroll-preserve-screen-position t) ; 1画面スクロール時にカーソルの画面上の位置をなるべく変えない

;;; 補完機能
;(partial-completion-mode 1) ;; エラーが出たのでコメントアウト


;;; shell mode
;(ansi-color-for-comint-mode-on) ; 色をつける
;(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt) ; パスワードを伏字にする
;add-hook 'comint-mode-hook	; M-pで履歴を補完
;	  (lambda ()
;	    (define-key comint-mode-map "\M-p" 'comint-previous-matching-input-from-input)
;	    (define-key comint-mode-map "\M-n" 'comint-next-matching-input-from-input)
;	    ))


;;; ispell (日本語でとまらないように)
(eval-after-load "ispell"
  '(setq ispell-skip-region-alist (cons '("[^A-Za-z0-9 -]+")
                                        ispell-skip-region-alist)))


;; ivy設定
(require 'ivy)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(setq ivy-height 30)  ; minibufferのサイズを拡大！(重要)
(setq ivy-extra-directories nil)
(setq ivy-re-builders-alist '((t . ivy--regex-plus)))


;; counsel設定
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)  ; find-fileもcounsel任せ
(defvar counsel-find-file-ignore-regexp (regexp-opt '("./" "../")))


;;; swiper
;; ivyを用いたisearchの拡張
;(global-set-key "\C-s" 'swiper)
;(defvar swiper-include-line-number-in-search t)  ;; line-numberでも検索可能


;;; company
;(require 'company)
;(global-company-mode) ; 全バッファで有効にする
;(setq company-auto-expand t)           ; 1個目を自動的に補完
;(setq company-transformers '(company-sort-by-backend-importance))  ; ソート順
;(setq company-idle-delay 0)            ; 遅延なしにすぐ表示。デフォルトは0.5
;(setq company-minimum-prefix-length 2) ; デフォルトは4
;(setq company-selection-wrap-around t) ; 候補の最後の次は先頭に戻る
;(setq completion-ignore-case t)
;(setq company-dabbrev-downcase nil)
;(global-set-key (kbd "C-M-i") 'company-complete)
;; C-n, C-pで補完候補の次/前の候補をを選択
;(define-key company-active-map (kbd "C-n") 'company-select-next)
;(define-key company-active-map (kbd "C-p") 'company-select-previous)
;(define-key company-search-map (kbd "C-n") 'company-select-next)
;(define-key company-search-map (kbd "C-p") 'company-select-previous)
;(define-key company-active-map (kbd "C-s") 'company-filter-candidates)  ; C-sで絞り込む
;(define-key company-active-map [tab] 'company-complete-selection)  ; TABで候補を設定
; 各種メジャーモードでもC-M-iでcompany-modeの補完を使う
;(define-key emacs-lisp-mode-map (kbd "C-M-i") 'company-complete)
;(define-key company-active-map (kbd "C-h") nil)  ; C-hはBackSpace割当のため無効化
; ドキュメント表示はC-Shift-h
;(define-key company-active-map (kbd "C-S-h") 'company-show-doc-buffer)

;; 未選択項目
;(set-face-attribute 'company-tooltip nil
;		    :foreground "black" :background "lightgrey")
;; 未選択項目&一致文字
;(set-face-attribute 'company-tooltip-common nil
;                    :foreground "black" :background "lightgrey")
;; 選択項目
;(set-face-attribute 'company-tooltip-selection nil
;		    :foreground "black" :background "steelblue")
;; 選択項目&一致文字
;(set-face-attribute 'company-tooltip-common-selection nil
;                    :foreground "white" :background "steelblue")
;; スクロールバー
;(set-face-attribute 'company-scrollbar-fg nil
;		    :background "orange")
;; スクロールバー背景
;(set-face-attribute 'company-scrollbar-bg nil
;		    :background "gray40")


;;; 行番号を常に表示させる
(global-linum-mode)
(setq linum-format "%4d ")

;;; 行番号をトグル
(defun toggle-linum-lines ()
;  "toggle display line number"
  (interactive)
  (setq linum-format "%4d ")
  (linum-mode
   (if linum-mode -1 1)))
(define-key global-map (kbd "C-x C-l") 'toggle-linum-lines)


;;; company-jedi
;(require 'jedi-core)
;(setq jedi:complete-on-dot t)  ; "."を入力したときにも(メソッドを)補完してくれる
;(setq jedi:use-shortcuts t)  ; "M-."で定義へジャンプ、"M-,"で定義ジャンプから戻る
;(add-hook 'python-mode-hook 'jedi:setup)
;(add-to-list 'company-backends 'company-jedi)  ; backendに追加

;;; テーマを設定(反映されない。。。)
;(add-to-list 'custom-theme-load-path "/home/ueda/.emacs.d/themes")
;(setq custom-theme-directory "/home/ueda/.emacs.d/themes")
;(load-theme 'tango-dark t)
;(enable-theme 'tango-dark)


;; 現在行を下線
;(setq hl-line-face 'underline)
;(global-hl-line-mode)


;;; undo-treeの設定
(require 'undo-tree)
(global-undo-tree-mode)
(global-set-key (kbd "M-/") 'undo-tree-redo)


;(require 'esup)  ;; profile


;;; flycheck
; http://www.flycheck.org/en/latest/
;; Python
;(add-hook 'python-mode-hook 'flycheck-mode)
;(global-flycheck-mode)


;;; dumb-jump
;; 宣言箇所に移動できる
;(setq dumb-jump-mode t)
;(setq dumb-jump-selector 'ivy)  ;; 候補選択をivyに任せる
;(setq dumb-jump-use-visible-window nil)
;(define-key global-map [(super d)] 'dumb-jump-go)  ;; go-to-definition!
;(define-key global-map [(super shift d)] 'dumb-jump-back)


;;; jedi(auto-complete用Python補完ツール)
;(add-hook 'python-mode-hook 'jedi:setup)
;(setq jedi:complete-on-dot t)              ; optional

;;; auto-complete
;(global-auto-complete-mode t)
;(ac-config-default)
;(add-to-list 'ac-modes 'text-mode)
;(setq ac-use-menu-map t)           ;; 補完メニュー表示時にC-n/C-pで補完候補選択
;; (define-key ac-menu-map "\C-n" 'ac-next)
;; (define-key ac-menu-map "\C-p" 'ac-previous)
;(setq ac-menu-height 25)  ;; change the height of completion menu
;(setq ac-ignore-case t)
;(setq ac-delay 0)  ;; 補完候補表示までの時間
;(setq ac-auto-show-menu 0.05)  ;; ヒント表示までの時間
;; (ac-set-trigger-key "TAB")
;; (define-key ac-completing-map (kbd "<tab>") 'ac-complete)


(provide '.emacs)
;;; .emacs ends here


;; modeline
;; https://qiita.com/Ladicle/items/feb5f9dce9adf89652cf
(use-package doom-themes
  :custom
  (doom-themes-enable-italic t)
  (doom-themes-enable-bold t)
  :custom-face
  (doom-modeline-bar ((t (:background "#6272a4"))))
  :config
  (load-theme 'doom-vibrant t)
  (doom-themes-neotree-config)
  (doom-themes-org-config))

(use-package doom-modeline
  :custom
  (doom-modeline-buffer-file-name-style 'truncate-with-project)
  (doom-modeline-icon nil)
  (doom-modeline-major-mode-icon nil)
  (doom-modeline-minor-modes nil)
  :hook
  (after-init . doom-modeline-mode)
  :config
  (line-number-mode 0)
  (column-number-mode 0)
  (doom-modeline-def-modeline 'main
    '(bar window-number matches buffer-info remote-host buffer-position parrot selection-info)
    '(misc-info persp-name lsp github debug minor-modes input-method major-mode process vcs checker)))
