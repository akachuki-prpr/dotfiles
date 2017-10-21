if &compatible
        set nocompatible
endif

augroup MyAutoCmd
	autocmd!
augroup END

syntax enable
set t_CO=256 "表示色の設定(<256色)
set fileformats=unix,dos "改行(EOL)の種類を設定する

	"編集関連
"set smarttab "行頭の余白内でTabを売ったとき'shiftwidth'の値だけ空白を挿入する
"set expandtab "Tabの代わりにスペースを挿入する
set virtualedit=block "矩形選択時に文字がない部分を選択できるようにする
set infercase "保管時に大文字小文字を区別しない
set hidden "バッファを閉じる代わりに隠す(Undo履歴を残すため)
set switchbuf=useopen "新しく開く代わりすでに開いてあるバッファを開く
set showmatch "対応する括弧などをハイライト表示する
set matchtime=3 "対応括弧のハイライト表示を3秒にする
set matchpairs& matchpairs+=<:> "対応括弧に'<'と'>'を追加

	"検索関連
set ignorecase "大文字小文字を区別しない
set smartcase "検索文字に大文字がある場合は大文字小文字を区別
set incsearch "インクリメンタルサーチ
set nohlsearch "検索マッチテキストをハイライトしない
set wrapscan "検索時に最後まで行ったら最初に戻る

"-------------表示関連-----------------------
set list "不可視文字の可視化
set number "行番号の表示
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲ "不可視文字を見やすく
set ambiwidth=double "全角の記号がおかしくならないようにする

"---------マクロおよびキー設定-------------------
"入力モード中にjjでEsc
inoremap jj <Esc>

"*でカーソル下の単語を検索 
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", "\\n', 'g')<CR><CR> 

"検索結果を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

"j, k による移動を折り返されたテキストでも自然に振る舞うように
nnoremap j gj
nnoremap k gk

"vを2回で行末まで選択
vnoremap v $h

"TABキーで対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> &

"Ctrl + hjklでウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"shift + 矢印キーでウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" w!! でスーパユーザとして保存
cmap w!! w !sudo tee > /dev/null %

" :eなどでファイルを開く際にフォルダが存在しない場合は自動作成
function! s:mkdir(dir, force)
	if !isdirectory(a:dir) && (a:force ||
			\input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y%[es]$')
		call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
	endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)
"-----------------------------------


"スクリーンベルを無効化
set t_vb=
set novisualbell

"タグファイル関連
if has('path_extra')
    set tags& tags +=.tags,tags
endif

set laststatus=2 "最下ウィンドウに常にステータス行を表示する
set showtabline=2 "タブページのラベルを常に表示する

" クリップボードをデフォルトのレジスタとして指定。後にYankRingを使うので
" 'unnamedplus'が存在しているかどうかで設定を分ける必要がある
if has('unnamedplus')
    " set clipboard& clipboard+=unnamedplus " 2013-07-03 14:30 unnamed 追加
    set clipboard& clipboard+=unnamedplus,unnamed
else
    " set clipboard& clipboard+=unnamed,autoselect 2013-06-24 10:00 autoselect 削除
    set clipboard& clipboard+=unnamed
endif

"バックスペースでなんでも消せるようにする
set backspace=eol,indent,start

"Swapファイル, Backupファイルを無効化
set nowritebackup
set nobackup
set noswapfile

set wildmenu "コマンドラインモードでTabキーによるファイル名補完を有効にする
set wildmode=list:full "マッチするものをリスト表示しつつ，Tabを押すごとに次のマッチを補完
set wildignore=*.o,*.obj,*.pyc,*.so,*.dll "無視されるファイルパターン
let g:python_highlight_all = 1

"dein Scripts-----------------------------
" Required:
set runtimepath+=/home/prpr/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
" 設定開始
if dein#load_state('/home/prpr/.cache/dein')
  call dein#begin('/home/prpr/.cache/dein')


  " Let dein manage dein
  " Required:
  call dein#add('/home/prpr/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')

  " You can specify revision/branch/tag.
  call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
	call dein#install()
endif

" Required:
filetype plugin indent on

"End dein Scripts-------------------------

